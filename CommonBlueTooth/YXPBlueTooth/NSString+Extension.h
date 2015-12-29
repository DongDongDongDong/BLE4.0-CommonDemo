//
//  YXPBlueTooth
//
//  Created by andylau on 15/8/10.
//  Copyright (c) 2015年 andylau. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)
/**
 *  计算文本占用的宽高
 * font 字体
 * maxSize 最大的显示范围
 * 返回占用的宽高
 */
// 类方法
+ (CGSize) sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

// 实例对象方法
- (CGSize) sizeWithFont:(UIFont *)font andMaxSize:(CGSize) maxSize;

/**
 *  根据字体大小计算出3个文字和4个文字应该分隔的间距
 *
 *  @param font 字体大小
 *
 *  @return 间距
 */
+ (CGFloat) marginOfLetterWithFont:(UIFont *)font;

@end
