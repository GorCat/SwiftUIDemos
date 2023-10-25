//
//  OWLMusicFirstRechargeAlertView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/21.
//

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicFirstRechargeAlertView : OWLBGMModuleBaseView

+ (instancetype)xyf_showDiscountAlertView:(UIView *)targetView
                                  bgColor:(nullable UIColor *)bgColor
                             productModel:(OWLMusicProductModel *)productModel
                             dismissBlock:(XYLVoidBlock)dismissBlock;

@end

NS_ASSUME_NONNULL_END
