//
//  OWLMusicTotalManager.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/16.
//

/**
 * @功能描述：直播间总管理类
 * @创建时间：2023.2.16
 * @创建人：许琰
 * @备注：被直播间VC持有，其他的子管理类都在这个类里面【数据 + 点击事件 + 声网 等管理类】
 */

#import "OWLMusicTotalManager.h"

#pragma mark - View
#import "OWLMusicBottomInputView.h"
#import "OWLPPPairShowView.h"
#import "OWLMusciCenterPopAlert.h"
#import "OWLMusicRiskyRoomView.h"
#import "OWLMusicFirstRechargeAlertView.h"
#import "OWLMusicJoinFanGuideView.h"

#pragma mark - VC
#import "OWLBGMModuleVC.h"

#pragma mark - Manager
#import "OWLMusicSubViewClickManager.h"
#import "OWLMusicDataSourceManager.h"
#import "OWLMusicAgoraManager.h"
#import "OWLPPAddAlertTool.h"
#import "OWLMusicFloatWindow.h"
#import "OWLMusicComboManager.h"
#import "OWLMusicBroadcastManager.h"

#pragma mark - Model
#import "XYCModulePushMessageModel.h"
#import "OWLMusicPushDestoryMsg.h"
#import "OWLMusicPrivateChatMsg.h"
#import "OWLMusicRandomTableMsgModel.h"
#import "OWLMusicBroadcastModel.h"
#import "OWLMusicEntryEffectPushMsg.h"

@interface OWLMusicTotalManager() <
OWLMusicDataSourceManagerDelegate,
OWLMusicSubManagerDataSource,
OWLMusicAgoraManagerDelegate,
OWLMusicSubViewClickManagerDelegate
>

#pragma mark - View
/// 主页面
@property (nonatomic, strong) OWLBGMModuleMainView *xyp_controlView;
/// 视频页面
@property (nonatomic, strong) OWLMusicVideoContainerView *xyp_videoContainerView;

#pragma mark - Manager
/// 子视图点击事件管理类
@property (nonatomic, strong) OWLMusicSubViewClickManager *xyp_clickManager;
/// 房间数据列表管理类
@property (nonatomic, strong) OWLMusicDataSourceManager *xyp_dataManager;
/// 声网管理类
@property (nonatomic, strong) OWLMusicAgoraManager *xyp_agoreManager;

#pragma mark - Data
/// 观众列表
@property (nonatomic, strong) NSMutableArray *xyp_memberList;
/// 是否被禁言
@property (nonatomic, assign) BOOL xyp_userIsMute;
/// 是否已经离开过直播间
@property (nonatomic, assign) BOOL xyp_hasDestroyLive;

@end

@implementation OWLMusicTotalManager

#pragma mark - Setter
- (void)setXyp_pipManager:(ZOEPIP_PIPManager *)xyp_pipManager {
    _xyp_pipManager = xyp_pipManager;
    self.xyp_agoreManager.xyp_pipManager = xyp_pipManager;
}

#pragma mark - Public
#pragma mark 初始化
- (void)xyf_setupManager {
    /// 初始化清空广播管理类
    [XYCBroadcastShared xyf_destoryManager];
    /// 初始化控制层视图 及 视频页面视图
    self.xyp_controlView = [[OWLBGMModuleMainView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    [XYCBroadcastShared xyf_setupBannerOnView:self.xyp_controlView];
    self.xyp_videoContainerView = [[OWLMusicVideoContainerView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    self.xyp_videoContainerView.dataSource = self;
    
    /// 将一些视图 传给 点击管理类，供其内部使用（weak属性）
    self.xyp_clickManager.xyp_targetView = self.xyp_targetView;
    self.xyp_clickManager.xyp_inputView = self.xyp_inputView;
    self.xyp_clickManager.xyp_controlView = self.xyp_controlView;
    
    /// 将一些代理事件设置给点击管理类
    [OWLPPAddAlertTool shareInstance].xyp_delegate = self.xyp_clickManager;
    self.xyp_controlView.delegate = self.xyp_clickManager;
    self.xyp_controlView.mainDelegate = self.xyp_clickManager;
    self.xyp_inputView.delegate = self.xyp_clickManager;
    
    /// 将视频视图 传给 RTC管理类，供其内部使用（weak属性）
    self.xyp_agoreManager.xyp_videoContainerView = self.xyp_videoContainerView;
    
    /// 初始化RTC设置
    [self.xyp_agoreManager xyf_configRTCEngine];
    
    /// 初始化清月的工具类计时器
    [[OWLPPAddAlertTool shareInstance] xyf_activationTimer];
    
    /// 重置状态
    self.xyp_isClose = NO;
}

#pragma mark 进入房间（ViewDidLoad）
- (void)xyf_joinRoomWithConfigModel:(OWLMusicEnterConfigModel *)configModel {
    
    kXYLWeakSelf
    /// 初始化数据管理类
    [self.xyp_dataManager xyf_setupDataManagerWithConfigModel:configModel];
    /// 调进入房间接口 (第一次进入房间的时候 需要在加入房间之后 获取列表数据。接口请求失败就不管了)
    [self xyf_requestJoinRoom:configModel.xyp_anchorID isShowLoading:YES isUGCRoom:configModel.xyp_isUGCRoom fromWay:configModel.xyp_fromWay completion:^(BOOL success, OWLMusicRoomDetailModel *model) {
        if (success) {
            [weakSelf.xyp_dataManager xyf_requestRoomList:configModel.xyp_isUGCRoom];
            /// 进入RTMChannel
            [weakSelf.xyp_agoreManager xyf_setupRTMChannel:model.dsb_rtcRoomID todo:@"" completion:^(BOOL success) {
                if (success) {
                    [[OWLPPAddAlertTool shareInstance] xyf_startNewRoom];
                }
            }];
            /// 进入RTC
            [weakSelf.xyp_agoreManager xyf_enterRTCRoom:model.dsb_rtcRoomID];
            /// 显示铁粉引导
            [weakSelf xyf_showFanClubGuide];
            /// 配置游戏
            [weakSelf xyf_setupGameFloatView:YES];
            /// 初始化充值优惠状态
            [weakSelf xyf_setupOneCoinAndPayDiscountView];
        }
    }];
    /// 埋点
    [OWLMusicTongJiTool xyf_thinkingWithTimeEventName:XYLThinkingEventTimeForOneLive];
}

#pragma mark 切换房间
/// 滑动切换房间
- (void)xyf_switchChangeRoom:(NSInteger)index {
    /// 滑动刷新当前列表之后的数据（删除不活跃的房间 添加更新列表中的数据）
    [self.xyp_dataManager xyf_refreshListAfterScrollStop:index];
    if (index == self.xyp_currentIndex) { return; }
    /// 提前显示loading
    [OWLJConvertToolShared xyf_showLoading];
    /// 滑动离开当前房间
    [self xyf_switchLeaveCurrentRoom];
    /// 滑动加入新的房间
    [self xyf_switchJoinRoomWithIndex:index fromWay:XYLOutDataSourceEnterRoomType_Scroll];
}

/// 滑动离开当前房间
- (void)xyf_switchLeaveCurrentRoom {
    /// 离开频道接口
    [self xyf_requestLeaveRoom];
    /// 退RTM频道
    [self.xyp_agoreManager xyf_leaveRtmChannel];
    /// 清除房间数据
    [self xyf_clearAllRoomData];
    /// 埋点
    [OWLMusicTongJiTool xyf_thinkingTimeForOneLive:self.xyp_currentTotalModel];
    /// 画中画清除上一帧画面
    [self.xyp_pipManager zoepip_clearLastPicture];
}

/// 滑动加入房间
- (void)xyf_switchJoinRoomWithIndex:(NSInteger)index fromWay:(XYLOutDataSourceEnterRoomType)fromWay {
    self.xyp_clickManager.xyp_hasSwitchRoom = YES;
    /// 清除biubiubiu
    [OWLMusicComboManager.shared xyf_stopAnimation:YES];
    /// 先更新数据管理类的当前房间信息 并回调刷新UI
    [self.xyp_dataManager xyf_switchChangeCurrentIndex:index fromWay:fromWay];
    
    /// 进入频道接口
    OWLMusicRoomTotalModel *nextModel = self.xyp_dataManager.xyp_currentModel;
    /// 加RTC
    [self.xyp_agoreManager xyf_switchRTCRoom:nextModel.xyp_detailModel.dsb_rtcRoomID];
    kXYLWeakSelf
    [self xyf_requestJoinRoom:[nextModel xyf_getOwnerID] isShowLoading:NO isUGCRoom:nextModel.xyp_isUGCRoom fromWay:fromWay completion:^(BOOL success, OWLMusicRoomDetailModel *model) {
        if (success) {
            /// 进入RTMChannel
            [weakSelf.xyp_agoreManager xyf_setupRTMChannel:[nextModel xyf_getRTCRoomID] todo:nextModel.xyp_tempModel.xyp_nickname completion:^(BOOL success) {
                if (success) {
                    [[OWLPPAddAlertTool shareInstance] xyf_startNewRoom];
                    /// 配置游戏
                    [weakSelf xyf_setupGameFloatView:NO];
                }
            }];
        } else {
            weakSelf.xyp_isClose = YES;
        }
    }];
    /// 埋点
    [OWLMusicTongJiTool xyf_thinkingWithTimeEventName:XYLThinkingEventTimeForOneLive];
}

/// 点击横幅切换房间
- (void)xyf_enterOtherRoomByBroadcast:(OWLMusicBroadcastModel *)model {
    /// 离开当前房间
    [self xyf_switchLeaveCurrentRoom];
    /// 数据源管理类 操控数据
    [self.xyp_dataManager xyf_enterOtherRoomByBroadcast:model];
}

#pragma mark 关闭相关
/// 关闭房间或最小化房间
/// - Parameter isUserClose: 是否是用户关闭房间
- (void)xyf_closeOrFloatWindow:(BOOL)isUserClose {
    BOOL isNeedFloatWindow = YES;
    if (isUserClose) {
        isNeedFloatWindow = OWLMusicInsideManagerShared.xyp_isOpenWindowInApp;
    }
    /// 如果不是关闭 && 没有最小化 && 当前房间是活跃的 && 需要开启小窗
    if (!self.xyp_isClose &&
        !OWLMusicFloatWindowShared.xyp_isShowing &&
        [self.xyp_currentTotalModel.xyp_detailModel xyf_beActive] &&
        isNeedFloatWindow) {
        [self xyf_changeVCToFloatWindow];
        /// 退出VC
        [self xyf_popLiveVC];
    } else {
        if (!OWLMusicFloatWindowShared.xyp_isShowing) {
            [self xyf_exitLiveRoom:YES];
        }
    }
}

#pragma mark 退出直播间相关
/// 退出直播间
- (void)xyf_exitLiveRoom:(BOOL)isNeedPopVC {
    if (self.xyp_hasDestroyLive) { return; }
    self.xyp_hasDestroyLive = YES;
    self.xyp_isClose = YES;
    if (isNeedPopVC) {
        /// 退出VC
        [self xyf_popLiveVC];
    }
    /// 取消常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    /// 重置浮窗
    [OWLMusicFloatWindowShared xyf_resetFloatingView];
    /// 埋点
    [OWLMusicTongJiTool xyf_thinkingTimeForOneLive:self.xyp_currentTotalModel];
    if ([self.xyp_currentTotalModel.xyp_detailModel xyf_isPKState]) {
        [OWLMusicTongJiTool xyf_thinkingTimeForOnePK:self.xyp_currentTotalModel];
    }
    /// 离开频道接口
    [self xyf_requestLeaveRoom];
    /// 退RTC
    [self.xyp_agoreManager xyf_exitRTCRoom];
    /// 退RTM频道
    [self.xyp_agoreManager xyf_leaveRtmChannel];
    /// 清除房间数据
    [self xyf_clearAllRoomData];
    /// 清空广播管理类
    [XYCBroadcastShared xyf_destoryManager];
    /// 释放所有内存
    [self xyf_releaseAllMemory];
    /// 给回调通知外部
    [OWLJConvertToolShared xyf_destroyModule];
}

/// 退出当前页面
- (void)xyf_popLiveVC {
    if (self.xyp_targetVC.navigationController) [self.xyp_targetVC.navigationController popViewControllerAnimated:YES];
    [self.xyp_targetVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 最小化相关
/// 页面最小化
- (void)xyf_changeVCToFloatWindow {
    /// 浮窗单例持有vc 用于跳转
    OWLMusicFloatWindowShared.xyp_backVC = self.xyp_targetVC;
    /// 获取浮窗视图
    [OWLMusicFloatWindowShared xyf_showFloatingWindow:[self xyf_fetchFloatingView] startFrame:[self.xyp_videoContainerView xyf_getViewWindowStartFrame]];
}

/// 获取小窗状态下的视图
- (UIView *)xyf_fetchFloatingView {
    /// 移除视图
    [self.xyp_videoContainerView removeFromSuperview];
    /// 改变状态：1.改总大小 2.改视频大小 3.xyp_isFloatState状态改变
    [self.xyp_videoContainerView xyf_changeFloatState:YES];
    
    return self.xyp_videoContainerView;
}

#pragma mark - Private
#pragma mark 清除数据相关
/// 清除所有房间数据
- (void)xyf_clearAllRoomData {
    /// 清除biubiubiu
    [OWLMusicComboManager.shared xyf_stopAnimation:YES];
    /// 清除横幅数据
    [XYCBroadcastShared xyf_destoryManager];
    /// 清除combo
    [OWLMusicInsideManagerShared xyf_removeComboView];
    /// 清除视频画面数据
    self.xyp_videoContainerView.xyp_roomStatus = 0;
    /// 清除页面数据
    [self xyf_dealEventWithType:XYLModuleEventType_ClearAllData obj:nil];
    /// 发通知 通知页面销毁
    [self xyf_postNotification:xyl_live_clear_room_info];
    /// 还原当前房间的异常状态
    [self xyp_currentTotalModel].xyp_isUnnormalJoin = NO;
    /// 清除礼物数据
    [self.xyp_controlView xyf_removeGift];
    /// 清RTC页面
    [self.xyp_agoreManager xyf_resetRemoteView];
    /// 清除列表数据
    [self xyf_refreshAllMemberList:[NSArray new]];
    /// 清除青月工具类的相关数据
    [[OWLPPAddAlertTool shareInstance] xyf_clearAllData];
    /// 清楚点击管理类数据（是否发送过消息、是否送过礼物 等）
    [self.xyp_clickManager xyf_clearAllData];
    /// 重置状态
    self.xyp_userIsMute = NO;
}

/// 释放所有内存（释放VC 和 视图）
- (void)xyf_releaseAllMemory {
    [self.xyp_controlView removeFromSuperview];
    [self.xyp_videoContainerView removeFromSuperview];
    [self.xyp_targetView xyf_removeAllSubviews];
    if (self.xyp_targetVC == OWLMusicInsideManagerShared.xyp_vc) {
        OWLMusicInsideManagerShared.xyp_vc = nil;
    }
    [self.xyp_pipManager zoepip_destroyPIP];
    self.xyp_targetVC = nil;
    self.xyp_controlView = nil;
    self.xyp_videoContainerView = nil;
    [self.xyp_clickManager xyf_removeTimer];
    [[OWLPPAddAlertTool shareInstance] xyf_destroyTimer];
    NSLog(@"xytest 清除vc");
}

#pragma mark 封禁相关
- (void)xyf_getMutedListAndCustomInfo {
    NSString *rtcRoomID = self.xyp_currentDetailModel.dsb_rtcRoomID;
    /// 房间内自定义消息
    [self.xyp_agoreManager xyf_getChannelAttWithRoomID:rtcRoomID];
    
    /// 接口
    kXYLWeakSelf
    [OWLMusicRequestApiManager xyf_requestMutedMembers:rtcRoomID isUGCRoom:self.xyp_currentDetailModel.dsb_isUGCRoom completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        if (aResponse.xyf_success) {
            if (rtcRoomID == [[weakSelf xyp_currentTotalModel] xyf_getRTCRoomID]) {
                NSDictionary *dic = [aResponse.data xyf_objectForKeyNotNil:@"data"];
                NSArray *list = [dic xyf_objectForKeyNotNil:@"accountIds"];
                [self.xyp_agoreManager xyf_sendLocalMsg:[OWLMusicMessageModel xyf_getMutedMembersInfoMsg:list]];
            }
        }
    }];
}

#pragma mark 事件相关
/// 处理事件
- (void)xyf_dealEventWithType:(XYLModuleEventType)type obj:(NSObject * __nullable)obj {
    [self.xyp_controlView xyf_dealWithEvent:type obj:obj];
}

#pragma mark 观众列表相关
/// 刷新观众列表（一整个数据源替换）
- (void)xyf_refreshAllMemberList:(NSArray *)array {
    [self.xyp_memberList removeAllObjects];
    self.xyp_memberList = [[NSMutableArray alloc] initWithArray:array];
    [self xyf_sortMemberList];
    [self xyf_updateMemberListData];
}

/// 观众列表排序（按照送礼数量降序排列）
- (void)xyf_sortMemberList {
    if (self.xyp_memberList.count == 0) { return; }
    NSSortDescriptor *giftDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"xyp_giftCost" ascending:NO];
    [self.xyp_memberList sortUsingDescriptors:@[giftDescriptor]];
}

/// 刷新观众列表
- (void)xyf_updateMemberListData {
    /// 更新顶部的观众列表
    [self.xyp_controlView xyf_updateMemberList:self.xyp_memberList];
    /// 更新弹窗的观众列表
    [self.xyp_clickManager xyf_updateMemberList:self.xyp_memberList];
    /// 更新模型中的列表
    self.xyp_currentDetailModel.dsb_memberList = self.xyp_memberList;
}

#pragma mark PK相关
/// 刷新PK数据及UI
- (void)xyf_refreshPKDataAndUI:(OWLMusicRoomPKDataModel *)pkModel {
    /// 刷新数据
    self.xyp_currentDetailModel.dsb_pkData = pkModel;
    /// 刷新视图
    [self.xyp_controlView xyf_updatePKData:pkModel];
}

/// 清除PK页面
- (void)xyf_clearPKView {
    /// 清除对面视频流
    [self.xyp_agoreManager xyf_stopOtherRemoteViewAndChangeSize];
    /// 清空数据并刷新UI
    [self xyf_refreshPKDataAndUI:nil];
    /// 重新刷新私聊按钮
    [self xyf_updatePrivateChatUI:self.xyp_currentTotalModel.xyp_detailModel.dsb_privateChatState];
    /// 重新刷新转盘按钮
    [self xyf_dealEventWithType:XYLModuleEventType_UpdateRandomTableIsShow obj:@(self.xyp_currentTotalModel.xyp_detailModel.dsb_circlePanState == 1)];
    /// 埋点
    [OWLMusicTongJiTool xyf_thinkingTimeForOnePK:self.xyp_currentTotalModel];
}

#pragma mark 私聊带走相关
/// 更新私聊UI
- (void)xyf_updatePrivateChatUI:(XYLModulePrivateChatStatusType)type {
    [self xyf_dealEventWithType:XYLModuleEventType_UpdatePrivateChat obj:@(type)];
    if (type == XYLModulePrivateChatStatusType_Close) {
        [self.xyp_clickManager xyf_closePrivateChatView];
    }
}

/// 展示更多弹窗
- (void)xyf_showMoreAlertViewWhenTakeAnchor {
    kXYLWeakSelf
    NSInteger anchorID = [[self xyp_currentTotalModel] xyf_getOwnerID];
    [OWLMusciCenterPopAlert xyf_showCenterPopAlert:1 anchorID:anchorID targetView:self.xyp_targetView moreAction:^{
        [weakSelf xyf_exitLiveRoom:YES];
        OWLMusicInsideManagerShared.xyp_isNeedRefreshHomeList = YES;
    }];
}

#pragma mark 房间状态相关
/// 更改房间状态
- (void)xyf_updateRoomStatus:(XYLModuleRoomStateType)roomState {
    [self xyp_currentTotalModel].xyp_detailModel.dsb_roomState = roomState;
    self.xyp_videoContainerView.xyp_roomStatus = roomState;
}

#pragma mark 历史弹幕相关
/// 加载历史弹幕
- (void)xyf_loadHistroyMessage:(NSMutableArray *)list currentAnchorID:(NSInteger)currentAnchorID {
    if (currentAnchorID != [[self xyp_currentTotalModel] xyf_getOwnerID]) { return; }
    kXYLWeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (currentAnchorID != [[self xyp_currentTotalModel] xyf_getOwnerID]) { return; }
        OWLMusicMessageModel *message = list.lastObject;
        if (message) {
            message.dsb_msgType = OWLMusicMessageType_TextMessage;
            [[OWLPPAddAlertTool shareInstance] xyf_showOneBarrageEffectWith:message andImmediatelyMsg:YES];
            [list removeLastObject];
            [weakSelf xyf_loadHistroyMessage:list currentAnchorID:currentAnchorID];
        }
    });
}

#pragma mark 自动弹窗相关
/// 初始化一金币转盘弹窗 和 首充优惠弹窗
- (void)xyf_setupOneCoinAndPayDiscountView {
    // ---- 初始化入口 ----
    /// 是否需要展示一金币转盘
    BOOL canShowOneCoin = OWLJConvertToolShared.xyf_isNeedShowOneCoin;
    /// 是否需要展示内购优惠
    BOOL canShowPayDiscount = [self xyf_isNeedShowPayDiscounts];
    
//    [self xyf_dealEventWithType:XYLModuleEventType_UpdateDiscountButton obj:@(canShowPayDiscount)];
    
    NSDictionary *notificationDic = @{ kXYLNotificationOneCoinStateKey : @(canShowOneCoin),
                                       kXYLNotificationPayDiscountStateKey : @(canShowPayDiscount)
    };
    
    [self xyf_dealEventWithType:XYLModuleEventType_UpdateCycleInfoView obj:notificationDic];
    /// 改变底部充值按钮状态
    [self xyf_dealEventWithType:XYLModuleEventType_UpdateBottomRechargeButton obj:@(canShowOneCoin)];
    
    // ---- 初始化自动弹窗 ----
    /// 自动展示一金币转盘： 如果需要展示一金币转盘 && 本次进程中还没展示过
    BOOL isAutoShowOneCoinAlert = canShowOneCoin && !OWLJConvertToolShared.xyf_hasShowOneCoinInRoom;
    /// 自动展示内购优惠转盘：如果需要展示内购优惠 &&  本地进程中还没展示过
    BOOL isAutoShowPayDiscountAlert = canShowPayDiscount && OWLMusicInsideManagerShared.xyp_shouldShowAutoDiscountView;
    
    if (isAutoShowOneCoinAlert) { /// 优先展示一金币优惠弹窗
        kXYLWeakSelf
        double time = 0.1 + OWLJConvertToolShared.xyf_oneCoinPromptTime;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf xyf_showOneCoinTest];
        });
    } else if (isAutoShowPayDiscountAlert) { /// 不自动展示1金币 才判断内购优惠
        OWLMusicInsideManagerShared.xyp_shouldShowAutoDiscountView = NO;
        [self.xyp_clickManager xyf_showDiscountAlertView:OWLMusicShowDiscountViewType_FirstAuto];
    }
}

- (void)xyf_showOneCoinTest {
    [OWLJConvertToolShared xyf_showOneCoinTest:NO];
}

/// 判断是否需要展示充值优惠
- (BOOL)xyf_isNeedShowPayDiscounts {
    /// 绿号 ==> 不展示
    if (OWLJConvertToolShared.xyf_isGreen) { return NO; }
    /// 充值过  ==> 不展示
    if (OWLMusicInsideManagerShared.xyf_hasRecharge) { return NO; }
    /// 不存在没买过的内购折扣模型  ==> 不展示
    if (OWLJConvertToolShared.xyf_discountList.count <= 0) { return NO; }
    /// 更新最便宜的内购模型
    self.xyp_clickManager.xyp_productModel = OWLJConvertToolShared.xyf_discountList.firstObject;
    
    return YES;
}

#pragma mark combo相关
/// 是否展示喷泉动画
- (void)xyf_showGiftComboAnimation:(OWLMusicGiftInfoModel *)gift message:(OWLMusicMessageModel *)message {
    if (gift && gift.dsb_comboIconImage.length > 0 && message.dsb_giftCombo >= 5) {
        [self xyf_giftComboAnimation:gift combo:message.dsb_giftCombo bySelf:message.dsb_accountID == OWLJConvertToolShared.xyf_userAccountID];
    }
}

/// 礼物喷泉动画
- (void)xyf_giftComboAnimation:(OWLMusicGiftInfoModel *)gift combo:(NSInteger)combo bySelf:(BOOL)bySelf {
    UIImage *image = [SDImageCache.sharedImageCache imageFromDiskCacheForKey:[SDWebImageManager.sharedManager cacheKeyForURL:[NSURL URLWithString:gift.dsb_comboIconImage]]];
    if (!image) {
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:gift.dsb_comboIconImage] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        }];
    }
    
    [OWLMusicComboManager.shared xyf_startAnimationWithImage:image size:CGSizeMake(gift.dsb_comboNum, gift.dsb_comboNum) container:self.xyp_controlView count:combo senderIsSelf:bySelf];
}

#pragma mark 铁粉相关
/// 显示铁粉引导
- (void)xyf_showFanClubGuide {
    /// 没有铁粉功能就不显示
    if (!OWLJConvertToolShared.xyf_isOpenFanClub) { return; }
    /// 买过铁粉就不显示
    if (self.xyp_currentTotalModel.xyp_detailModel.dsb_fanInfo.dsb_isGainedFan) { return; }
    /// 是铁粉就不显示
    if (self.xyp_currentTotalModel.xyp_detailModel.dsb_fanInfo.dsb_isFan) { return; }
    /// 是svip就不显示
    if (OWLJConvertToolShared.xyf_userIsSvip) { return; }
    /// 已经显示过就不显示
    if (OWLJConvertToolShared.xyf_isShowFanGuideTip) { return; }
    /// 展示引导
    OWLMusicJoinFanGuideView *view = [[OWLMusicJoinFanGuideView alloc] init];
    [self.xyp_targetView addSubview:view];
    [OWLJConvertToolShared xyf_hadShowFanTip];
}

#pragma mark 游戏相关
/// 配置游戏
- (void)xyf_setupGameFloatView:(BOOL)isNeedInitDefauleGame {
    /// 语聊房当前游戏模型
    OWLMusicGameConfigModel *chatGameModel = [OWLJConvertToolShared xyf_chatCurrentGameModel];
    /// 直播间当前游戏模型
    OWLMusicGameConfigModel *liveGameModel = OWLMusicInsideManagerShared.xyp_gamePopView.game;
    /// 游戏配置模型
    OWLMusicGameInfoModel *gameInfoModel = self.xyp_currentTotalModel.xyp_detailModel.dsb_gameConfig;
    
    if (gameInfoModel.dsb_enable) { // 开启游戏
        /// 直播间和语聊房都没有游戏，初始化一个默认游戏
        if (!chatGameModel && !liveGameModel && isNeedInitDefauleGame) {
            OWLMusicGameConfigModel *defaultModel = [gameInfoModel xyf_findDefaultGameModel];
            if (defaultModel) {
                OWLMusicGamePopView *popView = [[OWLMusicGamePopView alloc]init];
                OWLMusicInsideManagerShared.xyp_gamePopView = popView;
                [popView xyf_loadModel:defaultModel initBig:NO];
            }
        }
        
        /// 检查语聊房的游戏开关是否关闭
        if (chatGameModel) {
            if (![gameInfoModel xyf_checkGameIsOpen:chatGameModel.dsb_gameId]) {
                [self xyf_closeChatGameFloatView];
            }
        }
        
        /// 检查直播间的游戏开关是否关闭
        if (liveGameModel) {
            if (![gameInfoModel xyf_checkGameIsOpen:liveGameModel.dsb_gameId]) {
                [self xyf_closeLiveGameFloatView];
            }
        }
        
    } else { // 不开启游戏
        /// 就把游戏关了
        [self xyf_closeChatOrLiveGameFloatView];
    }
}

/// 关闭直播间语聊房游戏悬浮窗
- (void)xyf_closeChatOrLiveGameFloatView {
    [self xyf_closeLiveGameFloatView];
    [self xyf_closeChatGameFloatView];
}

/// 关闭直播间悬浮窗
- (void)xyf_closeLiveGameFloatView {
    [OWLMusicInsideManagerShared.xyp_gamePopView xyf_close];
}

/// 关闭语聊房悬浮窗
- (void)xyf_closeChatGameFloatView {
    [OWLJConvertToolShared xyf_closeChatRoomGame];
}

#pragma mark - Network
/// 加入房间接口
/// - Parameters:
///   - anchorID: 主播ID
///   - isShowLoading: 是否展示loading
///   - isUGCRoom: 是否是UGC房间
///   - fromWay: 进入房间的方式
///   - completion: 回调
- (void)xyf_requestJoinRoom:(NSInteger)anchorID
              isShowLoading:(BOOL)isShowLoading
                  isUGCRoom:(BOOL)isUGCRoom
                    fromWay:(XYLOutDataSourceEnterRoomType)fromWay
                 completion:(void(^)(BOOL success, OWLMusicRoomDetailModel *model))completion {
    kXYLWeakSelf
        if (isShowLoading) { [OWLJConvertToolShared xyf_showLoading]; }
    [OWLMusicRequestApiManager xyf_requestJoinRoomWithHostID:anchorID isUGCRoom:isUGCRoom completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        [OWLJConvertToolShared xyf_hideLoading];
        if (aResponse.xyf_success) {
            OWLMusicRoomDetailModel *model = [[OWLMusicRoomDetailModel alloc] initWithDictionary:[aResponse.data xyf_objectForKeyNotNil:@"data"]];
            /// 更新房间详情信息（只在joinRoom接口调用）内部会判断是否需要刷新当前UI 通过回调刷新控制层UI数据
            [weakSelf.xyp_dataManager xyf_updateRoomDetailInfoModel:model];
            /// 初始化礼物弹窗
            [[OWLPPAddAlertTool shareInstance] xyf_addGiftChooseToView:weakSelf.xyp_targetView andDataArray:model.dsb_giftList];
            if (weakSelf.xyp_currentTotalModel.xyf_getOwnerID == model.dsb_ownerAccountID) {
                /// 校验当前房间的视频流
                [weakSelf.xyp_agoreManager xyf_setupVideoAfterJoinRoom:model];
            }
            if (completion) { completion(YES, model); }
            /// 埋点
            [OWLMusicTongJiTool xyf_thinkingEnterRoomSuccess:model fromWay:fromWay];
        } else if (aResponse.xyf_requestSuccessWithWrongCode) {
            [weakSelf.xyp_dataManager xyf_updateRoomUnnormalState:YES anchorID:anchorID];
            [OWLJConvertToolShared xyf_showErrorTip:aResponse.message];
            if (completion) { completion(NO, nil); }
        } else {
            [weakSelf.xyp_dataManager xyf_updateRoomUnnormalState:YES anchorID:anchorID];
            [OWLJConvertToolShared xyf_showNoNetworkTip];
            
            if (completion) { completion(NO, nil); }
        }
    }];
}

/// 离开房间接口
- (void)xyf_requestLeaveRoom {
    NSInteger roomID = [self.xyp_currentTotalModel xyf_getRoomID];
    if (roomID <= 0) { return;}
    
    [OWLMusicRequestApiManager xyf_requestLeaveRoomWithRoomID:roomID isUGCRoom:self.xyp_currentTotalModel.xyp_isUGCRoom completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        
    }];
}

#pragma mark - 处理推送消息
/// 处理推送消息
- (void)xyf_handleOpcode3Data:(XYCModulePushMessageModel *)model {
    switch (model.xyp_subCode) {
        case 36: /// 老直播间关闭✅
            [self xyf_dealOldClosePushMsg:model];
            break;
        case 37: /// 新直播间开启✅
            [self xyf_dealNewOpenPushMsg:model];
            break;
        case 38: /// 直播间恢复✅
            [self xyf_dealResumeRoomPushMsg:model];
            break;
        case 39: /// 直播间编辑✅
            [self xyf_dealEditRoomPushMsg:model];
            break;
        case 40: /// 直播间解散✅
            [self xyf_dealDestoryPushMsg:model isUGCRoom:NO];
            break;
        case 41: /// 直播间私聊开关改变✅
            [self xyf_dealChangePrivateChatPushMsg:model];
            break;
        case 61: /// 直播间目标更新✅
            [self xyf_dealUpdateGoalPushMsg:model];
            break;
        case 63: /// 直播间目标达成✅
            [self xyf_dealFinishGoalPushMsg];
            break;
        case 66: /// UGC视频聊天室开启
            [self xyf_dealNewOpenPushMsg:model];
            break;
        case 67: /// UGC视频聊天室恢复
            [self xyf_dealResumeRoomPushMsg:model];
            break;
        case 68: /// UGC被踢出
            [self xyf_dealDestoryPushMsg:model isUGCRoom:YES];
            break;
        case 69: /// 老UGC视频聊天室关闭
            [self xyf_dealOldClosePushMsg:model];
            break;
        case 70: /// UGC视频聊天室编辑
            [self xyf_dealEditRoomPushMsg:model];
            break;
        case 75: /// 横幅✅
            [self xyf_dealBroadcastPushMsg:model];
            break;
        case 80: /// 进场特效
            [self xyf_dealEntryEffectPushMsg:model];
            break;
        default:
            break;
    }
}

/// 36.老直播间关闭
- (void)xyf_dealOldClosePushMsg:(XYCModulePushMessageModel *)model {
    OWLMusicRoomDetailModel *detailModel = [[OWLMusicRoomDetailModel alloc] initWithDictionary:model.xyp_data];
    [self.xyp_dataManager xyf_deleteRoom:detailModel];
}


/// 37.新直播间开启
- (void)xyf_dealNewOpenPushMsg:(XYCModulePushMessageModel *)model {
    OWLMusicRoomDetailModel *detailModel = [[OWLMusicRoomDetailModel alloc] initWithDictionary:model.xyp_data];
    [self.xyp_dataManager xyf_addRoom:detailModel];
}

/// 38.直播间恢复
- (void)xyf_dealResumeRoomPushMsg:(XYCModulePushMessageModel *)model {
    OWLMusicRoomDetailModel *detailModel = [[OWLMusicRoomDetailModel alloc] initWithDictionary:model.xyp_data];
    [self.xyp_dataManager xyf_resumeRoom:detailModel];
    [self xyf_postNotification:xyl_live_room_resume withObject:@(detailModel.dsb_ownerAccountID)];
}

/// 39/70 直播间/UGC房间编辑
- (void)xyf_dealEditRoomPushMsg:(XYCModulePushMessageModel *)model {
    OWLMusicRoomDetailModel *detailModel = [[OWLMusicRoomDetailModel alloc] initWithDictionary:model.xyp_data];
    /// 如果不是当前主播的房间就不作处理
    if (detailModel.dsb_ownerAccountID != [[self xyp_currentTotalModel] xyf_getOwnerID]) {
        return;
    }
    
    /// 更新目标
    [self xyp_currentDetailModel].dsb_roomGoal = detailModel.dsb_roomGoal;
    [self xyf_dealEventWithType:XYLModuleEventType_UpdateGoal obj:detailModel.dsb_roomGoal];
    [self.xyp_clickManager xyf_updateGoal:detailModel.dsb_roomGoal];
    /// 更新带走礼物
    [self xyp_currentDetailModel].dsb_privateChatGiftID = detailModel.dsb_privateChatGiftID;
    [self.xyp_clickManager xyf_updatePrivateGift:detailModel.dsb_privateChatGiftID];
    /// 更新封面
    [[self xyp_currentTotalModel] xyf_updateCover:detailModel.dsb_cover];
    [self.xyp_videoContainerView.xyp_mineAnchorView xyf_setCover:detailModel.dsb_cover isClean:NO];
}

/// 40.直播间解散
- (void)xyf_dealDestoryPushMsg:(XYCModulePushMessageModel *)model isUGCRoom:(BOOL)isUGCRoom {
    OWLMusicPushDestoryMsg *destroyModel = [[OWLMusicPushDestoryMsg alloc] initWithDictionary:model.xyp_data];
    OWLMusicRoomTotalModel *currentModel = [self xyp_currentTotalModel];
    if ([currentModel xyf_getOwnerID] == destroyModel.dsb_destoryOne.dsb_ownerAccountID) {
        [self.xyp_pipManager zoepip_clearLastPicture];
        [currentModel xyf_updateRoomID:destroyModel.dsb_newOne.dsb_roomID];
        [self xyf_updateRoomStatus:destroyModel.dsb_newOne.dsb_roomState];
        if (currentModel.xyp_detailModel.xyf_isPKState) {
            [self xyf_clearPKView];
            if (OWLJConvertToolShared.xyf_isGreen || isUGCRoom) {
                [OWLJConvertToolShared xyf_showNotiTip:[XYCStringTool xyf_userQuitPKWithIsOther:NO]];
            } else {
                [OWLJConvertToolShared xyf_showNotiTip:[XYCStringTool xyf_hostQuitPKWithIsOther:NO]];
            }
        }
    }

    OWLMusicInsideManagerShared.xyp_isNeedRefreshHomeList = YES;
    
    if (isUGCRoom) {
        [OWLMusicInsideManagerShared xyf_insideCloseLivePage:!OWLMusicFloatWindowShared.xyp_isShowing];
        if (destroyModel.dsb_destroyType == XYLModuleDestoryReasonType_ReportRoom) {
            [OWLMusicRiskyRoomView xyf_showRiskyRoomView];
        }
    }
}

/// 41.直播间私聊开关改变
- (void)xyf_dealChangePrivateChatPushMsg:(XYCModulePushMessageModel *)model {
    OWLMusicPrivateChatMsg *privateModel = [[OWLMusicPrivateChatMsg alloc] initWithDictionary:model.xyp_data];
    if (privateModel.dsb_roomID == [self xyf_currentRoomID]) {
        self.xyp_currentTotalModel.xyp_detailModel.dsb_privateChatState = privateModel.dsb_privateState;
        [self xyf_updatePrivateChatUI:privateModel.dsb_privateState];
    }
}

/// 61.直播间目标更新
- (void)xyf_dealUpdateGoalPushMsg:(XYCModulePushMessageModel *)model {
    OWLMusicRoomGoalModel *goalModel = [[OWLMusicRoomGoalModel alloc] initWithDictionary:model.xyp_data];
    [self xyp_currentDetailModel].dsb_roomGoal = goalModel;
    [self xyf_dealEventWithType:XYLModuleEventType_UpdateGoal obj:goalModel];
    [self.xyp_clickManager xyf_updateGoal:goalModel];
}

/// 63.直播间目标达成
- (void)xyf_dealFinishGoalPushMsg {
    [[OWLPPAddAlertTool shareInstance] xyf_addAchieveGoalsSvgTo:self.xyp_targetView andName:[self xyp_currentDetailModel].dsb_ownerNickname];
}

/// 75.横幅展示
- (void)xyf_dealBroadcastPushMsg:(XYCModulePushMessageModel *)model {
    OWLMusicBroadcastModel *broadcastModel = [[OWLMusicBroadcastModel alloc] initWithDictionary:model.xyp_data];
    broadcastModel.xyp_showType = XYLBroadcastShowTypeGift;
    [XYCBroadcastShared xyf_addChannalBanner:broadcastModel];
}

/// 80.进场特效
- (void)xyf_dealEntryEffectPushMsg:(XYCModulePushMessageModel *)model {
    if (!OWLMusicInsideManagerShared.xyp_isShowNewEnterEffect) { return; }
    OWLMusicEntryEffectPushMsg *entryModel = [[OWLMusicEntryEffectPushMsg alloc] initWithDictionary:model.xyp_data];
    [self xyf_dealEventWithType:XYLModuleEventType_ShowEnterPagEffect obj:entryModel];
}

#pragma mark - OWLMusicSubManagerDataSource 子管理类数据源
/// 获取观众列表
- (NSMutableArray *)xyf_subManagerGetMemberList {
    return self.xyp_memberList;
}

/// 获取当前房间ID
- (NSInteger)xyf_subManagerGetCurrentRoomID {
    return self.xyf_currentRoomID;
}

/// 获取当前房间模型
- (OWLMusicRoomTotalModel *)xyf_subManagerGetCurrentRoomModel {
    return self.xyp_currentTotalModel;
}

/// 当前是否被禁言
- (BOOL)xyf_subManagerGetIsMute {
    return self.xyp_userIsMute;
}

/// 是否显示两个视图
- (BOOL)xyf_subManagerIsShowTwoPeople {
    return self.xyp_currentTotalModel.xyp_detailModel.dsb_pkData != nil;
}

#pragma mark - OWLMusicSubViewClickManagerDelegate 点击事件管理类的代理
/// 发消息
- (void)xyf_clickManagerSendMessage:(OWLMusicMessageModel *)message type:(OWLMusicSubViewClickSendMsgType)type {
    switch (type) {
        case OWLMusicSubViewClickSendMsgType_LocalAndRemote: /// 本地远端都发
            [self.xyp_agoreManager xyf_sendMessage:message];
            [self.xyp_agoreManager xyf_sendLocalMsg:message];
            break;
        case OWLMusicSubViewClickSendMsgType_Local: /// 只发本地
            [self.xyp_agoreManager xyf_sendLocalMsg:message];
            break;
        case OWLMusicSubViewClickSendMsgType_Remote: /// 只发远端
            [self.xyp_agoreManager xyf_sendMessage:message];
            break;
        case OWLMusicSubViewClickSendMsgType_SendText: /// 发送文字消息
            [self xyf_sendTextMessage:message];
            break;
    }
}

/// 更新观众列表
- (void)xyf_clickManagerUpdateMemberList:(NSArray *)list {
    [self xyf_refreshAllMemberList:list];
}

/// 发送文字消息
- (void)xyf_sendTextMessage:(OWLMusicMessageModel *)message {
    if ([OWLJConvertToolShared xyf_judgeNoNetworkAndShowNoNetTip]) { return; }
    if (self.xyp_userIsMute) {
        [OWLJConvertToolShared xyf_showNotiTip:[XYCStringTool xyf_userMute:YES]];
        return;
    }
    self.xyp_clickManager.xyp_isSendMsg = YES; /// 设置发送状态
    [self.xyp_agoreManager xyf_sendMessage:message]; /// 发送远端消息
    [[OWLPPAddAlertTool shareInstance] xyf_showOneBarrageEffectWith:message andImmediatelyMsg:YES]; /// 本地插入消息
    if (self.xyp_currentTotalModel.xyp_isUGCRoom) { return; }
    /// 掉接口
    [OWLMusicRequestApiManager xyf_requestSendText:message.dsb_text roomID:self.xyp_currentDetailModel.dsb_roomID completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
    }];
}

/// 点击对方房间
- (void)xyf_clickManagerEnterOtherAnchorRoom {
    /// 离开当前房间
    [self xyf_switchLeaveCurrentRoom];
    /// 数据源管理类 操控数据
    [self.xyp_dataManager xyf_enterOtherRoom];
}

/// 设置返回手势
- (void)xyf_clickManagerConfigPopGestureRecognizer:(BOOL)isEnable {
    [self xyf_giveCallBackChangePopGes:isEnable];
}

/// 关闭或者最小化房间
- (void)xyf_clickManagerCloseOrChangeFloatState {
    if (![OWLJConvertToolShared xyf_isShowScrollTip]) {
        [self xyf_giveCallBackShowGuideView];
        return;
    }
    [self xyf_closeOrFloatWindow:YES];
}

#pragma mark - OWLMusicDataSourceManagerDelegate 数据管理类的代理
/// 需要刷新列表（tableview reloadData）
- (void)xyf_liveDataSourceManagerRefreshList {
    [self xyf_giveCallBackReloadList];
}

/// 更新当前房间详情模型（在此处刷新控制层模型）
- (void)xyf_liveDataSourceManagerUpdateCurrentRoomDetailModel {
    /// 更新成员列表
    [self xyf_refreshAllMemberList:self.xyp_currentDetailModel.dsb_memberList];
    /// 更新控制层视图数据
    [self.xyp_controlView xyf_updateRoomData:self.xyp_dataManager.xyp_currentModel];
    /// 更新房间状态
    [self xyf_updateRoomStatus:self.xyp_currentDetailModel.dsb_roomState];
    /// 更新事件
    [self xyf_dealEventWithType:XYLModuleEventType_JoinRoom obj:self.xyp_dataManager.xyp_currentModel];
}

/// 插入或删除列表某个数据
- (void)xyf_liveDataSourceManagerOperateData:(NSInteger)index isDelete:(BOOL)isDelete {
    [self xyf_giveCallBackOperateData:index isDelete:isDelete];
}

/// 跳转到对面直播间
/// - Parameter isAlreadyHasRoom: 当前列表中是否已经有这个数据
- (void)xyf_liveDataSourceManagerEnterOtherRoom:(BOOL)isAlreadyHasRoom
                                        fromWay:(XYLOutDataSourceEnterRoomType)fromWay {
    [self xyf_giveCallBackEnterOtherRoom:isAlreadyHasRoom fromWay:fromWay];
}

/// 刷新恢复的房间（如果恢复的房间为当前房间才会走这个回调）
- (void)xyf_liveDataSourceManagerResumeRoom:(OWLMusicRoomTotalModel *)resumeModel isNeedCleanPK:(BOOL)isNeedCleanPK {
    if (isNeedCleanPK) {
        [self xyf_clearPKView];
    }
    
    /// 更新房间状态
    [self xyf_updateRoomStatus:XYLModuleRoomStateType_Living];
    /// 更新控制层视图数据
    [self.xyp_controlView xyf_updateRoomData:resumeModel];
}

/// 刷新当前主播ID
- (void)xyf_liveDataSourceManagerUpdateCurrentAnchorID:(NSInteger)anchorID {
    [self xyf_giveCallBackUpdateAnchorID:anchorID];
}

#pragma mark - OWLMusicAgoraManagerDelegate 声网管理类的代理
#pragma mark RTMChannel
/// 收到RTMChannel的弹幕消息
- (void)xyf_roomModuleManagerRTMChannelReceiveMessage:(OWLMusicMessageModel *)message {
    
    switch (message.dsb_msgType) {
        case OWLMusicMessageType_SystemTip: /// 1.系统提示
            [self xyf_dealMessageSystemTip:message];
            break;
        case OWLMusicMessageType_JoinRoom: /// 2.加入直播间✅
            [self xyf_dealMessageJoinRoom:message];
            break;
        case OWLMusicMessageType_TextMessage: /// 3.文本消息✅
            [[OWLPPAddAlertTool shareInstance] xyf_showOneBarrageEffectWith:message andImmediatelyMsg:NO];
            break;
        case OWLMusicMessageType_SendGift: /// 4.礼物
            [self xyf_dealMessageSendGift:message];
            break;
        case OWLMusicMessageType_MuteUser: /// 5.被禁言✅
            [[OWLPPAddAlertTool shareInstance] xyf_showOneBarrageEffectWith:message andImmediatelyMsg:NO];
            break;
        case OWLMusicMessageType_CancelMuteUser: /// 6.被取消禁言（不处理）✅
            break;
        case OWLMusicMessageType_UpdateRoomInfo: /// 7.刷新房间信息
            [self xyf_dealUpdateRoomInfo:message];
            break;
        case OWLMusicMessageType_UserTakeAnchor: /// 8.用户带走主播
            [self xyf_dealMessageUserTakeAnchor:message];
            break;
        case OWLMusicMessageType_MatchPKSuccess: /// 9.PK匹配成功
            [self xyf_dealMessageMatchPKSuccess:message];
            break;
        case OWLMusicMessageType_FinishPK: /// 10.PK结束✅
            [self xyf_dealMessageFinishPK];
            break;
        case OWLMusicMessageType_UpdatePKGoals: /// 11.PK分数更新✅
            [self xyf_dealMessageUpdatePKGoals:message];
            break;
        case OWLMusicMessageType_PKTimeUp: /// 12.PK时间到 携带pkwinner
            [self xyf_dealMessagePKTimeUp:message];
            break;
        case OWLMusicMessageType_PKAgain: /// 13.PK再来一次✅
            [self xyf_dealMessagePKAgain:message];
            break;
        case OWLMusicMessageType_PKRunAway: /// 14.PK逃跑✅
            [self xyf_dealMessagePKRunAway];
            break;
        case OWLMusicMessageType_PrivateOpenState: /// 15.私聊按钮开关✅
            [self xyf_dealMessagePrivateOpenState:message];
            break;
        case OWLMusicMessageType_UpdateMemberList: /// 16.刷新观众信息✅
            [self xyf_dealMessageUpdateMemberList:message];
            break;
        case OWLMusicMessageType_OppsiteVideo: /// 17.通知对面视频开关（不处理）✅
            
            break;
        case OWLMusicMessageType_TurntableInfo: /// 18.通知更新转盘信息以及转盘结果
            [self xyf_dealMessageTurntableInfo:message];
            break;
        case OWLMusicMessageType_MutedMembersInfo: /// 19.禁言列表 ✅
            [self xyf_dealMessageMutedMembersInfo:message];
            break;
        default:
            break;
    }
}

/// 1.系统提示
- (void)xyf_dealMessageSystemTip:(OWLMusicMessageModel *)message {
    /// 同步房间消息给其他用户
    [self.xyp_agoreManager xyf_sendMessage:[OWLMusicMessageModel xyf_getUpdateInfoMsg:self.xyp_currentDetailModel]];
    /// 获取禁言消息 + PK对方音视频状态
    [self xyf_getMutedListAndCustomInfo];
    /// 插入消息
    [[OWLPPAddAlertTool shareInstance] xyf_showOneBarrageEffectWith:message andImmediatelyMsg:YES];
    /// 读取房间历史弹幕
    NSMutableArray *messageList = [NSMutableArray arrayWithArray:self.xyp_currentDetailModel.dsb_lastMessages];
    [self xyf_loadHistroyMessage:messageList currentAnchorID:self.xyp_currentDetailModel.dsb_ownerAccountID];
}

/// 2.进入直播间
- (void)xyf_dealMessageJoinRoom:(OWLMusicMessageModel *)message {
    [[OWLPPAddAlertTool shareInstance] xyf_showOneBarrageEffectWith:message andImmediatelyMsg:message.dsb_accountID == OWLJConvertToolShared.xyf_userAccountID];
    if (message.dsb_isPrivilegeUser) {
        if (OWLMusicInsideManagerShared.xyp_isShowNewEnterEffect) { return; }
        [[OWLPPAddAlertTool shareInstance] xyf_addJoinRoomSvgTo:self.xyp_targetView andAvatar:message.dsb_avatar andName:message.dsb_nickname];
    }
}

/// 4.送礼
- (void)xyf_dealMessageSendGift:(OWLMusicMessageModel *)message {
    /// 插消息
    [[OWLPPAddAlertTool shareInstance] xyf_showOneBarrageEffectWith:message andImmediatelyMsg:NO];
    /// 礼物弹幕
    [[OWLPPAddAlertTool shareInstance] xyf_showSendGiftEffectWith:message];
    /// 动画模型
    OWLMusicGiftInfoModel *model = [OWLJConvertToolShared xyf_getGiftModel:message.dsb_giftID];
    /// 礼物全屏特效
    [self.xyp_controlView xyf_receiveGiftMessage:model];
    /// 展示喷泉动画
    [self xyf_showGiftComboAnimation:model message:message];
}

/// 7.刷新房间信息
- (void)xyf_dealUpdateRoomInfo:(OWLMusicMessageModel *)message {
    if (message.dsb_text.length == 0) { return; }
    OWLMusicRoomDetailModel *model = [[OWLMusicRoomDetailModel alloc] initWithDictionary:[message.dsb_text mj_JSONObject]];
    if (model.dsb_ownerAccountID != self.xyp_currentTotalModel.xyp_tempModel.xyp_anchorID) { return; }
    /// 收到的最新的房间消息是已结束PK
    if (self.xyp_currentDetailModel.xyf_isPKState && !model.dsb_pkData) {
        /// 清空PK视图
        [self xyf_clearPKView];
    }
    /// 更新房间列表
    [self xyf_refreshAllMemberList:model.dsb_memberList];
    /// 更新房间状态
    [self xyf_updateRoomStatus:model.dsb_roomState];
}

/// 8.用户带走主播
- (void)xyf_dealMessageUserTakeAnchor:(OWLMusicMessageModel *)message {
    /// 如果是自己带走的 不处理以下逻辑
    if (message.dsb_accountID == OWLJConvertToolShared.xyf_userAccountID) { return; }
    /// 如果是绿号 也不显示动画
    if (OWLJConvertToolShared.xyf_isGreen) {
        /// 更新房间状态
        [self xyf_updateRoomStatus:XYLModuleRoomStateType_PrivateChat];
        return;
    }
    
    OWLPPPairShowView *view = [[OWLPPPairShowView alloc] init];
    [self.xyp_targetView addSubview:view];
    [view xyf_preparePlaySvgWithAncAvatar:[self xyp_currentDetailModel].dsb_ownerAvatar andUAvatar:message.dsb_avatar andAncName:[self xyp_currentDetailModel].dsb_ownerNickname andUName:message.dsb_nickname andIsMine:NO];
    kXYLWeakSelf
    view.xyp_playEndPair = ^{
        /// 关闭私聊按钮
        weakSelf.xyp_currentTotalModel.xyp_detailModel.dsb_privateChatState = XYLModulePrivateChatStatusType_Close;
        [weakSelf xyf_updatePrivateChatUI:XYLModulePrivateChatStatusType_Close];
        /// 弹更多主播弹窗
        [weakSelf xyf_showMoreAlertViewWhenTakeAnchor];
        
    };
    
    /// 更新房间状态
    [self xyf_updateRoomStatus:XYLModuleRoomStateType_PrivateChat];
}

/// 9.PK配对成功
- (void)xyf_dealMessageMatchPKSuccess:(OWLMusicMessageModel *)message {
    OWLMusicRoomPKDataModel *model = [[OWLMusicRoomPKDataModel alloc] initWithDictionary:[message.dsb_text mj_JSONObject]];
    /// 拉对面的流
    [self.xyp_agoreManager xyf_startOtherRemoteViewAndChangeSize:model];
    if (self.xyp_dataManager.xyp_currentModel.xyp_tempModel.xyp_anchorID == model.dsb_ownerPlayer.dsb_accountID) {
        [self xyf_refreshPKDataAndUI:model];
        [self xyf_dealEventWithType:XYLModuleEventType_PKMatchSuccess obj:model];
    }
    [self xyf_updatePrivateChatUI:XYLModulePrivateChatStatusType_Close];
    [self xyf_dealEventWithType:XYLModuleEventType_UpdateRandomTableIsShow obj:@(NO)];
}

/// 10.PK结束
- (void)xyf_dealMessageFinishPK {
    /// 时间大于0 说明时间还没到 是自己主播跑了
    if (self.xyp_currentTotalModel.xyp_detailModel.dsb_pkData.dsb_leftTime > 0) {
        if (OWLJConvertToolShared.xyf_isGreen || self.xyp_currentTotalModel.xyp_detailModel.dsb_isUGCRoom) {
            [OWLJConvertToolShared xyf_showNotiTip:[XYCStringTool xyf_userQuitPKWithIsOther:NO]];
        } else {
            [OWLJConvertToolShared xyf_showNotiTip:[XYCStringTool xyf_hostQuitPKWithIsOther:NO]];
        }
    }
    /// 清空PK视图
    [self xyf_clearPKView];
}

/// 11.PK分数更新 （1.刷新分数 2.刷新前三头像）
- (void)xyf_dealMessageUpdatePKGoals:(OWLMusicMessageModel *)message {
    OWLMusicRoomPKDataModel *currentPKData = [self xyp_currentDetailModel].dsb_pkData;
    OWLMusicRoomPKDataModel *updatePKData = [[OWLMusicRoomPKDataModel alloc] initWithDictionary:[message.dsb_text mj_JSONObject]];
    currentPKData.dsb_ownerPoint = updatePKData.dsb_ownerPoint;
    currentPKData.dsb_otherPoint = updatePKData.dsb_otherPoint;
    [self xyf_refreshPKDataAndUI:currentPKData];
}

/// 12.PK时间到 携带pkwinner（1.刷新胜利失败图标 2.刷新连胜次数 3.停止PK计时并刷新为惩罚或打平状态 4.插版聊消息）
- (void)xyf_dealMessagePKTimeUp:(OWLMusicMessageModel *)message {
    OWLMusicRoomPKWinnerModel *model = [[OWLMusicRoomPKWinnerModel alloc] initWithDictionary:[message.dsb_text mj_JSONObject]];
    OWLMusicRoomPKDataModel *currentPKData = [self xyp_currentDetailModel].dsb_pkData;
    currentPKData.dsb_leftTime = 0;
    currentPKData.dsb_winAnchorData = model;
    if (model.dsb_accountID == currentPKData.dsb_ownerPlayer.dsb_accountID) { /// 自己主播赢了
        currentPKData.dsb_ownerPlayer.dsb_wins = model.dsb_winTime;
        currentPKData.dsb_otherPlayer.dsb_wins = 0;
    } else if (model.dsb_accountID == 0) { /// 平局
        
    } else { /// 对方主播赢了
        currentPKData.dsb_otherPlayer.dsb_wins = model.dsb_winTime;
        currentPKData.dsb_ownerPlayer.dsb_wins = 0;
    }
    
    /// 刷新数据
    self.xyp_currentDetailModel.dsb_pkData = currentPKData;
    
    /// 触发事件：PK倒计时结束
    [self xyf_dealEventWithType:XYLModuleEventType_PKTimeEnd obj:currentPKData];
    
    [[OWLPPAddAlertTool shareInstance] xyf_showOneBarrageEffectWith:[OWLMusicMessageModel xyf_pkEndTipMsg] andImmediatelyMsg:YES];
}

/// 13.PK再来一次（显示对应主播的准备图标）
- (void)xyf_dealMessagePKAgain:(OWLMusicMessageModel *)message {
    NSInteger accountID = [message.dsb_text integerValue];
    OWLMusicRoomPKDataModel *data = [self xyp_currentDetailModel].dsb_pkData;
    if (data.dsb_ownerPlayer.dsb_accountID == accountID) {
        data.dsb_ownerPlayer.dsb_roomStatus = XYLModuleRoomStateType_WaitNextPKing;
    } else if (data.dsb_otherPlayer.dsb_accountID == accountID) {
        data.dsb_otherPlayer.dsb_roomStatus = XYLModuleRoomStateType_WaitNextPKing;
    }
    [self xyf_refreshPKDataAndUI:data];
}

/// 14.PK逃跑
- (void)xyf_dealMessagePKRunAway {
    /// 清空PK视图
    [self xyf_clearPKView];
    
    /// 提示
    if (OWLJConvertToolShared.xyf_isGreen || self.xyp_currentTotalModel.xyp_isUGCRoom) {
        [OWLJConvertToolShared xyf_showNotiTip:[XYCStringTool xyf_userQuitPKWithIsOther:YES]];
    } else {
        [OWLJConvertToolShared xyf_showNotiTip:[XYCStringTool xyf_hostQuitPKWithIsOther:YES]];
    }
}

/// 15.私聊按钮开关
- (void)xyf_dealMessagePrivateOpenState:(OWLMusicMessageModel *)message {
    OWLMusicPrivateChatMsg *privateModel = [[OWLMusicPrivateChatMsg alloc] initWithDictionary:[message.dsb_text mj_JSONObject]];
    if (privateModel.dsb_roomID == [self xyf_currentRoomID]) {
        self.xyp_currentTotalModel.xyp_detailModel.dsb_privateChatState = privateModel.dsb_privateState;
        [self xyf_updatePrivateChatUI:privateModel.dsb_privateState];
    }
}

/// 16.刷新观众列表
- (void)xyf_dealMessageUpdateMemberList:(OWLMusicMessageModel *)message {
    NSObject *obj = [[message.dsb_text mj_JSONData] mj_JSONObject];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *arr = [OWLMusicMemberModel mj_objectArrayWithKeyValuesArray:obj];
        [self xyf_refreshAllMemberList:arr];
    }
}

/// 18.通知更新转盘信息以及转盘结果
- (void)xyf_dealMessageTurntableInfo:(OWLMusicMessageModel *)message {
    OWLMusicRandomTableMsgModel *tableModel = [[OWLMusicRandomTableMsgModel alloc] initWithDictionary:[message.dsb_text mj_JSONObject]];
    OWLMusicRoomDetailModel *currentModel = self.xyp_currentTotalModel.xyp_detailModel;
    currentModel.dsb_circlePanState = tableModel.dsb_turnTableIsOpen;
    currentModel.dsb_circlePanTitle = tableModel.dsb_turnTableTitle;
    currentModel.dsb_circlePanItems = tableModel.dsb_turnTableInfoList;
    
    [self xyf_dealEventWithType:XYLModuleEventType_UpdateRandomTable obj:tableModel];
}

/// 19.禁言列表
- (void)xyf_dealMessageMutedMembersInfo:(OWLMusicMessageModel *)message {
    NSObject *obj = [[message.dsb_text mj_JSONData] mj_JSONObject];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *list = (NSArray *)obj;
        BOOL isMute = [list containsObject:@(OWLJConvertToolShared.xyf_userAccountID)];
        if (self.xyp_userIsMute != isMute) {
            [OWLJConvertToolShared xyf_showNotiTip:[XYCStringTool xyf_userMute:isMute]];
        }
        self.xyp_userIsMute = isMute;
    }
}

#pragma mark - 给回调
- (void)xyf_giveCallBackReloadList {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_totalManagerRefreshRoomList)]) {
        [self.delegate xyf_totalManagerRefreshRoomList];
    }
}

- (void)xyf_giveCallBackOperateData:(NSInteger)index isDelete:(BOOL)isDelete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_totalManagerOperateData:isDelete:)]) {
        [self.delegate xyf_totalManagerOperateData:index isDelete:isDelete];
    }
}

- (void)xyf_giveCallBackEnterOtherRoom:(BOOL)isAlreadyHasRoom fromWay:(XYLOutDataSourceEnterRoomType)fromWay {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_totalManagerEnterOtherRoom:fromWay:)]) {
        [self.delegate xyf_totalManagerEnterOtherRoom:isAlreadyHasRoom fromWay:fromWay];
    }
}

- (void)xyf_giveCallBackShowGuideView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_totalManagerShowGuideView)]) {
        [self.delegate xyf_totalManagerShowGuideView];
    }
}

- (void)xyf_giveCallBackChangePopGes:(BOOL)isEnable {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_totalManagerChangePopGesture:)]) {
        [self.delegate xyf_totalManagerChangePopGesture:isEnable];
    }
}

- (void)xyf_giveCallBackUpdateAnchorID:(NSInteger)anchorID {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_totalManagerUpdateCurrentHostID:)]) {
        [self.delegate xyf_totalManagerUpdateCurrentHostID:anchorID];
    }
}

#pragma mark - Getter
/// 当前房间列表
- (NSMutableArray *)xyp_dataSourceRoomList {
    return self.xyp_dataManager.xyp_currentRoomList;
}

/// 当前房间总模型
- (OWLMusicRoomTotalModel *)xyp_currentTotalModel {
    return self.xyp_dataManager.xyp_currentModel;
}

/// 当前房间详情模型
- (OWLMusicRoomDetailModel *)xyp_currentDetailModel {
    return self.xyp_currentTotalModel.xyp_detailModel;
}

/// 当前房间下标
- (NSInteger)xyp_currentIndex {
    return self.xyp_dataManager.xyp_currentIndex;
}

/// 当前房间ID
- (NSInteger)xyf_currentRoomID {
    return self.xyp_currentTotalModel.xyf_getRoomID;
}

#pragma mark - Lazy
- (OWLMusicSubViewClickManager *)xyp_clickManager {
    if (!_xyp_clickManager) {
        _xyp_clickManager = [[OWLMusicSubViewClickManager alloc] init];
        _xyp_clickManager.dataSource = self;
        _xyp_clickManager.delegate = self;
    }
    return _xyp_clickManager;
}

- (OWLMusicDataSourceManager *)xyp_dataManager {
    if (!_xyp_dataManager) {
        _xyp_dataManager = [[OWLMusicDataSourceManager alloc] init];
        _xyp_dataManager.delegate = self;
        _xyp_dataManager.dataSource = self;
    }
    return _xyp_dataManager;
}

- (OWLMusicAgoraManager *)xyp_agoreManager {
    if (!_xyp_agoreManager) {
        _xyp_agoreManager = [[OWLMusicAgoraManager alloc] init];
        _xyp_agoreManager.delegate = self;
        _xyp_agoreManager.dataSource = self;
    }
    return _xyp_agoreManager;
}

- (NSMutableArray *)xyp_memberList {
    if (!_xyp_memberList) {
        _xyp_memberList = [[NSMutableArray alloc] init];
    }
    return _xyp_memberList;
}

@end
