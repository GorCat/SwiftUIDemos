//
//  OWLBGMPKRankListTopOneUserView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/15.
//

/**
 * @功能描述：直播间PK - 排行榜弹窗 - 第一名
 * @创建时间：2023.2.15
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseView.h"
#import "OWLMusicPKTopUserModel.h"
#import "OWLBGMPKRankListUserInfoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMPKRankListTopOneUserView : UIView

- (instancetype)initWithIsOtherAnchor:(BOOL)isOtherAnchor;

@property (nonatomic, strong) OWLMusicPKTopUserModel *xyp_model;

@property (nonatomic, weak) id <OWLBGMPKRankListUserInfoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
