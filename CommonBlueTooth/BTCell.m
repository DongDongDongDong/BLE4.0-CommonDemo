//
//  BTCell.m
//  YXPBlueTooth
//
//  Created by andylau on 15/8/11.
//  Copyright (c) 2015年 andylau. All rights reserved.
//

#import "BTCell.h"

@interface BTCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *UUID;
@property (weak, nonatomic) IBOutlet UILabel *RSSI;

@end
@implementation BTCell

- (void)setModal:(NearByModal *)modal{
    self.name.text = [NSString stringWithFormat:@"设备名:%@",modal.name];
    self.UUID.text = [NSString stringWithFormat:@"UUID:%@",modal.UUID];
    self.RSSI.text = [NSString stringWithFormat:@"RSSI:%@",modal.RSSI];
}

@end
