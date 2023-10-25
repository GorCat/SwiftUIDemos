//
//  ZOEPIP_AVPIPController.h
//  ZBNChatRoom
//
//  Created by zzzzzzzzzz on 2023/6/26.
//

#import <AVKit/AVKit.h>
#import "ZOEPIP_SampleBufferRender.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZOEPIP_AVPIPController : NSObject

@property (nonatomic, strong, readonly) ZOEPIP_SampleBufferRender *zoepip_displayView;
- (instancetype)initWithDisplayView:(ZOEPIP_SampleBufferRender *)displayView;
- (void)zoepip_releasePIP;
@property (nonatomic, strong, readonly) AVPictureInPictureController *zoepip_pipController;

@end

NS_ASSUME_NONNULL_END
