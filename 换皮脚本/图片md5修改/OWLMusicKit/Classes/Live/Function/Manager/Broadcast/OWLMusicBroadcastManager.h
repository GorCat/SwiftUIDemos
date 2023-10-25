//
//  OWLMusicBroadcastManager.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/5.
//

#import <Foundation/Foundation.h>
#import "OWLMusicBroadcastCell.h"
#import "OWLMusicBroadcastModel.h"

NS_ASSUME_NONNULL_BEGIN
#define XYCBroadcastShared [OWLMusicBroadcastManager manager]

@interface OWLMusicBroadcastManager : NSObject

+ (instancetype)manager;

- (void)xyf_setupBannerOnView:(UIView *)view;

- (void)xyf_addChannalBanner:(OWLMusicBroadcastModel *)xyp_model;

- (void)xyf_leaveRoom;

- (void)xyf_clearBannerData;

- (void)xyf_destoryManager;

@end

NS_ASSUME_NONNULL_END
