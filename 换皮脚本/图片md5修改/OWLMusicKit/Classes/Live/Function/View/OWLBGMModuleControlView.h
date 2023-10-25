//
//  OWLBGMModuleControlView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间控制层视图（跟着手势划走的）
 * @创建时间：2023.2.9
 * @创建人：许琰
 * @备注：【顶部视图+房间信息+聊天+底部操作栏】
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMModuleControlView : OWLBGMModuleBaseView

@property (nonatomic, weak) id <OWLBGMModuleBaseViewDelegate> controlDelegate;

/// 更新观众列表
- (void)xyf_updateMemberList:(NSMutableArray *)memberList;

/// 键盘弹起更新消息frame
- (void)xyf_updateFrameWhenKeyboardChanged:(CGFloat)bottomHeight changeType:(XYLModuleChangeInputViewHeightType)changeType;

@end

NS_ASSUME_NONNULL_END
