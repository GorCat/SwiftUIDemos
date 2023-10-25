//
//  OWLMusicPKVSUserView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicPKVSUserView : UIView

- (instancetype)initWithIsOtherAnchor:(BOOL)isOtherAnchor;

@property (nonatomic, strong) OWLMusicRoomPKPlayerModel *xyp_playerModel;

@end

NS_ASSUME_NONNULL_END
