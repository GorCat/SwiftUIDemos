//
//  OWLMusicBroadcastCell.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/28.
//

#import <UIKit/UIKit.h>
#import "OWLMusicBroadcastModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicBroadcastCell : UIView

@property (nonatomic, strong, readonly) OWLMusicBroadcastModel * xyp_model;

@property (nonatomic, copy) void(^stateChangeBlock)(XYLBroadcastCellState state);

@property (nonatomic, copy) void (^cellWillStayBlock)(OWLMusicBroadcastModel * xyp_bannerModel);

@property (nonatomic, copy) void (^tapChannalBannerBlock)(OWLMusicBroadcastModel * xyp_bannerModel);

- (void)xyf_loadModel:(OWLMusicBroadcastModel *)xyp_model;

- (void)xyf_cellEnter;

@end

NS_ASSUME_NONNULL_END
