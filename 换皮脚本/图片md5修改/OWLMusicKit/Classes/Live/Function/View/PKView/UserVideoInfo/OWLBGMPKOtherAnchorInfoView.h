//
//  OWLBGMPKOtherAnchorInfoView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层 - 用户pk信息视图 - 对面主播信息
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLMusicPKBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMPKOtherAnchorInfoView : OWLMusicPKBaseView

@property (nonatomic, strong) OWLMusicRoomPKPlayerModel *xyp_otherPlayerModel;

- (CGRect)xyf_anchorViewFrame;

@end

NS_ASSUME_NONNULL_END
