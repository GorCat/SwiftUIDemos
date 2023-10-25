//// OWLBGMRoomToolsAlertView.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间工具视图弹窗
 * @创建时间：2023.2.11
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMRoomToolsAlertView : OWLBGMModuleBaseView

+ (instancetype)xyf_showRoomToolsAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                targetView:(UIView *)targetView
                              dismissBlock:(XYLVoidBlock)dismissBlock;

- (instancetype)initWithDismissBlock:(XYLVoidBlock)dismissBlock;

- (void)xyf_showInView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
