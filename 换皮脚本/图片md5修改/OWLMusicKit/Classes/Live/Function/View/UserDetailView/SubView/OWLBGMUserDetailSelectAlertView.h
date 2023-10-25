//
//  OWLBGMUserDetailSelectAlertView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

/**
 * @功能描述：直播间用户信息弹窗 - 举报/拉黑弹窗
 * @创建时间：2023.2.13
 * @创建人：许琰
 */

#import "OWLBGMUserDetailBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMUserDetailSelectAlertView : OWLBGMUserDetailBaseView

+ (instancetype)xyf_showUserDetailSelectAlertView:(UIView *)targetView
                                     isBlockOther:(BOOL)isBlockOther
                                         isAnchor:(BOOL)isAnchor;

- (instancetype)initWithIsBlockOther:(BOOL)isBlockOther isAnchor:(BOOL)isAnchor;

@end

NS_ASSUME_NONNULL_END
