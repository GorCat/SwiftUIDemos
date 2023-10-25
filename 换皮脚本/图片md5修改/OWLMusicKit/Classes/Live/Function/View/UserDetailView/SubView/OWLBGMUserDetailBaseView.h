//// OWLBGMUserDetailBaseView.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 子视图基类
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 用户详情弹窗点击事件
typedef NS_ENUM(NSInteger, OWLBGMUserDetailBaseViewClickType) {
    /// 展示奖章列表
    OWLBGMUserDetailBaseViewClickType_ShowMedalsView   = 0,
    /// 发消息
    OWLBGMUserDetailBaseViewClickType_Message          = 1,
    /// 关注
    OWLBGMUserDetailBaseViewClickType_Follow           = 2,
    /// 取关
    OWLBGMUserDetailBaseViewClickType_Unfollow         = 3,
    /// 进入个人详情
    OWLBGMUserDetailBaseViewClickType_EnterUserDetail  = 4,
    /// 举报
    OWLBGMUserDetailBaseViewClickType_ShowReportView   = 5,
    /// 拉黑
    OWLBGMUserDetailBaseViewClickType_Block            = 6,
    /// 取消拉黑
    OWLBGMUserDetailBaseViewClickType_Unblock          = 7,
};

@protocol OWLBGMUserDetailBaseViewDelegate <NSObject>

/// 用户详情子视图点击事件
- (void)xyf_liveUserDetailBaseViewClickAction:(OWLBGMUserDetailBaseViewClickType)type;

@end

@interface OWLBGMUserDetailBaseView : UIView

@property (nonatomic, weak) id <OWLBGMUserDetailBaseViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
