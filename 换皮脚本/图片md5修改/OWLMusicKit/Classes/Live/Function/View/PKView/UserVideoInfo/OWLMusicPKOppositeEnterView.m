//
//  OWLMusicPKOppositeEnterView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/2.
//

#import "OWLMusicPKOppositeEnterView.h"
#import "UIButton+XYLExtention.h"

@interface OWLMusicPKOppositeEnterView ()

/// 背景
@property (nonatomic, strong) UIView *xyp_bgView;
/// 对方文案
@property (nonatomic, strong) UIStackView *xyp_stackView;
/// 对方按钮
@property (nonatomic, strong) UIButton *xyp_oppsideButton;

@end

@implementation OWLMusicPKOppositeEnterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled || self.hidden || self.alpha < 0.01) {
        return nil;
    }
    
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    for (UIView *view in self.subviews) {
        CGPoint tempPoint = [view convertPoint:point fromView:self];
        CGRect bounds = view.bounds;
        if (CGRectContainsPoint(bounds, tempPoint)) {
            if ([view isKindOfClass:[UIButton class]]) {
                return view;
            }
        }
    }
    return nil;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.xyp_bgView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.xyp_bgView.xyp_h / 2.0, self.xyp_bgView.xyp_h / 2.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.xyp_bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.xyp_bgView.layer.mask = maskLayer;
    self.xyp_bgView.layer.masksToBounds = YES;
    self.xyp_bgView.clipsToBounds = YES;
    
    [self addSubview:self.xyp_stackView];
    [self.xyp_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self addSubview:self.xyp_oppsideButton];
}

#pragma mark - Actions
- (void)xyf_clickOppositeButton {
    [self xyf_giveCallBackClickType:XYLModuleBaseViewClickType_EnterOtherRoom];
}

#pragma mark - 给回调
- (void)xyf_giveCallBackClickType:(XYLModuleBaseViewClickType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickEvent:)]) {
        [self.delegate xyf_lModuleBaseViewClickEvent:type];
    }
}

#pragma mark - Getter
- (CGRect)xyf_oppositeViewFrame {
    CGFloat height = 27;
    CGFloat width = 82;
    CGFloat x = kXYLScreenWidth - width;
    CGFloat y = kXYLPKVideoViewHeight - 50 - height;
    return CGRectMake(x, y, width, height);
}

#pragma mark - Lazy
- (UIView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, 27)];
        _xyp_bgView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.3);
    }
    return _xyp_bgView;
}

- (UIStackView *)xyp_stackView {
    if (!_xyp_stackView){
        _xyp_stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, 82, 27)];
        _xyp_stackView.axis = UILayoutConstraintAxisHorizontal;
        _xyp_stackView.spacing = 5;
        _xyp_stackView.distribution = UIStackViewDistributionFill;
        _xyp_stackView.alignment = UIStackViewAlignmentCenter;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = kXYLLocalString(@"Opposite");
        label.textColor = UIColor.whiteColor;
        label.font = kXYLGilroyMediumFont(12);
        UIImageView *image = [[UIImageView alloc] init];
        [XYCUtil xyf_loadMirrorImage:image iconStr:@"xyr_pk_opposite_arrow_icon"];
        image.contentMode = UIViewContentModeScaleAspectFit;
        
        [_xyp_stackView addArrangedSubview:label];
        [_xyp_stackView addArrangedSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(7);
            make.width.mas_equalTo(4);
        }];
    }
    return _xyp_stackView;
}

- (UIButton *)xyp_oppsideButton {
    if (!_xyp_oppsideButton) {
        _xyp_oppsideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 82, 27)];
        [_xyp_oppsideButton addTarget:self action:@selector(xyf_clickOppositeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_oppsideButton;
}

@end
