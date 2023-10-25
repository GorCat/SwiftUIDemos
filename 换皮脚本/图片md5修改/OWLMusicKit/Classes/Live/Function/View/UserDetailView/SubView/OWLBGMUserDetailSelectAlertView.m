//
//  OWLBGMUserDetailSelectAlertView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

/**
 * @功能描述：直播间用户信息弹窗 - 举报/拉黑弹窗
 * @创建时间：2023.2.13
 * @创建人：许琰
 */

#import "OWLBGMUserDetailSelectAlertView.h"

@interface OWLBGMUserDetailSelectAlertView ()

#pragma mark - Views
/// 容器
@property (nonatomic, strong) UIView *xyp_contentView;
/// stackView
@property (nonatomic, strong) UIStackView *xyp_stackView;
/// 举报
@property (nonatomic, strong) UIButton *xyp_reportButton;
/// 拉黑
@property (nonatomic, strong) UIButton *xyp_blockButton;
/// 取消按钮
@property (nonatomic, strong) UIButton *xyp_cancelButton;

#pragma mark - BOOL
/// 是否有拉黑按钮
@property (nonatomic, assign) BOOL xyp_hasBlockButton;
/// 是否显示拉黑状态
@property (nonatomic, assign) BOOL xyp_isShowBlockState;

#pragma mark - Layout
/// 总体高度
@property (nonatomic, assign) CGFloat xyp_totalHeight;
/// stackview高度
@property (nonatomic, assign) CGFloat xyp_stackHeight;

@end

@implementation OWLBGMUserDetailSelectAlertView

+ (instancetype)xyf_showUserDetailSelectAlertView:(UIView *)targetView
                                     isBlockOther:(BOOL)isBlockOther
                                         isAnchor:(BOOL)isAnchor {
    OWLBGMUserDetailSelectAlertView *view = [[OWLBGMUserDetailSelectAlertView alloc] initWithIsBlockOther:isBlockOther isAnchor:isAnchor];
    [view xyf_showInView:targetView];
    return view;
}
                                  
- (instancetype)initWithIsBlockOther:(BOOL)isBlockOther isAnchor:(BOOL)isAnchor {
    self = [super initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    if (self) {
        self.xyp_hasBlockButton = isAnchor; // 只有主播才有拉黑按钮
        self.xyp_isShowBlockState = !isBlockOther; // 如果已经拉黑了对方 显示取消拉黑。如果还没拉黑对方 显示拉黑
        [self xyf_setupLayout];
        [self xyf_setupView];
        [self xyf_setupTap];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout {
    self.xyp_stackHeight = self.xyp_hasBlockButton ? [self xyf_getButtonHeight] * 2 + 1 : [self xyf_getButtonHeight];
    self.xyp_totalHeight = self.xyp_stackHeight + 9 + [self xyf_getButtonHeight] + [self xyf_getBottomMargin];
    self.xyp_contentView.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.xyp_totalHeight);
}

- (void)xyf_setupView {
    self.backgroundColor = kXYLColorFromRGBA(0x000000, 0.15);
    [self addSubview:self.xyp_contentView];
    
    [self.xyp_contentView addSubview:self.xyp_cancelButton];
    [self.xyp_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xyp_contentView).offset(-[self xyf_getBottomMargin]);
        make.leading.equalTo(self.xyp_contentView).offset(9);
        make.trailing.equalTo(self.xyp_contentView).offset(-9);
        make.height.mas_equalTo([self xyf_getButtonHeight]);
    }];
    
    [self.xyp_contentView addSubview:self.xyp_stackView];
    [self.xyp_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xyp_cancelButton.mas_top).offset(-9);
        make.leading.equalTo(self.xyp_contentView).offset(9);
        make.trailing.equalTo(self.xyp_contentView).offset(-9);
        make.height.mas_equalTo(self.xyp_stackHeight);
    }];
    
    [self.xyp_stackView addArrangedSubview:self.xyp_reportButton];
    if (self.xyp_hasBlockButton) {
        NSString *title = self.xyp_isShowBlockState ? kXYLLocalString(@"Block") : kXYLLocalString(@"Unblock");
        [self.xyp_blockButton setTitle:title forState:UIControlStateNormal];
        [self.xyp_stackView addArrangedSubview:self.xyp_blockButton];
    }
}

- (void)xyf_setupTap {
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_viewAction)];
    [self addGestureRecognizer:viewTap];
}

#pragma mark - 动画
/// 展示
- (void)xyf_showInView:(UIView *)superView {
    CGRect rect = self.xyp_contentView.frame;
    rect.origin.y = kXYLScreenHeight - self.xyp_totalHeight;
    [superView addSubview:self];
    [UIView animateWithDuration:0.15 animations:^{
        self.xyp_contentView.frame = rect;
    }];
}

/// 消失
- (void)xyf_dismiss {
    CGRect rect = self.xyp_contentView.frame;
    rect.origin.y = kXYLScreenHeight;
    [UIView animateWithDuration:0.15 animations:^{
        self.xyp_contentView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Actions
- (void)xyf_viewAction {
    [self xyf_dismiss];
}

- (void)xyf_blockButtonAction {
    [self xyf_dismiss];
    OWLBGMUserDetailBaseViewClickType type = self.xyp_isShowBlockState ? OWLBGMUserDetailBaseViewClickType_Block : OWLBGMUserDetailBaseViewClickType_Unblock;
    [self xyf_giveCallBackClickActionWithType:type];
}

- (void)xyf_cancelButtonAction {
    [self xyf_dismiss];
}

- (void)xyf_reportButtonAction {
    [self xyf_dismiss];
    [self xyf_giveCallBackClickActionWithType:OWLBGMUserDetailBaseViewClickType_ShowReportView];
}

#pragma mark - Getter
/// 底部间距
- (CGFloat)xyf_getBottomMargin {
    return [XYCUtil xyf_isIPhoneX] ? 34 : 15;
}

/// 按钮高度
- (CGFloat)xyf_getButtonHeight {
    return 54;
}

#pragma mark - 给回调
- (void)xyf_giveCallBackClickActionWithType:(OWLBGMUserDetailBaseViewClickType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_liveUserDetailBaseViewClickAction:)]) {
        [self.delegate xyf_liveUserDetailBaseViewClickAction:type];
    }
}

#pragma mark - Lazy
- (UIView *)xyp_contentView {
    if (!_xyp_contentView) {
        _xyp_contentView = [[UIView alloc] init];
    }
    return _xyp_contentView;
}

- (UIButton *)xyp_cancelButton {
    if (!_xyp_cancelButton) {
        _xyp_cancelButton = [[UIButton alloc] init];
        _xyp_cancelButton.backgroundColor = kXYLColorFromRGB(0xffffff);
        _xyp_cancelButton.layer.cornerRadius = 10;
        _xyp_cancelButton.clipsToBounds = YES;
        _xyp_cancelButton.titleLabel.font = kXYLGilroyBoldFont(18);
        [_xyp_cancelButton setTitle:kXYLLocalString(@"Cancel") forState:UIControlStateNormal];
        [_xyp_cancelButton setTitleColor:kXYLColorFromRGB(0x288AFF) forState:UIControlStateNormal];
        [_xyp_cancelButton addTarget:self action:@selector(xyf_cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_cancelButton;
}

- (UIButton *)xyp_reportButton {
    if (!_xyp_reportButton) {
        _xyp_reportButton = [[UIButton alloc] init];
        _xyp_reportButton.backgroundColor = kXYLColorFromRGB(0xEBECEB);
        _xyp_reportButton.titleLabel.font = kXYLGilroyMediumFont(16);
        [_xyp_reportButton setTitle:kXYLLocalString(@"Report") forState:UIControlStateNormal];
        [_xyp_reportButton setTitleColor:kXYLColorFromRGB(0x288AFF) forState:UIControlStateNormal];
        [_xyp_reportButton addTarget:self action:@selector(xyf_reportButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_reportButton;
}

- (UIButton *)xyp_blockButton {
    if (!_xyp_blockButton) {
        _xyp_blockButton = [[UIButton alloc] init];
        _xyp_blockButton.backgroundColor = kXYLColorFromRGB(0xEBECEB);
        _xyp_blockButton.titleLabel.font = kXYLGilroyMediumFont(16);
        [_xyp_blockButton setTitle:kXYLLocalString(@"Block") forState:UIControlStateNormal];
        [_xyp_blockButton setTitleColor:kXYLColorFromRGB(0x288AFF) forState:UIControlStateNormal];
        [_xyp_blockButton addTarget:self action:@selector(xyf_blockButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_blockButton;
}

- (UIStackView *)xyp_stackView {
    if (!_xyp_stackView) {
        _xyp_stackView = [[UIStackView alloc] init];
        _xyp_stackView.axis = UILayoutConstraintAxisVertical;
        _xyp_stackView.alignment = UIStackViewAlignmentFill;
        _xyp_stackView.distribution = UIStackViewDistributionFillEqually;
        _xyp_stackView.spacing = 1;
        _xyp_stackView.backgroundColor = kXYLColorFromRGB(0xCBOWLPPOWLPP);
        _xyp_stackView.clipsToBounds = YES;
        _xyp_stackView.layer.cornerRadius = 10;
    }
    return _xyp_stackView;
}

@end
