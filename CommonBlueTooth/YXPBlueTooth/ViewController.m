//
//  ViewController.m
//  YXPBlueTooth
//
//  Created by andylau on 15/8/10.
//  Copyright (c) 2015年 andylau. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "NearByModal.h"
#import "BTCell.h"
#import "MBProgressHUD+MB.h"
#import "PeripheralViewController.h"
#define ScanTimeInterval 1.0
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<CBCentralManagerDelegate>

// 中央设备
@property (nonatomic, strong) CBCentralManager *mgr;
// 外部设备
@property (nonatomic, strong) NSMutableArray *peripherals;
// 已连接的设备
@property (nonatomic, strong) CBPeripheral *selectedPer;
@property (nonatomic, strong) NSTimer *timer;
// timeout connect
@property (nonatomic, strong) NSTimer *endTimer;
//@property (nonatomic, strong) NSMutableArray *NearArray;

@property (nonatomic, strong) UIImageView *emptyImg;

@end

@implementation ViewController

#pragma mark - lazyLoad
- (CBCentralManager *)mgr{
    if (_mgr == nil) {
        _mgr = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    return _mgr;
}


- (NSMutableArray *)peripherals{
    if (_peripherals == nil) {
        _peripherals = [[NSMutableArray alloc]init];
    }
    return _peripherals;
}


#pragma mark lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationButton];
    self.title = @"搜索蓝牙设备";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.emptyImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty.jpg"]];
    CGFloat width = 200;
    CGFloat height = 280;
    CGFloat navHeight = 64 ;
    self.emptyImg.frame = CGRectMake(0.5 * (SCREENWIDTH - width), 0.5 * (SCREENHEIGHT - height - navHeight), width, height);
    [self.view addSubview:self.emptyImg];
    self.emptyImg.hidden = YES;
}

- (void)initNavigationButton{
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(startScan)];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"停止" style:UIBarButtonItemStyleDone target:self action:@selector(stopScanss)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.rightBarButtonItem = backBtn;
}


- (void)startScan{
    [MBProgressHUD showMessage:@"开始搜索"];
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:ScanTimeInterval target:self selector:@selector(scanForPeripherals) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    if (_timer && !_timer.valid) {
        [_timer fire];
    }
}
- (void)stopScanss{
    if (_timer && _timer.valid) {
        [_timer invalidate];
        _timer = nil;
    }
    [self.mgr stopScan];
}

- (void)scanForPeripherals{
    if (self.mgr.state == CBCentralManagerStateUnsupported) {//设备不支持蓝牙
    }else{
        if (self.mgr.state == CBCentralManagerStatePoweredOn) {
            [MBProgressHUD hideHUD];
            [self.mgr scanForPeripheralsWithServices:nil options:nil];
        }        
    }
    
}




#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"%s",__func__);
    switch ((long)central.state) {
        case 0:
            NSLog(@"蓝牙状态未知");
            [MBProgressHUD hideHUD];
            break;
        case 1:
            NSLog(@"正在重置蓝牙状态");
            [MBProgressHUD hideHUD];
            break;
        case 2:
            NSLog(@"该设备不支持蓝牙4.0");
            [MBProgressHUD hideHUD];
            break;
        case 3:
            NSLog(@"该设备未授权");
            [MBProgressHUD hideHUD];
            break;
        case 4:
            NSLog(@"蓝牙状态关闭");
            [MBProgressHUD hideHUD];
            break;
        case 5:
            NSLog(@"蓝牙设备正常，可以使用");
            break;
        default:
            break;
    }
}



// 发现外部设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    BOOL isExist = NO;
    if (!([peripheral.name isEqual:@"(null)"] || peripheral.name == nil)) {
    
        // 添加外部设备
        NearByModal *modal = [[NearByModal alloc]init];
        modal.name = peripheral.name;
        modal.RSSI = [NSString stringWithFormat:@"%@",RSSI];
        NSString *temp = [NSString stringWithFormat:@"%@",peripheral.identifier];
        modal.UUID = [temp substringFromIndex:31];
        modal.Peripheral = peripheral;
        if (self.peripherals.count == 0) {
            [self.peripherals addObject:modal];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            for (int i = 0;i < self.peripherals.count;i++) {
                NearByModal *nearModal = [self.peripherals objectAtIndex:i];
                if ([nearModal.UUID isEqualToString:modal.UUID]) {
                    isExist = YES;
                    [self.peripherals replaceObjectAtIndex:i withObject:modal];
                    [self.tableView reloadData];
                }
            }
            if (!isExist) {
                [self.peripherals addObject:modal];
                NSIndexPath *path = [NSIndexPath indexPathForRow:self.peripherals.count - 1 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
        NSLog(@"peripheral--%@ advertisementData--%@    RSSI--%@",peripheral,advertisementData,RSSI);
    }

    
}

// 连接到外设
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [MBProgressHUD hideHUD];
    PeripheralViewController *newVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PeripheralViewController_ID"];
//    newVc.view.backgroundColor = [UIColor orangeColor];
    newVc.currentPeripheral = peripheral;
    NSString *Str = [NSString stringWithFormat:@"%@",peripheral];
    newVc.currentInfo = Str;
    [MBProgressHUD showSuccess:@"连接成功！"];
    [self.navigationController pushViewController:newVc animated:YES];
    NSLog(@"连接到设备 %@",peripheral);
  

}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
{
    NSLog(@"连接外设失败 %@",peripheral);
    [MBProgressHUD showSuccess:@"连接外设失败！"];
    [self.navigationController popViewControllerAnimated:YES];

}


 //  跟某个外设失去连接
 
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"已失去连接 %@",peripheral);
    [MBProgressHUD showSuccess:@"与外设失去连接！"];
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.peripherals.count == 0) {
        self.emptyImg.hidden = NO;
    }else{
        self.emptyImg.hidden = YES;
    }
    return self.peripherals.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearByModal *modal = self.peripherals[indexPath.row];
    BTCell *cell = [[NSBundle mainBundle] loadNibNamed:@"BTCell" owner:self options:nil][0];
    cell.modal = modal;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NearByModal *modal = self.peripherals[indexPath.row];
    [self stopScanss];
    [MBProgressHUD showMessage:@"开始连接"];
    
    if (self.mgr.state == CBCentralManagerStateUnsupported) {//设备不支持蓝牙
        [MBProgressHUD hideHUD];
    }else{
        if (self.mgr.state == CBCentralManagerStatePoweredOn) {
        
            [self.mgr connectPeripheral:modal.Peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,CBConnectPeripheralOptionNotifyOnNotificationKey:@YES,CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES}];
            
        }else{
            [MBProgressHUD hideHUD];
        }
    }
}



@end
