//
//  OWLPPOpenBannerView.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLPPOpenBannerView : UIView

@property (nonatomic, copy) void(^xyp_bannerDetail)(NSInteger index);

- (void)xyf_configListData:(NSArray *)array;

- (void)xyf_showOpenView;

@end

NS_ASSUME_NONNULL_END
