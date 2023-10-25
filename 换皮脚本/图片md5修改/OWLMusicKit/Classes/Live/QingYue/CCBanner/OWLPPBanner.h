//
//  OWLPPBanner.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OWLPPBanner;

///banner代理
@protocol OWLPPBannerDelegate <NSObject>

/** 点击item */
- (void) xyf_didSelectOneItemByIndex:(NSInteger) index andBanner:(OWLPPBanner *) banner;

/** 点击关闭banner按钮 */
- (void) xyf_clickedCloseBanner;

/** 点击more按钮 */
- (void) xyf_clickedLookMore;

@end

///live banner
@interface OWLPPBanner : UIView

@property (nonatomic, weak) id<OWLPPBannerDelegate> xyp_delegate;

/** 是否轮播 - 默认打开 */
@property (nonatomic, assign) BOOL xyp_isCarousel;

/** 滚动间隔时间 - 默认5s */
@property (nonatomic, assign) NSInteger xyp_carouselTime;

/** 加载状态图 */
@property (nonatomic, strong) UIImage * xyp_placeImage;

/**
 填充数据
 @param dataArray banner数组
 */
- (void) xyf_configBannerData:(NSArray *) dataArray;

/**
 轮播下一页
 */
- (void) xyf_carouselNextPage;

/**
 关闭banner
 */
- (void) xyf_dismiss;

@end

NS_ASSUME_NONNULL_END
