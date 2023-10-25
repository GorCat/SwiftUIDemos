//
//  XYCUtil.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYCUtil : NSObject

/// 是否是10以上
+ (BOOL)xyf_isIPhoneX;

/// 半弹窗裁圆角
+ (void)xyf_clickRadius:(CGFloat)radius alertView:(UIView *)alertView;

/// 数字显示（1000以内数字，1000以上x.xk）
+ (NSString *)xyf_getKiloNum:(NSInteger)num;

/// 个人描述
+ (NSString *)xyf_moodTip:(NSString *)mood;

/// 在主线程
+ (void)xyf_doInMain:(void(^)(void))block;

+ (CGRect)xyf_arlTargetRect:(CGRect)targetRect bySuperRect:(CGRect)superRect;

/// 被push出来的最后一个控制器
+ (UIViewController *)xyf_getLastedPushedViewController;

+ (UINavigationController *)xyf_currentNavVC;

/// 截取字符串，为了避免字符里含有表情，把表情截一半
/// @param string 要截的字符串
/// @param maxLength 最大长度
+ (NSString *)xyf_subToString:(NSString *)string maxLength:(NSInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
