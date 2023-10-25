//
//  OWLMusicBottomView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/22.
//

#import "OWLMusicBottomView.h"
#import "OWLMusicComboView.h"
#import "OWLMusicCircleView.h"

@interface OWLMusicBottomView ()

#pragma mark - Views
/// 输入框背景
@property (nonatomic, strong) UIView *xyp_bgView;
/// 标签背景
@property (nonatomic, strong) UIView *xyp_medalBGView;
/// 标签按钮
@property (nonatomic, strong) UILabel *xyp_medalLabel;
/// 标签图片
@property (nonatomic, strong) UIImageView *xyp_medalIV;
/// 输入文案
@property (nonatomic, strong) UILabel *xyp_hiLabel;
/// 更多按钮
@property (nonatomic, strong) UIImageView *xyp_moreButton;
/// 礼物背景
@property (nonatomic, strong) UIView *xyp_giftView;
/// 礼物图片
@property (nonatomic, strong) UIImageView *xyp_giftIV;
/// 举报按钮
@property (nonatomic, strong) UIImageView *xyp_reportButton;
/// 铁粉按钮
@property (nonatomic, strong) UIImageView *xyp_fanView;
/// 游戏按钮
@property (nonatomic, strong) UIImageView *xyp_gameView;
/// 充值容器
@property (nonatomic, strong) UIView *xyp_rechargeBGView;
/// 充值轮播
@property (nonatomic, strong) OWLMusicCircleView *xyp_rechargeCircleView;
/// 充值按钮
@property (nonatomic, strong) UIImageView *xyp_rechargeView;
/// 充值轮播按钮
@property (nonatomic, strong) UIImageView *xyp_rechargeCircleIV;
/// 1金币转盘轮播按钮
@property (nonatomic, strong) UIImageView *xyp_oneCoinCircleIV;
/// stackView
@property (nonatomic, strong) UIStackView *xyp_stackView;

#pragma mark - Model
/// 房间模型
@property (nonatomic, strong) OWLMusicRoomTotalModel *xyp_model;
/// 模型
@property (nonatomic, strong) OWLMusicGiftInfoModel *xyp_giftModel;
/// 金额
@property (nonatomic, assign) NSInteger xyp_cutCoins;

#pragma mark - Ges
/// 长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *xyp_longGes;

@end

@implementation OWLMusicBottomView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.xyp_cutCoins = OWLJConvertToolShared.xyf_userCoins;
        [self xyf_setupNotification];
        [self xyf_setupView];
        [self xyf_updateMedal:OWLJConvertToolShared.xyf_configTagUrl];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(16);
        make.top.equalTo(self);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(120);
    }];

    [self.xyp_bgView addSubview:self.xyp_medalBGView];
    [self.xyp_medalBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_bgView);
        make.leading.equalTo(self.xyp_bgView).offset(11);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(36);
    }];

    [self.xyp_bgView addSubview:self.xyp_hiLabel];
    [self.xyp_hiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_bgView);
        make.leading.equalTo(self.xyp_medalBGView.mas_trailing).offset(5);
    }];
    
    [self addSubview:self.xyp_stackView];
    [self.xyp_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(36);
    }];
    
    for (NSNumber *functionNum in OWLMusicInsideManagerShared.xyp_bottomManager.bottomArray) {
        OWLMusicBottomFunctionType functionType = (OWLMusicBottomFunctionType)functionNum.integerValue;
        UIView *functionView;
        switch (functionType) {
            case OWLMusicBottomFunctionType_Report:
                functionView = self.xyp_reportButton;
                break;
            case OWLMusicBottomFunctionType_More:
                functionView = self.xyp_moreButton;
                break;
            case XYLModuleSingleVideoSizeType_Fan:
                functionView = self.xyp_fanView;
                break;
            case OWLMusicBottomFunctionType_Game:
                functionView = self.xyp_gameView;
                break;
            case XYLModuleSingleVideoSizeType_Recharge:
                functionView = self.xyp_rechargeBGView;
                break;
            case OWLMusicBottomFunctionType_FastGift:
                functionView = self.xyp_giftView;
                break;
        }
        
        if (functionView) {
            [self.xyp_stackView addArrangedSubview:functionView];
            [functionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(36);
            }];
        }
    }
}

- (void)xyf_setupNotification {
    [self xyf_observeNotification:xyl_user_update_coins];
    [self xyf_observeNotification:xyl_module_buy_fan_success];
    [self xyf_observeNotification:xyl_module_buy_svip_success];
    [self xyf_observeNotification:xyl_module_success_open_onecoin_turntable];
}

#pragma mark - 更新
/// 更新房间信息
- (void)xyf_updateRoomData:(OWLMusicRoomTotalModel *)model {
    _xyp_model = model;
    if (model.xyp_detailModel.dsb_quickGift) {
        _xyp_giftModel = model.xyp_detailModel.dsb_quickGift;
        [XYCUtil xyf_loadOriginImage:self.xyp_giftIV url:model.xyp_detailModel.dsb_quickGift.dsb_iconImageUrl placeholder:nil];
    } else {
        if (model.xyp_detailModel.dsb_giftList.count > 0) {
            OWLMusicGiftConfigModel *config = model.xyp_detailModel.dsb_giftList.firstObject;
            OWLMusicGiftInfoModel *gift = config.dsb_giftList.firstObject;
            _xyp_giftModel = gift;
            if (gift) {
                [XYCUtil xyf_loadOriginImage:self.xyp_giftIV url:gift.dsb_iconImageUrl placeholder:nil];
            }
        }
    }
}

/// 更新标签
- (void)xyf_updateMedal:(NSString *)url {
    if (url.length == 0) {
        self.xyp_medalIV.image = nil;
        self.xyp_medalLabel.hidden = NO;
    } else {
        self.xyp_medalLabel.hidden = YES;
        [XYCUtil xyf_loadOriginImage:self.xyp_medalIV url:url placeholder:nil];
    }
}

#pragma mark - Private
/// 送礼
- (void)xyf_sendGift:(OWLMusicGiftInfoModel *)model {
    [self xyf_giveCallBackClickQuickGift:model];
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickFastGift];
    if (model) {
        NSInteger coins = self.xyp_cutCoins - model.dsb_giftCoin;
        if (coins >= 0) {
            self.xyp_cutCoins -= model.dsb_giftCoin;
            if (model.dsb_comboIconImage.length > 0) {
                [OWLMusicComboViewManager.shared xyf_ClickedGift:model.dsb_giftID roomId:OWLMusicInsideManagerShared.xyp_hostID container:self.superview frame:[self.xyp_giftView convertRect:self.xyp_giftView.bounds toView:self.superview] isQuick:YES numberFont:kXYLGilroyBoldFont(10)];
            }
        } else {
            [OWLMusicInsideManagerShared xyf_removeComboView];
        }
    }
}

/// 改变铁粉状态
- (void)xyf_changeFanState:(OWLMusicRoomTotalModel *)model {
    BOOL isHidden = YES;
    OWLMusicFanInfoModel *currentFanModel = model.xyp_detailModel.dsb_fanInfo;
    if (currentFanModel.dsb_isFan || /// 是铁粉就不显示
        OWLJConvertToolShared.xyf_userIsSvip /// 是Svip就不显示
        ) {
        
    } else {
        isHidden = NO;
    }
    self.xyp_fanView.hidden = isHidden;
}

/// 改变游戏状态
- (void)xyf_changeGameState:(OWLMusicRoomTotalModel *)model {
    if (![self xyf_isNeedAddGameButton]) { return; }
    self.xyp_gameView.hidden = !model.xyp_detailModel.dsb_gameConfig.dsb_enable;
}

/// 改变充值状态
- (void)xyf_changeRechargeStateWithIsShowOneCoin:(BOOL)isShowOneCoin {
    if (isShowOneCoin) {
        self.xyp_rechargeView.hidden = YES;
        self.xyp_rechargeCircleView.hidden = NO;
        [self.xyp_rechargeCircleView xyf_loadArray:@[self.xyp_oneCoinCircleIV, self.xyp_rechargeCircleIV]];
    } else {
        self.xyp_rechargeView.hidden = NO;
        self.xyp_rechargeCircleView.hidden = YES;
        [self.xyp_rechargeCircleView xyf_loadArray:nil];
    }
}

#pragma mark - 事件处理
/// 处理事件(触发事件)
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject * __nullable)obj {
    switch (type) {
        case XYLModuleEventType_UpdateUserMedal:
            [self xyf_dealEventUpdateUserMedal:obj];
            break;
        case XYLModuleEventType_JoinRoom:
            [self xyf_dealEventJoinRoom:obj];
            break;
        case XYLModuleEventType_UpdateBottomRechargeButton:
            [self xyf_dealEventUpdateBottomRechargeButton:obj];
            break;
        default:
            break;
    }
}

- (void)xyf_dealEventUpdateUserMedal:(NSObject * __nullable)obj {
    NSString *url = (NSString *)obj;
    [self xyf_updateMedal:url];
}

- (void)xyf_dealEventJoinRoom:(NSObject * __nullable)obj {
    OWLMusicRoomTotalModel *model = (OWLMusicRoomTotalModel *)obj;
    /// 改变铁粉状态
    [self xyf_changeFanState:model];
    /// 改变游戏状态
    [self xyf_changeGameState:model];
    /// 改变充值状态
    [self xyf_changeRechargeStateWithIsShowOneCoin:OWLJConvertToolShared.xyf_isNeedShowOneCoin];
}

- (void)xyf_dealEventUpdateBottomRechargeButton:(NSObject * __nullable)obj {
    BOOL isShowOneCoin = [(NSNumber *)obj boolValue];
    [self xyf_changeRechargeStateWithIsShowOneCoin:isShowOneCoin];
}

#pragma mark - Actions
- (void)xyf_giftAction {
    if (OWLJConvertToolShared.xyf_judgeNoNetworkAndShowNoNetTip) {
        [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickFastGift];
        return;
    }
    [self xyf_sendGift:self.xyp_giftModel];
}

- (void)xyf_moreAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickMore];
    [self xyf_giveCallBackClickType:XYLModuleBaseViewClickType_ShowRoomTools];
}

- (void)xyf_inputAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventShowKeyboard];
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickBarrage];
    [self xyf_giveCallBackClickType:XYLModuleBaseViewClickType_ShowTextInput];
}

- (void)xyf_medalAction {
    [self xyf_giveCallBackClickType:XYLModuleBaseViewClickType_EditMedalListView];
}

- (void)xyf_fanAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickGetFreeMsg];
    [self xyf_giveCallBackClickType:XYLModuleBaseViewClickType_ClickFanButton];
}

- (void)xyf_gameAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickGame];
    [self xyf_giveCallBackClickType:XYLModuleBaseViewClickType_ClickGameButton];
}

- (void)xyf_rechargeAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickRecharge];
    [self xyf_giveCallBackClickType:XYLModuleBaseViewClickType_ShowRechargeView];
}

- (void)xyf_reportAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickInfoEvent:accountID:avatar:nickname:displayAccountID:isAnchor:)]) {
        [self.delegate xyf_lModuleBaseViewClickInfoEvent:XYLModuleBaseViewInfoClickType_ShowReportUserView accountID:[self.xyp_model xyf_getOwnerID] avatar:@"" nickname:@"" displayAccountID:@"" isAnchor:!self.xyp_model.xyp_detailModel.dsb_isUGCRoom];
    }
}

- (void)xyf_oneCoinAction {
    [OWLJConvertToolShared xyf_showOneCoinTest:YES];
}

- (void)xyf_fastGiftButtonLongTouch:(UILongPressGestureRecognizer *)ges {
    OWLMusicGiftInfoModel *gift = self.xyp_giftModel;
    if (gift) {
        if (gift.dsb_comboIconImage.length > 0) {
            
        } else {
            [ges setState:UIGestureRecognizerStateEnded];
            return;
        }
        if (ges.state == UIGestureRecognizerStateBegan) {
            if (OWLJConvertToolShared.xyf_judgeNoNetworkAndShowNoNetTip) {
                return;
            }
            // 开始触发
            OWLMusicInsideManagerShared.comboing = 1;
            [self xyf_giftFast];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = NO;
        }
        if (ges.state == UIGestureRecognizerStateEnded ||
            ges.state == UIGestureRecognizerStateCancelled) {
            OWLMusicInsideManagerShared.comboing = -1;
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
        if (ges.state == UIGestureRecognizerStateChanged) {
            CGPoint point = [ges locationInView:self];
            BOOL b = [self.layer containsPoint:point];
            if (b) {
            } else {
                [ges setState:UIGestureRecognizerStateEnded];
            }
        }
    }
}

- (void)xyf_giftFast {
    if (OWLMusicInsideManagerShared.comboing == -1) {
        [self.xyp_longGes setState:UIGestureRecognizerStateEnded];
        return;
    }
    if (OWLMusicInsideManagerShared.comboing == 1) {
        [self xyf_sendGift:self.xyp_giftModel];
        kXYLWeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf xyf_giftFast];
        });
    }
}

#pragma mark - 给回调
- (void)xyf_giveCallBackClickType:(XYLModuleBaseViewClickType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickEvent:)]) {
        [self.delegate xyf_lModuleBaseViewClickEvent:type];
    }
}

- (void)xyf_giveCallBackClickQuickGift:(OWLMusicGiftInfoModel *)gift {
    if (gift == nil) { return; }
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewSendGift:)]) {
        [self.delegate xyf_lModuleBaseViewSendGift:gift];
    }
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_user_update_coins]) {
        NSNumber *num = notification.object;
        NSInteger coins = num.integerValue;
        self.xyp_cutCoins = coins;
    } else if ([notification.name isEqualToString:xyl_module_buy_fan_success]) {
        NSDictionary *dic = notification.object;
        NSInteger accountId = [[dic objectForKey:kXYLNotificationAccountIDKey] integerValue];
        if (accountId == [self.xyp_model xyf_getOwnerID]) {
            self.xyp_fanView.hidden = YES;
            [self xyf_dealEventUpdateUserMedal:OWLJConvertToolShared.xyf_configTagUrl];
        }
    } else if ([notification.name isEqualToString:xyl_module_buy_svip_success]) {
        self.xyp_fanView.hidden = YES;
    } else if ([notification.name isEqualToString:xyl_module_success_open_onecoin_turntable]) {
        [self xyf_changeRechargeStateWithIsShowOneCoin:NO];
    }
}

#pragma mark - Getter
/// 是否添加游戏按钮: 不是绿号才添加按钮，显示隐藏由服务端字段控制
- (BOOL)xyf_isNeedAddGameButton {
    return !OWLJConvertToolShared.xyf_isGreen;
}

#pragma mark - Lazy
- (UIView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIView alloc] init];
        _xyp_bgView.clipsToBounds = YES;
        _xyp_bgView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.3);
        _xyp_bgView.layer.cornerRadius = 18;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_inputAction)];
        [_xyp_bgView addGestureRecognizer:tap];
    }
    return _xyp_bgView;
}

- (UIView *)xyp_medalBGView {
    if (!_xyp_medalBGView) {
        _xyp_medalBGView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_medalAction)];
        [_xyp_medalBGView addGestureRecognizer:tap];
        
        [_xyp_medalBGView addSubview:self.xyp_medalLabel];
        [self.xyp_medalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_xyp_medalBGView);
        }];
        
        [_xyp_medalBGView addSubview:self.xyp_medalIV];
        [self.xyp_medalIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_xyp_medalBGView);
        }];
    }
    return _xyp_medalBGView;
}

- (UILabel *)xyp_medalLabel {
    if (!_xyp_medalLabel) {
        _xyp_medalLabel = [[UILabel alloc] init];
        _xyp_medalLabel.text = kXYLLocalString(@"Medal");
        _xyp_medalLabel.textColor = kXYLColorFromRGBA(0xE5E1DF, 0.74);
        _xyp_medalLabel.font = kXYLGilroyBoldFont(8);
        _xyp_medalLabel.backgroundColor = kXYLColorFromRGBA(0x000000, 0.2);
        _xyp_medalLabel.layer.cornerRadius = 7;
        _xyp_medalLabel.clipsToBounds = YES;
        _xyp_medalLabel.layer.borderColor = kXYLColorFromRGBA(0xffffff, 0.4).CGColor;
        _xyp_medalLabel.layer.borderWidth = 1;
        _xyp_medalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_medalLabel;
}

- (UIImageView *)xyp_medalIV {
    if (!_xyp_medalIV) {
        _xyp_medalIV = [[UIImageView alloc] init];
        _xyp_medalIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _xyp_medalIV;
}

- (UILabel *)xyp_hiLabel {
    if (!_xyp_hiLabel) {
        _xyp_hiLabel = [[UILabel alloc] init];
        _xyp_hiLabel.text = kXYLLocalString(@"Say hi~");
        _xyp_hiLabel.textColor = kXYLColorFromRGBA(0xffffff, 0.74);
        _xyp_hiLabel.font = kXYLGilroyBoldFont(14);
    }
    return _xyp_hiLabel;
}

- (UIView *)xyp_giftView {
    if (!_xyp_giftView) {
        _xyp_giftView = [[UIView alloc] init];
        _xyp_giftView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.3);
        _xyp_giftView.clipsToBounds = YES;
        _xyp_giftView.layer.cornerRadius = 18;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_giftAction)];
        [_xyp_giftView addGestureRecognizer:tap];
        
        self.xyp_longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_fastGiftButtonLongTouch:)];
        self.xyp_longGes.minimumPressDuration = 0.3;
        [_xyp_giftView addGestureRecognizer:self.xyp_longGes];
        
        [_xyp_giftView addSubview:self.xyp_giftIV];
        [self.xyp_giftIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_xyp_giftView);
            make.width.height.mas_equalTo(32);
        }];
    }
    return _xyp_giftView;
}

- (UIImageView *)xyp_giftIV {
    if (!_xyp_giftIV) {
        _xyp_giftIV = [[UIImageView alloc] init];
        _xyp_giftIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xyp_giftIV;
}

- (UIImageView *)xyp_moreButton {
    if (!_xyp_moreButton) {
        _xyp_moreButton = [[UIImageView alloc] init];
        _xyp_moreButton.userInteractionEnabled = YES;
        [XYCUtil xyf_loadIconImage:_xyp_moreButton iconStr:@"xyr_bottom_more_icon"];
        _xyp_moreButton.clipsToBounds = YES;
        _xyp_moreButton.layer.cornerRadius = 18;
        _xyp_moreButton.contentMode = UIViewContentModeCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_moreAction)];
        [_xyp_moreButton addGestureRecognizer:tap];
    }
    return _xyp_moreButton;
}

- (UIImageView *)xyp_reportButton {
    if (!_xyp_reportButton) {
        _xyp_reportButton = [[UIImageView alloc] init];
        _xyp_reportButton.userInteractionEnabled = YES;
        [XYCUtil xyf_loadIconImage:_xyp_reportButton iconStr:@"xyr_bottom_report_icon"];
        _xyp_reportButton.clipsToBounds = YES;
        _xyp_reportButton.layer.cornerRadius = 18;
        _xyp_reportButton.contentMode = UIViewContentModeCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_reportAction)];
        [_xyp_reportButton addGestureRecognizer:tap];
        _xyp_reportButton.hidden = !OWLJConvertToolShared.xyf_isJustMain;
    }
    return _xyp_reportButton;
}

- (UIImageView *)xyp_fanView {
    if (!_xyp_fanView) {
        _xyp_fanView = [[UIImageView alloc] init];
        _xyp_fanView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_fanAction)];
        [_xyp_fanView addGestureRecognizer:tap];
        [XYCUtil xyf_loadIconImage:_xyp_fanView iconStr:@"xyr_bottom_fan_icon"];
    }
    return _xyp_fanView;
}

- (UIImageView *)xyp_gameView {
    if (!_xyp_gameView) {
        _xyp_gameView = [[UIImageView alloc] init];
        _xyp_gameView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_gameAction)];
        [_xyp_gameView addGestureRecognizer:tap];
        [XYCUtil xyf_loadIconImage:_xyp_gameView iconStr:@"xyr_bottom_game_icon"];
    }
    return _xyp_gameView;
}

- (UIImageView *)xyp_rechargeView {
    if (!_xyp_rechargeView) {
        _xyp_rechargeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        _xyp_rechargeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_rechargeAction)];
        [_xyp_rechargeView addGestureRecognizer:tap];
        _xyp_rechargeView.hidden = YES;
        [XYCUtil xyf_loadIconImage:_xyp_rechargeView iconStr:@"xyr_bottom_recharge_icon"];
    }
    return _xyp_rechargeView;
}

- (UIView *)xyp_rechargeBGView {
    if (!_xyp_rechargeBGView) {
        _xyp_rechargeBGView = [[UIView alloc] init];
        [_xyp_rechargeBGView addSubview:self.xyp_rechargeView];
        [_xyp_rechargeBGView addSubview:self.xyp_rechargeCircleView];
    }
    return _xyp_rechargeBGView;
}

- (OWLMusicCircleView *)xyp_rechargeCircleView {
    if (!_xyp_rechargeCircleView) {
        _xyp_rechargeCircleView = [[OWLMusicCircleView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        _xyp_rechargeCircleView.hidden = YES;
    }
    return _xyp_rechargeCircleView;
}

- (UIImageView *)xyp_rechargeCircleIV {
    if (!_xyp_rechargeCircleIV) {
        _xyp_rechargeCircleIV = [[UIImageView alloc] init];
        _xyp_rechargeCircleIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_rechargeAction)];
        [_xyp_rechargeCircleIV addGestureRecognizer:tap];
        [XYCUtil xyf_loadIconImage:_xyp_rechargeCircleIV iconStr:@"xyr_bottom_recharge_circle_icon"];
    }
    return _xyp_rechargeCircleIV;
}

- (UIImageView *)xyp_oneCoinCircleIV {
    if (!_xyp_oneCoinCircleIV) {
        _xyp_oneCoinCircleIV = [[UIImageView alloc] init];
        _xyp_oneCoinCircleIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_oneCoinAction)];
        [_xyp_oneCoinCircleIV addGestureRecognizer:tap];
        [XYCUtil xyf_loadIconImage:_xyp_oneCoinCircleIV iconStr:@"xyr_bottom_oneCoin_circle_icon"];
    }
    return _xyp_oneCoinCircleIV;
}

- (UIStackView *)xyp_stackView {
    if (!_xyp_stackView) {
        _xyp_stackView = [[UIStackView alloc] init];
        _xyp_stackView.axis = UILayoutConstraintAxisHorizontal;
        _xyp_stackView.spacing = 9;
        _xyp_stackView.alignment = UIStackViewAlignmentCenter;
    }
    return _xyp_stackView;
}

@end
