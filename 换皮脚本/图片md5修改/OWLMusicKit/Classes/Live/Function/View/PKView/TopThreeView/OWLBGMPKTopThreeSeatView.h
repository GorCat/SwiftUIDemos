//
//  OWLBGMPKTopThreeSeatView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层 - 一边前三名座位
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLMusicPKBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMPKTopThreeSeatView : OWLMusicPKBaseView

- (instancetype)initWithframe:(CGRect)frame isOtherAnchor:(BOOL)isOtherAnchor;

@property (nonatomic, strong) NSArray *xyp_avatarList;

@end

NS_ASSUME_NONNULL_END
