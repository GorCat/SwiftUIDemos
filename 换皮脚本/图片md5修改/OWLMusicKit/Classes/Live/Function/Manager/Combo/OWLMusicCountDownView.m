//
//  OWLMusicCountDownView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/27.
//

#import "OWLMusicCountDownView.h"
#import "OWLMusicComboView.h"

@interface OWLMusicCountDownView () <CAAnimationDelegate>

@property (nonatomic, retain) UIImageView *xyp_imageView;

@property (nonatomic, retain) CAShapeLayer *xyp_countDownLayer;

@property (nonatomic, retain) NSTimer *xyp_countDownTimer;

@end

@implementation OWLMusicCountDownView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.xyp_imageView];
        [self.xyp_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return  self;
}


- (void)xyf_startCountDown {
    [self xyf_addCountDownAnimation];
    [self xyf_addScaleAnimation];
}

- (void)xyf_addCountDownAnimation {
    [self.layer addSublayer:self.xyp_countDownLayer];
    
    CGFloat xyp_x = self.frame.size.width / 2.0;
    CGFloat xyp_y = self.frame.size.height / 2.0;
    
    UIBezierPath *xyp_countDownPath = [[UIBezierPath alloc] init];
    [xyp_countDownPath addArcWithCenter:CGPointMake(xyp_x, xyp_y) radius:MIN(xyp_x, xyp_y) startAngle:-M_PI_2 endAngle:-2.5*M_PI clockwise:NO];
    _xyp_countDownLayer.path = xyp_countDownPath.CGPath;
    _xyp_countDownLayer.strokeStart = 0.0;
    _xyp_countDownLayer.strokeEnd = 1.0;
    _xyp_countDownLayer.fillColor = [UIColor clearColor].CGColor;
    _xyp_countDownLayer.strokeColor = [UIColor whiteColor].CGColor;
    _xyp_countDownLayer.lineWidth = 3.0;
    _xyp_countDownLayer.lineCap = kCALineCapRound;
    
    CABasicAnimation *xyp_countDownAnimation = [[CABasicAnimation alloc] init];
    xyp_countDownAnimation.fromValue = @1.0;
    xyp_countDownAnimation.toValue = @0.0;
    xyp_countDownAnimation.duration = 3.0;
    xyp_countDownAnimation.fillMode = kCAFillModeForwards;
    xyp_countDownAnimation.removedOnCompletion = NO;
    xyp_countDownAnimation.delegate = self;
    
    [self.xyp_countDownLayer addAnimation:xyp_countDownAnimation forKey:@"strokeEnd"];
    
    if (self.xyp_countDownTimer.isValid) {
        [self.xyp_countDownTimer invalidate];
    }
    
    self.xyp_countDownTimer = [NSTimer scheduledTimerWithTimeInterval:xyp_countDownAnimation.duration repeats:NO block:^(NSTimer * _Nonnull timer) {
        if([self.superview isKindOfClass:[OWLMusicComboView class]] ){
            [(OWLMusicComboView *)self.superview xyf_finishCountDown];
        }
    }];
    [NSRunLoop.mainRunLoop addTimer:self.xyp_countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)xyf_addScaleAnimation {
    CASpringAnimation *xyp_scaleAnimation = [[CASpringAnimation alloc] init];
    xyp_scaleAnimation.duration = 2.5;
    xyp_scaleAnimation.removedOnCompletion = YES;
    xyp_scaleAnimation.damping = 100.0;
    xyp_scaleAnimation.fromValue = @0.83;
    xyp_scaleAnimation.toValue = @1.0;
    [self.layer addAnimation:xyp_scaleAnimation forKey:@"transform.scale"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive || flag) {
        if ([self.superview isKindOfClass:[OWLMusicComboView class]]) {
            [(OWLMusicComboView *)self.superview xyf_finishCountDown];
        }
    }
}

- (UIImageView *)xyp_imageView {
    if(!_xyp_imageView) {
        _xyp_imageView = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_imageView iconStr:@"xyr_icon_combo"];
    }
    return  _xyp_imageView;
}

- (CAShapeLayer *)xyp_countDownLayer {
    if (!_xyp_countDownLayer) {
        _xyp_countDownLayer = [[CAShapeLayer alloc] init];
    }
    return  _xyp_countDownLayer;
}

@end
