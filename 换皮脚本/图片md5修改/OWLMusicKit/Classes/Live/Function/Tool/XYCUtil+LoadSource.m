//
//  XYCUtil+LoadSource.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

#import "XYCUtil+LoadSource.h"

@implementation XYCUtil (LoadSource)

#pragma mark - 加载图片
/// 加载icon图片（UI切图资源放在服务器上的资源图）
/// - Parameters:
///   - imageView: 图片控件
///   - iconStr: 图片命名
+ (void)xyf_loadIconImage:(UIImageView *)imageView iconStr:(NSString *)iconStr {
    imageView.image = iconStr.xyf_getOwnImageFromName;
}

/// 加载镜像icon图片
+ (void)xyf_loadMirrorImage:(UIImageView *)imageView iconStr:(NSString *)iconStr {
    imageView.image = iconStr.xyf_getOwnImageFromName.xyf_getMirroredImage;
}

/// 加载不同语言下的图片
+ (void)xyf_loadMainLanguageImage:(UIImageView *)imageView iconStr:(NSString *)iconStr {
    NSString *realStr = iconStr;
    if ([OWLJConvertToolShared.xyf_currentLanguage isEqualToString:@"ar"]) {
        realStr = [NSString stringWithFormat:@"%@_ar",iconStr];
    }
    [self xyf_loadIconImage:imageView iconStr:realStr];
}

#pragma mark - 获取图标
+ (UIImage *)xyf_getIconWithName:(NSString *) iconStr {
    UIImage *image = iconStr.xyf_getOwnImageFromName;
    return image ? image : [UIImage new];
}

+ (UIImage *)xyf_getIconWithNameInMainLanguage:(NSString *)iconStr {
    NSString *realStr = iconStr;
    if ([OWLJConvertToolShared.xyf_currentLanguage isEqualToString:@"ar"]) {
        realStr = [NSString stringWithFormat:@"%@_ar",iconStr];
    }
    return [self xyf_getIconWithName:realStr];
}

#pragma mark - 获取.png图标
+ (UIImage *)xyf_getPngIconWithName:(NSString *) iconStr {
    if (iconStr.length < 1) {
        return nil;
    }
    NSString * resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:kXYLResourceName]];
    NSString * resultPath = [resourcePath stringByAppendingFormat:@"/%@/%@.png",kXYLZipName,iconStr];
    UIImage * icon = [UIImage imageWithContentsOfFile:resultPath];
    return icon ? icon : nil;
}

#pragma mark - 剪切图片
+ (UIImage *)xyf_scaleToSize:(UIImage *)img size:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) {
        return [[UIImage alloc] init];
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [img xyf_drawInRect:CGRectMake(0, 0, size.width, size.height) withContentMode:UIViewContentModeScaleAspectFill clipsToBounds:NO];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - 给图片切圆角
+ (UIImage *)xyf_circleImageWith:(UIImage *) startImg
{
    // 1.加载原图
    UIImage *oldImage = startImg;
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width;
    CGFloat imageH = oldImage.size.height;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 4.画边框(大圆)
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    // 6.画图
    [oldImage drawInRect:CGRectMake(0, 0, oldImage.size.width, oldImage.size.height)];
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 8.结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 加载网图
/// 加载小缩略图
+ (void)xyf_loadSmallImage:(UIImageView *)imageView url:(NSString *)url placeholder:(nullable UIImage *)placeholder {
    [self xyf_loadImage:imageView url:url placeholder:placeholder scaleStr:@"-small"];
}

/// 加载中缩略图
+ (void)xyf_loadMediumImage:(UIImageView *)imageView url:(NSString *)url placeholder:(nullable UIImage *)placeholder {
    [self xyf_loadImage:imageView url:url placeholder:placeholder scaleStr:@"-medium"];
}

/// 加载原图
+ (void)xyf_loadOriginImage:(UIImageView *)imageView url:(NSString *)url placeholder:(nullable UIImage *)placeholder {
    [self xyf_loadImage:imageView url:url placeholder:placeholder];
}

/// 加载缩略图
+ (void)xyf_loadImage:(UIImageView *)imageView url:(NSString *)url placeholder:(nullable UIImage *)placeholder scaleStr:(NSString *)scaleStr {
    if (url.length == 0) {
        [self xyf_loadImage:imageView url:@"" placeholder:placeholder];
        return;
    }
    NSString *realURL = [self xyf_getLoadImageStr:url scaleStr:scaleStr];
    [self xyf_loadImage:imageView url:realURL placeholder:placeholder];
}

/// 获取加载图片的url
+ (NSString *)xyf_getLoadImageStr:(NSString *)url scaleStr:(NSString *)scaleStr {
    if (url.length == 0) {
        return @"";
    }
    
    NSString *string = url;
    NSArray *array = [string componentsSeparatedByString:@"."];
    NSString *lastStr = (NSString *)array.lastObject;
    NSString *realLastStr = [NSString stringWithFormat:@"%@.%@",scaleStr, lastStr];
    NSMutableArray *list = [NSMutableArray arrayWithArray:array];
    [list removeLastObject];
    NSString *realURL = [list componentsJoinedByString:@"."];
    [list addObject:realLastStr];
    realURL = [NSString stringWithFormat:@"%@%@",realURL, realLastStr];
    return realURL;
}

/// 加载图片
+ (void)xyf_loadImage:(UIImageView *)imageView url:(NSString *)url placeholder:(nullable UIImage *)placeholder {
    NSURL *imageUrl = [NSURL URLWithString:url];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageUrl.absoluteString];
    [imageView sd_setImageWithURL:imageUrl placeholderImage:cacheImage ? cacheImage : placeholder];
}

@end
