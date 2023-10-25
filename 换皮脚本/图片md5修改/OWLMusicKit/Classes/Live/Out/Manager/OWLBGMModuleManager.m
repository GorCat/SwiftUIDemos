//
//  OWLBGMModuleManager.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间单例类
 * @创建时间：2023.2.9
 * @创建人：许琰
 */

#import "OWLBGMModuleManager.h"
#import "OWLBGMModuleVC.h"
#import "XYCModulePushMessageModel.h"
#import "OWLMusicInsideManager.h"
#import "OWLMusciCompressionTool.h"
#import "OWLMusicFloatWindow.h"
#import "OWLPPAddAlertTool.h"
#import "OWLMusicFirstRechargeAlertView.h"
#import "OWLMusicDownloadManager.h"

@interface OWLBGMModuleManager ()

@property (nonatomic, strong) AgoraRtmChannel *xyp_rtmChannel;

@end

@implementation OWLBGMModuleManager

#pragma mark - 单例
+ (instancetype)shareInstance {
    static OWLBGMModuleManager *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

#pragma mark - 外部接口
/// 进入房间
/// 外部**不需要“是否进入同一个房间”的判断**.
/// 进入直播间之前，需要在外部判断是否在语聊房的boss位上，如果**在boss位就不能跳转到直播间内部**。
/// - Parameters:
///   - roomID: 房间ID（没有 就传0）
///   - agoraRoomId: 声网ID(没有 就传空字符串)
///   - anchorID: 主播ID（必传！）
///   - isUGCRoom: 是否是UGC房间
///   - fromWay: 进入直播间的路径
///   - pushAnimation: 这个回调需外部自行pushVC
- (void)xyf_enterRoomWithRoomID:(NSInteger)roomID
                    agoraRoomId:(NSString *)agoraRoomId
                       anchorID:(NSInteger)anchorID
                      isUGCRoom:(BOOL)isUGCRoom
                        fromWay:(XYLOutDataSourceEnterRoomType)fromWay
                  pushAnimation:(void(^)(UIViewController *vc))pushAnimation {
    [OWLMusicDownloadManager sharedInstance];
    OWLMusicEnterConfigModel *configModel = [OWLMusicEnterConfigModel new];
    configModel.xyp_roomId = roomID;
    configModel.xyp_agoraRoomId = agoraRoomId;
    configModel.xyp_anchorID = anchorID;
    configModel.xyp_isUGCRoom = isUGCRoom;
    configModel.xyp_fromWay = fromWay;
    [self xyf_enterRoomWithEnterConfig:configModel pushAnimation:pushAnimation];
}

/// 更新用户金币
- (void)xyf_updateUserCoins:(NSInteger)coins {
    [self xyf_postNotification:xyl_user_update_coins withObject:@(coins)];
}

/// 关注用户（在以下情况调这个方法）
/// 1.关注接口调成功的时候  isFollow传改变之后的状态
/// 2.关注接口调失败 并且 错误码为-53（用户已关注主播）isFollow传YES。其余的接口失败的情况不调这个方法
- (void)xyf_followAnchor:(NSInteger)anchorID isFollow:(BOOL)isFollow {
    NSDictionary *dic = @{ kXYLNotificationAccountIDKey : @(anchorID), kXYLNotificationFollowStateKey : @(isFollow) };
    [self xyf_postNotification:xyl_user_operate_follow_anchor withObject:dic];
}

/// 拉黑用户（在以下情况调这个方法）
/// 1.接口成功 isBlock传改变之后的状态
/// 2.接口失败： ①code = -9(该账号已在黑名单) isBlock 传YES
///           ②code = -10(该账号不在黑名单)isBlock 传NO
- (void)xyf_blockAnchor:(NSInteger)anchorID isBlock:(BOOL)isBlock {
    /// 更新拉黑状态
    NSDictionary *blockDic = @{ kXYLNotificationAccountIDKey : @(anchorID), kXYLNotificationBlockStateKey : @(isBlock) };
    [self xyf_postNotification:xyl_user_operate_block_anchor withObject:blockDic];
    
    /// 如果拉黑了主播 需要吧关注变成NO
    if (isBlock) {
        NSDictionary *followDic = @{ kXYLNotificationAccountIDKey : @(anchorID), kXYLNotificationFollowStateKey : @(NO) };
        [self xyf_postNotification:xyl_user_operate_follow_anchor withObject:followDic];
    }
}

/// 关闭房间（强制退出方法：在挤号、异常、删号、退出登录、hunting、打电话、进入语聊房，等场景之前调用）
- (void)xyf_closeLiveModule {
    [OWLMusicInsideManagerShared xyf_insideCloseLivePage:!OWLMusicFloatWindowShared.xyp_isShowing];
}

/// 最小化或者关闭房间（当跳转到下一个页面的之前 先调用这个方法 切到最小化之后再跳转）
- (void)xyf_closeOrFloatLive {
    [OWLMusicInsideManagerShared xyf_insideCloseOrFloatWindow];
}

/// 成功购买vip（成功购买vip的时候 调这个方法用于刷新礼物列表。 注：外部不需要判断是否在直播间内，内部会判断）
- (void)xyf_successBuySvip {
    [[OWLPPAddAlertTool shareInstance] xyf_refreshGiftViewAfterBuy];
    [self xyf_postNotification:xyl_module_buy_svip_success];
}

/// 隐藏小窗（在小窗模式下 逛其他页面 有时候需要隐藏小窗，离开这个页面之后 再显示。比如 视频详情页面之类的）
/// 开关声音的逻辑需要在外面处理，外部不需要判断是否在直播间中，内部会判断
- (void)xyf_changeFloatState:(BOOL)isHidden {
    if (OWLMusicFloatWindowShared.xyp_isShowing) {
        OWLMusicFloatWindowShared.hidden = isHidden;
    }
}

/// 充钱成功 反正就是用户花了真💰的地方。（先更新本地金币、svip状态之后，然后再调这个方法）
/// 1.内购验证小票接口调成功
/// 2.购买svip成功
/// 3.rtm加币消息（注：改消息有两种情况-后台加币/third充值。只需要在充值的时候掉这个方法，外部判断一下productID.length > 0，再调这个方法）
- (void)xyf_rechargeSuccess {
    OWLMusicInsideManagerShared.xyp_hasRechargeInThisLife = YES;
    [self xyf_postNotification:xyl_module_recharge_success];
}

/// 成功购买铁粉(本地改完标签信息之后再调用)
/// - Parameters:
///   - stanLabel: 铁粉标签
///   - anchorID: 主播ID
- (void)xyf_successBuyFan:(OWLMusicEventLabelModel *)stanLabel anchorID:(NSInteger)anchorID {
    if (!stanLabel) { return; }
    NSDictionary *stanDic = [stanLabel mj_JSONObject];
    NSDictionary *notificationDic = @{ kXYLNotificationAccountIDKey : @(anchorID),
                                       kXYLNotificationFanInfoKey : stanDic };
    [self xyf_postNotification:xyl_module_buy_fan_success withObject:notificationDic];
}

/// 弹出0.99充值优惠弹窗
/// 调用时机：每次打开app，第一次从内购页面返回时调用。（是否充值过的逻辑在sdk内部会判断）
/// 前提：必须在一进入主包就初始化OWLBGMModuleManager这个类 并设置代理。不然就自己写弹窗→_→
/// - Parameters:
///   - targetView: 父视图
///   - bgColor: 背景蒙版颜色（主包有需要的自己加，不需要的穿nil）
- (void)xyf_show099RechargeView:(UIView *)targetView
                        bgColor:(nullable UIColor *)bgColor {
    /// 如果充值过 就不弹弹窗
    if (OWLMusicInsideManagerShared.xyf_hasRecharge) {
        return;
    }

    NSMutableArray *arr = OWLJConvertToolShared.xyf_discountList;
    OWLMusicProductModel *model = [arr xyf_objectAtIndexSafe:0];
    if (!model) { return; }
    OWLMusicInsideManagerShared.xyp_isRTL = [self.dataSource xyf_getOutBoolTypeInfo:XYLOutDataSourceBoolInfoType_isRTL];
    OWLMusicInsideManagerShared.xyp_currentLanguage = [self.dataSource xyf_getOutTextTypeInfo:XYLOutDataSourceTextInfoType_CurrentLanguage];
    [OWLMusicFirstRechargeAlertView xyf_showDiscountAlertView:targetView bgColor:bgColor productModel:model dismissBlock:^{
        
    }];
    
}

#pragma mark - 解压资源（在进入主包的时候就调这个方法 谢谢！）
/// 加载资源
- (void)xyf_compressionResources {
    [OWLMusciCompressionTool xyf_compressionResources];
}

#pragma mark - 外部推送处理
/// 处理外部的推送消息（在SSE推送 及 RTM的messageReceived回调中处理 传一整个字典）
- (void)xyf_handlePushData:(NSDictionary *)dic {
    XYCModulePushMessageModel *model = [[XYCModulePushMessageModel alloc] initWithDictionary:dic];
    switch (model.xyp_opCode) {
        case 3:
            [OWLMusicInsideManagerShared xyf_insideHandleOpcode3Data:model];
            break;
        default:
            break;
    }
}

#pragma mark - 游戏相关(和语聊房联动，在语聊房的delegate/datasource中调用)
/// 获取当前直播间游戏信息（语聊房delegate中调用）
- (NSDictionary *)xyf_getCurrentGameInfo {
    if (OWLMusicInsideManagerShared.xyp_gamePopView.game) {
        return [OWLMusicInsideManagerShared.xyp_gamePopView.game mj_JSONObject];
    } else {
        return nil;
    }
}

/// 关闭直播间游戏悬浮窗（删号、退出登录、挤号、封号等 也要调用该方法 关闭游戏悬浮窗）
- (void)xyf_closeGameSmallView {
    if (OWLMusicInsideManagerShared.xyp_gamePopView) {
        [OWLMusicInsideManagerShared.xyp_gamePopView xyf_close];
    }
}

/// 打开直播间游戏页面
- (void)xyf_showGamePlayView {
    if (OWLMusicInsideManagerShared.xyp_gamePopView) {
        [OWLMusicInsideManagerShared.xyp_gamePopView xyf_big];
    }
}

#pragma mark - 悬浮窗/画中画相关(在主包的设置中调用)
/// 切换应用内悬浮窗开关
- (void)xyf_changeWindowInAppIsOpen:(BOOL)isOpen {
    [OWLJConvertToolShared xyf_changeInAppWindowState:isOpen isSDKChange:NO];
    [self xyf_postNotification:xyl_module_update_window_inapp_isOpen withObject:@(isOpen)];
}

/// 切换应用外画中画开关
- (void)xyf_changeWindowOutAppIsOpen:(BOOL)isOpen {
    [OWLJConvertToolShared xyf_changeOutAppWindowState:isOpen isSDKChange:NO];
    [self xyf_postNotification:xyl_module_update_window_outapp_isOpen withObject:@(isOpen)];
}

#pragma mark - 1金币转盘AB测试相关
/// 用户成功转1金币转盘
/// 调用时机：用户转1金币转盘转成功（主包的所有1金币转盘转成功都要调这个方法）
/// 调用前提：需要将XYLOutDataSourceBoolInfoType_hasOpenOneCoinSuccess对应存的值改成Yes（改成已成功转过）
/// 调用结果：直播间内部会将转盘的入口隐藏。
- (void)xyf_successOpenOneCoinTurntable {
    [self xyf_postNotification:xyl_module_success_open_onecoin_turntable];
}

#pragma mark - Getter
- (BOOL)xyp_isInLiveModule {
    return OWLMusicInsideManagerShared.xyp_vc != nil;
}

- (BOOL)xyp_isFloatState {
    return self.xyp_isInLiveModule ? OWLMusicFloatWindowShared.xyp_isShowing : NO;
}

- (BOOL)xyp_isTakingAnchor {
    return self.xyp_isInLiveModule ? OWLMusicInsideManagerShared.xyp_isTakingAnchor : NO;
}

- (NSMutableDictionary *)xyf_liveBasicTongjiDic {
    if (OWLMusicInsideManagerShared.xyp_vc.xyp_currentTotalModel) {
        return [OWLMusicTongJiTool xyf_addBasicInfo];
    } else {
        return nil;
    }
}

#pragma mark - Private
- (void)xyf_enterRoomWithEnterConfig:(OWLMusicEnterConfigModel *)config
                       pushAnimation:(void(^)(UIViewController *vc))pushAnimation {
    /// 如果当前持有直播VC
    if (OWLMusicInsideManagerShared.xyp_vc) {
        if (OWLMusicInsideManagerShared.xyp_vc.xyp_compairCurrentHostID == config.xyp_anchorID) {
            /// 如果在小窗模式就push，如果当前vc就是这个主播，就不跳转
            if (OWLMusicFloatWindowShared.xyp_isShowing) {
                [OWLMusicFloatWindowShared xyf_resetFloatingView];
                if (pushAnimation) {
                    pushAnimation(OWLMusicInsideManagerShared.xyp_vc);
                }
            }
            return;
        } else {
            /// 退出上一个页面
            [OWLMusicInsideManagerShared xyf_insideCloseLivePage:!OWLMusicFloatWindowShared.xyp_isShowing];
        }
    }
    
    OWLBGMModuleVC *vc = [[OWLBGMModuleVC alloc] initWithAnchorID:config.xyp_anchorID];
    vc.xyp_configModel = config;
    vc.hidesBottomBarWhenPushed = YES;
    OWLMusicInsideManagerShared.xyp_vc = vc;
    OWLMusicInsideManagerShared.xyp_isNeedRefreshHomeList = NO;
    OWLMusicInsideManagerShared.xyp_isRTL = [self.dataSource xyf_getOutBoolTypeInfo:XYLOutDataSourceBoolInfoType_isRTL];
    OWLMusicInsideManagerShared.xyp_currentLanguage = [self.dataSource xyf_getOutTextTypeInfo:XYLOutDataSourceTextInfoType_CurrentLanguage];
    OWLMusicInsideManagerShared.xyp_isShowNewEnterEffect = [self.dataSource xyf_getOutBoolTypeInfo:XYLOutDataSourceBoolInfoType_isShowEntryEffect];
    OWLMusicInsideManagerShared.xyp_isTakingAnchor = NO;
    OWLMusicInsideManagerShared.xyp_useMainSVGPath = [OWLJConvertToolShared xyf_isUseMainSVGPath];
    OWLMusicInsideManagerShared.xyp_bottomManager = [[OWLMusicBottomFunctionManager alloc] init];
    OWLMusicInsideManagerShared.xyp_hasPIPFunc = [OWLJConvertToolShared xyf_hasPIPFunction];
    OWLMusicInsideManagerShared.xyp_isOpenWindowInApp = [OWLJConvertToolShared xyf_isOpenWindowInApp];
    OWLMusicInsideManagerShared.xyp_isOpenWindowOutApp = [OWLJConvertToolShared xyf_isOpenWindowOutApp];
    
    if (pushAnimation) {
        pushAnimation(vc);
    }
}

@end
