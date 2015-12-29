//
//  NearByModal.h
//  YXPBlueTooth
//
//  Created by andylau on 15/8/11.
//  Copyright (c) 2015年 andylau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface NearByModal : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *RSSI;
@property (nonatomic, copy) NSString *UUID;
@property (nonatomic, copy) NSString *name2;

@property (nonatomic, strong) CBPeripheral *Peripheral;
@end
