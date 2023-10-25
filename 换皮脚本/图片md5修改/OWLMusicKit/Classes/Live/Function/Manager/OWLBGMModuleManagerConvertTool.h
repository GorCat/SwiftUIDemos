//
//  OWLBGMModuleManagerConvertTool.h
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

#import <Foundation/Foundation.h>
#import "OWLMusicBannerInfoModel.h"
#define OWLJConvertToolShared ([OWLBGMModuleManagerConvertTool shareInstance])

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMModuleManagerConvertTool : NSObject

#pragma mark - 单例
+ (instancetype)shareInstance;

#pragma mark - 属性
/// banner信息
@property (nonatomic, strong) OWLMusicBannerInfoModel *xyp_bannerInfo;
/// 直播间礼物信息
@property (nonatomic, strong) OWLMusicGiftListModel *xyp_giftInfo;

#pragma mark - Getter
#pragma mark 用户信息
/// 用户sesstion
- (NSString *)xyf_userSession;

/// 用户ID
- (NSInteger)xyf_userAccountID;

/// 用户昵称
- (NSString *)xyf_userName;

/// 用户头像
- (NSString *)xyf_userAvatar;

/// 用户充值总额
- (float)xyf_userTotalRecharge;

/// 用户余额
- (NSInteger)xyf_userCoins;

/// 用户是否是Svip
- (BOOL)xyf_userIsSvip;

/// 用户是否是特权用户（消息内用）
- (BOOL)xyf_userIsPrivilege;

/// 用户整体信息
- (NSDictionary *)xyf_userAccountDic;

#pragma mark 配置信息
/// 标签标题
- (NSString *)xyf_configTagTitle;

/// 标签URL
- (NSString *)xyf_configTagUrl;

/// 标签高度
- (NSInteger)xyf_configTagHeight;

/// 标签宽度
- (NSInteger)xyf_configTagWidth;

/// PK比分URL
- (NSString *)xyf_pkFlagURL;

/// 头像占位图
- (UIImage *)xyf_userPlaceHolder;

/// 获取内购模型
- (OWLMusicPayModel *)xyf_getPayConfigModel;

/// 获取铁粉内购项模型
- (OWLMusicProductModel *)xyf_getFanProductModel;

/// 当前语聊房游戏模型
- (OWLMusicGameConfigModel *)xyf_chatCurrentGameModel;

/// 获取未购买过的内购折扣数组
- (NSMutableArray *)xyf_discountList;

/// 是否关闭广播
- (BOOL)xyf_isCloseBroadcast;

/// 是否显示转盘
- (BOOL)xyf_isShowRandomTable;

/// 是否开启铁粉功能
- (BOOL)xyf_isOpenFanClub;

/// 是否使用主包的svg路径
- (BOOL)xyf_isUseMainSVGPath;

/// 主包的PAG路径
- (NSString *)xyf_getSVGPath:(NSString *)url;

/// 是否是一金币实验组
- (BOOL)xyf_isOneCoinTest;

/// 是否在房间中弹过一金币转盘
- (BOOL)xyf_hasShowOneCoinInRoom;

/// 是否成功转过一金币转盘
- (BOOL)xyf_hasSuccessPlayOneCoin;

/// 是否需要展示1金币转盘
- (BOOL)xyf_isNeedShowOneCoin;

/// 1金币实验转盘弹出时间配置
- (NSInteger)xyf_oneCoinPromptTime;

#pragma mark RTC/RTM
/// RTC实例
- (AgoraRtcEngineKit *)xyf_rtcKit;

/// RTM实例
- (AgoraRtmKit *)xyf_rtmKit;

#pragma mark 其他信息
/// 当前是否是无网络状态
- (BOOL)xyf_noNetwork;

/// SSE状态
- (NSInteger)xyf_sseStatus;

/// 获取当前窗口
- (UIWindow *)xyf_keyWindow;

/// 获取当前VC
- (UIViewController *)xyf_getCurrentVC;

/// 是否显示过滑动提示
- (BOOL)xyf_isShowScrollTip;

/// 是否支持私聊功能
- (BOOL)xyf_isShowPrivateChat;

/// 是否是绿号
- (BOOL)xyf_isGreen;

/// 是否为阿语
- (BOOL)xyf_isRTL;

/// 是否仅有main
- (BOOL)xyf_isJustMain;

/// 是否显示过滑动引导
- (BOOL)xyf_isShowFanGuideTip;

/// 当前语言
- (NSString *)xyf_currentLanguage;

/// 获取性别类型
- (XYLOutDataSourceGenderType)xyf_getGenderType:(NSString *)genderStr;

/// 是否开启画中画功能（15.0以上服务端配置，15.0以下不开启画中画功能）
- (BOOL)xyf_hasPIPFunction;

/// 应用内悬浮窗开关
- (BOOL)xyf_isOpenWindowInApp;

/// 应用外画中画开关
- (BOOL)xyf_isOpenWindowOutApp;

#pragma mark - 方法
/// 显示loading
- (void)xyf_showLoading;

/// 隐藏loading
- (void)xyf_hideLoading;

/// 显示信息提示
- (void)xyf_showNotiTip:(NSString *)tip;

/// 显示错误提示
- (void)xyf_showErrorTip:(NSString *)tip;

/// 显示成功提示
- (void)xyf_showSuccessTip:(NSString *)tip;

/// 无网提示
- (void)xyf_showNoNetworkTip;

/// 判断是否无网（并弹无网提示）YES 无网 NO 有网
- (BOOL)xyf_judgeNoNetworkAndShowNoNetTip;

/// 网络层接口请求失败的错误提示
- (void)xyf_showNetworkErrowTip:(NSString *)tip;

/// 弹充值弹窗
- (void)xyf_insideShowRechargeView:(UIView *)superView;

/// 关注、取关主播
- (void)xyf_userFollowAnchor:(NSInteger)anchorID isFollow:(BOOL)isFollow completion:(void(^)(BOOL followState))completion;

/// 携带信息的点击事件
- (void)xyf_insideEventWithUserInfoType:(OWLMusicEventWithUserInfoType)type
                              accountID:(NSInteger)accountID
                               nickname:(NSString *)nickname
                                 avatar:(NSString *)avatar
                              displayID:(NSString *)displayID
                               isAnchor:(BOOL)isAnchor;

/// 更新金币数量
- (void)xyf_updateUserCoins:(NSInteger)coins;

/// 更新用户标签
- (void)xyf_updateUserLabel:(OWLMusicEventLabelModel *)label;

/// 已经显示过滑动提示
- (void)xyf_hadShowScrollTip;

/// 已经显示过铁粉提示
- (void)xyf_hadShowFanTip;

/// 跳转到视频私聊页面
- (void)xyf_jumpToPrivateVideoChat:(NSDictionary *)dic;

/// 上传图片
- (void)xyf_updateImage:(UIImage *)image isNeedJH:(BOOL)isNeedJH completion:(void(^)(BOOL success, NSString *photoUrl))completion;

/// 敏感词处理
- (NSString *)xyf_wordFilter:(NSString *)text;

/// 用户拉黑主播
/// - Parameters:
///   - anchorID: 主播id
///   - isBlock: 是否拉黑
- (void)xyf_insideUserBlockAnchor:(NSInteger)anchorID
                          isBlock:(BOOL)isBlock;

/// 刷新首页
- (void)xyf_insideRefreshHomepage;

/// 进入个人主页
- (void)xyf_enterUserDetailVCWithAccountID:(NSInteger)accountID
                                  nickname:(NSString *)nickname
                                    avatar:(NSString *)avatar
                                 displayID:(NSString *)displayID
                                  isAnchor:(BOOL)isAnchor;

/// 进入私聊页面
- (void)xyf_enterSingleChatVCWithAccountID:(NSInteger)accountID
                                  nickname:(NSString *)nickname
                                    avatar:(NSString *)avatar
                                 displayID:(NSString *)displayID
                                  isAnchor:(BOOL)isAnchor;

/// 进入个人中心的充值页面
- (void)xyf_enterRechargeVC;

/// 根据礼物ID获取礼物
- (OWLMusicGiftInfoModel *)xyf_getGiftModel:(NSInteger)giftID;

/// 显示禁止录屏
- (void)xyf_showNoScreenView;

/// 提醒充值SVIP
- (void)xyf_remindRechargeSvip;

/// 获取进入方式字符串
- (NSString *)xyf_getEnterRoomWayStr:(XYLOutDataSourceEnterRoomType)type;

/// 销毁直播间
- (void)xyf_destroyModule;

/// 改变广播状态
- (void)xyf_changeBroadcastState:(BOOL)isClose;

/// 进入语聊房
- (void)xyf_enterChatRoom:(NSInteger)roomID;

/// 关闭游戏的方法(语聊房SDK的方法)
- (void)xyf_closeChatRoomGame;

/// 打开游戏的方法(语聊房SDK的方法)
- (void)xyf_showChatRoomGame;

/// 统计点击游戏悬浮窗事件
- (void)xyf_tongjiGameBallClick:(NSInteger)gameID;

/// 需要主包更新金币
- (void)xyf_needUpdateUserCoins;

/// 改变应用内悬浮窗开关
- (void)xyf_changeInAppWindowState:(BOOL)isOpen isSDKChange:(BOOL)isSDKChange;

/// 改变应用外画中画开关
- (void)xyf_changeOutAppWindowState:(BOOL)isOpen isSDKChange:(BOOL)isSDKChange;

/// 展示1金币转盘
- (void)xyf_showOneCoinTest:(BOOL)isClick;

@end

NS_ASSUME_NONNULL_END
