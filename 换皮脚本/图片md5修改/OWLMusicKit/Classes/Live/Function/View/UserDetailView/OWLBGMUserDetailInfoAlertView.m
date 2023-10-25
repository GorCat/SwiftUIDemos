//// OWLBGMUserDetailInfoAlertView.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMUserDetailInfoAlertView.h"
#import "OWLBGMUserDetailBaseInfoView.h"
#import "OWLBGMUserDetailDataInfoView.h"
#import "OWLBGMUserDetailMedalsInfoView.h"
#import "OWLBGMUserDetailOperateView.h"
#import "OWLBGMUserDetailSelectAlertView.h"

@interface OWLBGMUserDetailInfoAlertView() <OWLBGMUserDetailBaseViewDelegate>

#pragma mark - Views
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 总容器
@property (nonatomic, strong) UIView *xyp_contentView;
/// 白色半圆背景
@property (nonatomic, strong) UIView *xyp_whiteBGView;
/// 头像
@property (nonatomic, strong) UIImageView *xyp_avatarIV;
/// 举报按钮
@property (nonatomic, strong) UIImageView *xyp_reportButton;
/// 基本信息
@property (nonatomic, strong) OWLBGMUserDetailBaseInfoView *xyp_baseInfoView;
/// 数据信息
@property (nonatomic, strong) OWLBGMUserDetailDataInfoView *xyp_dataInfoView;
/// 奖牌信息
@property (nonatomic, strong) OWLBGMUserDetailMedalsInfoView *xyp_medalsInfoView;
/// 操作区域
@property (nonatomic, strong) OWLBGMUserDetailOperateView *xyp_operateView;
/// 选择操作弹窗
@property (nonatomic, strong) OWLBGMUserDetailSelectAlertView *xyp_selectAlertView;

#pragma mark - Data
/// 详情模型
@property (nonatomic, strong) OWLMusicAccountDetailInfoModel *xyp_detailModel;

#pragma mark - BOOL
/// 是否是主播
@property (nonatomic, assign) BOOL xyp_isAnchor;
/// 是否有奖章视图
@property (nonatomic, assign) BOOL xyp_hasMedalsView;
/// 是否有操作视图(是主播才有)
@property (nonatomic, assign) BOOL xyp_hasOperateView;
/// 是否拉黑对方
@property (nonatomic, assign) BOOL xyp_isBlockOther;
/// 是否正在请求关注接口
@property (nonatomic, assign) BOOL xyp_isRequestingFollow;

#pragma mark - Layout
/// 内容总高度
@property (nonatomic, assign) CGFloat xyp_contentViewHeight;

#pragma mark - Block
/// 页面消失的回调
@property (nonatomic, copy, nullable) XYLVoidBlock xyp_dismissBlock;

@end

@implementation OWLBGMUserDetailInfoAlertView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

+ (instancetype)xyf_showUserDetailAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                 targetView:(UIView *)targetView
                                detailModel:(OWLMusicAccountDetailInfoModel *)detailModel
                                   isAnchor:(BOOL)isAnchor
                               dismissBlock:(XYLVoidBlock)dismissBlock {
    OWLBGMUserDetailInfoAlertView *view = [[OWLBGMUserDetailInfoAlertView alloc] initWithDetailModel:detailModel isAnchor:isAnchor dismissBlock:dismissBlock];
    view.delegate = delegate;
    [view xyf_showInView:targetView];
    
    return view;
}

- (instancetype)initWithDetailModel:(OWLMusicAccountDetailInfoModel *)detailModel
                           isAnchor:(BOOL)isAnchor
                       dismissBlock:(XYLVoidBlock)dismissBlock {
    self = [super initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    if (self) {
        self.xyp_detailModel = detailModel;
        self.xyp_isAnchor = isAnchor;
        self.xyp_hasOperateView = self.xyp_isAnchor;
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
    self.xyp_hasMedalsView = self.xyp_detailModel.xyp_lables.count > 0;
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
    
    [self.xyp_whiteBGView addSubview:self.xyp_reportButton];
    [self.xyp_reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(21);
        make.top.equalTo(self.xyp_whiteBGView).offset(16);
        make.leading.equalTo(self.xyp_whiteBGView).offset(16);
    }];
    
    [self.xyp_whiteBGView addSubview:self.xyp_baseInfoView];
    [self.xyp_baseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.xyp_whiteBGView);
        make.top.equalTo(self.xyp_whiteBGView).offset([self xyf_getAvatarWH] / 2.0);
        make.height.mas_equalTo([self.xyp_baseInfoView xyf_getHeight]);
    }];
    
    [self.xyp_whiteBGView addSubview:self.xyp_dataInfoView];
    [self.xyp_dataInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_baseInfoView.mas_bottom);
        make.leading.trailing.equalTo(self.xyp_whiteBGView);
        make.height.mas_equalTo([self.xyp_dataInfoView xyf_getHeight]);
    }];
    
    [self.xyp_whiteBGView addSubview:self.xyp_medalsInfoView];
    [self.xyp_medalsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.xyp_dataInfoView.mas_bottom);
        make.height.mas_equalTo([self xyf_getMedalsViewHeight]);
    }];
    
    if (self.xyp_hasOperateView) {
        [self.xyp_whiteBGView addSubview:self.xyp_operateView];
        [self.xyp_operateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.xyp_whiteBGView);
            make.top.equalTo(self.xyp_medalsInfoView.mas_bottom);
            make.height.mas_equalTo(self.xyp_operateView.xyf_getHeight);
        }];
    }
}

- (void)xyf_setupTap {
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_viewAction)];
    [self addGestureRecognizer:viewTap];
    
    UITapGestureRecognizer *whiteViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_whiteViewAction)];
    [self.xyp_whiteBGView addGestureRecognizer:whiteViewTap];
}

- (void)xyf_setupData {
    [XYCUtil xyf_loadMediumImage:self.xyp_avatarIV url:self.xyp_detailModel.xyp_avatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
    self.xyp_baseInfoView.xyp_model = self.xyp_detailModel;
    self.xyp_dataInfoView.xyp_model = self.xyp_detailModel;
    self.xyp_operateView.xyp_isFollow = self.xyp_detailModel.xyp_isFollow;
    self.xyp_medalsInfoView.xyp_model = self.xyp_detailModel;
    self.xyp_isBlockOther = self.xyp_detailModel.xyp_blockType == XYLModuleBlackListStatusType_BlockOther || self.xyp_detailModel.xyp_blockType == XYLModuleBlackListStatusType_BlockEachOther;
    self.xyp_reportButton.hidden = self.xyp_detailModel.xyp_accountId == OWLJConvertToolShared.xyf_userAccountID;
}

- (void)xyf_setupNotification {
    [self xyf_observeNotification:xyl_user_operate_follow_anchor];
    [self xyf_observeNotification:xyl_user_operate_block_anchor];
}

#pragma mark - Private
/// 更新奖牌区域
- (void)xyf_refreshMedalsInfoView {
    BOOL beforeHasMedalsView = self.xyp_hasMedalsView;
    self.xyp_hasMedalsView = YES;
    /// 如果 之前的状态 != 更新后的状态，需要更新ui
    if (beforeHasMedalsView != self.xyp_hasMedalsView) {
        [self.xyp_medalsInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([self xyf_getMedalsViewHeight]);
        }];
        self.xyp_contentViewHeight = [self xyf_getTotalHeight];
        CGRect rect = CGRectMake(0, kXYLScreenHeight - self.xyp_contentViewHeight, kXYLScreenWidth, self.xyp_contentViewHeight);
        kXYLWeakSelf
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf layoutIfNeeded];
            weakSelf.xyp_medalsInfoView.alpha = self.xyp_hasMedalsView ? 1 : 0;
            weakSelf.xyp_contentView.frame = rect;
        }];
    }
}

/// 拉黑
- (void)xyf_blockOrCancelBlock:(BOOL)isBlock {
    [OWLJConvertToolShared xyf_insideUserBlockAnchor:self.xyp_detailModel.xyp_accountId isBlock:isBlock];
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

#pragma mark - OWLBGMUserDetailBaseViewDelegate 用户详情子视图点击事件代理
/// 用户详情子视图点击事件
- (void)xyf_liveUserDetailBaseViewClickAction:(OWLBGMUserDetailBaseViewClickType)type {
    switch (type) {
        case OWLBGMUserDetailBaseViewClickType_ShowMedalsView: /// 展示奖章列表
            [self xyf_giveCallBackClickWithUserInfoAction:XYLModuleBaseViewInfoClickType_ShowMedalListView];
            break;
        case OWLBGMUserDetailBaseViewClickType_Message: /// 发消息
            [self xyf_giveCallBackClickWithUserInfoAction:XYLModuleBaseViewInfoClickType_EnterTextChatVC];
            break;
        case OWLBGMUserDetailBaseViewClickType_Follow: /// 关注
            [self xyf_giveCallBackClickFollow:YES];
            break;
        case OWLBGMUserDetailBaseViewClickType_Unfollow: /// 取关
            [self xyf_giveCallBackClickFollow:NO];
            break;
        case OWLBGMUserDetailBaseViewClickType_EnterUserDetail: /// 进入个人详情
            [self xyf_giveCallBackClickWithUserInfoAction:XYLModuleBaseViewInfoClickType_EnterUserDetailVC];
            break;
        case OWLBGMUserDetailBaseViewClickType_ShowReportView: /// 举报
            [self xyf_giveCallBackClickWithUserInfoAction:XYLModuleBaseViewInfoClickType_ShowReportUserView];
            break;
        case OWLBGMUserDetailBaseViewClickType_Block: /// 拉黑
            [self xyf_blockOrCancelBlock:YES];
            break;
        case OWLBGMUserDetailBaseViewClickType_Unblock: /// 取消拉黑
            [self xyf_blockOrCancelBlock:NO];
            break;
    }
}

#pragma mark - Action
- (void)xyf_viewAction {
    [self xyf_dismiss];
}

/// 点击白色背景（空事件 拦截xyf_viewAction）
- (void)xyf_whiteViewAction {
    
}

- (void)xyf_reportButtonAction {
    OWLBGMUserDetailSelectAlertView *view = [OWLBGMUserDetailSelectAlertView xyf_showUserDetailSelectAlertView:self isBlockOther:self.xyp_isBlockOther isAnchor:self.xyp_isAnchor];
    view.delegate = self;
}

/// 头像点击事件
- (void)xyf_avatarIVAction {
    [self xyf_giveCallBackClickWithUserInfoAction:XYLModuleBaseViewInfoClickType_EnterUserDetailVC];
}

#pragma mark - 给回调
- (void)xyf_giveCallBackClickWithUserInfoAction:(XYLModuleBaseViewInfoClickType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickInfoEvent:accountID:avatar:nickname:displayAccountID:isAnchor:)]) {
        [self.delegate xyf_lModuleBaseViewClickInfoEvent:type accountID:self.xyp_detailModel.xyp_accountId avatar:self.xyp_detailModel.xyp_avatar nickname:self.xyp_detailModel.xyp_nickName displayAccountID:self.xyp_detailModel.xyp_displayAccountId isAnchor:self.xyp_isAnchor];
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
            self.xyp_operateView.xyp_isFollow = followState;
            NSInteger fans = self.xyp_detailModel.xyp_followers;
            self.xyp_detailModel.xyp_followers = followState ? fans + 1 : fans - 1;
            self.xyp_dataInfoView.xyp_model = self.xyp_detailModel;
        }
    } else if ([notification.name isEqualToString:xyl_user_operate_block_anchor]) {
        NSDictionary *dic = notification.object;
        NSInteger accountId = [[dic objectForKey:kXYLNotificationAccountIDKey] integerValue];
        BOOL blockState = [[dic objectForKey:kXYLNotificationBlockStateKey] boolValue];
        if (self.xyp_detailModel.xyp_accountId == accountId) {
            self.xyp_isBlockOther = blockState;
        }
    }
}

#pragma mark - Getter
/// 头像宽高
- (CGFloat)xyf_getAvatarWH {
    return 90;
}

/// 奖章视图高度
- (CGFloat)xyf_getMedalsViewHeight {
    return self.xyp_hasMedalsView ? [self.xyp_medalsInfoView xyf_getHeight] : 0;
}

/// 操作视图高度
- (CGFloat)xyf_getOperateViewHeight {
    return self.xyp_hasOperateView ? [self.xyp_operateView xyf_getHeight] : 0;
}

/// 底部间距
- (CGFloat)xyf_getBottomMargin {
    return [XYCUtil xyf_isIPhoneX] ? 22 : 12;
}

/// 获取总高
- (CGFloat)xyf_getTotalHeight {
    /// 高度 = 头像 + 基本信息 + 数据信息 + 奖章视图 + 操作视图 + 底部间距
    return [self xyf_getAvatarWH] + [self.xyp_baseInfoView xyf_getHeight] + [self.xyp_dataInfoView xyf_getHeight] + [self xyf_getMedalsViewHeight] + [self xyf_getOperateViewHeight] + [self xyf_getBottomMargin];
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

- (UIImageView *)xyp_reportButton {
    if (!_xyp_reportButton) {
        _xyp_reportButton = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_reportButton iconStr:@"xyr_user_detail_report_icon"];
        _xyp_reportButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_reportButtonAction)];
        [_xyp_reportButton addGestureRecognizer:tap];
    }
    return _xyp_reportButton;
}

- (OWLBGMUserDetailBaseInfoView *)xyp_baseInfoView {
    if (!_xyp_baseInfoView) {
        _xyp_baseInfoView = [[OWLBGMUserDetailBaseInfoView alloc] init];
    }
    return _xyp_baseInfoView;
}

- (OWLBGMUserDetailDataInfoView *)xyp_dataInfoView {
    if (!_xyp_dataInfoView) {
        _xyp_dataInfoView = [[OWLBGMUserDetailDataInfoView alloc] init];
        _xyp_dataInfoView.xyp_isAnchor = self.xyp_isAnchor;
    }
    return _xyp_dataInfoView;
}

- (OWLBGMUserDetailMedalsInfoView *)xyp_medalsInfoView {
    if (!_xyp_medalsInfoView) {
        _xyp_medalsInfoView = [[OWLBGMUserDetailMedalsInfoView alloc] init];
        _xyp_medalsInfoView.hidden = !self.xyp_hasMedalsView;
        _xyp_medalsInfoView.delegate = self;
    }
    return _xyp_medalsInfoView;
}

- (OWLBGMUserDetailOperateView *)xyp_operateView {
    if (!_xyp_operateView) {
        _xyp_operateView = [[OWLBGMUserDetailOperateView alloc] init];
        _xyp_operateView.delegate = self;
    }
    return _xyp_operateView;
}

@end
