//
//  OWLBGMModuleBaseViewDelegate.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间视图代理方法
 * @创建时间：2023.2.9
 * @创建人：许琰
 * @备注：直播间内所有的视图的点击事件代理 都用这一个。虽然用block回调一个id类型出去更方便，但是xy觉得不好维护，也不利于代码阅读。
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 直播间视图无需带参数的点击事件类型
typedef NS_ENUM(NSInteger, XYLModuleBaseViewClickType) {
    /// 展示观众列表
    XYLModuleBaseViewClickType_ShowAudienceList     = 0,
    /// 展示房间工具
    XYLModuleBaseViewClickType_ShowRoomTools,
    /// 展示充值弹窗
    XYLModuleBaseViewClickType_ShowRechargeView,
    /// 展示礼物列表
    XYLModuleBaseViewClickType_ShowGiftList,
    /// 弹出文本输入
    XYLModuleBaseViewClickType_ShowTextInput,
    /// 编辑奖章弹窗
    XYLModuleBaseViewClickType_EditMedalListView,
    /// 展示私聊弹窗
    XYLModuleBaseViewClickType_ShowPrivateChatView,
    /// 进入对面房间
    XYLModuleBaseViewClickType_EnterOtherRoom,
    /// 点击关闭按钮
    XYLModuleBaseViewClickType_ClickCloseButton,
    /// 点击充值优惠
    XYLModuleBaseViewClickType_ClickDiscountButton,
    /// 点击铁粉按钮
    XYLModuleBaseViewClickType_ClickFanButton,
    /// 点击游戏按钮
    XYLModuleBaseViewClickType_ClickGameButton,
    /// 点击设置按钮
    XYLModuleBaseViewClickType_ClickStreamSettings,
};

/// 直播间视图带用户基本信息的点击事件类型
typedef NS_ENUM(NSInteger, XYLModuleBaseViewInfoClickType) {
    /// 展示用户信息弹窗
    XYLModuleBaseViewInfoClickType_ShowUserDetailView           = 0,
    /// 进入私聊页面
    XYLModuleBaseViewInfoClickType_EnterTextChatVC              = 1,
    /// 进入用户详情
    XYLModuleBaseViewInfoClickType_EnterUserDetailVC            = 2,
    /// 展示用户奖章弹窗
    XYLModuleBaseViewInfoClickType_ShowMedalListView            = 3,
    /// 举报用户
    XYLModuleBaseViewInfoClickType_ShowReportUserView           = 4,
    /// 展示PK对方用户详情弹窗
    XYLModuleBaseViewInfoClickType_ShowPKOtherUserDetailView    = 5,
};

/// 直播间输入改变键盘高度类型
typedef NS_ENUM(NSInteger, XYLModuleChangeInputViewHeightType) {
    /// 消失
    XYLModuleChangeInputViewHeightType_Dismiss      = 1,
    /// 展示
    XYLModuleChangeInputViewHeightType_Show,
    /// 输入中
    XYLModuleChangeInputViewHeightType_Input,
};

@protocol OWLBGMModuleBaseViewDelegate <NSObject>

/// 点击事件（无需带参数的点击事件）
/// - Parameter clickType: 点击类型
- (void)xyf_lModuleBaseViewClickEvent:(XYLModuleBaseViewClickType)clickType;


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
                                 isAnchor:(BOOL)isAnchor;


/// 关注/取关主播
/// - Parameters:
///   - accountID: 主播ID
///   - isFollow: yes-关注 no-取关
///   - completion: 完成回调
- (void)xyf_lModuleBaseViewFollowAnchor:(NSInteger)accountID
                               isFollow:(BOOL)isFollow
                             completion:(void(^)(void))completion;


/// 点击展示PK送礼排行榜
- (void)xyf_lModuleBaseViewShowPKRankWithAccountID:(NSInteger)accountID
                                     isOtherAnchor:(BOOL)isOtherAnchor;

/// 用户送礼
- (void)xyf_lModuleBaseViewSendGift:(OWLMusicGiftInfoModel *)model;


/// 用户发送文字
- (void)xyf_lModuleBaseViewSendText:(NSString *)text;


/// 键盘弹起更新高度
- (void)xyf_lModuleBaseViewUpdateKeyboardHeight:(CGFloat)height changeType:(XYLModuleChangeInputViewHeightType)changeType;


/// 更新标签
- (void)xyf_lModuleBaseViewUpdateLabel:(OWLMusicEventLabelModel *)label;


/// 展示房间详情
- (void)xyf_lModuleBaseViewShowRoomDetail:(CGFloat)leftMargin;


/// 当前房间模型
- (OWLMusicRoomDetailModel *)xyf_lModuleGetCurrentTotalModel;

@end

NS_ASSUME_NONNULL_END
