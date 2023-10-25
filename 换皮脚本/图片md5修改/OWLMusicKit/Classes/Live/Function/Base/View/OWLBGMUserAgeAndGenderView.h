//// OWLBGMUserAgeAndGenderView.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户性别年龄视图
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>
@class OWLBGMUserAgeAndGenderConfig;

NS_ASSUME_NONNULL_BEGIN

/// 性别年龄视图大小类型
typedef NS_ENUM(NSInteger, OWLJUserAgeAndGenderViewSizeType) {
    /// 40 x 18
    OWLBGMUserAgeAndGenderViewSizeType_4018    = 1,
    /// 34 x 14
    OWLBGMUserAgeAndGenderViewSizeType_3414    = 2
};

@interface OWLBGMUserAgeAndGenderView : UIView

/// 配置
@property (nonatomic, strong, readonly) OWLBGMUserAgeAndGenderConfig *xyp_config;

/// 初始化
- (instancetype)initWithType:(OWLJUserAgeAndGenderViewSizeType)type;

/// 更新信息
- (void)xyf_updateGender:(NSString *)gender age:(NSInteger)age;

@end

@interface OWLBGMUserAgeAndGenderConfig : NSObject

/// 整体大小
@property (nonatomic, assign) CGSize xyp_totalSize;
/// 字体大小
@property (nonatomic, strong) UIFont *xyp_font;
/// 性别图标大小
@property (nonatomic, assign) CGSize xyp_genderSize;
/// 性别图标左边距离
@property (nonatomic, assign) CGFloat xyp_genderLeftMargin;
/// 视图大小类型
@property (nonatomic, assign) OWLJUserAgeAndGenderViewSizeType xyp_sizeType;

+ (OWLBGMUserAgeAndGenderConfig *)xyf_configWithType:(OWLJUserAgeAndGenderViewSizeType)type;

@end

NS_ASSUME_NONNULL_END
