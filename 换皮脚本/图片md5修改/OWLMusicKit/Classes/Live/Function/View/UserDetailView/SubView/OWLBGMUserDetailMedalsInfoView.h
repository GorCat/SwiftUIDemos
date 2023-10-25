//// OWLBGMUserDetailMedalsInfoView.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 奖章信息视图
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMUserDetailBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMUserDetailMedalsInfoView : OWLBGMUserDetailBaseView

/// 信息模型
@property (nonatomic, strong) OWLMusicAccountDetailInfoModel *xyp_model;

- (CGFloat)xyf_getHeight;

@end

NS_ASSUME_NONNULL_END
