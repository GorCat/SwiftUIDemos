//// OWLBGMUserDetailOperateView.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 操作视图
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMUserDetailBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMUserDetailOperateView : OWLBGMUserDetailBaseView

/// ID
@property (nonatomic, assign) NSInteger xyp_accountID;

/// 是否关注
@property (nonatomic, assign) BOOL xyp_isFollow;

/// 总体高度
- (CGFloat)xyf_getHeight;

@end

NS_ASSUME_NONNULL_END
