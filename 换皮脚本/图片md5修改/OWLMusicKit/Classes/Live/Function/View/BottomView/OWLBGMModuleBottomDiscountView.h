//
//  OWLBGMModuleBottomDiscountView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/24.
//

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OWLBGMModuleBottomDiscountViewDelegate <NSObject>

- (void)xyf_bottomDiscountViewIsHidden:(BOOL)isHidden;

@end

@interface OWLBGMModuleBottomDiscountView : OWLBGMModuleBaseView

@property (nonatomic, weak) id <OWLBGMModuleBottomDiscountViewDelegate> discountDelegate;

@end

NS_ASSUME_NONNULL_END
