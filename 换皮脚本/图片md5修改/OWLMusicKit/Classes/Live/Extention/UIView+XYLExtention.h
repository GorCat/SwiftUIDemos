//
//  UIView+XYLExtention.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XYLExtention)

- (void)xyf_removeAllSubviews;

@property (assign, nonatomic) CGFloat xyp_x;
@property (assign, nonatomic) CGFloat xyp_y;
@property (assign, nonatomic) CGFloat xyp_w;
@property (assign, nonatomic) CGFloat xyp_h;
@property (assign, nonatomic) CGSize xyp_size;
@property (assign, nonatomic) CGPoint xyp_origin;

#pragma mark 三种颜色渐变背景
- (void)xyf_addThreeGradientColor:(NSArray *)colorArr andColorFrame:(CGRect)frame andCorner:(CGFloat)corner;

#pragma mark - 添加渐变蒙层
- (void)xyf_addDefaultGradientMaskView;


///UIView转UIImage
- (UIImage *)xyf_getImageFromView;

@end

NS_ASSUME_NONNULL_END
