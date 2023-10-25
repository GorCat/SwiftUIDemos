//
//  OWLBGMModuleManager.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间单例类
 * @创建时间：2023.2.9
 * @创建人：许琰
 */

#import <Foundation/Foundation.h>
#import "OWLBGMModuleDataSource.h"
#import "OWLBGMModuleDelegate.h"
#define OWLBGMModuleManagerShared ([OWLBGMModuleManager shareInstance])

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMModuleManager : NSObject

/// 数据源
@property (nonatomic, weak) id <OWLBGMModuleDataSource> dataSource;
/// 代理
@property (nonatomic, weak) id <OWLBGMModuleDelegate> delegate;
/// 是否正在直播间模块中
@property (nonatomic, assign) BOOL xyp_isInLiveModule;
/// 是否是小窗状态
@property (nonatomic, assign) BOOL xyp_isFloatState;
/// 是否正在带走
@property (nonatomic, assign) BOOL xyp_isTakingAnchor;
/// 当前直播间的公共埋点参数
- (NSMutableDictionary *)xyf_liveBasicTongjiDic;

#pragma mark - 单例
+ (instancetype)shareInstance;


#pragma mark - 进入方法
/// 进入房间
/// 进入直播间之前，需要在外部判断是否在语聊房的boss位上，如果**在boss位就不能跳转到直播间内部**
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
                  pushAnimation:(void(^)(UIViewController *vc))pushAnimation;


#pragma mark - 外部接口
/// 更新用户金币
- (void)xyf_updateUserCoins:(NSInteger)coins;

/// 充值成功 反正就是用户花了真💰的地方。
/// 注：不需要判断是否在直播间中，直接调就行了
/// **不要和更新用户金币混淆。是用户充值成功，用于内部消优惠弹窗，不要随便调用！！！**
/// 1.内购验证小票接口调成功(包括订单重发时掉接口也算) （买铁粉不算！！！！）
/// 2.购买svip成功
/// 3.rtm加币消息（注：该消息有两种情况-后台加币/third充值。只需要在充值的时候掉这个方法，外部判断一下productID.length > 0，再调这个方法）
- (void)xyf_rechargeSuccess;

/// 关注用户（主包外面关注/取关需要调方法通知直播间内部更新UI状态。在外部统一封装的接口中，以下情况调用方法）
/// 1.关注接口调成功的时候  isFollow传改变之后的状态
/// 2.关注接口调失败 并且 错误码为-53（用户已关注主播）isFollow传YES。其余的接口失败的情况不调这个方法
- (void)xyf_followAnchor:(NSInteger)anchorID isFollow:(BOOL)isFollow;

/// 拉黑用户（主包外面拉黑/取消拉黑需要调方法通知直播间内部更新UI状态。在外部统一封装的接口中，以下情况调用方法）
/// 1.接口成功 isBlock传改变之后的状态
/// 2.接口失败： ①code = -9(该账号已在黑名单) isBlock 传YES
///           ②code = -10(该账号不在黑名单)isBlock 传NO
- (void)xyf_blockAnchor:(NSInteger)anchorID isBlock:(BOOL)isBlock;

/// 关闭房间（强制退出方法 外部不需要判断逻辑 直接在以下场景跳转页面之前 调用这个方法。
/// 目前想到的逻辑↓（如果各自包有不同需求自行增删）
/// 1.因为各种原因回到登录页（删号、退出登录、挤号、封号等）：在清user账号之前调用，不然内部的退出逻辑用户信息都为空
/// 2.hunting：在跳转到hunting页面之前调用
/// 3.打电话：在点击打电话方法之前调用
/// 4.进入语聊房：在跳转语聊房之前调用
- (void)xyf_closeLiveModule;

/// 最小化或者关闭房间（当跳转到下一个页面的之前 先调用这个方法 切到最小化之后再跳转）
- (void)xyf_closeOrFloatLive;

/// 成功购买vip（成功购买vip的时候 “先更新本地svip状态！！！” 然后再调这个方法用于刷新礼物列表。 注：外部不需要判断是否在直播间内，内部会判断）
- (void)xyf_successBuySvip;

/// 隐藏小窗（在小窗模式下 逛其他页面 有时候需要隐藏小窗，离开这个页面之后 再显示。比如 视频详情页面之类的）外部不需要判断是否在直播间中，内部会判断
/// 开关声音的逻辑需要**外面自己用rtc单例关声音**。
/// 因为[rtcKit adjustPlaybackSignalVolume:0]这个方法不一定对每个主包都适用←**徐老师说的**。不对所有主包适用的方法 sdk就不封了。
- (void)xyf_changeFloatState:(BOOL)isHidden;


/// 成功购买铁粉(本地改完标签信息之后再调用)
/// - Parameters:
///   - stanLabel: 铁粉标签
///   - anchorID: 主播ID
- (void)xyf_successBuyFan:(OWLMusicEventLabelModel *)stanLabel anchorID:(NSInteger)anchorID;

/// 弹出0.99充值优惠弹窗
/// 调用时机：每次打开app，第一次从内购页面返回时调用。（是否充值过的逻辑在sdk内部会判断）
/// 前提：必须在一进入主包就初始化OWLBGMModuleManager这个类 并设置代理。不然就自己写弹窗→_→
/// - Parameters:
///   - targetView: 父视图
///   - bgColor: 背景蒙版颜色（主包有需要的自己加，不需要的穿nil）
- (void)xyf_show099RechargeView:(UIView *)targetView
                        bgColor:(nullable UIColor *)bgColor;

#pragma mark - 解压资源（在进入主包的时候就调这个方法 谢谢！）
/// 加载资源
- (void)xyf_compressionResources;

#pragma mark - 外部推送处理
/// 处理外部的推送消息（在SSE推送 及 RTM的messageReceived回调中处理 传一整个字典）
- (void)xyf_handlePushData:(NSDictionary *)dic;

#pragma mark - 游戏相关(和语聊房联动，在语聊房的delegate/datasource中调用)
/// 获取当前直播间游戏信息（语聊房delegate中调用）
- (NSDictionary *)xyf_getCurrentGameInfo;

/// 关闭直播间游戏悬浮窗（删号、退出登录、挤号、封号等 也要调用该方法 关闭游戏悬浮窗）
- (void)xyf_closeGameSmallView;

/// 打开直播间游戏页面
- (void)xyf_showGamePlayView;

#pragma mark - 悬浮窗/画中画相关(在主包的设置中调用)
/// 切换应用内悬浮窗开关
- (void)xyf_changeWindowInAppIsOpen:(BOOL)isOpen;

/// 切换应用外画中画开关
- (void)xyf_changeWindowOutAppIsOpen:(BOOL)isOpen;

#pragma mark - 1金币转盘AB测试相关
/// 用户成功转1金币转盘
/// 调用时机：用户转1金币转盘转成功（主包的所有1金币转盘转成功都要调这个方法）
/// 调用前提：需要将XYLOutDataSourceBoolInfoType_hasOpenOneCoinSuccess对应存的值改成Yes（改成已成功转过）
/// 调用目的：直播间内部会将转盘的入口隐藏。
- (void)xyf_successOpenOneCoinTurntable;

@end

NS_ASSUME_NONNULL_END
