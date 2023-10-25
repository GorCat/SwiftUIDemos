//
//  OWLMusicAutoFollowView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/13.
//

#import "OWLMusicAutoFollowView.h"

@interface OWLMusicAutoFollowView ()

#pragma mark - Views
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 总容器
@property (nonatomic, strong) UIView *xyp_contentView;
/// 白色半圆背景
@property (nonatomic, strong) UIView *xyp_whiteBGView;
/// 头像
@property (nonatomic, strong) UIImageView *xyp_avatarIV;
/// 昵称
@property (nonatomic, strong) UILabel *xyp_nicknameLabel;
/// 昵称
@property (nonatomic, strong) UILabel *xyp_moodLabel;
/// 关注按钮
@property (nonatomic, strong) UIButton *xyp_followButton;

#pragma mark - Data
/// 详情模型
@property (nonatomic, strong) OWLMusicAccountDetailInfoModel *xyp_detailModel;

#pragma mark - Layout
/// 内容总高度
@property (nonatomic, assign) CGFloat xyp_contentViewHeight;

#pragma mark - BOOL
/// 是否关注
@property (nonatomic, assign) BOOL xyp_isFollow;
/// 是否正在请求关注接口
@property (nonatomic, assign) BOOL xyp_isRequestingFollow;
/// 是否拉黑对方
@property (nonatomic, assign) BOOL xyp_isBlockOther;

#pragma mark - Block
/// 页面消失的回调
@property (nonatomic, copy, nullable) XYLVoidBlock xyp_dismissBlock;

@end

@implementation OWLMusicAutoFollowView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

+ (instancetype)xyf_showAutoFollowAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                 targetView:(UIView *)targetView
                                detailModel:(OWLMusicAccountDetailInfoModel *)detailModel
                               dismissBlock:(XYLVoidBlock)dismissBlock {
    OWLMusicAutoFollowView *view = [[OWLMusicAutoFollowView alloc] initWithDetailModel:detailModel dismissBlock:dismissBlock];
    view.delegate = delegate;
    [view xyf_showInView:targetView];
    
    return view;
}

- (instancetype)initWithDetailModel:(OWLMusicAccountDetailInfoModel *)detailModel
                       dismissBlock:(XYLVoidBlock)dismissBlock {
    self = [super initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    if (self) {
        self.xyp_detailModel = detailModel;
        self.xyp_dismissBlock = dismissBlock;
        [self xyf_setupLayout];
        [self xyf_setupView];
        [self xyf_setupTap];
        [self xyf_setupData];
        [self xyf_setupNotification];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout {
    self.xyp_contentViewHeight = [self xyf_getTotalHeight];
    self.xyp_contentView.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.xyp_contentViewHeight);
}

- (void)xyf_setupView {
    self.backgroundColor = kXYLColorFromRGBA(0x000000, 0.3);
    [self addSubview:self.xyp_contentView];
    
    [self.xyp_contentView addSubview:self.xyp_whiteBGView];
    [self.xyp_whiteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.xyp_contentView);
        make.top.equalTo(self.xyp_contentView).offset([self xyf_getAvatarWH] / 2.0);
    }];
    
    [self.xyp_contentView addSubview:self.xyp_avatarIV];
    [self.xyp_avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo([self xyf_getAvatarWH]);
        make.centerY.equalTo(self.xyp_whiteBGView.mas_top);
        make.centerX.equalTo(self.xyp_contentView);
    }];
    
    [self.xyp_contentView addSubview:self.xyp_nicknameLabel];
    [self.xyp_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.xyp_contentView);
        make.top.equalTo(self.xyp_avatarIV.mas_bottom).offset(12);
    }];
    
    [self.xyp_contentView addSubview:self.xyp_moodLabel];
    [self.xyp_moodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_contentView).offset(58);
        make.trailing.equalTo(self.xyp_contentView).offset(-58);
        make.top.equalTo(self.xyp_nicknameLabel.mas_bottom).offset(8);
    }];
    
    [self.xyp_contentView addSubview:self.xyp_followButton];
    [self.xyp_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xyp_contentView).offset(-[self xyf_getButtonBottomMargin]);
        make.leading.equalTo(self.xyp_contentView).offset(39);
        make.trailing.equalTo(self.xyp_contentView).offset(-39);
        make.height.mas_equalTo([self xyf_getButtonHeight]);
    }];
}

- (void)xyf_setupTap {
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_viewAction)];
    [self addGestureRecognizer:viewTap];
    
    UITapGestureRecognizer *whiteViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_whiteViewAction)];
    [self.xyp_whiteBGView addGestureRecognizer:whiteViewTap];
}

- (void)xyf_setupData {
    [XYCUtil xyf_loadMediumImage:self.xyp_avatarIV url:self.xyp_detailModel.xyp_avatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
    self.xyp_nicknameLabel.text = self.xyp_detailModel.xyp_nickName;
    self.xyp_moodLabel.text = [XYCUtil xyf_moodTip:self.xyp_detailModel.xyp_mood];
    self.xyp_isFollow = self.xyp_detailModel.xyp_isFollow;
}

- (void)xyf_setupNotification {
    [self xyf_observeNotification:xyl_user_operate_follow_anchor];
}

#pragma mark - Setter
- (void)setXyp_isFollow:(BOOL)xyp_isFollow {
    _xyp_isFollow = xyp_isFollow;
    self.xyp_followButton.selected = xyp_isFollow;
    self.xyp_followButton.backgroundColor = xyp_isFollow ? kXYLColorFromRGB(0xEAEBEE) : kXYLColorFromRGB(0xEA417F);
}

#pragma mark - 动画
/// 展示
- (void)xyf_showInView:(UIView *)superView {
    CGRect rect = self.xyp_contentView.frame;
    rect.origin.y = kXYLScreenHeight - self.xyp_contentViewHeight;
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.xyp_contentView.frame = rect;
    }];
}

/// 消失
- (void)xyf_dismiss {
    CGRect rect = self.xyp_contentView.frame;
    rect.origin.y = kXYLScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.xyp_contentView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        !self.xyp_dismissBlock?:self.xyp_dismissBlock();
    }];
}

#pragma mark - Action
- (void)xyf_viewAction {
    [self xyf_dismiss];
}

/// 点击白色背景（空事件 拦截xyf_viewAction）
- (void)xyf_whiteViewAction {
    
}

/// 头像点击事件
- (void)xyf_avatarIVAction {
    [self xyf_giveCallBackClickWithUserInfoAction:XYLModuleBaseViewInfoClickType_EnterUserDetailVC];
}

/// 关注
- (void)xyf_followButtonAction {
    [self xyf_giveCallBackClickFollow:!self.xyp_isFollow];
}

#pragma mark - 给回调
- (void)xyf_giveCallBackClickWithUserInfoAction:(XYLModuleBaseViewInfoClickType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickInfoEvent:accountID:avatar:nickname:displayAccountID:isAnchor:)]) {
        [self.delegate xyf_lModuleBaseViewClickInfoEvent:type accountID:self.xyp_detailModel.xyp_accountId avatar:self.xyp_detailModel.xyp_avatar nickname:self.xyp_detailModel.xyp_nickName displayAccountID:self.xyp_detailModel.xyp_displayAccountId isAnchor:YES];
    }
}

- (void)xyf_giveCallBackClickFollow:(BOOL)isFollow {
    if (self.xyp_isRequestingFollow) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewFollowAnchor:isFollow:completion:)]) {
        self.xyp_isRequestingFollow = YES;
        kXYLWeakSelf;
        [self.delegate xyf_lModuleBaseViewFollowAnchor:self.xyp_detailModel.xyp_accountId isFollow:isFollow completion:^{
            weakSelf.xyp_isRequestingFollow = NO;
        }];
    }
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_user_operate_follow_anchor]) {
        NSDictionary *dic = notification.object;
        NSInteger accountId = [[dic objectForKey:kXYLNotificationAccountIDKey] integerValue];
        BOOL followState = [[dic objectForKey:kXYLNotificationFollowStateKey] boolValue];
        if (self.xyp_detailModel.xyp_accountId == accountId) {
            self.xyp_detailModel.xyp_isFollow = followState;
            self.xyp_isFollow = followState;
        }
    }
}

#pragma mark - Getter
/// 头像宽高
- (CGFloat)xyf_getAvatarWH {
    return 90;
}

/// 按钮顶部间距
- (CGFloat)xyf_getButtonTopMargin {
    return 93.5;
}

/// 按钮高度
- (CGFloat)xyf_getButtonHeight {
    return 55;
}

/// 按钮底部间距
- (CGFloat)xyf_getButtonBottomMargin {
    return [XYCUtil xyf_isIPhoneX] ? 24 : 14;
}

/// 获取总高
- (CGFloat)xyf_getTotalHeight {
    /// 高度 = 头像 + 按钮顶部间距 + 按钮高度 + 按钮底部间距
    return [self xyf_getAvatarWH] + [self xyf_getButtonTopMargin] + [self xyf_getButtonHeight] + [self xyf_getButtonBottomMargin];
}

#pragma mark - Lazy
- (UIView *)xyp_contentView {
    if (!_xyp_contentView) {
        _xyp_contentView = [[UIView alloc] init];
    }
    return _xyp_contentView;
}

- (UIView *)xyp_whiteBGView {
    if (!_xyp_whiteBGView) {
        _xyp_whiteBGView = [[UIView alloc] init];
        // 一个很呆的方式实现背景圆角 (上面一个20圆角的view + 下面一个长方形的view盖一下)，因为高度可能会更新 xy怕圆角裁剪有问题
        UIView *cornerView = [[UIView alloc] init];
        cornerView.backgroundColor = UIColor.whiteColor;
        cornerView.layer.cornerRadius = 20;
        cornerView.clipsToBounds = YES;
        [_xyp_whiteBGView addSubview:cornerView];
        [cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(_xyp_whiteBGView);
            make.height.mas_equalTo(60);
        }];
        
        UIView *rectView = [[UIView alloc] init];
        rectView.backgroundColor = UIColor.whiteColor;
        [_xyp_whiteBGView addSubview:rectView];
        [rectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(_xyp_whiteBGView);
            make.top.equalTo(cornerView.mas_bottom).offset(-25);
        }];
    }
    return _xyp_whiteBGView;
}

- (UIImageView *)xyp_avatarIV {
    if (!_xyp_avatarIV) {
        _xyp_avatarIV = [[UIImageView alloc] init];
        _xyp_avatarIV.layer.cornerRadius = [self xyf_getAvatarWH] / 2.0;
        _xyp_avatarIV.clipsToBounds = YES;
        _xyp_avatarIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_avatarIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_avatarIVAction)];
        [_xyp_avatarIV addGestureRecognizer:tap];
    }
    return _xyp_avatarIV;
}

- (UILabel *)xyp_nicknameLabel {
    if (!_xyp_nicknameLabel) {
        _xyp_nicknameLabel = [[UILabel alloc] init];
        _xyp_nicknameLabel.font = kXYLGilroyBoldFont(18);
        _xyp_nicknameLabel.textColor = kXYLColorFromRGB(0x333333);
    }
    return _xyp_nicknameLabel;
}

- (UILabel *)xyp_moodLabel {
    if (!_xyp_moodLabel) {
        _xyp_moodLabel = [[UILabel alloc] init];
        _xyp_moodLabel.textColor = kXYLColorFromRGB(0xB0B0B1);
        _xyp_moodLabel.numberOfLines = 2;
        _xyp_moodLabel.font = kXYLGilroyMediumFont(12);
        _xyp_moodLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_moodLabel;
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
