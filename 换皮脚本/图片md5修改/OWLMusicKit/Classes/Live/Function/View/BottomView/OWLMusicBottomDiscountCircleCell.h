//
//  OWLMusicBottomDiscountCircleCell.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OWLMusicBottomDiscountCircleCellDelegate <NSObject>

- (void)xyf_BottomDiscountCircleClickWithType:(XYLModuleCycleInfoType)type;

@end

@interface OWLMusicBottomDiscountCircleCell : UICollectionViewCell

@property (nonatomic, weak) id <OWLMusicBottomDiscountCircleCellDelegate> delegate;

@property (nonatomic, assign) XYLModuleCycleInfoType type;

@end

NS_ASSUME_NONNULL_END
