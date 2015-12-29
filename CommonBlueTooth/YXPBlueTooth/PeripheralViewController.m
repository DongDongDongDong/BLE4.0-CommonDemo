
//
//  PeripheralViewController.m
//  YXPBlueTooth
//
//  Created by andylau on 15/8/11.
//  Copyright (c) 2015年 andylau. All rights reserved.
//

#import "PeripheralViewController.h"
#import "DataViewController.h"
#import "MBProgressHUD+MB.h"
@interface PeripheralViewController ()

// 当前用到的特征
@property (nonatomic, strong) CBCharacteristic *currentCharacteristic;

// 接收到BLE传过来的的数据(多条)
//@property (nonatomic, copy) NSMutableArray *receiveBytesArray;
// 拼接起来的每一条数据
@property (nonatomic, copy) NSString *perStringList;


@property (nonatomic, strong) UILabel *lab;

@property (weak, nonatomic) IBOutlet UITextView *textViewLog;
@property (nonatomic, copy) NSString *logString;

@end

@implementation PeripheralViewController

//-(NSString *)currentInfo{
//    if (_currentInfo == nil) {
//        _currentInfo = [[NSString alloc]init];
//    }
//    return _currentInfo;
//}

- (NSString *)perStringList {
    if (_perStringList == nil) {
        _perStringList = [NSString string];
    }
    return _perStringList;
}

//-  (NSMutableArray *)receiveBytesArray{
//    if (_receiveBytesArray == nil) {
//        _receiveBytesArray = [NSMutableArray array];
//    }
//    return _receiveBytesArray;
//}


- (void)setCurrentInfo:(NSString *)currentInfo{
    _currentInfo = currentInfo;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, self.view.bounds.size.width - 10, 200)];
    lab.backgroundColor = [UIColor whiteColor];
    lab.text = self.currentInfo;
    lab.numberOfLines = 0;
    self.lab = lab;
    [self.view addSubview:lab];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setUp];
}

- (void)setUp{
    [self.currentPeripheral setDelegate:self];
    [self.currentPeripheral discoverServices:nil];
}

#pragma mark - CBPeripheralDelegate

//  外设查找到服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    NSLog(@" 查找到服务 %s",__func__);
    
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"%@",service);
        //  查找特征
        [self.currentPeripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"发现 特征出现错误  %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    for (CBCharacteristic * characteristic in service.characteristics)
    {
     NSLog(@"查找到了服务:%@ 的 特征: %@",service.UUID,characteristic.UUID);
        
        
// 获取Mac地址（当前设备的获取方式）
        if( [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]])
        {
            [peripheral readValueForCharacteristic:characteristic];
        }
        

 // 当前设备需要监听的characteristic的UUID
        if( [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"49535343-1E4D-4BD9-BA61-23C647249616"]])
        {
            self.currentCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}



-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    NSLog(@"------------------------------------------------------------");
// 获取mac地址
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
        NSString *str = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSString *macString;
        if (str.length) {
            NSString *a = [str substringWithRange:NSMakeRange(0, 2)];
             NSString *b = [str substringWithRange:NSMakeRange(2, 2)];
             NSString *c = [str substringWithRange:NSMakeRange(4, 2)];
             NSString *d = [str substringWithRange:NSMakeRange(6, 2)];
             NSString *e = [str substringWithRange:NSMakeRange(8, 2)];
             NSString *f = [str substringWithRange:NSMakeRange(10, 2)];
            macString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",a,b,c,d,e,f];
        }
        NSLog(@"%@", macString);
        self.lab.text = [self.lab.text stringByAppendingString:macString];
    }else{
        // 获取监听的数据
        NSLog(@"收到--数据:%@",[self convertDataToHexStr:characteristic.value]);
        self.logString = [NSString stringWithFormat:@"收到数据 %@ \n",[self convertDataToHexStr:characteristic.value]];
        self.textViewLog.text = [NSString stringWithFormat:@"%@%@",self.textViewLog.text,self.logString];
        NSString *tempValue = [NSString stringWithFormat:@"%@",[self convertDataToHexStr:characteristic.value]];
        // 第一次连接收到数据为0000000000
        if (![tempValue isEqual:@"0000000000"]) {
            self.perStringList  = [self.perStringList stringByAppendingString:tempValue];
            if ([tempValue hasSuffix:@"2b2d2b2d2b2d2b2d2b2d"]) {
                
                [MBProgressHUD showSuccess:@"数据接收完毕"];
            }
        }
    }

}

//搜索到Characteristic的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    //打印出Characteristic和他的Descriptors
    NSLog(@"发现Descriptors的特征characteristic uuid:%@",characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"Descriptor uuid:%@",d.UUID);
    }
    
}

//获取到Descriptors的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    NSLog(@"发现Descriptor的特征characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],[self convertDataToHexStr:descriptor.value]);
}


#pragma notification 

- (IBAction)beginNotify:(id)sender {
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [self.currentPeripheral setNotifyValue:YES forCharacteristic:self.currentCharacteristic];
    [MBProgressHUD show:@"开始监听..." duration:5.0];

}


- (IBAction)stopNotify:(id)sender {
//    [self.currentPeripheral setNotifyValue:NO forCharacteristic:self.currentCharacteristic];

    DataViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DataViewController_ID"];
//    vc.hexStrArray = self.receiveBytesArray;
    vc.perString = self.perStringList;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"%@",self.perStringList);
}


- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}



@end
