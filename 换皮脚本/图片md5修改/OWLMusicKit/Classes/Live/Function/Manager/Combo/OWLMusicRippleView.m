//
//  OWLMusicRippleView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/27.
//

#import "OWLMusicRippleView.h"

@implementation OWLMusicRippleView

- (void)xyf_addRipple {
    CAShapeLayer *xyp_pulseLayer = [[CAShapeLayer alloc] init];
    xyp_pulseLayer.frame = self.bounds;
    xyp_pulseLayer.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:83.0/255.0 alpha:0.7].CGColor;
    xyp_pulseLayer.opacity = 0.0;
    xyp_pulseLayer.cornerRadius = self.layer.bounds.size.height / 2.0;
    
    CABasicAnimation *xyp_opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    xyp_opacityAnimation.fromValue = @1.0;
    xyp_opacityAnimation.toValue = @0.0;
    [xyp_opacityAnimation setRemovedOnCompletion:YES];
    
    CABasicAnimation *xyp_scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    xyp_scaleAnimation.fromValue = @1.0;
    xyp_scaleAnimation.toValue = @1.6;
    
    CAAnimationGroup *xyp_group = [[CAAnimationGroup alloc] init];
    xyp_group.animations = @[xyp_opacityAnimation,xyp_scaleAnimation];
    xyp_group.duration = 1.0;
    xyp_group.autoreverses = NO;
    xyp_group.repeatCount = 1;
    
    [xyp_pulseLayer addAnimation:xyp_group forKey:@"groupAnimation"];
    
    CAReplicatorLayer *xyp_replicatorLayer = [[CAReplicatorLayer alloc] init];
    xyp_replicatorLayer.frame = self.bounds;
    xyp_replicatorLayer.instanceCount = 1;
    
    [self.layer addSublayer:xyp_replicatorLayer];
    
    [xyp_replicatorLayer addSublayer:xyp_pulseLayer];
}

@end
