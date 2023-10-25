//
//  XYCUtil.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#import "XYCUtil.h"

@implementation XYCUtil

/// 是否是10以上
+ (BOOL)xyf_isIPhoneX {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 0 ? YES : NO;
    } else {
        return NO;
    }
}

/// 半弹窗裁圆角
+ (void)xyf_clickRadius:(CGFloat)radius alertView:(UIView *)alertView {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:alertView.bounds byRoundingCorners:  UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = alertView.bounds;
    maskLayer.path = maskPath.CGPath;
    alertView.layer.mask = maskLayer;
    alertView.layer.masksToBounds = YES;
    alertView.clipsToBounds = YES;
}

/// 数字显示（1000以内数字，1000以上x.xk）
+ (NSString *)xyf_getKiloNum:(NSInteger)num {
    if (num < 1000) {
        return [NSString stringWithFormat:@"%ld",(long)num];
    }
    NSInteger kiloNum = num / 1000;
    NSInteger hundredNum = num % 1000 / 100;
    NSInteger tenNum = num % 1000 % 100 / 10;
    NSString *str = @"";
    if (tenNum > 0) {
        str = [NSString stringWithFormat:@"%ld.%ld%ldk",(long)kiloNum, (long)hundredNum, (long)tenNum];
    } else if (hundredNum > 0) {
        str = [NSString stringWithFormat:@"%ld.%ldk",(long)kiloNum, (long)hundredNum];
    } else {
        str = [NSString stringWithFormat:@"%ldk",(long)kiloNum];
    }
    
    return str;
}

/// 个人描述
+ (NSString *)xyf_moodTip:(NSString *)mood {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *str = [mood stringByTrimmingCharactersInSet:set];
    return str.length > 0 ? mood : kXYLLocalString(@"Welcome to my world and look forward to chill with you.");
}

/// 在主线程
+ (void)xyf_doInMain:(void(^)(void))block {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

+ (CGRect)xyf_arlTargetRect:(CGRect)targetRect bySuperRect:(CGRect)superRect {
    if (OWLJConvertToolShared.xyf_isRTL) {
        CGRect rect = targetRect;
        CGFloat x = superRect.size.width - rect.origin.x - rect.size.width;
        CGFloat y = rect.origin.y;
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        rect = CGRectMake(x, y, width, height);
        return rect;
    }
    return targetRect;
}

#pragma mark - 获取控制器
/// 被push出来的最后一个控制器
+ (UIViewController *)xyf_getLastedPushedViewController {
    UIViewController *rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    return [self xyf_getViewController:rootViewController];
}

+ (UIViewController *)xyf_getViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *) vc visibleViewController];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self xyf_getViewController:[((UITabBarController *) vc) selectedViewController]];
    } else {
        return vc;
    }
}

+ (UINavigationController *)xyf_currentNavVC {
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self xyf_getCurrentNavVC:rootViewController];
}

+ (UINavigationController *)xyf_getCurrentNavVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self xyf_getCurrentNavVC:nc];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self xyf_getCurrentNavVC:((UINavigationController *)vc).presentedViewController];
        }
        return [self xyf_getCurrentNavVC:((UINavigationController *)vc).topViewController];
    } else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self xyf_getCurrentNavVC:vc.presentedViewController];
        }
        else {
            return vc.navigationController;
        }
    } else {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
}

#pragma mark - 字符串截取
/// 截取字符串，为了避免字符里含有表情，把表情截一半
/// @param string 要截的字符串
/// @param maxLength 最大长度
+ (NSString *)xyf_subToString:(NSString *)string maxLength:(NSInteger)maxLength {
    if (string.length <= maxLength) {
        return string;
    }
    __block NSInteger idx = 0;
    __block NSString  *trimString = @"";//截取出的字串
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                                     options:NSStringEnumerationByComposedCharacterSequences
                                  usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                      idx += (enclosingRange.length);
        
                                      if (idx > maxLength) {
                                          *stop = YES; //取出所需要就break，提高效率
                                          return ;
                                      }
                                      trimString = [trimString stringByAppendingString:substring];
                                      
                                  }];
    return trimString;
}
@end
