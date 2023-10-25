//
//  OWLPPBannerItem.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OWLMusicBannerModel;

@protocol OWLPPBannerItemDelegate <NSObject>

@optional
- (void) xyf_bannerItemClick:(NSInteger)index;

@end

@interface OWLPPBannerItem : UICollectionViewCell

@property (nonatomic, weak) id <OWLPPBannerItemDelegate> delegate;

@property (nonatomic, assign) NSInteger xyp_index;

- (void)xyf_updateBannerModel:(OWLMusicBannerModel *)model;

@end

NS_ASSUME_NONNULL_END
