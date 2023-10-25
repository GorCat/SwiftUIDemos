//
//  XYCUtil+LoadSource.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

#import "XYCUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYCUtil (LoadSource)

#pragma mark - 加载图片
/// 加载icon图片（UI切图资源放在服务器上的资源图）
/// - Parameters:
///   - imageView: 图片控件
///   - iconStr: 图片命名
+ (void)xyf_loadIconImage:(UIImageView *)imageView iconStr:(NSString *)iconStr;

/// 加载镜像icon图片
+ (void)xyf_loadMirrorImage:(UIImageView *)imageView iconStr:(NSString *)iconStr;

/// 加载不同语言下的图片
+ (void)xyf_loadMainLanguageImage:(UIImageView *)imageView iconStr:(NSString *)iconStr;

/// 获取icon图片（UI切图资源放在服务器上的资源图）
/// - Parameters:
///   - iconStr: 图片命名
+ (UIImage *)xyf_getIconWithName:(NSString *) iconStr;

/// 在不同语言环境下的图片
+ (UIImage *)xyf_getIconWithNameInMainLanguage:(NSString *)iconStr;

/// 获取.png图标
+ (UIImage *)xyf_getPngIconWithName:(NSString *) iconStr;

/// 剪切图片
+ (UIImage *)xyf_scaleToSize:(UIImage *)img size:(CGSize)size;

/// 给图片切圆角
+ (UIImage *)xyf_circleImageWith:(UIImage *) startImg;

#pragma mark - 加载网图
/// 加载小缩略图
+ (void)xyf_loadSmallImage:(UIImageView *)imageView url:(NSString *)url placeholder:(nullable UIImage *)placeholder;

/// 加载中缩略图
+ (void)xyf_loadMediumImage:(UIImageView *)imageView url:(NSString *)url placeholder:(nullable UIImage *)placeholder;

/// 加载原图
+ (void)xyf_loadOriginImage:(UIImageView *)imageView url:(NSString *)url placeholder:(nullable UIImage *)placeholder;


@end

NS_ASSUME_NONNULL_END
