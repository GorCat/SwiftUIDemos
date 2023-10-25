//
//  UIButton+XYLExtention.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (XYLExtention)

/// 加载icon图片（UI切图资源放在服务器上的资源图）
/// - Parameters:
///   - iconStr: 图片命名
- (void)xyf_loadIconStr:(NSString *)iconStr;

@end

NS_ASSUME_NONNULL_END
