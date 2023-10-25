//// OWLBGMUserDetailOperateView.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 操作视图
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMUserDetailOperateView.h"

@interface OWLBGMUserDetailOperateView()

/// 消息按钮
@property (nonatomic, strong) UIButton *xyp_messageButton;
/// 关注按钮
@property (nonatomic, strong) UIButton *xyp_followButton;

@end

@implementation OWLBGMUserDetailOperateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_messageButton];
    [self.xyp_messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([self xyf_getTopMargin]);
        make.bottom.equalTo(self).offset(-[self xyf_getBottomMargin]);
        make.leading.equalTo(self).offset(16);
        make.trailing.equalTo(self.mas_centerX).offset(-8);
    }];
    
    [self addSubview:self.xyp_followButton];
    [self.xyp_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([self xyf_getTopMargin]);
        make.bottom.equalTo(self).offset(-[self xyf_getBottomMargin]);
        make.trailing.equalTo(self).offset(-16);
        make.leading.equalTo(self.mas_centerX).offset(8);
    }];
}

#pragma mark - Setter
- (void)setXyp_isFollow:(BOOL)xyp_isFollow {
    _xyp_isFollow = xyp_isFollow;
    self.xyp_followButton.selected = xyp_isFollow;
    self.xyp_followButton.backgroundColor = xyp_isFollow ? kXYLColorFromRGB(0xEAEBEE) : kXYLColorFromRGB(0xEA417F);
}

#pragma mark - Getter
/// 顶部间距
- (CGFloat)xyf_getTopMargin {
    return 12;
}

/// 按钮高度
- (CGFloat)xyf_getButtonHeight {
    return 55;
}

/// 底部间距
- (CGFloat)xyf_getBottomMargin {
    return 12;
}

/// 总体高度
- (CGFloat)xyf_getHeight {
    return [self xyf_getTopMargin] + [self xyf_getButtonHeight] + [self xyf_getBottomMargin];
}

#pragma mark - Actions
- (void)xyf_messageButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_liveUserDetailBaseViewClickAction:)]) {
        [self.delegate xyf_liveUserDetailBaseViewClickAction:OWLBGMUserDetailBaseViewClickType_Message];
    }
}

- (void)xyf_followButtonAction {
    OWLBGMUserDetailBaseViewClickType type = self.xyp_isFollow ? OWLBGMUserDetailBaseViewClickType_Unfollow : OWLBGMUserDetailBaseViewClickType_Follow;
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_liveUserDetailBaseViewClickAction:)]) {
        [self.delegate xyf_liveUserDetailBaseViewClickAction:type];
    }
}

#pragma mark - Lazy
- (UIButton *)xyp_messageButton {
    if (!_xyp_messageButton) {
        _xyp_messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _xyp_messageButton.layer.cornerRadius = [self xyf_getButtonHeight] / 2.0;
        _xyp_messageButton.clipsToBounds = YES;
        _xyp_messageButton.backgroundColor = kXYLColorFromRGB(0xEAEBEE);
        [_xyp_messageButton setTitle:kXYLLocalString(@"Message") forState:UIControlStateNormal];
        _xyp_messageButton.titleLabel.font = kXYLGilroyBoldFont(16);
        [_xyp_messageButton setTitleColor:kXYLColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_xyp_messageButton addTarget:self action:@selector(xyf_messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_messageButton;
}

- (UIButton *)xyp_followButton {
    if (!_xyp_followButton) {
        _xyp_followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _xyp_followButton.layer.cornerRadius = [self xyf_getButtonHeight] / 2.0;
        _xyp_followButton.clipsToBounds = YES;
        [_xyp_followButton setTitle:kXYLLocalString(@"Follow") forState:UIControlStateNormal];
        [_xyp_followButton setTitle:kXYLLocalString(@"Followed") forState:UIControlStateSelected];
        [_xyp_followButton setTitleColor:kXYLColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_xyp_followButton setTitleColor:kXYLColorFromRGB(0xA2A3A7) forState:UIControlStateSelected];
        _xyp_followButton.titleLabel.font = kXYLGilroyBoldFont(16);
        _xyp_followButton.backgroundColor = kXYLColorFromRGB(0xEA417F);
        [_xyp_followButton addTarget:self action:@selector(xyf_followButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_followButton;
}

@end
