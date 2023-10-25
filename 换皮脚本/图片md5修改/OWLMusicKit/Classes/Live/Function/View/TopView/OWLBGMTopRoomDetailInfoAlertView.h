//
//  OWLBGMTopRoomDetailInfoAlertView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

/**
 * @功能描述：直播间顶部视图-房间信息详情弹窗
 * @创建时间：2023.2.10
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMTopRoomDetailInfoAlertView : OWLBGMModuleBaseView

+ (instancetype)xyf_showRoomDetailAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                 targetView:(UIView *)targetView
                                       goal:(OWLMusicRoomGoalModel *)goalModel
                                 leftMargin:(CGFloat)leftMargin
                               dismissBlock:(XYLVoidBlock)dismissBlock;

/// 更新数据
- (void)xyf_updateRoomGoal:(OWLMusicRoomGoalModel *)goal isInit:(BOOL)isInit;

@end

NS_ASSUME_NONNULL_END
