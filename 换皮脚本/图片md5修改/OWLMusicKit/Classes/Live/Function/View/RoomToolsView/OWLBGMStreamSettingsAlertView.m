//
//  OWLBGMStreamSettingsAlertView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/6/30.
//

#import "OWLBGMStreamSettingsAlertView.h"
#import "OWLBGMStreamSettingsInfoView.h"

@interface OWLBGMStreamSettingsAlertView()

#pragma mark - Views
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;
/// stackView
@property (nonatomic, strong) UIStackView *xyp_stackView;
/// 悬浮窗
@property (nonatomic, strong) OWLBGMStreamSettingsInfoView *xyp_inAppView;
/// 画中画
@property (nonatomic, strong) OWLBGMStreamSettingsInfoView *xyp_outAppView;

#pragma mark - BOOL
/// 是否有画中画功能
@property (nonatomic, assign) BOOL xyp_hasPIPFunc;

#pragma mark - Layout
/// 总高度
@property (nonatomic, assign) CGFloat xyp_totalHeight;



@end

@implementation OWLBGMStreamSettingsAlertView

+ (instancetype)xyf_showStreamSettingsAlertView:(UIView *)targetView {
    OWLBGMStreamSettingsAlertView *view = [[OWLBGMStreamSettingsAlertView alloc] init];
    [view xyf_showInView:targetView];
    
    return view;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.xyp_hasPIPFunc = [OWLJConvertToolShared xyf_hasPIPFunction];
        [self xyf_setupLayout];
        [XYCUtil xyf_clickRadius:20 alertView:self];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout {
    self.xyp_totalHeight = self.xyp_hasPIPFunc ? 200 : 150;
    self.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.xyp_totalHeight);
}

- (void)xyf_setupView {
    self.backgroundColor = kXYLColorFromRGB(0x1F1F22);
    
    [self addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.xyp_stackView];
    [self.xyp_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.xyp_titleLabel.mas_bottom).offset(12);
    }];
    
    [self.xyp_stackView addArrangedSubview:self.xyp_inAppView];
    [self.xyp_inAppView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(67);
        make.width.mas_equalTo(kXYLScreenWidth);
    }];
    
    if (self.xyp_hasPIPFunc) {
        [self.xyp_stackView addArrangedSubview:self.xyp_outAppView];
        [self.xyp_outAppView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(67);
            make.width.mas_equalTo(kXYLScreenWidth);
        }];
    }
}

#pragma mark - 动画
/// 展示
- (void)xyf_showInView:(UIView *)superView {
    CGRect rect = self.frame;
    rect.origin.y = kXYLScreenHeight - self.xyp_totalHeight;
    [superView addSubview:self.xyp_overyView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = rect;
    }];
}

/// 消失
- (void)xyf_dismiss {
    CGRect rect = self.frame;
    rect.origin.y = kXYLScreenHeight;
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.xyp_overyView removeFromSuperview];
    }];
}

#pragma mark - Action
- (void)xyf_overyViewAction {
    [self xyf_dismiss];
}

#pragma mark - Lazy
- (UIControl *)xyp_overyView {
    if (!_xyp_overyView) {
        _xyp_overyView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_overyView.backgroundColor = UIColor.clearColor;
        [_xyp_overyView addTarget:self action:@selector(xyf_overyViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_overyView;
}

- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.font = kXYLGilroyBoldFont(18);
        _xyp_titleLabel.text = kXYLLocalString(@"Stream Settings");
        _xyp_titleLabel.textColor = UIColor.whiteColor;
    }
    return _xyp_titleLabel;
}

- (UIStackView *)xyp_stackView {
    if (!_xyp_stackView) {
        _xyp_stackView = [[UIStackView alloc] init];
        _xyp_stackView.axis = UILayoutConstraintAxisVertical;
        _xyp_stackView.alignment = UIStackViewAlignmentCenter;
    }
    return _xyp_stackView;
}

- (OWLBGMStreamSettingsInfoView *)xyp_inAppView {
    if (!_xyp_inAppView) {
        _xyp_inAppView = [[OWLBGMStreamSettingsInfoView alloc] initWithType:OWLMusciStreamSettingType_InApp];
    }
    return _xyp_inAppView;
}

- (OWLBGMStreamSettingsInfoView *)xyp_outAppView {
    if (!_xyp_outAppView) {
        _xyp_outAppView = [[OWLBGMStreamSettingsInfoView alloc] initWithType:OWLMusciStreamSettingType_OutApp];
    }
    return _xyp_outAppView;
}

@end
