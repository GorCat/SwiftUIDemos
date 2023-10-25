//
//  OWLBGMTopTargetCoinsView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

/**
 * @功能描述：直播间顶部视图-目标金额
 * @创建时间：2023.2.10
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMTopTargetCoinsView : OWLBGMModuleBaseView

- (void)xyf_updateRoomGoal:(OWLMusicRoomGoalModel *)model;

@end

NS_ASSUME_NONNULL_END
