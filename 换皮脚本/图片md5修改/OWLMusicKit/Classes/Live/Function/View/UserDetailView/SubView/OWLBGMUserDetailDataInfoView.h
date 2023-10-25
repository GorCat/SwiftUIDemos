//// OWLBGMUserDetailDataInfoView.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 数据信息视图【关注 + 粉丝 + 消费/奖章】
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMUserDetailDataInfoView : UIView

/// 是否是主播
@property (nonatomic, assign) BOOL xyp_isAnchor;
/// 信息模型
@property (nonatomic, strong) OWLMusicAccountDetailInfoModel *xyp_model;

- (CGFloat)xyf_getHeight;

@end

NS_ASSUME_NONNULL_END
