//// OWLBGMAudienceAlertView.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间观众列表弹窗
 * @创建时间：2023.2.11
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMAudienceAlertView : OWLBGMModuleBaseView

/// 用户列表数据
@property (nonatomic, strong) NSMutableArray *xyp_dataList;

- (instancetype)initWithDismissBlock:(XYLVoidBlock)dismissBlock;

- (void)xyf_showInView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
