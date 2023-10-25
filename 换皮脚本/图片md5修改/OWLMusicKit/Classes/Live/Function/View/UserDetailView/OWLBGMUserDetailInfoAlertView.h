//// OWLBGMUserDetailInfoAlertView.h
// qianDuoDuo
//
// 
//


/**
 * @功能描述：直播间用户信息弹窗
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMUserDetailInfoAlertView : OWLBGMModuleBaseView

+ (instancetype)xyf_showUserDetailAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                 targetView:(UIView *)targetView
                                detailModel:(OWLMusicAccountDetailInfoModel *)detailModel
                                   isAnchor:(BOOL)isAnchor
                               dismissBlock:(XYLVoidBlock)dismissBlock;

@end

NS_ASSUME_NONNULL_END
