//
//  OWLBGMPKTopThreeSeatAvatarView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层 - 前三名座位 - 单个头像
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLMusicPKBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMPKTopThreeSeatAvatarView : OWLMusicPKBaseView

- (void)xyf_updateSeatNum:(NSInteger)num isOther:(BOOL)isOther;

@property (nonatomic, copy) NSString *xyp_avatar;

@end

NS_ASSUME_NONNULL_END
