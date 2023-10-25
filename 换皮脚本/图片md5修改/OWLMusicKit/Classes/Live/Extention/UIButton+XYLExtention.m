//
//  UIButton+XYLExtention.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/23.
//

#import "UIButton+XYLExtention.h"

@implementation UIButton (XYLExtention)

#pragma mark - 加载图片
/// 加载icon图片（UI切图资源放在服务器上的资源图）
/// - Parameters:
///   - iconStr: 图片命名
- (void)xyf_loadIconStr:(NSString *)iconStr {
    [self setImage:iconStr.xyf_getOwnImageFromName forState:UIControlStateNormal];
}

@end
