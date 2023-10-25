//
//  OWLBGMTopRoomInfoView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间顶部房间信息视图
 * @创建时间：2023.2.9
 * @创建人：许琰
 * @备注：顶部 【主播信息 + 观众列表 + 房间主题 + 目标金额 + 房间ID】 一栏
 */

#import "OWLBGMTopRoomInfoView.h"
#import "OWLMusicTopAudienceListCell.h"
#import "OWLBGMTopRoomThemeView.h"
#import "OWLBGMTopTargetCoinsView.h"

@interface OWLBGMTopRoomInfoView () <
UICollectionViewDelegate,
UICollectionViewDataSource,
OWLMusicTopAudienceListCellDelegate
>

#pragma mark - 主播信息
/// 主播信息背景
@property (nonatomic, strong) UIView *xyp_anchorInfoBGView;
/// 头像
@property (nonatomic, strong) UIImageView *xyp_avatarIV;
/// 昵称
@property (nonatomic, strong) UILabel *xyp_nicknameLabel;
/// 观看icon
@property (nonatomic, strong) UIImageView *xyp_watchIV;
/// 人数
@property (nonatomic, strong) UILabel *xyp_numLabel;
/// 关注按钮
@property (nonatomic, strong) UIImageView *xyp_followButton;

#pragma mark - 观众列表
/// 观众列表背景
@property (nonatomic, strong) UIView *xyp_audienceListBGView;
/// 观众按钮
@property (nonatomic, strong) UIButton *xyp_audienceButton;
/// 观众列表
@property (nonatomic, strong) UICollectionView *xyp_collectionView;

#pragma mark - 房间主题
/// 房间主题
@property (nonatomic, strong) OWLBGMTopRoomThemeView *xyp_themeView;

#pragma mark - 目标金额
/// 目标金额
@property (nonatomic, strong) OWLBGMTopTargetCoinsView *xyp_targetCoinsView;

#pragma mark - 房间ID
/// 房间ID容器
@property (nonatomic, strong) UIView *xyp_roomIDView;
/// 房间ID
@property (nonatomic, strong) UILabel *xyp_roomIDLabel;

#pragma mark - Data
/// 是否是关注状态
@property (nonatomic, assign) BOOL xyp_isFollow;
/// 模型
@property (nonatomic, strong) OWLMusicRoomTotalModel *xyp_model;
/// 是否正在请求关注
@property (nonatomic, assign) BOOL xyp_isRequestFollow;

@end

@implementation OWLBGMTopRoomInfoView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
        [self xyf_setupNotification];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    
    /// ---- 观众列表视图 ----
    [self addSubview:self.xyp_audienceButton];
    [self.xyp_audienceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2.5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(38);
        make.trailing.equalTo(self).offset(-42);
    }];
    
    [self addSubview:self.xyp_audienceListBGView];
    [self.xyp_audienceListBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(126);
        make.centerY.equalTo(self.xyp_audienceButton);
        make.height.mas_equalTo(30);
        make.trailing.equalTo(self).offset(-[self xyp_getAudienceListRightMargin]);
    }];
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.colors = @[
        (__bridge id)kXYLColorFromRGBA(0x000000, 0.0).CGColor,
        (__bridge id)kXYLColorFromRGBA(0x000000, 1.0).CGColor,
    ];
    layer.locations = @[@0, @0.1]; // 设置颜色的范围
    layer.startPoint = CGPointMake(1, 0); // 设置颜色渐变的起点
    layer.endPoint = CGPointMake(0, 0); // 设置颜色渐变的终点，与 startPoint 形成一个颜色渐变方向
    if (OWLJConvertToolShared.xyf_isRTL) {
        layer.startPoint = CGPointMake(0, 0); // 设置颜色渐变的起点
        layer.endPoint = CGPointMake(1, 0); // 设置颜色渐变的终点，与 startPoint 形成一个颜色渐变方向
    }
    
    layer.frame = CGRectMake(0, 0, kXYLScreenWidth - 126 - [self xyp_getAudienceListRightMargin], 30);
    self.xyp_audienceListBGView.layer.mask = layer;
    
    [self.xyp_audienceListBGView addSubview:self.xyp_collectionView];
    [self.xyp_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.xyp_audienceListBGView);
        make.trailing.equalTo(self.xyp_audienceListBGView);
        make.width.mas_equalTo(30);
    }];
    
    /// ---- 主播信息视图 ----
    [self addSubview:self.xyp_anchorInfoBGView];
    [self.xyp_anchorInfoBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(12);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(134);
    }];
    
    /// ---- 房间ID ----
    [self addSubview:self.xyp_roomIDView];
    [self.xyp_roomIDView addSubview:self.xyp_roomIDLabel];
    [self.xyp_roomIDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-12);
        make.height.mas_equalTo(14);
        make.bottom.equalTo(self).offset(-7);
    }];
    [self.xyp_roomIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.xyp_roomIDView);
        make.leading.equalTo(self.xyp_roomIDView).offset(6);
    }];
    
    /// ---- 房间主题 ----
    [self addSubview:self.xyp_themeView];
    [self.xyp_themeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_anchorInfoBGView.mas_bottom).offset(5);
        make.leading.equalTo(self).offset(12);
        make.height.mas_equalTo(22);
    }];
    
    /// ---- 目标金额 ----
    [self addSubview:self.xyp_targetCoinsView];
    [self.xyp_targetCoinsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_anchorInfoBGView.mas_bottom).offset(5);
        make.leading.equalTo(self.xyp_themeView.mas_trailing).offset(6);
        make.height.mas_equalTo(22);
        make.trailing.lessThanOrEqualTo(self.xyp_roomIDView.mas_leading).offset(-8);
    }];
    
}

/// 更新观众列表width
- (void)xyf_refreshAudienceListWithAnchorWidth:(CGFloat)anchorWidth {
    CGFloat listLeftMargin = 12 + anchorWidth + 10;
    CGFloat listRightMargin = [self xyp_getAudienceListRightMargin];
    CGFloat listMaxWidth = kXYLScreenWidth - listLeftMargin - listRightMargin;
    CGFloat listRealWidth = self.xyp_audienceList.count * 36 - 6;
    if (listRealWidth < 0) { listRealWidth = 0; }
    if (listRealWidth > listMaxWidth) {
        listRealWidth = listMaxWidth;
        self.xyp_collectionView.scrollEnabled = YES;
    } else {
        self.xyp_collectionView.scrollEnabled = NO;
    }
    [self.xyp_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(listRealWidth);
    }];
}

- (void)xyf_setupNotification {
    [self xyf_observeNotification:xyl_user_operate_follow_anchor];
}

#pragma mark - Setter
- (void)setXyp_audienceList:(NSArray *)xyp_audienceList {
    _xyp_audienceList = xyp_audienceList;
    CGFloat width = self.xyp_isFollow ? 104 : 134;
    [self xyf_refreshAudienceListWithAnchorWidth:width];
    [self.xyp_collectionView reloadData];
}

#pragma mark - Public
#pragma mark 处理事件
/// 处理事件(触发事件)
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject * __nullable)obj {
    switch (type) {
        case XYLModuleEventType_UpdateGoal: /// 更新目标
            [self dealWithUpdateGoal:obj];
            break;
        default:
            break;
    }
}

/// 更新目标
- (void)dealWithUpdateGoal:(NSObject * __nullable)obj {
    OWLMusicRoomGoalModel *goal = (OWLMusicRoomGoalModel *)obj;
    [self xyf_updateGoal:goal];
}

#pragma mark 更新数据
- (void)xyf_updateRoomData:(OWLMusicRoomTotalModel *)model {
    self.xyp_model = model;
    /// ---- 主播信息视图 ----
    [XYCUtil xyf_loadSmallImage:self.xyp_avatarIV url:model.xyp_detailModel.dsb_ownerAvatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
    self.xyp_nicknameLabel.text = model.xyp_detailModel.dsb_ownerNickname;
    [self xyf_updateFollowState:model.xyp_detailModel.dsb_isFollowedOwner isAnimation:NO];
    [self xyp_updateAudienceNumStr];

    /// ---- 房间目标 ----
    [self xyf_updateGoal:model.xyp_detailModel.dsb_roomGoal];
    /// ---- 房间ID----
    if (OWLJConvertToolShared.xyf_isRTL) {
        self.xyp_roomIDLabel.text = [NSString stringWithFormat:@"%@ :ID",model.xyp_detailModel.dsb_ownerDisplayAccountID];
    } else {
        self.xyp_roomIDLabel.text = [NSString stringWithFormat:@"ID: %@",model.xyp_detailModel.dsb_ownerDisplayAccountID];
    }
}

/// 更新目标
- (void)xyf_updateGoal:(OWLMusicRoomGoalModel *)goal {
    BOOL isHidden = goal.dsb_desc.length == 0;
    if (self.xyp_model.xyp_detailModel.dsb_isUGCRoom) isHidden = YES;
    self.xyp_themeView.hidden = isHidden;
    self.xyp_targetCoinsView.hidden = isHidden;
    if (isHidden) { return; }
    
    /// ---- 房间主题 ----
    [self.xyp_themeView xyf_updateNotice:goal.dsb_desc];
    /// ---- 目标金额 ----
    [self.xyp_targetCoinsView xyf_updateRoomGoal:goal];
}

/// 更新关注状态
/// - Parameters:
///   - isFollow: 是否关注
///   - isAnimation: 是否需要动画
- (void)xyf_updateFollowState:(BOOL)isFollow isAnimation:(BOOL)isAnimation {
    self.xyp_isFollow = isFollow;
    CGFloat width = isFollow ? 104 : 134;
    CGFloat buttonWidth = isFollow ? 0 : 33;
    [self.xyp_anchorInfoBGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    [self.xyp_followButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
    }];
    
    [self xyf_refreshAudienceListWithAnchorWidth:width];
    if (isAnimation) {
        kXYLWeakSelf
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf layoutIfNeeded];
            weakSelf.xyp_followButton.alpha = !isFollow;
        }];
    } else {
        self.xyp_followButton.alpha = !isFollow;
    }
}

/// 更新观众人数
- (void)xyp_updateAudienceNumStr {
    NSInteger num = self.xyp_model.xyp_detailModel.dsb_currentPeopleNum;
    NSString *str;
    if (num >= 100000) {
        str = @"99.9k";
    } else if (num >= 1000) {
        str = [NSString stringWithFormat:@"%.0fk",(num / 1000.f)];
    } else {
        str = [NSString stringWithFormat:@"%ld",(long)num];
    }
    [self.xyp_audienceButton setTitle:str forState:UIControlStateNormal];
    self.xyp_numLabel.text = str;
}

#pragma mark - Public
- (CGFloat)xyf_getRoomDetailLeftMargin:(UIView *)view {
    CGFloat margin = CGRectGetMinX(view.frame);
    if (OWLJConvertToolShared.xyf_isRTL) {
        margin = CGRectGetMaxX(view.frame) - kXYLDetailRoomWidth;
    }
    return margin;
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.xyp_audienceList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OWLMusicTopAudienceListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OWLMusicTopAudienceListCell class]) forIndexPath:indexPath];
    cell.model = [self.xyp_audienceList xyf_objectAtIndexSafe:indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - OWLMusicTopAudienceListCellDelegate 观众cell点击事件
/// 点击头像（fix 点击不走didSelectItemAtIndexPath 估计重写hitTest有问题了 但懒得改）
- (void)xyf_topAudienceListCellClickUser:(OWLMusicMemberModel *)model {
    [self xyf_giveCallBackClickWithUserInfoAction:XYLModuleBaseViewInfoClickType_ShowUserDetailView accountID:model.xyp_accountId avatar:model.xyp_avatar nickname:model.xyp_nickName displayAccountID:model.xyp_displayAccountId isAnchor:model.xyp_roleType == XYLModuleMemberType_Anchor];
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_user_operate_follow_anchor]) {
        if (self.xyp_model.xyp_isUGCRoom) { return; }
        NSDictionary *dic = notification.object;
        NSInteger accountId = [[dic objectForKey:kXYLNotificationAccountIDKey] integerValue];
        BOOL followState = [[dic objectForKey:kXYLNotificationFollowStateKey] boolValue];
        if (self.xyp_model.xyp_detailModel.dsb_ownerAccountID == accountId) {
            self.xyp_model.xyp_detailModel.dsb_isFollowedOwner = followState;
            [self xyf_updateFollowState:followState isAnimation:YES];
        }
    }
}

#pragma mark - Action
/// 点击观众列表按钮
- (void)xyf_audienceButtonAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickAudienceList];
    [self xyf_giveCallBackClickAction:XYLModuleBaseViewClickType_ShowAudienceList];
}

/// 点击关注
- (void)xyf_followButtonAction {
    [self xyf_giveCallBackClickFollow];
}

/// 点击房间主题
- (void)xyf_themeViewAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickQuota];
    [self xyf_giveCallBackShowRoomDetail:[self xyf_getRoomDetailLeftMargin:self.xyp_themeView]];
}

/// 点击目标金额
- (void)xyf_targetCoinsViewAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickQuota];
    [self xyf_giveCallBackShowRoomDetail:[self xyf_getRoomDetailLeftMargin:self.xyp_targetCoinsView]];
}

/// 点击主播信息
- (void)xyf_anchorInfoViewAction {
    [OWLMusicTongJiTool xyf_thinkingWithName:XYLThinkingEventClickHostAvatar];
    [self xyf_giveCallBackClickWithUserInfoAction:XYLModuleBaseViewInfoClickType_ShowUserDetailView accountID:self.xyp_model.xyp_detailModel.dsb_ownerAccountID avatar:@"" nickname:@"" displayAccountID:@"" isAnchor:!self.xyp_model.xyp_detailModel.dsb_isUGCRoom];
}

#pragma mark - 给回调
- (void)xyf_giveCallBackClickAction:(XYLModuleBaseViewClickType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickEvent:)]) {
        [self.delegate xyf_lModuleBaseViewClickEvent:type];
    }
}

- (void)xyf_giveCallBackClickFollow {
    if (self.xyp_isRequestFollow) {
        return;
    }
    self.xyp_isRequestFollow = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewFollowAnchor:isFollow:completion:)]) {
        kXYLWeakSelf
        [self.delegate xyf_lModuleBaseViewFollowAnchor:self.xyp_model.xyp_detailModel.dsb_ownerAccountID isFollow:!self.xyp_isFollow completion:^{
            weakSelf.xyp_isRequestFollow = NO;
        }];
    }
}

- (void)xyf_giveCallBackClickWithUserInfoAction:(XYLModuleBaseViewInfoClickType)type
                                      accountID:(NSInteger)accountID
                                         avatar:(NSString *)avatar
                                       nickname:(NSString *)nickname
                               displayAccountID:(NSString *)displayAccountID
                                       isAnchor:(BOOL)isAnchor {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickInfoEvent:accountID:avatar:nickname:displayAccountID:isAnchor:)]) {
        [self.delegate xyf_lModuleBaseViewClickInfoEvent:type accountID:accountID avatar:avatar nickname:nickname displayAccountID:displayAccountID isAnchor:isAnchor];
    }
}

- (void)xyf_giveCallBackShowRoomDetail:(CGFloat)leftMargin {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewShowRoomDetail:)]) {
        [self.delegate xyf_lModuleBaseViewShowRoomDetail:leftMargin];
    }
}

#pragma mark - Getter
/// 观众列表右边间距
- (CGFloat)xyp_getAudienceListRightMargin {
    return 86;
}

#pragma mark - Lazy
- (UIView *)xyp_anchorInfoBGView {
    if (!_xyp_anchorInfoBGView) {
        _xyp_anchorInfoBGView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 134, 35)];
        _xyp_anchorInfoBGView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.3);
        _xyp_anchorInfoBGView.clipsToBounds = YES;
        _xyp_anchorInfoBGView.layer.cornerRadius = 17.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_anchorInfoViewAction)];
        [_xyp_anchorInfoBGView addGestureRecognizer:tap];
        
        [_xyp_anchorInfoBGView addSubview:self.xyp_avatarIV];
        [self.xyp_avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_xyp_anchorInfoBGView).offset(2);
            make.height.width.mas_equalTo(30);
            make.centerY.equalTo(_xyp_anchorInfoBGView);
        }];
        
        [_xyp_anchorInfoBGView addSubview:self.xyp_followButton];
        [self.xyp_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_xyp_anchorInfoBGView);
            make.height.mas_equalTo(27);
            make.width.mas_equalTo(33);
            make.trailing.equalTo(_xyp_anchorInfoBGView).offset(-4);
        }];
        
        [_xyp_anchorInfoBGView addSubview:self.xyp_nicknameLabel];
        [self.xyp_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.xyp_avatarIV.mas_trailing).offset(4);
            make.top.equalTo(_xyp_anchorInfoBGView).offset(2.5);
            make.width.mas_equalTo(55.5);
        }];
        
        [_xyp_anchorInfoBGView addSubview:self.xyp_watchIV];
        [self.xyp_watchIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(13);
            make.leading.equalTo(self.xyp_avatarIV.mas_trailing).offset(4);
            make.bottom.equalTo(_xyp_anchorInfoBGView).offset(-3);
        }];
        
        [_xyp_anchorInfoBGView addSubview:self.xyp_numLabel];
        [self.xyp_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.xyp_watchIV.mas_trailing).offset(1.5);
            make.centerY.equalTo(self.xyp_watchIV);
            make.trailing.equalTo(self.xyp_followButton.mas_leading).offset(-4.5);
        }];
    }
    return _xyp_anchorInfoBGView;
}

- (UIImageView *)xyp_avatarIV {
    if (!_xyp_avatarIV) {
        _xyp_avatarIV = [[UIImageView alloc] init];
        _xyp_avatarIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_avatarIV.layer.cornerRadius = 15;
        _xyp_avatarIV.clipsToBounds = YES;
        _xyp_avatarIV.image = OWLJConvertToolShared.xyf_userPlaceHolder;
    }
    return _xyp_avatarIV;
}

- (UILabel *)xyp_nicknameLabel {
    if (!_xyp_nicknameLabel) {
        _xyp_nicknameLabel = [[UILabel alloc] init];
        _xyp_nicknameLabel.textColor = kXYLColorFromRGB(0xffffff);
        _xyp_nicknameLabel.font = kXYLGilroyBoldFont(12);
    }
    return _xyp_nicknameLabel;
}

- (UIImageView *)xyp_watchIV {
    if (!_xyp_watchIV) {
        _xyp_watchIV = [[UIImageView alloc] init];
        _xyp_watchIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_watchIV.clipsToBounds = YES;
        [XYCUtil xyf_loadIconImage:_xyp_watchIV iconStr:@"xyr_top_info_watch_icon"];
    }
    return _xyp_watchIV;
}

- (UILabel *)xyp_numLabel {
    if (!_xyp_numLabel) {
        _xyp_numLabel = [[UILabel alloc] init];
        _xyp_numLabel.font = kXYLGilroyMediumFont(10);
        _xyp_numLabel.textColor = kXYLColorFromRGB(0xffffff);
    }
    return _xyp_numLabel;
}

- (UIImageView *)xyp_followButton {
    if (!_xyp_followButton) {
        _xyp_followButton = [[UIImageView alloc] init];
        _xyp_followButton.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_followButton.clipsToBounds = YES;
        [XYCUtil xyf_loadIconImage:_xyp_followButton iconStr:@"xyr_top_info_follow_icon"];
        _xyp_followButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_followButtonAction)];
        [_xyp_followButton addGestureRecognizer:tap];
        _xyp_followButton.alpha = 0;
    }
    return _xyp_followButton;
}

- (UIView *)xyp_audienceListBGView {
    if (!_xyp_audienceListBGView) {
        _xyp_audienceListBGView = [[UIView alloc] initWithFrame:CGRectMake(126, 2.5, kXYLScreenWidth - 126 - [self xyp_getAudienceListRightMargin], 30)];
    }
    return _xyp_audienceListBGView;
}

- (UIButton *)xyp_audienceButton {
    if (!_xyp_audienceButton) {
        _xyp_audienceButton = [[UIButton alloc] init];
        _xyp_audienceButton.clipsToBounds = YES;
        _xyp_audienceButton.layer.cornerRadius = 15;
        [_xyp_audienceButton addTarget:self action:@selector(xyf_audienceButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _xyp_audienceButton.backgroundColor = kXYLColorFromRGBA(0x000000, 0.3);
        _xyp_audienceButton.titleLabel.font = kXYLGilroyMediumFont(12);
        [_xyp_audienceButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_xyp_audienceButton setTitle:@"0" forState:UIControlStateNormal];
    }
    return _xyp_audienceButton;
}

- (UICollectionView *)xyp_collectionView {
    if (!_xyp_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(30, 30);
        layout.minimumLineSpacing = 6;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _xyp_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _xyp_collectionView.backgroundColor = [UIColor clearColor];
        _xyp_collectionView.showsVerticalScrollIndicator = NO;
        _xyp_collectionView.showsHorizontalScrollIndicator = NO;
        _xyp_collectionView.delegate = self;
        _xyp_collectionView.dataSource = self;
        [_xyp_collectionView registerClass:[OWLMusicTopAudienceListCell class] forCellWithReuseIdentifier:NSStringFromClass([OWLMusicTopAudienceListCell class])];
        if (@available(iOS 11.0, *)) {
            _xyp_collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (OWLJConvertToolShared.xyf_isRTL) {
            _xyp_collectionView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        } else {
            _xyp_collectionView.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        }
        
    }
    return _xyp_collectionView;
}

- (OWLBGMTopRoomThemeView *)xyp_themeView {
    if (!_xyp_themeView) {
        _xyp_themeView = [[OWLBGMTopRoomThemeView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_themeViewAction)];
        [_xyp_themeView addGestureRecognizer:tap];
    }
    return _xyp_themeView;
}

- (OWLBGMTopTargetCoinsView *)xyp_targetCoinsView {
    if (!_xyp_targetCoinsView) {
        _xyp_targetCoinsView = [[OWLBGMTopTargetCoinsView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_targetCoinsViewAction)];
        [_xyp_targetCoinsView addGestureRecognizer:tap];
    }
    return _xyp_targetCoinsView;
}

- (UIView *)xyp_roomIDView {
    if (!_xyp_roomIDView) {
        _xyp_roomIDView = [[UIView alloc] init];
        _xyp_roomIDView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.1);
        _xyp_roomIDView.layer.cornerRadius = 7;
        _xyp_roomIDView.clipsToBounds = YES;
    }
    return _xyp_roomIDView;
}

- (UILabel *)xyp_roomIDLabel {
    if (!_xyp_roomIDLabel) {
        _xyp_roomIDLabel = [[UILabel alloc] init];
        _xyp_roomIDLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_roomIDLabel.font = kXYLGilroyMediumFont(11);
        _xyp_roomIDLabel.textColor = kXYLColorFromRGBA(0xffffff, 0.5);
    }
    return _xyp_roomIDLabel;
}

@end
