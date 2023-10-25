//// OWLMusicPKRankListCell.h
// qianDuoDuo
//
// 
//


#import <UIKit/UIKit.h>
#import "OWLBGMPKRankListUserInfoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicPKRankListCell : UITableViewCell

@property (nonatomic, strong) OWLMusicPKTopUserModel *xyp_model;

@property (nonatomic, assign) NSInteger xyp_rank;

@property (nonatomic, weak) id <OWLBGMPKRankListUserInfoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
