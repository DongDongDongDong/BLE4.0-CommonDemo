//
//  PeripheralViewController.h
//  YXPBlueTooth
//
//  Created by andylau on 15/8/11.
//  Copyright (c) 2015年 andylau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralViewController : UIViewController<CBPeripheralDelegate>

@property (nonatomic,strong) CBPeripheral *currentPeripheral;



// 当前连接设备的信息
@property (nonatomic, copy) NSString *currentInfo;

@end
