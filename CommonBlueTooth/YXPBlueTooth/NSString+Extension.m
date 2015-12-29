//
//  YXPBlueTooth
//
//  Created by andylau on 15/8/10.
//  Copyright (c) 2015年 andylau. All rights reserved.
//


#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    NSDictionary * attribute = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
}

+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    NSDictionary * attribute = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
}

+ (CGFloat)marginOfLetterWithFont:(UIFont *)font{
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize threeSzie = [self sizeWithText:@"所有人" andFont:font andMaxSize:maxSize];
    CGSize fourSzie = [self sizeWithText:@"车牌号码" andFont:font andMaxSize:maxSize];
    return (fourSzie.width - threeSzie.width) / 2;
}
@end
