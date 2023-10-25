//
//  OWLMusicRandomTableView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/25.
//

#import <UIKit/UIKit.h>
@class OWLMusicRandomTableColorModel, OWLMusicRandomTableViewModel;

#define XYLDegress2Radians(degrees) ((M_PI * degrees) / 180)

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRandomTableColorModel : NSObject

@property (nonatomic, strong) UIColor *xyp_startColor;

@property (nonatomic, strong) UIColor *xyp_endColor;

@end

@interface OWLMusicRandomTableViewModel : NSObject

@property (nonatomic, copy) NSString *xyp_remark;

@property (nonatomic, assign) int xyp_index;

@property (nonatomic, assign) int xyp_displayIndex;

@property (nonatomic, copy) NSString *xyp_imageName;

@property (nonatomic, assign) int xyp_num;

@end


@interface OWLMusicRandomTableView : UIView

@property (nonatomic, strong) NSDictionary *xyp_attributes;

@property (nonatomic, assign) CGSize xyp_imageSize;

@property (nonatomic, strong) NSArray <UIColor *> *xyp_panBgColors;

@property (nonatomic, strong) NSArray <OWLMusicRandomTableColorModel *> *xyp_panBgGradientColors;

@property (nonatomic, assign) CGFloat xyp_circleWidth;

@property (nonatomic, assign) CGFloat xyp_textPadding;

@property (nonatomic, strong) NSArray <OWLMusicRandomTableViewModel *> *xyp_luckyItemArray;

@property (nonatomic, copy) void(^lunckyAnimationDidStopBlock)(BOOL flag, OWLMusicRandomTableViewModel *item);


- (void)xyf_ramdomTabelToDisplayIndex:(NSInteger)displayIndex;

@end



NS_ASSUME_NONNULL_END
