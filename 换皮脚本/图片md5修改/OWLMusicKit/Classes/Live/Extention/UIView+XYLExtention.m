//
//  UIView+XYLExtention.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/9.
//

#import "UIView+XYLExtention.h"

@implementation UIView (XYLExtention)

- (void)xyf_removeAllSubviews {
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (void)setXyp_x:(CGFloat)xyp_x {
    CGRect frame = self.frame;
    frame.origin.x = xyp_x;
    self.frame = frame;
}

- (CGFloat)xyp_x {
    return self.frame.origin.x;
}

- (void)setXyp_y:(CGFloat)xyp_y {
    CGRect frame = self.frame;
    frame.origin.y = xyp_y;
    self.frame = frame;
}

- (CGFloat)xyp_y {
    return self.frame.origin.y;
}

- (void)setXyp_w:(CGFloat)xyp_w
{
    CGRect frame = self.frame;
    frame.size.width = xyp_w;
    self.frame = frame;
}

- (CGFloat)xyp_w
{
    return self.frame.size.width;
}

- (void)setXyp_h:(CGFloat)xyp_h
{
    CGRect frame = self.frame;
    frame.size.height = xyp_h;
    self.frame = frame;
}

- (CGFloat)xyp_h
{
    return self.frame.size.height;
}

- (void)setXyp_size:(CGSize)xyp_size
{
    CGRect frame = self.frame;
    frame.size = xyp_size;
    self.frame = frame;
}

- (CGSize)xyp_size
{
    return self.frame.size;
}

- (void)setXyp_origin:(CGPoint)xyp_origin
{
    CGRect frame = self.frame;
    frame.origin = xyp_origin;
    self.frame = frame;
}

- (CGPoint)xyp_origin
{
    return self.frame.origin;
}

#pragma mark 三种颜色渐变背景
- (void)xyf_addThreeGradientColor:(NSArray *)colorArr andColorFrame:(CGRect)frame andCorner:(CGFloat)corner {
    CAGradientLayer * gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = frame;
    gradientLayer.cornerRadius = corner;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[colorArr[0] CGColor],(id)[colorArr[1] CGColor], [colorArr[2] CGColor],nil];
    gradientLayer.locations = @[@(0.0),@(0.75),@(1)];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

#pragma mark - 添加渐变蒙层
- (void)xyf_addDefaultGradientMaskView {
    CAGradientLayer * gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[kXYLColorFromRGBA(0x000000, 0.0) CGColor], (id)[kXYLColorFromRGBA(0x000000, 1) CGColor], [kXYLColorFromRGBA(0x000000, 1) CGColor],nil];
    gradientLayer.locations = @[@(0.0),@(0.3),@(1)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = self.bounds;
    self.layer.mask = gradientLayer;
}

///UIView转UIImage
- (UIImage *)xyf_getImageFromView {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
