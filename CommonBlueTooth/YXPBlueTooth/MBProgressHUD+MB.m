
#import "MBProgressHUD+MB.h"
#import "NSString+Extension.h"

#define kFont [UIFont systemFontOfSize:17]
@implementation MBProgressHUD (MB)
#pragma mark 显示信息

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];

    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
//     快速显示一个提示信息
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = text;
    
//    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    
    CGSize maxSize = [text sizeWithFont:kFont andMaxSize:CGSizeMake(220, MAXFLOAT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, maxSize.height)];
    label.text = text;
    label.font = kFont;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    hud.customView = label;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    
    [hud show:YES];    
    // 1.2秒之后再消失
    [hud hide:YES afterDelay:1.2];
    
//    NSLog(@"%@",[UIApplication sharedApplication].windows);
}

+ (void)show:(NSString *)text duration:(CGFloat)duration
{
    UIView * view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    //     快速显示一个提示信息
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.labelText = text;
    
    //    // 设置图片
    //    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    
    CGSize maxSize = [text sizeWithFont:kFont andMaxSize:CGSizeMake(220, MAXFLOAT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, maxSize.height)];
    label.text = text;
    label.font = kFont;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    hud.customView = label;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    
    [hud show:YES];
    // 1.2秒之后再消失
    [hud hide:YES afterDelay:duration];
    
    //    NSLog(@"%@",[UIApplication sharedApplication].windows);
    
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
