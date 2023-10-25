//
//  OWLMusicAutoFollowView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/13.
//

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicAutoFollowView : OWLBGMModuleBaseView

/// 详情模型
@property (nonatomic, strong, readonly) OWLMusicAccountDetailInfoModel *xyp_detailModel;

+ (instancetype)xyf_showAutoFollowAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                 targetView:(UIView *)targetView
                                detailModel:(OWLMusicAccountDetailInfoModel *)detailModel
                               dismissBlock:(XYLVoidBlock)dismissBlock;

/// 消失
- (void)xyf_dismiss;

@end

NS_ASSUME_NONNULL_END
