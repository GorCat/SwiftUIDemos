//
//  OWLBGMMedalListAlertView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

/**
 * @功能描述：直播间用户奖章弹窗
 * @创建时间：2023.2.13
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"
#import "OWLMusicEventLabelModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMMedalListAlertView : OWLBGMModuleBaseView

/// 是否仅展示(从个人详情弹窗点击为仅展示。从输入框点击就可以编辑)
@property (nonatomic, assign) BOOL xyp_isJustShow;

- (instancetype)initWithAccountID:(NSInteger)accountID;

- (void)xyf_showInView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
