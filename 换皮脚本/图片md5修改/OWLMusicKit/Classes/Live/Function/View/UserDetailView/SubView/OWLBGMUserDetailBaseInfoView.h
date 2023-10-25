//// OWLBGMUserDetailBaseInfoView.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 基础信息视图【昵称 + 性别 + 个签】
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMUserDetailBaseInfoView : OWLBGMModuleBaseView

@property (nonatomic, strong) OWLMusicAccountDetailInfoModel *xyp_model;

- (CGFloat)xyf_getHeight;

@end

NS_ASSUME_NONNULL_END
