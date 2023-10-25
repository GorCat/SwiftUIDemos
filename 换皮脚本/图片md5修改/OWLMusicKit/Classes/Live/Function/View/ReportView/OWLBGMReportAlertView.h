//
//  OWLBGMReportAlertView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

/**
 * @功能描述：直播间举报弹窗
 * @创建时间：2023.2.10
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMReportAlertView : OWLBGMModuleBaseView

+ (instancetype)xyf_showReportUserAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                 targetView:(UIView *)targetView
                                 relationID:(NSInteger)relationID
                             isUGCRoomOwner:(BOOL)isUGCRoomOwner
                               dismissBlock:(XYLVoidBlock)dismissBlock;

- (void)xyf_showInView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
