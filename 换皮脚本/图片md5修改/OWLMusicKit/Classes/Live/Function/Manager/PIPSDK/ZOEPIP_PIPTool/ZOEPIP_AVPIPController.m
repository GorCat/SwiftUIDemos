//
//  ZOEPIP_AVPIPController.m
//  ZBNChatRoom
//
//  Created by zzzzzzzzzz on 2023/6/26.
//

#import "ZOEPIP_AVPIPController.h"
@interface ZOEPIP_AVPIPController()<AVPictureInPictureSampleBufferPlaybackDelegate>
@end
@implementation ZOEPIP_AVPIPController

- (instancetype)initWithDisplayView:(ZOEPIP_SampleBufferRender *)displayView {
    if (@available(iOS 15.0, *)) {
        if ([AVPictureInPictureController isPictureInPictureSupported]) {
            self = [super init];
            if (self) {
                _zoepip_displayView = displayView;
                AVPictureInPictureControllerContentSource *pipControllerContentSource = [[AVPictureInPictureControllerContentSource alloc] initWithSampleBufferDisplayLayer:_zoepip_displayView.zoepip_displayLayer playbackDelegate:self];
                
                _zoepip_pipController = [[AVPictureInPictureController alloc] initWithContentSource:pipControllerContentSource];
                _zoepip_pipController.requiresLinearPlayback = YES;
                [_zoepip_pipController setValue:@1 forKey:@"controlsStyle"];
            }
            return self;
        }
    }
    return nil;
}

- (void)zoepip_releasePIP {
    _zoepip_pipController.delegate = nil;
    _zoepip_pipController = nil;
    [_zoepip_displayView zoepip_reset];
    _zoepip_displayView = nil;
}

#pragma mark - <AVPictureInPictureSampleBufferPlaybackDelegate>

- (void)pictureInPictureController:(nonnull AVPictureInPictureController *)pictureInPictureController didTransitionToRenderSize:(CMVideoDimensions)newRenderSize {
    
}

- (void)pictureInPictureController:(nonnull AVPictureInPictureController *)pictureInPictureController setPlaying:(BOOL)playing {
    
}

- (void)pictureInPictureController:(nonnull AVPictureInPictureController *)pictureInPictureController skipByInterval:(CMTime)skipInterval completionHandler:(nonnull void (^)(void))completionHandler {
    
}

- (BOOL)pictureInPictureControllerIsPlaybackPaused:(nonnull AVPictureInPictureController *)pictureInPictureController {
    return NO;
}

- (CMTimeRange)pictureInPictureControllerTimeRangeForPlayback:(nonnull AVPictureInPictureController *)pictureInPictureController {
    return CMTimeRangeMake(kCMTimeZero, CMTimeMake(INT64_MAX, 1000));
}

@end
