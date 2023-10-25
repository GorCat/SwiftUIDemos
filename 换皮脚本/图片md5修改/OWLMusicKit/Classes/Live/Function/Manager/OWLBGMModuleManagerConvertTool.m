//
//  OWLBGMModuleManagerConvertTool.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间工具类
 * @创建时间：2023.2.9
 * @创建人：许琰
 * @备注：直播间单例类OWLBGMModuleManager 的数据源和代理方法的转换类。在内部就不直接使用delegate和dataSource调方法
 */

#import "OWLBGMModuleManagerConvertTool.h"
#import "OWLMusicBroadcastManager.h"
#import "OWLMusicFloatWindow.h"
#import "OWLBGMModuleVC.h"

@implementation OWLBGMModuleManagerConvertTool

#pragma mark - 单例
+ (instancetype)shareInstance {
    static OWLBGMModuleManagerConvertTool *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

#pragma mark - Getter
#pragma mark 用户信息
/// 用户sesstion
- (NSString *)xyf_userSession {
    return [self xyf_getTextInfo:XYLOutDataSourceTextInfoType_Session];
}

/// 用户ID
- (NSInteger)xyf_userAccountID {
    return [self xyf_getNumInfo:XYLOutDataSourceNumInfoType_AccountID];
}

/// 用户昵称
- (NSString *)xyf_userName {
    return [self xyf_getTextInfo:XYLOutDataSourceTextInfoType_Nickname];
}

/// 用户头像
- (NSString *)xyf_userAvatar {
    return [self xyf_getTextInfo:XYLOutDataSourceTextInfoType_Avatar];
}

/// 用户充值总额
- (float)xyf_userTotalRecharge {
    return [self xyf_getFloatInfo:XYLOutDataSourceFloatInfoType_RechargeAmount];
}

/// 用户余额
- (NSInteger)xyf_userCoins {
    return [self xyf_getNumInfo:XYLOutDataSourceNumInfoType_Coins];
}

/// 用户是否是Svip
- (BOOL)xyf_userIsSvip {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isSVIP];
}

/// 用户是否是特权用户（消息内用）
- (BOOL)xyf_userIsPrivilege {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isPrivilege];
}

/// 用户整体信息
- (NSDictionary *)xyf_userAccountDic {
    return [self xyf_getDicInfo:XYLOutDataSourceDicInfoType_AccountInfo];
}

#pragma mark 配置信息
/// 标签标题
- (NSString *)xyf_configTagTitle {
    return [self xyf_getTextInfo:XYLOutDataSourceTextInfoType_TagTitle];
}

/// 标签URL
- (NSString *)xyf_configTagUrl {
    return [self xyf_getTextInfo:XYLOutDataSourceTextInfoType_TagUrl];
}

/// 标签高度
- (NSInteger)xyf_configTagHeight {
    return [self xyf_getNumInfo:XYLOutDataSourceNumInfoType_TagHeight];
}

/// 标签宽度
- (NSInteger)xyf_configTagWidth {
    return [self xyf_getNumInfo:XYLOutDataSourceNumInfoType_TagWidth];
}

/// PK比分URL
- (NSString *)xyf_pkFlagURL {
    return [self xyf_getTextInfo:XYLOutDataSourceTextInfoType_PKFlagUrl];
}

/// banner信息
- (OWLMusicBannerInfoModel *)xyf_configBannerInfo {
    NSDictionary *dic = [self xyf_getDicInfo:XYLOutDataSourceDicInfoType_BannerList];
    OWLMusicBannerInfoModel *model = [[OWLMusicBannerInfoModel alloc] initWithDictionary:dic];
    return model;
}

/// 直播间礼物信息
- (OWLMusicGiftListModel *)xyf_configGiftList {
    NSDictionary *dic = [self xyf_getDicInfo:XYLOutDataSourceDicInfoType_GiftList];
    OWLMusicGiftListModel *model = [[OWLMusicGiftListModel alloc] initWithDictionary:dic];
    return model;
}

/// 当前语聊房游戏模型
- (OWLMusicGameConfigModel *)xyf_chatCurrentGameModel {
    NSDictionary *dic = [self xyf_getDicInfo:XYLOutDataSourceDicInfoType_CurrentGameInfo];
    return [OWLMusicGameConfigModel mj_objectWithKeyValues:dic];
}

/// 获取内购模型
- (OWLMusicPayModel *)xyf_getPayConfigModel {
    NSArray *array = [self xyf_getOutArrayTypeInfo:XYLOutDataSourceArrayInfoType_PayConfigs];
    NSArray *arr = [OWLMusicPayModel mj_objectArrayWithKeyValuesArray:array];
    OWLMusicPayModel *payModel;
    for (OWLMusicPayModel *model in arr) {
        if (model.dsb_payType == 1) {
            payModel = model;
            break;
        }
    }
    return payModel;
}

/// 获取铁粉内购项模型
- (OWLMusicProductModel *)xyf_getFanProductModel {
    OWLMusicPayModel *payModel = [self xyf_getPayConfigModel];
    OWLMusicProductModel *fanModel;
    if (!payModel || payModel.dsb_products.count <= 0) {
        return fanModel;
    }
    for (OWLMusicProductModel *productModel in payModel.dsb_products) {
        if (productModel.dsb_productType == XYLProductType_FanClub) {
            fanModel = productModel;
            break;
        }
    }
    return fanModel;
}

/// 获取未购买过的内购折扣数组
- (NSMutableArray *)xyf_discountList {
    OWLMusicPayModel *payModel = [self xyf_getPayConfigModel];
    NSMutableArray *discountList = [[NSMutableArray alloc] init];
    if (!payModel || payModel.dsb_products.count <= 0) {
        return discountList;
    }
    
    for (OWLMusicProductModel *productModel in payModel.dsb_products) {
        if (productModel.dsb_productType == XYLProductType_DiscountConsume && !productModel.dsb_isBought) {
            [discountList xyf_addObjectIfNotNil:productModel];
        }
    }
    
    if (discountList.count > 0) {
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dsb_oriPriceUSD" ascending:YES];
        [discountList sortUsingDescriptors:@[descriptor]];
    }
    
    return discountList;
}

/// 是否关闭广播
- (BOOL)xyf_isCloseBroadcast {
    if (OWLJConvertToolShared.xyf_isGreen) {
        return YES;
    }
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isCloseBroadcast];
}

/// 是否显示转盘
- (BOOL)xyf_isShowRandomTable {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isOpenTurntable];
}

/// 是否开启铁粉功能
- (BOOL)xyf_isOpenFanClub {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isOpenFanClub];
}

/// 是否使用主包的svg路径
- (BOOL)xyf_isUseMainSVGPath {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isUseMainSVGPath];
}

/// 主包的PAG路径
- (NSString *)xyf_getSVGPath:(NSString *)url {
    if (OWLBGMModuleManagerShared.dataSource && [OWLBGMModuleManagerShared.dataSource respondsToSelector:@selector(xyf_getSVGPathWithUrl:)]) {
        return [OWLBGMModuleManagerShared.dataSource xyf_getSVGPathWithUrl:url];
    } else {
        return @"";
    }
}

/// 是否是一金币实验组
- (BOOL)xyf_isOneCoinTest {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_hasOneCoinTest];
}

/// 是否在房间中弹过一金币转盘
- (BOOL)xyf_hasShowOneCoinInRoom {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_hasAutoShowOneCoin];
}

/// 是否成功转过一金币转盘
- (BOOL)xyf_hasSuccessPlayOneCoin {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_hasOpenOneCoinSuccess];
}

/// 是否需要展示1金币转盘
- (BOOL)xyf_isNeedShowOneCoin {
    /// 是实验组 && 没有成功转过
    return self.xyf_isOneCoinTest && !self.xyf_hasSuccessPlayOneCoin;
}

/// 1金币实验转盘弹出时间配置
- (NSInteger)xyf_oneCoinPromptTime {
    return [self xyf_getNumInfo:XYLOutDataSourceNumInfoType_TurntablePromptTime];
}

#pragma mark RTC/RTM
/// RTC实例
- (AgoraRtcEngineKit *)xyf_rtcKit {
    return [self xyf_getRTCKit];
}

/// RTM实例
- (AgoraRtmKit *)xyf_rtmKit {
    return [self xyf_getRTMKit];
}

#pragma mark - 其他信息
/// 头像占位图
- (UIImage *)xyf_userPlaceHolder {
    return [self xyf_userAvatarPlaceHolderImage];
}

/// 当前是否是无网络状态
- (BOOL)xyf_noNetwork {
    return [OWLBGMModuleManagerShared.dataSource xyf_getOutNetworkState] == XYLOutDataSourceNetworkStateType_NoConnection;
}

/// SSE状态
- (NSInteger)xyf_sseStatus {
    return [OWLBGMModuleManagerShared.dataSource xyf_sseStatus];
}

/// 获取当前窗口
- (UIWindow *)xyf_keyWindow {
    // 徐老师说 这个肯定不会取空
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.keyWindow == YES){
            keyWindow = window;
        }
    }
    return keyWindow;
}

/// 获取当前VC
- (UIViewController *)xyf_getCurrentVC {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *temp in windows) {
            if (temp.windowLevel == UIWindowLevelNormal) {
                window = temp;
                break;
            }
        }
    }
    // 取当前展示的控制器
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    // 如果为UITabBarController：取选中控制器
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    // 如果为UINavigationController：取可视控制器
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
//    return [OWLBGMModuleManagerShared.dataSource xyf_outsideModuleGetCurrentVC];
}

/// 是否显示过滑动提示
- (BOOL)xyf_isShowScrollTip {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_hasShowGuideState];
}

/// 是否支持私聊功能
- (BOOL)xyf_isShowPrivateChat {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isOpenPrivateChat];
}

/// 是否是绿号
- (BOOL)xyf_isGreen {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isGreenAccount];
}

/// 是否仅有main
- (BOOL)xyf_isJustMain {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isJustMain];
}

/// 是否显示过滑动引导
- (BOOL)xyf_isShowFanGuideTip {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isShowFanGuide];
}

/// 是否为阿语
- (BOOL)xyf_isRTL {
    return OWLMusicInsideManagerShared.xyp_isRTL;
}

/// 当前语言
- (NSString *)xyf_currentLanguage {
    return OWLMusicInsideManagerShared.xyp_currentLanguage;
}

/// 获取性别类型
- (XYLOutDataSourceGenderType)xyf_getGenderType:(NSString *)genderStr {
    NSString *lowerGender = genderStr.lowercaseString;
    if ([lowerGender isEqualToString:@"female"]) {
        return XYLOutDataSourceGenderType_Female;
    } else if ([lowerGender isEqualToString:@"male"]) {
        return XYLOutDataSourceGenderType_Male;
    } else {
        if (OWLBGMModuleManagerShared.dataSource && [OWLBGMModuleManagerShared.dataSource respondsToSelector:@selector(xyf_outsideModuleGetGenderType:)]) {
            return [OWLBGMModuleManagerShared.dataSource xyf_outsideModuleGetGenderType:lowerGender];
        } else {
            return XYLOutDataSourceGenderType_Female;
        }
    }
}

/// 是否开启画中画功能（15.0以上服务端配置，15.0以下不开启画中画功能）
- (BOOL)xyf_hasPIPFunction {
    if (@available(iOS 15.0, *)) {
        return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_hasPIPFunction];
    };
    return NO;
}

/// 应用内悬浮窗开关
- (BOOL)xyf_isOpenWindowInApp {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isOpenWindowInApp];
}

/// 应用外画中画开关
- (BOOL)xyf_isOpenWindowOutApp {
    return [self xyf_getBoolInfo:XYLOutDataSourceBoolInfoType_isOpenWindowOutApp];
}

#pragma mark - 方法
/// 显示loading
- (void)xyf_showLoading {
    [self xyf_insideLoading:YES];
}

/// 隐藏loading
- (void)xyf_hideLoading {
    [self xyf_insideLoading:NO];
}

/// 显示信息提示
- (void)xyf_showNotiTip:(NSString *)tip {
    [self xyf_insideShowTip:XYLOutDataSourceTopAlertType_Notification text:tip];
}

/// 显示错误提示
- (void)xyf_showErrorTip:(NSString *)tip {
    [self xyf_insideShowTip:XYLOutDataSourceTopAlertType_Fail text:tip];
}

/// 显示成功提示
- (void)xyf_showSuccessTip:(NSString *)tip {
    [self xyf_insideShowTip:XYLOutDataSourceTopAlertType_Success text:tip];
}

/// 无网提示
- (void)xyf_showNoNetworkTip {
    [self xyf_showNotiTip:kXYLLocalString(@"Please check your network.")];
}

/// 判断是否无网（并弹无网提示）
- (BOOL)xyf_judgeNoNetworkAndShowNoNetTip {
    BOOL isNoNetwork = self.xyf_noNetwork;
    if (isNoNetwork) {
        [self xyf_showNoNetworkTip];
    }
    return isNoNetwork;
}

/// 网络层接口请求失败的错误提示
- (void)xyf_showNetworkErrowTip:(NSString *)tip {
    BOOL isNoNetwork = self.xyf_noNetwork;
    if (isNoNetwork) {
        [self xyf_showNoNetworkTip];
    } else {
        [self xyf_showErrorTip:tip];
    }
}

/// 弹充值弹窗
- (void)xyf_insideShowRechargeView:(UIView *)superView {
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleShowRechargeView:superView];
}

/// 更新金币数量
- (void)xyf_updateUserCoins:(NSInteger)coins {
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleUpdateUserLeftCoin:coins];
    [self xyf_postNotification:xyl_user_update_coins withObject:@(coins)];
}

/// 更新用户标签
- (void)xyf_updateUserLabel:(OWLMusicEventLabelModel *)label {
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleUpdateUserMedal:label];
}

/// 已经显示过滑动提示
- (void)xyf_hadShowScrollTip {
    [self xyf_changeLocalBoolState:YES type:XYLNeedChangeBoolInfoType_hasShowGuideState];
}

/// 已经显示过铁粉提示
- (void)xyf_hadShowFanTip {
    [self xyf_changeLocalBoolState:YES type:XYLNeedChangeBoolInfoType_hasShowFanGuide];
}

/// 跳转到视频私聊页面
- (void)xyf_jumpToPrivateVideoChat:(NSDictionary *)dic {
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleEnterPrivateVideoChat:dic];
}

/// 上传图片
- (void)xyf_updateImage:(UIImage *)image isNeedJH:(BOOL)isNeedJH completion:(void(^)(BOOL success, NSString *photoUrl))completion {
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleUploadImage:image isNeedJH:isNeedJH completion:completion];
}

/// 敏感词处理
- (NSString *)xyf_wordFilter:(NSString *)text {
    return [OWLBGMModuleManagerShared.delegate xyf_outsideModuleFilterWord:text];
}

/// 进入个人主页
- (void)xyf_enterUserDetailVCWithAccountID:(NSInteger)accountID
                                  nickname:(NSString *)nickname
                                    avatar:(NSString *)avatar
                                 displayID:(NSString *)displayID
                                  isAnchor:(BOOL)isAnchor {
    /// 先退出上一个页面
    [OWLMusicInsideManagerShared xyf_insideCloseOrFloatWindow];
    /// 进入个人主页
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleEventWithUserInfoType:OWLMusicEventWithUserInfoType_EnterDetailInfo accountID:accountID nickname:nickname avatar:avatar displayID:displayID isAnchor:isAnchor];
}

/// 进入私聊页面
- (void)xyf_enterSingleChatVCWithAccountID:(NSInteger)accountID
                                  nickname:(NSString *)nickname
                                    avatar:(NSString *)avatar
                                 displayID:(NSString *)displayID
                                  isAnchor:(BOOL)isAnchor {
    /// 先退出上一个页面
    [OWLMusicInsideManagerShared xyf_insideCloseOrFloatWindow];
    /// 进入私聊页面
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleEventWithUserInfoType:OWLMusicEventWithUserInfoType_EnterTextChat accountID:accountID nickname:nickname avatar:avatar displayID:displayID isAnchor:isAnchor];
}

/// 进入个人中心的充值页面
- (void)xyf_enterRechargeVC {
    /// 先退出上一个页面
    [OWLMusicInsideManagerShared xyf_insideCloseOrFloatWindow];
    /// 进入充值页面
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleEnterRechargeVC];
}

/// 根据礼物ID获取礼物
- (OWLMusicGiftInfoModel *)xyf_getGiftModel:(NSInteger)giftID {
    OWLMusicGiftInfoModel *model = nil;
    for (OWLMusicGiftInfoModel *gift in self.xyp_giftInfo.dsb_giftList) {
        if (gift.dsb_giftID == giftID) {
            model = gift;
            break;
        }
    }
    return model;
}

/// 显示禁止录屏
- (void)xyf_showNoScreenView {
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleShowNoScreenView];
}

/// 提醒充值SVIP
- (void)xyf_remindRechargeSvip {
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleRemindRechargeSVIP];
}

/// 获取进入方式字符串
- (NSString *)xyf_getEnterRoomWayStr:(XYLOutDataSourceEnterRoomType)type {
    switch (type) {
        case XYLOutDataSourceEnterRoomType_Unknown:
            return @"";
        case XYLOutDataSourceEnterRoomType_HomeList:
            return @"home-list";
        case XYLOutDataSourceEnterRoomType_Scroll:
            return @"scroll";
        case XYLOutDataSourceEnterRoomType_Detail:
            return @"detail";
        case XYLOutDataSourceEnterRoomType_Avatar:
            return @"avata";
        case XYLOutDataSourceEnterRoomType_Broadcast:
            return @"broadcast";
    }
    return @"";
}

/// 改变广播状态
- (void)xyf_changeBroadcastState:(BOOL)isClose {
    if (isClose) {
        [XYCBroadcastShared xyf_clearBannerData];
    }
    [self xyf_showNotiTip:[XYCStringTool xyf_operateBroadcast:isClose]];
    [self xyf_changeLocalBoolState:isClose type:XYLNeedChangeBoolInfoType_isCloseBroadcast];
}

/// 进入语聊房
- (void)xyf_enterChatRoom:(NSInteger)roomID {
    [OWLMusicInsideManagerShared xyf_insideCloseLivePage:!OWLMusicFloatWindowShared.xyp_isShowing];
    /// 延迟0.3秒进语聊房
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleJoinChatRoom:roomID];
    });
}

/// 关闭游戏的方法(语聊房SDK的方法)
- (void)xyf_closeChatRoomGame {
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleChatRoomCloseGame)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleChatRoomCloseGame];
    }
}

/// 打开游戏的方法(语聊房SDK的方法)
- (void)xyf_showChatRoomGame {
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleChatRoomShowGame)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleChatRoomShowGame];
    }
}

/// 统计点击游戏悬浮窗事件
- (void)xyf_tongjiGameBallClick:(NSInteger)gameID {
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleTongjiGameBallClick:)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleTongjiGameBallClick:gameID];
    }
}

/// 需要主包更新金币
- (void)xyf_needUpdateUserCoins {
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_needUpdateUserCoins)]) {
        [OWLBGMModuleManagerShared.delegate xyf_needUpdateUserCoins];
    }
}

/// 改变应用内悬浮窗开关
/// - Parameters:
///   - isOpen: 是否开启
///   - isSDKChange: 是否是SDK内部的改变
- (void)xyf_changeInAppWindowState:(BOOL)isOpen isSDKChange:(BOOL)isSDKChange {
    OWLMusicInsideManagerShared.xyp_isOpenWindowInApp = isOpen;
    if (isSDKChange) {
        [self xyf_changeLocalBoolState:isOpen type:XYLNeedChangeBoolInfoType_isOpenWindowInApp];
    }
}

/// 改变应用外画中画开关
/// - Parameters:
///   - isOpen: 是否开启
///   - isSDKChange: 是否是SDK内部的改变
- (void)xyf_changeOutAppWindowState:(BOOL)isOpen isSDKChange:(BOOL)isSDKChange {
    OWLMusicInsideManagerShared.xyp_isOpenWindowOutApp = isOpen;
    [OWLMusicInsideManagerShared.xyp_vc xyf_changePIPOpenState:isOpen];
    if (isSDKChange) {
        [self xyf_changeLocalBoolState:isOpen type:XYLNeedChangeBoolInfoType_isOpenWindowOutApp];
    }
}

/// 展示1金币转盘
- (void)xyf_showOneCoinTest:(BOOL)isClick {
    if (isClick) {
        /// 点击抽奖按钮埋点
        [OWLMusicTongJiTool xyf_thinkingClickOneCoinButton];
        /// 将是否自动显示过一金币弹窗改为yes
        [self xyf_changeLocalBoolState:YES type:XYLNeedChangeBoolInfoType_hasAutoShowOneCoin];
    }
    
    /// 抽奖弹窗曝光
    [OWLMusicTongJiTool xyf_thinkingWithName:XYLThinkingEventShowOneCoinPage];
    
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleOpenOneCoinTurntable)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleOpenOneCoinTurntable];
    }
}

#pragma mark - OWLBGMModuleDataSource
/// 获取文本类型信息
- (NSString *)xyf_getTextInfo:(XYLOutDataSourceTextInfoType)textType {
    return [OWLBGMModuleManagerShared.dataSource xyf_getOutTextTypeInfo:textType] ?: @"";
}

/// 获取数字类型信息
- (NSInteger)xyf_getNumInfo:(XYLOutDataSourceNumInfoType)numType {
    return [OWLBGMModuleManagerShared.dataSource xyf_getOutNumTypeInfo:numType];
}

/// 获取字典类型信息
- (NSDictionary *)xyf_getDicInfo:(XYLOutDataSourceDicInfoType)dicType {
    return [OWLBGMModuleManagerShared.dataSource xyf_getOutDicTypeInfo:dicType];
}

/// 获取布尔类型信息
- (BOOL)xyf_getBoolInfo:(XYLOutDataSourceBoolInfoType)boolType {
    return [OWLBGMModuleManagerShared.dataSource xyf_getOutBoolTypeInfo:boolType];
}

/// 获取小数类型信息
- (float)xyf_getFloatInfo:(XYLOutDataSourceFloatInfoType)floatType {
    return [OWLBGMModuleManagerShared.dataSource xyf_getOutFloatTypeInfo:floatType];
}

/// 获取数组类型信息
- (NSMutableArray *)xyf_getOutArrayTypeInfo:(XYLOutDataSourceArrayInfoType)arrayType {
    return [OWLBGMModuleManagerShared.dataSource xyf_getOutArrayTypeInfo:arrayType];
}

/// 获取RTC实例【注：每个主包应该都有自己的RTC单例】
- (AgoraRtcEngineKit *)xyf_getRTCKit {
    return [OWLBGMModuleManagerShared.dataSource xyf_getRTCKit];
}

/// 获取RTM实例【注：每个主包应该都有自己的RTM单例】
- (AgoraRtmKit *)xyf_getRTMKit {
    return [OWLBGMModuleManagerShared.dataSource xyf_getRTMKit];
}

/// 用户头像占位图
- (UIImage *)xyf_userAvatarPlaceHolderImage {
    return [OWLBGMModuleManagerShared.dataSource xyf_userAvatarPlaceHolderImage];
}

#pragma mark - OWLBGMModuleDelegate
/// 关注、取关主播
- (void)xyf_userFollowAnchor:(NSInteger)anchorID isFollow:(BOOL)isFollow completion:(void(^)(BOOL followState))completion {
    [OWLBGMModuleManagerShared.delegate xyf_userFollowAnchor:anchorID isFollow:isFollow completion:^(BOOL followState) {
        if (completion) { completion(followState); }
    }];
}

/// 携带信息的点击事件
- (void)xyf_insideEventWithUserInfoType:(OWLMusicEventWithUserInfoType)type
                              accountID:(NSInteger)accountID
                               nickname:(NSString *)nickname
                                 avatar:(NSString *)avatar
                              displayID:(NSString *)displayID
                               isAnchor:(BOOL)isAnchor {
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleEventWithUserInfoType:type accountID:accountID nickname:nickname avatar:avatar displayID:displayID isAnchor:isAnchor];
}

/// 显示/隐藏loading
- (void)xyf_insideLoading:(BOOL)isShow {
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleLoading:isShow];
}

/// 显示提示
- (void)xyf_insideShowTip:(XYLOutDataSourceTopAlertType)type text:(NSString *)text {
    [XYCUtil xyf_doInMain:^{
        if (text.length <= 0) { return; }
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleShowTopAlert:type text:text];
    }];
}

/// 用户拉黑主播
/// - Parameters:
///   - anchorID: 主播id
///   - isBlock: 是否拉黑
- (void)xyf_insideUserBlockAnchor:(NSInteger)anchorID
                          isBlock:(BOOL)isBlock {
    [self xyf_showLoading];
    [OWLBGMModuleManagerShared.delegate xyf_userBlockAnchor:anchorID isBlock:isBlock completion:^{
        [self xyf_hideLoading];
    }];
}

/// 刷新首页
- (void)xyf_insideRefreshHomepage {
    [OWLBGMModuleManagerShared.delegate xyf_outsideModuleReloadHomeList];
    OWLMusicInsideManagerShared.xyp_isNeedRefreshHomeList = NO;
}

/// 销毁直播间
- (void)xyf_destroyModule {
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleDestroy)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleDestroy];
    }
}

/// 更改本地的bool状态
- (void)xyf_changeLocalBoolState:(BOOL)state type:(XYLNeedChangeBoolInfoType)type {
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleChangeLocalBoolState:type:)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleChangeLocalBoolState:state type:type];
    }
}

#pragma mark - Lazy
- (OWLMusicBannerInfoModel *)xyp_bannerInfo {
    if (!_xyp_bannerInfo) {
        _xyp_bannerInfo = [self xyf_configBannerInfo];
    }
    return _xyp_bannerInfo;
}

- (OWLMusicGiftListModel *)xyp_giftInfo {
    if (!_xyp_giftInfo) {
        _xyp_giftInfo = [self xyf_configGiftList];
    }
    return _xyp_giftInfo;
}

@end
