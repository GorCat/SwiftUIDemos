//
//  OWLPPAddAlertTool.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/27.
//

#import <Foundation/Foundation.h>

@class OWLPPBanner, OWLPPGiftPublicityView;

NS_ASSUME_NONNULL_BEGIN

///控件添加工具代理
@protocol OWLPPAddAlerToolDelegate <NSObject>

@required
/** 显示充值弹窗 */
- (void) xyf_showRechargeView;

/** 去svip页面 */
- (void) xyf_jumpToSpecialPage;

/** 点击礼物 */
- (void) xyf_clickedGift:(OWLMusicGiftInfoModel *) gift;

/** 是否在当前直播间发送过弹幕 */
- (BOOL) xyf_isSendBarrageInCurrentRoom;

/** 是否在当前直播间送过礼物 */
- (BOOL) xyf_isSendGiftInCurrentRoom;

/** 是否关注了当前主播 */
- (BOOL) xyf_isFollowedHostInCurrentRoom;

/** 是否被当前直播间禁言了 */
- (BOOL) xyf_isBeMutedInCurrentRoom;

/** 发送Hi */
- (void) xyf_sendHiToHost;

/** 打开送礼界面 */
- (void) xyf_showSendGiftAlert;

/** 关注当前主播 */
- (void) xyf_followCurrentHost;

/** 当前主播的头像 */
- (NSString *) xyf_currentHostAvatar;

/** 点击弹幕用户名字 */
- (void) xyf_clickBarrageNickname:(NSInteger) xyp_accoundId andType:(OWLMusicMessageUserType) xyp_type;

/** 获取VC的view*/
- (UIView *) xyf_getVCView;

/** 进入房间60s 弹关注弹窗*/
- (void) xyf_showFollowAlert;

/** 弹出礼物是的弹窗y */
- (void) xyf_chooseGiftAlertYChanged:(double) xyp_y;


@end

/** 控件添加工具 */
@interface OWLPPAddAlertTool : NSObject

@property (nonatomic, weak) id<OWLPPAddAlerToolDelegate> xyp_delegate;

/** 是否在当前直播间发送过弹幕 */
@property (nonatomic, assign) BOOL xyf_hasSendBarrage;

/** 是否在当前直播间送过礼物 */
@property (nonatomic, assign) BOOL xyf_hasSendGift;

/** 是否关注了当前主播 */
@property (nonatomic, assign) BOOL xyf_hasFollowed;

/** 当前主播头像 */
@property (nonatomic, copy) NSString * xyf_hostAvatar;

/** 小banner */
@property (nonatomic, strong, readonly) OWLPPBanner * xyp_banner;

/** 收到礼物显示容器 */
@property (nonatomic, strong, readonly) OWLPPGiftPublicityView * xyp_receiveGiftView;

/** 单例 */
+ (instancetype)shareInstance;

/** 进入后激活定时器 */
- (void) xyf_activationTimer;

/** 离开前销毁定时器及UI控件 */
- (void) xyf_destroyTimer;

/** 清理上一个直播间的显示数据 */
- (void) xyf_clearAllData;

/** 开始新的直播间(RTM连接成功) */
- (void) xyf_startNewRoom;

/////*****************************     内部方法     *******************************//////

/** 通过礼物id查找礼物url */
- (OWLMusicGiftInfoModel *) xyf_inquireGiftModelWith:(NSInteger) xyp_giftId;

/////*****************************     banner part     *******************************//////

/**
 添加小banner
 @param showView 添加supperview
*/
- (void) xyf_addSmallBannerToView:(UIView *) showView;

/////*****************************     礼物列表 part     *******************************//////

/**
 初始化礼物列表view
 @param showView 添加supperview
 @param ggArray 礼物数组
*/
- (void) xyf_addGiftChooseToView:(UIView *) showView andDataArray:(NSArray *) ggArray;

/**
 显示礼物列表弹窗
*/
- (void) xyf_showGiftAlert;

/**
 刷新礼物列表数据
 @param ggArray banner数组
*/
- (void) xyf_refreshGiftArray:(NSArray *) ggArray;

/**
 购买svip后刷新礼物列表
*/
- (void) xyf_refreshGiftViewAfterBuy;

/**
 礼物发送成功后转换
 @param gift 礼物模型
 @param blindId 盲盒id 不是盲盒的话传0
*/
- (OWLMusicMessageModel *) xyf_convertMessageModelWith:(OWLMusicGiftInfoModel *) gift andBlindId:(NSInteger) blindId;

/////*****************************     礼物送出显示 part     *******************************//////

/**
 添加礼物送出显示容器
 @param showView 添加supperview
*/
- (void) xyf_addSendGiftShowView:(UIView *) showView;

/**
 显示送礼物弹窗
 @param msg 礼物消息数据
*/
- (void) xyf_showSendGiftEffectWith:(OWLMusicMessageModel *) msg;


/////*****************************     弹幕 part     *******************************//////

/**
 添加弹幕显示容器
 @param showView 添加supperview
*/
- (void) xyf_addBarrageShowView:(UIView *) showView;

/**
 添加显示弹幕信息
 @param xyp_msg 弹幕消息数据
 @param xyp_isImmediately 是否是需要立即插入的消息
*/
- (void) xyf_showOneBarrageEffectWith:(OWLMusicMessageModel *) xyp_msg andImmediatelyMsg:(BOOL)xyp_isImmediately;

/**
 修改弹幕区域位置
 @param xyp_rect 弹幕frame
 @param xyp_isRefresh 是否需要刷新
*/
- (void) xyf_refreshBarragePartFrame:(CGRect) xyp_rect andIsRefresh:(BOOL)xyp_isRefresh;


/////*****************************     其他 part     *******************************//////

/**
 播放完成目标svg
 @param xyp_showView 添加supperview
 @param xyp_name 主播昵称
 */
- (void) xyf_addAchieveGoalsSvgTo:(UIView *) xyp_showView andName:(NSString *) xyp_name;

/**
 播放svip进入房间svg
 @param xyp_showView 添加supperview
 @param xyp_avatar 用户头像
 @param xyp_name 用户昵称
 */
- (void) xyf_addJoinRoomSvgTo:(UIView *) xyp_showView andAvatar:(NSString *) xyp_avatar andName:(NSString *) xyp_name;

@end

NS_ASSUME_NONNULL_END
