//
//  OWLBGMPKRankListAlertView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/15.
//

/**
 * @功能描述：直播间PK - 送礼排行榜弹窗
 * @创建时间：2023.2.15
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMPKRankListAlertView : OWLBGMModuleBaseView

+ (instancetype)xyf_showPKRankListAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                 targetView:(UIView *)targetView
                              isOtherAnchor:(BOOL)isOtherAnchor
                                   anchorID:(NSInteger)anchorID
                                     roomID:(NSInteger)roomID
                               dismissBlock:(XYLVoidBlock)dismissBlock;

@end

NS_ASSUME_NONNULL_END
