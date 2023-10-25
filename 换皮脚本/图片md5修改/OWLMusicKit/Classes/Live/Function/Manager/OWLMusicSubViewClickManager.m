//
//  OWLMusicSubViewClickManager.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

#import "OWLMusicSubViewClickManager.h"

#pragma mark - Views
#import "OWLBGMTopRoomDetailInfoAlertView.h"
#import "OWLBGMAudienceAlertView.h"
#import "OWLBGMReportAlertView.h"
#import "OWLBGMRoomToolsAlertView.h"
#import "OWLBGMUserDetailInfoAlertView.h"
#import "OWLBGMMedalListAlertView.h"
#import "OWLBGMPKRankListAlertView.h"
#import "OWLMusicBottomInputView.h"
#import "OWLBGMModuleMainView.h"
#import "OWLPPPairShowView.h"
#import "OWLMusicTakeHerAlert.h"
#import "OWLMusicAutoFollowView.h"
#import "OWLMusicFirstRechargeAlertView.h"
#import "OWLMusicJoinFanAlertView.h"
#import "OWLMusicGameMenuView.h"
#import "OWLBGMStreamSettingsAlertView.h"

#pragma mark - Model
#import "OWLMusicSendGiftResponseModel.h"
#import "OWLMusicEnterPrivateChatModel.h"
#import "OWLMusicMessageModel.h"

#pragma mark - Manager
#import "OWLMusicInsideManager.h"
#import "OWLMusicSystemAuthManager.h"
#import "OWLMusicBroadcastManager.h"

#pragma mark - VC
#import "OWLBGMModuleVC.h"

@interface OWLMusicSubViewClickManager()

#pragma mark - Views
/// 房间详情弹窗
@property (nonatomic, strong) OWLBGMTopRoomDetailInfoAlertView *xyp_goalView;
/// 观众列表弹窗
@property (nonatomic, strong) OWLBGMAudienceAlertView *xyp_audienceListView;
/// 私聊弹窗
@property (nonatomic, strong) OWLMusicTakeHerAlert *xyp_privateChatView;
/// 自动关注弹窗
@property (nonatomic, strong) OWLMusicAutoFollowView *xyp_autoFollowView;
/// 充值优惠弹窗
@property (nonatomic, strong) OWLMusicFirstRechargeAlertView *xyp_discountView;

#pragma mark - BOOL
/// 是否正在请求用户详情
@property (nonatomic, assign) BOOL xyp_isRequestAccountInfo;

#pragma mark - 定时器逻辑
/// 定时器
@property (nonatomic, strong) NSTimer *xyp_timer;
/// 折扣计时
@property (nonatomic, assign) NSInteger xyp_discountSecond;

@end

@implementation OWLMusicSubViewClickManager

- (void)dealloc {
    NSLog(@"xytest 点击事件管理类 dealloc");
}

#pragma mark - Public
/// 更新观众列表
- (void)xyf_updateMemberList:(NSMutableArray *)memberList {
    self.xyp_audienceListView.xyp_dataList = memberList;
}

/// 清理所有数据
- (void)xyf_clearAllData {
    self.xyp_isSendMsg = NO;
    self.xyp_isSendGift = NO;
    [self.xyp_autoFollowView xyf_dismiss];
}

/// 更新目标视图
- (void)xyf_updateGoal:(OWLMusicRoomGoalModel *)model {
    [self.xyp_goalView xyf_updateRoomGoal:model isInit:NO];
}

/// 更新带走礼物
- (void)xyf_updatePrivateGift:(NSInteger)giftID {
    OWLMusicGiftInfoModel *model = [OWLJConvertToolShared xyf_getGiftModel:[self xyf_getCurrentRoom].dsb_privateChatGiftID];
    if (model == nil) { return; }
    [self.xyp_privateChatView xyf_updateTakeGiftData:model];
}

/// 关闭私聊带走弹窗
- (void)xyf_closePrivateChatView {
    [self.xyp_privateChatView xyf_dismissView];
}

#pragma mark - Private
#pragma mark 送礼相关
/// 判断用户的钱是否够送礼物
- (BOOL)xyf_judgeUserCoinIsEnough:(OWLMusicGiftInfoModel *)gift {
    if (OWLJConvertToolShared.xyf_userCoins < gift.dsb_giftCoin) {
        [OWLJConvertToolShared xyf_showNotiTip:kXYLLocalString(@"You don't have enough coins to continue")];
        [self xyf_lModuleBaseViewClickEvent:XYLModuleBaseViewClickType_ShowRechargeView];
        return NO;
    }
    return YES;
}

/// 判断用户是否被拉黑
- (BOOL)xyf_judgeUserIsMute {
    if ([self xyf_isMute]) {
        [OWLJConvertToolShared xyf_showNotiTip:[XYCStringTool xyf_userMute:YES]];
        return true;
    }
    return false;
}

/// 送礼
- (void)xyf_sendGift:(OWLMusicGiftInfoModel *)gift isFast:(BOOL)isFast {
    if (OWLJConvertToolShared.xyf_judgeNoNetworkAndShowNoNetTip) { return; }
    if (![self xyf_judgeUserCoinIsEnough:gift]) { return; }
    kXYLWeakSelf
    NSInteger roomID = [self xyf_getCurrentRoomID];
    [OWLMusicRequestApiManager xyf_requestSendGiftWithRoomID:[self xyf_getCurrentRoomID] giftID:gift.dsb_giftID isUGCRoom:[self xyf_getCurrentRoom].dsb_isUGCRoom completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        if (aResponse.xyf_success) {
            OWLMusicSendGiftResponseModel *model = [[OWLMusicSendGiftResponseModel alloc] initWithDictionary:[aResponse.data xyf_objectForKeyNotNil:@"data"]];
            /// 通过礼物管理类 获取消息模型
            OWLMusicMessageModel *message = [[OWLPPAddAlertTool shareInstance]xyf_convertMessageModelWith:gift andBlindId:gift.dsb_isBlindGift ? model.dsb_giftID : 0];
            /// 通知显示礼物弹幕（本地+远端）
            [weakSelf xyf_giveCallBackSendMsg:message type:OWLMusicSubViewClickSendMsgType_LocalAndRemote];
            /// 更新房间排行榜信息（本地+远端）
            [weakSelf xyf_updateMemberListAfterSendGift:gift];
            /// 更新金币
            [OWLJConvertToolShared xyf_updateUserCoins:model.dsb_leftCoins];
            /// 更新送礼物状态
            if (roomID == [self xyf_getCurrentRoomID]) { weakSelf.xyp_isSendGift = YES; }
            /// 埋点
            [OWLMusicTongJiTool xyf_thinkingSengGift:gift isPrivate:NO isFast:isFast];
            [OWLMusicTongJiTool xyf_firebaseSpendCoin:gift.dsb_giftCoin spendWay:@"sendGift"];
        } else if (aResponse.xyf_requestSuccessWithWrongCode) {
            [OWLJConvertToolShared xyf_showErrorTip:aResponse.message];
        } else {
            [OWLJConvertToolShared xyf_showNoNetworkTip];
        }
    }];
}

/// 送礼之后刷新观众列表排序
- (void)xyf_updateMemberListAfterSendGift:(OWLMusicGiftInfoModel *)gift {
    NSArray *list = [self xyf_getMemberList];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:list];
    for (OWLMusicMemberModel *model in array) {
        if (model.xyp_accountId == OWLJConvertToolShared.xyf_userAccountID) {
            model.xyp_giftCost += gift.dsb_giftCoin;
        }
    }
    [self xyf_giveCallBackUpdateMemberList:array];
    OWLMusicMessageModel *message = [OWLMusicMessageModel xyf_getUpdateMemberListMsg:[self xyf_getMemberList]];
    [self xyf_giveCallBackSendMsg:message type:OWLMusicSubViewClickSendMsgType_LocalAndRemote];
}

#pragma mark 带走相关
/// 带走主播时检查权限
- (void)xyf_checkAuthWhenTakeAnchor:(OWLMusicGiftInfoModel *)gift {
    /// 检查相机权限
    [OWLMusicSystemAuthShared xyf_checkHasCameraAuth:^(BOOL succeed) {
        if (succeed) {
            /// 检查麦克风权限
            [OWLMusicSystemAuthShared xyf_checkHasAudioAuth:^(BOOL succeed) {
                if (succeed) {
                    [self xyf_takeAnchorWithGift:gift];
                }
            }];
        }
    }];
}

/// 私聊带走
- (void)xyf_takeAnchorWithGift:(OWLMusicGiftInfoModel *)gift {
    if ([self xyf_judgeUserIsMute]) { return; }
    if (OWLJConvertToolShared.xyf_judgeNoNetworkAndShowNoNetTip) { return; }
    if (![self xyf_judgeUserCoinIsEnough:gift]) { return; }
    [OWLJConvertToolShared xyf_showLoading];
    /// 埋点
    [OWLMusicTongJiTool xyf_thinkingStartCall];
    kXYLWeakSelf;
    NSInteger roomID = [self xyf_getCurrentRoom].dsb_roomID;
    [OWLMusicRequestApiManager xyf_requestTakeAnchor:roomID giftID:gift.dsb_giftID completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        [OWLJConvertToolShared xyf_hideLoading];
        if (aResponse.xyf_success) {
            /// 画中画状态切换
            [OWLMusicInsideManagerShared.xyp_vc xyf_changePIPOpenState:NO];
            /// 更新带走状态
            [weakSelf xyf_updateTakingState:YES];
            OWLMusicEnterPrivateChatModel *model = [[OWLMusicEnterPrivateChatModel alloc] initWithDictionary:[aResponse.data xyf_objectForKeyNotNil:@"data"]];
            /// 更新金币
            [OWLJConvertToolShared xyf_updateUserCoins:model.dsb_leftCoins];
            /// 发送RTM消息
            OWLMusicMessageModel *message = [OWLMusicMessageModel xyf_getTakeAnchorMsg:gift privateVideoDict:[aResponse.data xyf_objectForKeyNotNil:@"data"]];
            [weakSelf xyf_giveCallBackSendMsg:message type:OWLMusicSubViewClickSendMsgType_Remote];
            /// 展示带走动画
            [weakSelf xyf_showTakeAnchorSvgView:model dic:[aResponse.data xyf_objectForKeyNotNil:@"data"]];
            /// 禁止滑动手势
            [weakSelf xyf_giveCallBackConfigPopGesture:NO];
            /// 带走横幅
            OWLMusicBroadcastModel *broadcastModel = [[OWLMusicBroadcastModel alloc] initTakeModelWithRoomID:roomID userName:OWLJConvertToolShared.xyf_userName userAvatar:OWLJConvertToolShared.xyf_userAvatar anchorName:model.dsb_anchorName anchorAvatar:model.dsb_anchorAvatar];
            [XYCBroadcastShared xyf_addChannalBanner:broadcastModel];
            /// 埋点
            [OWLMusicTongJiTool xyf_thinkingSengGift:gift isPrivate:YES isFast:NO];
            [OWLMusicTongJiTool xyf_firebaseSpendCoin:gift.dsb_giftCoin spendWay:@"live-private"];
        } else if (aResponse.xyf_requestSuccessWithWrongCode) {
            [OWLJConvertToolShared xyf_showErrorTip:aResponse.message];
        } else {
            [OWLJConvertToolShared xyf_showNoNetworkTip];
        }
    }];
}

- (void)xyf_showTakeAnchorSvgView:(OWLMusicEnterPrivateChatModel *)model dic:(NSDictionary *)dic {
    OWLPPPairShowView *view = [[OWLPPPairShowView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    [self.xyp_targetView addSubview:view];
    [view xyf_preparePlaySvgWithAncAvatar:model.dsb_anchorAvatar andUAvatar:OWLJConvertToolShared.xyf_userAvatar andAncName:model.dsb_anchorName andUName:OWLJConvertToolShared.xyf_userName andIsMine:YES];
    kXYLWeakSelf
    view.xyp_playEndPair = ^{
        [OWLMusicInsideManagerShared xyf_insideCloseLivePage:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [OWLJConvertToolShared xyf_jumpToPrivateVideoChat:dic];
            [weakSelf xyf_updateTakingState:NO];
        });
    };
}

/// 更新带走状态
- (void)xyf_updateTakingState:(BOOL)isTaking {
    OWLMusicInsideManagerShared.xyp_isTakingAnchor = isTaking;
}

#pragma mark 关注相关
/// 在关注或取消关注房主之后 将需要刷新首页列表的标记置为YES
/// - Parameters:
///   - accountID: 主播ID
///   - isIgnoreJudge: 是否不需要和当前主播做判断
- (void)xyf_refreshRoomAfterOpFollowHost:(NSInteger)accountID isIgnoreJudge:(BOOL)isIgnoreJudge {
    if (accountID == [self xyf_getCurrentRoom].dsb_ownerAccountID || isIgnoreJudge) {
        OWLMusicInsideManagerShared.xyp_isNeedRefreshHomeList = YES;
    }
}

#pragma mark - OWLPPAddAlerToolDelegate 青月小姐妹的工具类代理
/** 显示充值弹窗 */
- (void)xyf_showRechargeView {
    [self xyf_clickShowRechargeView];
}

/** 点击礼物 */
- (void)xyf_clickedGift:(OWLMusicGiftInfoModel *)gift {
    [self xyf_sendGift:gift isFast:NO];
}

/** 是否在当前直播间发送过弹幕 */
- (BOOL)xyf_isSendBarrageInCurrentRoom {
    return self.xyp_isSendMsg;
}

/** 是否在当前直播间送过礼物 */
- (BOOL)xyf_isSendGiftInCurrentRoom {
    return self.xyp_isSendGift;
}

/** 是否关注了当前主播 */
- (BOOL)xyf_isFollowedHostInCurrentRoom {
    return self.xyf_getCurrentRoom.dsb_isFollowedOwner;
}

/** 是否被当前直播间禁言了 */
- (BOOL)xyf_isBeMutedInCurrentRoom {
    return self.xyf_isMute;
}

/** 发送Hi */
- (void)xyf_sendHiToHost {
    OWLMusicMessageModel *model = [OWLMusicMessageModel xyf_getTextMessage:@"Hi"];
    [self xyf_giveCallBackSendMsg:model type:OWLMusicSubViewClickSendMsgType_SendText];
}

/** 打开送礼界面 */
- (void)xyf_showSendGiftAlert {
    [[OWLPPAddAlertTool shareInstance] xyf_showGiftAlert];
}

/** 关注当前主播 */
- (void)xyf_followCurrentHost {
    kXYLWeakSelf
    NSInteger accountID = self.xyf_getCurrentRoom.dsb_ownerAccountID;
    [OWLJConvertToolShared xyf_userFollowAnchor:accountID isFollow:YES completion:^(BOOL followState) {
        [weakSelf xyf_refreshRoomAfterOpFollowHost:accountID isIgnoreJudge:YES];
    }];
}

/** 当前主播的头像 */
- (NSString *)xyf_currentHostAvatar {
    return self.xyf_getCurrentRoom.dsb_ownerAvatar;
}

/** 点击弹幕用户名字 */
- (void) xyf_clickBarrageNickname:(NSInteger) xyp_accoundId andType:(OWLMusicMessageUserType) xyp_type {
    [self xyf_clickShowUserDetailView:xyp_accoundId nickname:@"" avatar:@"" displayAccountID:@"" isAnchor:xyp_type != OWLMusicMessageUserType_User isPkOtherUser:NO];
}

/** 去svip页面 */
- (void)xyf_jumpToSpecialPage {
    [OWLJConvertToolShared xyf_remindRechargeSvip];
}

/** 获取VC的view*/
- (UIView *) xyf_getVCView {
    return self.xyp_targetView;
}

/** 进入房间60s 弹关注弹窗*/
- (void) xyf_showFollowAlert {
    [self xyf_showAutoFollowAlertView];
}

/** 弹出礼物是的弹窗y */
- (void) xyf_chooseGiftAlertYChanged:(double) xyp_y {
    [self.xyp_controlView xyf_updateGiftWhenPopGiftView:xyp_y];
}

#pragma mark - OWLBGMModuleBaseViewDelegate 所有视图点击事件回调
/// 点击事件（无需带参数的点击）
/// - Parameter clickType: 点击类型
- (void)xyf_lModuleBaseViewClickEvent:(XYLModuleBaseViewClickType)clickType {
    switch (clickType) {
        case XYLModuleBaseViewClickType_ShowAudienceList: /// 展示观众列表
            [self xyf_clickShowAudienceListView];
            break;
        case XYLModuleBaseViewClickType_ShowRoomTools: /// 展示房间工具
            [self xyf_clickShowRoomToolsView];
            break;
        case XYLModuleBaseViewClickType_ShowRechargeView: /// 展示充值弹窗
            [self xyf_clickShowRechargeView];
            break;
        case XYLModuleBaseViewClickType_ShowGiftList: /// 展示礼物列表
            [self xyf_clickShowGiftList];
            break;
        case XYLModuleBaseViewClickType_ShowTextInput: /// 弹出文本输入
            [self xyf_clickShowTextInput];
            break;
        case XYLModuleBaseViewClickType_EditMedalListView: /// 编辑奖章弹窗
            [self xyf_clickShowMedalListView:OWLJConvertToolShared.xyf_userAccountID isJustShow:NO];
            break;
        case XYLModuleBaseViewClickType_ShowPrivateChatView: /// 展示私聊弹窗
            [self xyf_clickShowPrivateChatView];
            break;
        case XYLModuleBaseViewClickType_EnterOtherRoom: /// 进入对方房间
            [self xyf_giveCallBackEnterOtherAnchorRoom];
            break;
        case XYLModuleBaseViewClickType_ClickCloseButton: /// 点击关闭按钮
            [self xyf_giveCallBackCloseOrChangeFloatState];
            break;
        case XYLModuleBaseViewClickType_ClickDiscountButton: /// 点击优惠按钮
            [self xyf_showDiscountAlertView:OWLMusicShowDiscountViewType_Click];
            break;
        case XYLModuleBaseViewClickType_ClickFanButton: /// 点击铁粉按钮
            [self xyf_showFanAlertView];
            break;
        case XYLModuleBaseViewClickType_ClickGameButton: /// 点击游戏按钮
            [self xyf_showGameAlertView];
            break;
        case XYLModuleBaseViewClickType_ClickStreamSettings: /// 点击设置按钮
            [self xyf_showStreamSettingsAlertView];
            break;
    }
}

/// 点击事件（带用户基本信息的点击事件）【注：不同的点击事件合并成一个方法了 用不到的参数就不用 空的话传@""】
/// - Parameters:
///   - clickType: 点击事件
///   - accountID: id
///   - avatar: 头像
///   - nickname: 昵称
///   - displayAccountID: 展示ID
///   - isAnchor: 是否是主播
- (void)xyf_lModuleBaseViewClickInfoEvent:(XYLModuleBaseViewInfoClickType)clickType
                                   accountID:(NSInteger)accountID
                                      avatar:(NSString *)avatar
                                    nickname:(NSString *)nickname
                            displayAccountID:(NSString *)displayAccountID
                                    isAnchor:(BOOL)isAnchor {
    switch (clickType) {
        case XYLModuleBaseViewInfoClickType_ShowUserDetailView: /// 展示用户信息弹窗
            [self xyf_clickShowUserDetailView:accountID nickname:nickname avatar:avatar displayAccountID:displayAccountID isAnchor:isAnchor isPkOtherUser:NO];
            break;
        case XYLModuleBaseViewInfoClickType_EnterTextChatVC: /// 进入私聊页面
            [OWLJConvertToolShared xyf_enterSingleChatVCWithAccountID:accountID nickname:nickname avatar:avatar displayID:displayAccountID isAnchor:isAnchor];
            break;
        case XYLModuleBaseViewInfoClickType_EnterUserDetailVC: /// 进入用户详情
            [OWLJConvertToolShared xyf_enterUserDetailVCWithAccountID:accountID nickname:nickname avatar:avatar displayID:displayAccountID isAnchor:isAnchor];
            break;
        case XYLModuleBaseViewInfoClickType_ShowMedalListView: /// 展示用户奖章弹窗
            [self xyf_clickShowMedalListView:accountID isJustShow:YES];
            break;
        case XYLModuleBaseViewInfoClickType_ShowReportUserView: /// 举报用户
            [self xyf_clickShowReportUserView:accountID];
            break;
        case XYLModuleBaseViewInfoClickType_ShowPKOtherUserDetailView: /// 展示PK对方用户详情弹窗
            [self xyf_clickShowUserDetailView:accountID nickname:nickname avatar:avatar displayAccountID:displayAccountID isAnchor:isAnchor isPkOtherUser:YES];
            break;
    }
}

/// 关注/取关主播
/// - Parameters:
///   - accountID: 主播ID
///   - isFollow: yes-关注 no-取关
///   - completion: 完成回调
- (void)xyf_lModuleBaseViewFollowAnchor:(NSInteger)accountID
                                  isFollow:(BOOL)isFollow
                                completion:(void(^)(void))completion {
    kXYLWeakSelf
    [OWLJConvertToolShared xyf_userFollowAnchor:accountID isFollow:isFollow completion:^(BOOL followState) {
        if (completion) { completion(); }
        [weakSelf xyf_refreshRoomAfterOpFollowHost:accountID isIgnoreJudge:NO];
    }];
}

/// 点击展示PK送礼排行榜
- (void)xyf_lModuleBaseViewShowPKRankWithAccountID:(NSInteger)accountID
                                        isOtherAnchor:(BOOL)isOtherAnchor {
    OWLMusicRoomDetailModel *model = [self xyf_getCurrentRoom];
    if (!model.xyf_isPKState) { return; }
    if (accountID == 0) { return; }
    NSInteger roomID = isOtherAnchor ? model.dsb_pkData.dsb_otherPlayer.dsb_roomID : model.dsb_roomID;
    if (roomID == 0) { return; }
    [OWLBGMPKRankListAlertView xyf_showPKRankListAlertView:self targetView:self.xyp_targetView isOtherAnchor:isOtherAnchor anchorID:accountID roomID:roomID dismissBlock:^{
        
    }];
}

/// 用户送礼
- (void)xyf_lModuleBaseViewSendGift:(OWLMusicGiftInfoModel *)model {
    [self xyf_sendGift:model isFast:YES];
}

/// 用户发送文字
- (void)xyf_lModuleBaseViewSendText:(NSString *)text {
    OWLMusicMessageModel *model = [OWLMusicMessageModel xyf_getTextMessage:text];
    [self xyf_giveCallBackSendMsg:model type:OWLMusicSubViewClickSendMsgType_SendText];
}

/// 键盘弹起更新高度
- (void)xyf_lModuleBaseViewUpdateKeyboardHeight:(CGFloat)height changeType:(XYLModuleChangeInputViewHeightType)changeType {
    [self.xyp_controlView xyf_updateFrameWhenKeyboardChanged:height changeType:changeType];
}

/// 更新标签
- (void)xyf_lModuleBaseViewUpdateLabel:(OWLMusicEventLabelModel *)label {
    [OWLJConvertToolShared xyf_updateUserLabel:label];
    [self.xyp_controlView xyf_dealWithEvent:XYLModuleEventType_UpdateUserMedal obj:label.dsb_labelUrl];
}

/// 展示房间详情
- (void)xyf_lModuleBaseViewShowRoomDetail:(CGFloat)leftMargin {
    kXYLWeakSelf
    self.xyp_goalView = [OWLBGMTopRoomDetailInfoAlertView xyf_showRoomDetailAlertView:self targetView:self.xyp_targetView goal:self.xyf_getCurrentRoom.dsb_roomGoal leftMargin:leftMargin dismissBlock:^{
        weakSelf.xyp_goalView = nil;
    }];
}

/// 当前房间模型
- (OWLMusicRoomDetailModel *)xyf_lModuleGetCurrentTotalModel {
    return [self xyf_getCurrentRoom];
}

#pragma mark - Actions
/// 展示观众列表
- (void)xyf_clickShowAudienceListView {
    kXYLWeakSelf
    self.xyp_audienceListView = [[OWLBGMAudienceAlertView alloc] initWithDismissBlock:^{
        weakSelf.xyp_audienceListView = nil;
    }];
    self.xyp_audienceListView.delegate = self;
    NSMutableArray *arr = [self xyf_getMemberList];
    [self xyf_updateMemberList:arr];
    [self.xyp_audienceListView xyf_showInView:self.xyp_targetView];
}

/// 展示房间工具
- (void)xyf_clickShowRoomToolsView {
    [OWLBGMRoomToolsAlertView xyf_showRoomToolsAlertView:self targetView:self.xyp_targetView dismissBlock:^{
        
    }];
}

/// 展示充值弹窗
- (void)xyf_clickShowRechargeView {
    [OWLJConvertToolShared xyf_insideShowRechargeView:self.xyp_targetView];
}

/// 操作广播开关
- (void)xyf_clickOperateBroadcast {
    NSLog(@"xytest 广播");
}

/// 展示礼物列表
- (void)xyf_clickShowGiftList {
    [[OWLPPAddAlertTool shareInstance] xyf_showGiftAlert];
}

/// 展示用户信息视图
- (void)xyf_clickShowUserDetailView:(NSInteger)accountID nickname:(NSString *)nickname avatar:(NSString *)avatar displayAccountID:(NSString *)displayAccountID isAnchor:(BOOL)isAnchor isPkOtherUser:(BOOL)isPkOtherUser {
    if (accountID == 0) { return; }
    if (self.xyp_isRequestAccountInfo) { return; }
    OWLMusicRoomDetailModel *model = [self xyf_getCurrentRoom];
    NSInteger roomID = isPkOtherUser ? model.dsb_pkData.dsb_otherPlayer.dsb_roomID : model.dsb_roomID;
    if (roomID == 0) { return; }
    
    self.xyp_isRequestAccountInfo = YES;
    kXYLWeakSelf
    [OWLMusicRequestApiManager xyf_requestAccountInfo:accountID roomID:roomID isAnchor:isAnchor isUGCRoom:model.dsb_isUGCRoom completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        if (aResponse.xyf_success) {
            OWLMusicAccountDetailInfoModel *model;
            if (isAnchor) {
                OWLBGMModuleAnchorModel *anchorModel = [[OWLBGMModuleAnchorModel alloc] initWithDictionary:[aResponse.data xyf_objectForKeyNotNil:@"data"]];
                model = [OWLMusicAccountDetailInfoModel xyf_configModelWithAnchor:anchorModel];
            } else {
                OWLBGMModuleUserModel *userModel = [[OWLBGMModuleUserModel alloc] initWithDictionary:[aResponse.data xyf_objectForKeyNotNil:@"data"]];
                model = [OWLMusicAccountDetailInfoModel xyf_configModelWithUser:userModel];
            }
            [OWLBGMUserDetailInfoAlertView xyf_showUserDetailAlertView:self targetView:self.xyp_targetView detailModel:model isAnchor:isAnchor dismissBlock:^{
                
            }];
            
        } else if (aResponse.xyf_requestSuccessWithWrongCode) {
            
        } else {
            
        }
        weakSelf.xyp_isRequestAccountInfo = NO;
    }];
}

/// 展示奖章列表
- (void)xyf_clickShowMedalListView:(NSInteger)accountID isJustShow:(BOOL)isJustShow {
    OWLBGMMedalListAlertView *view = [[OWLBGMMedalListAlertView alloc] initWithAccountID:accountID];
    view.xyp_isJustShow = isJustShow;
    view.delegate = self;
    [view xyf_showInView:self.xyp_targetView];
}

/// 展示举报弹窗
- (void)xyf_clickShowReportUserView:(NSInteger)accountID {
    BOOL isUGCRoomOwner = NO;
    NSInteger relationID = accountID;
    /// 如果是ugc房间的房主 举报要传roomID
    if ([self xyf_getCurrentRoom].dsb_isUGCRoom && accountID == [self xyf_getCurrentRoom].dsb_ownerAccountID) {
        isUGCRoomOwner = YES;
        relationID = [self xyf_getCurrentRoomID];
    }
    
    [OWLBGMReportAlertView xyf_showReportUserAlertView:self targetView:self.xyp_targetView relationID:relationID isUGCRoomOwner:isUGCRoomOwner dismissBlock:^{
        
    }];
}

/// 展示文本输入
- (void)xyf_clickShowTextInput {
    self.xyp_inputView.delegate = self;
    [self.xyp_inputView xyf_showInView:self.xyp_targetView];
}

/// 展示私聊弹窗
- (void)xyf_clickShowPrivateChatView {
    if (OWLJConvertToolShared.xyf_judgeNoNetworkAndShowNoNetTip) { return; }
    if ([self xyf_judgeUserIsMute]) { return; }
    OWLMusicGiftInfoModel *model = [OWLJConvertToolShared xyf_getGiftModel:[self xyf_getCurrentRoom].dsb_privateChatGiftID];
    if (model == nil) { return; }
    kXYLWeakSelf
    self.xyp_privateChatView = [OWLMusicTakeHerAlert xyf_showTakeHerAlertViewWithGift:model targetView:self.xyp_targetView andChatCoin:[self xyf_getCurrentRoom].dsb_ownerCallPrice andAnchorAvatar:[self xyf_getCurrentRoom].dsb_ownerAvatar andUserAvatar:OWLJConvertToolShared.xyf_userAvatar andSureTake:^{
        [weakSelf xyf_checkAuthWhenTakeAnchor:weakSelf.xyp_privateChatView.xyp_giftModel];
    } andDismissBlock:^{
        weakSelf.xyp_privateChatView = nil;
    }];
}

/// 展示自动关注弹窗
- (void)xyf_showAutoFollowAlertView {
    OWLMusicRoomDetailModel *currentRoom = [self xyf_getCurrentRoom];
    if (!currentRoom) { return; }
    if (currentRoom.dsb_isFollowedOwner) { return; }
    
    OWLMusicAccountDetailInfoModel *model = [[OWLMusicAccountDetailInfoModel alloc] init];
    model.xyp_avatar = currentRoom.dsb_ownerAvatar;
    model.xyp_nickName = currentRoom.dsb_ownerNickname;
    model.xyp_isFollow = NO;
    model.xyp_mood = currentRoom.dsb_ownerMood;
    model.xyp_accountId = currentRoom.dsb_ownerAccountID;
    model.xyp_displayAccountId = currentRoom.dsb_ownerDisplayAccountID;
    
    if (self.xyp_autoFollowView) {
        [self.xyp_autoFollowView removeFromSuperview];
        self.xyp_autoFollowView = nil;
    }
    kXYLWeakSelf
    self.xyp_autoFollowView = [OWLMusicAutoFollowView xyf_showAutoFollowAlertView:self targetView:self.xyp_targetView detailModel:model dismissBlock:^{
        weakSelf.xyp_autoFollowView = nil;
    }];
}

/// 展示充值优惠弹窗
- (void)xyf_showDiscountAlertView:(OWLMusicShowDiscountViewType)showType {
    if (self.xyp_discountView) { return; }
    
    kXYLWeakSelf
    OWLMusicProductModel *model = self.xyp_productModel;
    if (showType == OWLMusicShowDiscountViewType_SecondAuto) {
        NSMutableArray *arr = OWLJConvertToolShared.xyf_discountList;
        model = [arr xyf_objectAtIndexSafe:1];
        if (!model) { return; }
    }
    self.xyp_discountView = [OWLMusicFirstRechargeAlertView xyf_showDiscountAlertView:self.xyp_targetView bgColor:nil productModel:model dismissBlock:^{
        weakSelf.xyp_discountView = nil;
        if (showType == OWLMusicShowDiscountViewType_FirstAuto) {
            [weakSelf xyf_addTimer];
        }
    }];
}

/// 点击铁粉按钮
- (void)xyf_showFanAlertView {
    [OWLMusicJoinFanAlertView xyf_showJoinFanAlertView:self.xyp_targetView fanModel:self.xyf_getCurrentRoom.dsb_fanInfo anchorID:self.xyf_getCurrentRoom.dsb_ownerAccountID];
}

/// 显示游戏弹窗
- (void)xyf_showGameAlertView {
    OWLMusicGameMenuView *view = [[OWLMusicGameMenuView alloc] initWithGameModel:[self xyf_getCurrentRoom].dsb_gameConfig];
    [view xyf_showInView:self.xyp_targetView];
}

/// 显示设置弹窗
- (void)xyf_showStreamSettingsAlertView {
    [OWLBGMStreamSettingsAlertView xyf_showStreamSettingsAlertView:self.xyp_targetView];
}

#pragma mark - 定时器逻辑
- (void)xyf_addTimer {
    self.xyp_discountSecond = 0;
    if (self.xyp_timer == nil) {
        self.xyp_timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(xyf_changeTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.xyp_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)xyf_removeTimer {
    self.xyp_discountSecond = 0;
    if (self.xyp_timer) {
        [self.xyp_timer invalidate];
        self.xyp_timer = nil;
    }
}

- (void)xyf_changeTime {
    if (self.xyp_hasSwitchRoom || OWLMusicInsideManagerShared.xyf_hasRecharge) {
        [self xyf_removeTimer];
        return;
    }
    self.xyp_discountSecond += 1;
    if (self.xyp_discountSecond == 20) {
        [self xyf_showDiscountAlertView:OWLMusicShowDiscountViewType_SecondAuto];
        [self xyf_removeTimer];
    }
}

#pragma mark - 给回调
- (void)xyf_giveCallBackSendMsg:(OWLMusicMessageModel *)message type:(OWLMusicSubViewClickSendMsgType)type {
    if (message == nil) { return; }
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_clickManagerSendMessage:type:)]) {
        [self.delegate xyf_clickManagerSendMessage:message type:type];
    }
}

- (void)xyf_giveCallBackUpdateMemberList:(NSArray *)list {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_clickManagerUpdateMemberList:)]) {
        [self.delegate xyf_clickManagerUpdateMemberList:list];
    }
}

- (void)xyf_giveCallBackEnterOtherAnchorRoom {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_clickManagerEnterOtherAnchorRoom)]) {
        [self.delegate xyf_clickManagerEnterOtherAnchorRoom];
    }
}

- (void)xyf_giveCallBackConfigPopGesture:(BOOL)isEnable {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_clickManagerConfigPopGestureRecognizer:)]) {
        [self.delegate xyf_clickManagerConfigPopGestureRecognizer:isEnable];
    }
}

/// 关闭或者最小化房间
- (void)xyf_giveCallBackCloseOrChangeFloatState {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_clickManagerCloseOrChangeFloatState)]) {
        [self.delegate xyf_clickManagerCloseOrChangeFloatState];
    }
}

#pragma mark - Getter
/// 获取当前roomID
- (NSInteger)xyf_getCurrentRoomID {
    NSInteger currentRoomID = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(xyf_subManagerGetCurrentRoomID)]) {
        currentRoomID = [self.dataSource xyf_subManagerGetCurrentRoomID];
    }
    return currentRoomID;
}

/// 获取当前房间
- (OWLMusicRoomDetailModel *)xyf_getCurrentRoom {
    OWLMusicRoomDetailModel *model;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(xyf_subManagerGetCurrentRoomModel)]) {
        model = [self.dataSource xyf_subManagerGetCurrentRoomModel].xyp_detailModel;
    }
    return model;
}

/// 获取观众列表
- (NSMutableArray *)xyf_getMemberList {
    NSMutableArray *arr = [NSMutableArray array];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(xyf_subManagerGetMemberList)]) {
        arr = [self.dataSource xyf_subManagerGetMemberList];
    }
    return arr;
}

/// 是否被禁言
- (BOOL)xyf_isMute {
    BOOL isMute = false;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(xyf_subManagerGetIsMute)]) {
        isMute = [self.dataSource xyf_subManagerGetIsMute];
    }
    return isMute;
}

@end
