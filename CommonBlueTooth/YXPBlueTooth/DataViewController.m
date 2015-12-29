//
//  DataViewController.m
//  YXPBlueTooth
//
//  Created by andylau on 15/11/17.
//  Copyright © 2015年 andylau. All rights reserved.
//

#import "DataViewController.h"
#import "MBProgressHUD+MB.h"
@interface DataViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *testImage;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;


@property (nonatomic, copy) NSString *BLE_words;
@property (nonatomic, copy) NSString *BLE_images;



@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (IBAction)arrangeData:(id)sender {

    // 字符串和图片间 －－ 字符串
    NSString *str = @"0a2b2b2b2b2b2b2b2b2b2b";
    if (self.perString) {
        NSString *hexStr;
//        hexStr = self.hexStrArray[0];
        hexStr = [self removeBLankWithStr:self.perString];
        NSArray *allArray = [hexStr componentsSeparatedByString:str];
        if (allArray) {
            NSString *words = [NSString stringWithFormat:@"%@",allArray[0]];
            self.BLE_words = [words substringWithRange:NSMakeRange(words.length - 12, 12)];
            self.BLE_images = [NSString stringWithFormat:@"%@",allArray[1]];
            [MBProgressHUD showSuccess:@"已收到数据"];
        }
    }else{
        [MBProgressHUD showError:@"获取数据失败"];
    }
}



- (IBAction)wordShow:(id)sender {
    if (self.BLE_words) {
        NSString *strings = [self stringFromHexString:[self removeBLankWithStr:self.BLE_words]];
        self.testLabel.text = [NSString stringWithFormat:@"%@",strings];
    }
}

- (IBAction)imageShow:(id)sender {
    if (self.BLE_images) {
        NSString *imgStr = [self removeBLankWithStr:self.BLE_images];
        NSData *data = [self transStrHexToData:imgStr];
        self.testImage.image = [UIImage imageWithData:data];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic.png"]];   // 保存文件的名称
        
        [UIImagePNGRepresentation([UIImage imageWithData:data])writeToFile: filePath    atomically:YES];
        
    }
}


- (NSString *)removeBLankWithStr:(NSString*)str{
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return strUrl;
}


- (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}

//- (NSString *)stringFromHexString:(NSString *)hexString {  // eg. hexString = @"8c376b4c"
//
//    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
//    bzero(myBuffer, [hexString length] / 2 + 1);
//    for (int i = 0; i < [hexString length] - 1; i += 2) {
//        unsigned int anInt;
//        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
//        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
//        [scanner scanHexInt:&anInt];
//        myBuffer[i / 2] = (char)anInt;
//    }
//    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:NSUnicodeStringEncoding];
//    //    printf("%s\n", myBuffer);
//    free(myBuffer);
//
//    NSString *temp1 = [unicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
//    NSString *temp2 = [temp1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    NSString *temp3 = [[@"\"" stringByAppendingString:temp2] stringByAppendingString:@"\""];
//    NSData *tempData = [temp3 dataUsingEncoding:NSUTF32StringEncoding];
//    NSString *temp4 = [NSPropertyListSerialization propertyListFromData:tempData
//                                                       mutabilityOption:NSPropertyListImmutable
//                                                                 format:NULL
//                                                       errorDescription:NULL];
//    NSString *string = [temp4 stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
//
//    NSLog(@"-------string----%@", string); //输出 谷歌
//    return string;
//}





/// 将十六进制的字符串转化为NSData
- (NSData *)transStrHexToData:(NSString *)strHex
{
    /// bytes索引
    NSUInteger j = 0;
    
    NSInteger len = strHex.length;
    
    //    if (len % 2 == 1) {
    //        /// 若不能被2整除则说明16进制的字符串不满足图片图。特此说明，假如只是单纯的把十六进制转换为NSData就把这个if干掉即可，
    //        return nil;
    //    }
    
    /// 动态分配内存
    Byte *bytes = (Byte *)malloc((len / 2 + 1) * sizeof(Byte));
    
    /// 初始化内存 其中memset的作用是在一段内存块中填充某个给定的值，它是对较大的结构体或数组进行清零操作的一种最快方法
    memset(bytes, '\0', (len / 2 + 1) * sizeof(Byte));
    
    /// for循环里面其实就是把16进制的字符串转化为字节数组的过程
    for (NSUInteger i = 0; i < strHex.length; i += 2) {
        
        /// 一字节byte是8位(比特)bit 一位就代表一个0或者1(即二进制) 每8位(bit)组成一个字节(Byte) 所以每一次取2为字符组合成一个字节 其实就是2个16进制的字符其实就是8位(bit)即一个字节byte
        NSString *str = [strHex substringWithRange:NSMakeRange(i, 2)];
        
        /// 将16进制字符串转化为十进制
        unsigned long uint_ch = strtoul([str UTF8String], 0, 16);
        
        bytes[j] = uint_ch;
        
        /// 自增
        j ++;
    }
    
    /// 将字节数组转化为NSData
    NSData *data = [[NSData alloc] initWithBytes:bytes length:len / 2];
    
    /// 释放内存
    free(bytes);
    
    return data;
}
@end