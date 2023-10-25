//
//  ZOEPIP_SampleBufferRender.h
//  ZBNChatRoom
//
//  Created by zzzzzzzzzz on 2023/6/26.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZOEPIP_SampleBufferRender : UIView
@property (nonatomic, readonly) AVSampleBufferDisplayLayer *zoepip_displayLayer;

- (void)zoepip_reset;

- (void)zoepip_renderVideoPixelBuffer:(AgoraOutputVideoFrame *_Nonnull)videoData;

@end

NS_ASSUME_NONNULL_END
