//
//  OWLMusicSubViewClickManager.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

#import <Foundation/Foundation.h>
#import "OWLPPAddAlertTool.h"

NS_ASSUME_NONNULL_BEGIN
@class OWLMusicBottomInputView, OWLBGMModuleMainView;

/// 发消息类型
typedef NS_ENUM(NSInteger, OWLMusicSubViewClickSendMsgType) {
    /// 本地远端都发
    OWLMusicSubViewClickSendMsgType_LocalAndRemote    = 1,
    /// 只发本地
    OWLMusicSubViewClickSendMsgType_Local             = 2,
    /// 只发远端
    OWLMusicSubViewClickSendMsgType_Remote            = 3,
    /// 文本消息
    OWLMusicSubViewClickSendMsgType_SendText          = 4
};

/// 优惠弹窗点击类型
typedef NS_ENUM(NSInteger, OWLMusicShowDiscountViewType) {
    /// 点击显示
    OWLMusicShowDiscountViewType_Click        = 1,
    /// 第一次自动显示
    OWLMusicShowDiscountViewType_FirstAuto,
    /// 第二次自动显示
    OWLMusicShowDiscountViewType_SecondAuto,
};

@protocol OWLMusicSubViewClickManagerDelegate <NSObject>

/// 发消息
- (void)xyf_clickManagerSendMessage:(OWLMusicMessageModel *)message type:(OWLMusicSubViewClickSendMsgType)type;

/// 更新观众列表
- (void)xyf_clickManagerUpdateMemberList:(NSArray *)list;

/// 点击对方房间
- (void)xyf_clickManagerEnterOtherAnchorRoom;

/// 设置返回手势
- (void)xyf_clickManagerConfigPopGestureRecognizer:(BOOL)isEnable;

/// 关闭或者最小化房间
- (void)xyf_clickManagerCloseOrChangeFloatState;

@end

@interface OWLMusicSubViewClickManager : NSObject <OWLBGMModuleBaseViewDelegate, OWLPPAddAlerToolDelegate>

/// 代理
@property (nonatomic, weak) id <OWLMusicSubViewClickManagerDelegate> delegate;

/// 数据源
@property (nonatomic, weak) id <OWLMusicSubManagerDataSource> dataSource;

/// 目标视图（也就是直播间VC.view）
@property (nonatomic, weak) UIView *xyp_targetView;

/// 输入框
@property (nonatomic, weak) OWLMusicBottomInputView *xyp_inputView;

/// 点击事件视图
@property (nonatomic, weak) OWLBGMModuleMainView *xyp_controlView;

/// 内购模型(最便宜的那个)
@property (nonatomic, strong) OWLMusicProductModel *xyp_productModel;

/// 是否发过消息
@property (nonatomic, assign) BOOL xyp_isSendMsg;

/// 是否送过礼物
@property (nonatomic, assign) BOOL xyp_isSendGift;

/// 是否送过礼物
@property (nonatomic, assign) BOOL xyp_hasSwitchRoom;

/// 更新观众列表
- (void)xyf_updateMemberList:(NSMutableArray *)memberList;

/// 清理所有数据
- (void)xyf_clearAllData;

/// 更新目标视图
- (void)xyf_updateGoal:(OWLMusicRoomGoalModel *)model;

/// 更新带走礼物
- (void)xyf_updatePrivateGift:(NSInteger)giftID;

/// 关闭私聊带走弹窗
- (void)xyf_closePrivateChatView;

/// 移除定时器
- (void)xyf_removeTimer;

/// 展示充值优惠弹窗
- (void)xyf_showDiscountAlertView:(OWLMusicShowDiscountViewType)showType;

@end

NS_ASSUME_NONNULL_END
