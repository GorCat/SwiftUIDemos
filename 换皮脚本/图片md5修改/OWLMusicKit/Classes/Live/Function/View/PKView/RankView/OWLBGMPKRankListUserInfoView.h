//
//  OWLBGMPKRankListUserInfoView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/15.
//

/**
 * @功能描述：直播间PK - 排行榜弹窗 - 用户信息视图
 * @创建时间：2023.2.15
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"
#import "OWLMusicPKTopUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol OWLBGMPKRankListUserInfoViewDelegate <NSObject>

- (void)xyf_pkRankListUserInfoClickAction:(OWLMusicPKTopUserModel *)model;

@end

@interface OWLBGMPKRankListUserInfoView : UIView

- (instancetype)initWithIsTopOne:(BOOL)isTopOne;

@property (nonatomic, weak) id <OWLBGMPKRankListUserInfoViewDelegate> delegate;

@property (nonatomic, strong) OWLMusicPKTopUserModel *xyp_model;

@property (nonatomic, assign) NSInteger xyp_rank;

@end

NS_ASSUME_NONNULL_END
