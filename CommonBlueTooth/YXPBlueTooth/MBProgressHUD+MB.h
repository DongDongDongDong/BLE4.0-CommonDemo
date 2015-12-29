
#import "MBProgressHUD.h"

@interface MBProgressHUD (MB)

//+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;
+ (void)show:(NSString *)text duration:(CGFloat)duration;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
