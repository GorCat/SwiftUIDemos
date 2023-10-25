//
//  ZOEPIP_SampleBufferRender.m
//  ZBNChatRoom
//
//  Created by zzzzzzzzzz on 2023/6/26.
//

#import "ZOEPIP_SampleBufferRender.h"

@interface ZOEPIP_SampleBufferRender () {
    NSInteger _videoWidth, _videoHeight;
}
@property (nonatomic, strong) AVSampleBufferDisplayLayer *zoepip_displayLayer;

@end

@implementation ZOEPIP_SampleBufferRender
- (AVSampleBufferDisplayLayer *)zoepip_displayLayer {
    if (!_zoepip_displayLayer) {
        _zoepip_displayLayer = [AVSampleBufferDisplayLayer new];
    }
    
    return _zoepip_displayLayer;
}

- (instancetype)init {
    if (self = [super init]) {
        [self.layer addSublayer:self.zoepip_displayLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.zoepip_displayLayer];
    }
    return self;
}

- (void)awakeFromNib{
  [super awakeFromNib];
    [self.layer addSublayer:self.zoepip_displayLayer];

}

- (void)updateConstraints{
    [super updateConstraints];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.clipsToBounds = YES;
    [self layoutDisplayLayer];
}

- (void)layoutDisplayLayer {
    if (_videoWidth == 0 || _videoHeight == 0 || CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
        return;
    }
    
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    CGFloat videoRatio = (CGFloat)_videoWidth/(CGFloat)_videoHeight;
    CGFloat viewRatio = viewWidth/viewHeight;
    
    CGSize videoSize;
    if (videoRatio >= viewRatio) {
        videoSize.height = viewHeight;
        videoSize.width = videoSize.height * videoRatio;
    }else {
        videoSize.width = viewWidth;
        videoSize.height = videoSize.width / videoRatio;
    }
    
    CGRect renderRect = CGRectMake(0.5 * (viewWidth - videoSize.width), 0.5 * (viewHeight - videoSize.height), videoSize.width, videoSize.height);
    
    if (!CGRectEqualToRect(renderRect, self.zoepip_displayLayer.frame)) {
        self.zoepip_displayLayer.frame = renderRect;
    }
}

- (void)zoepip_reset {
    [self.zoepip_displayLayer flushAndRemoveImage];
}

- (OSType)getFormatType: (NSInteger)type {
    switch (type) {
        case 1:
            return kCVPixelFormatType_420YpCbCr8Planar;
            
        case 2:
            return kCVPixelFormatType_32BGRA;
            
        default:
            return kCVPixelFormatType_32BGRA;
    }
}

- (void)zoepip_renderVideoPixelBuffer:(AgoraOutputVideoFrame *_Nonnull)videoData {
    if (!videoData) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_videoWidth = videoData.width;
        self->_videoHeight = videoData.height;
        
        [self layoutDisplayLayer];
    });
    
    @autoreleasepool {
        CVPixelBufferRef pixelBuffer = videoData.pixelBuffer;
        
        CMVideoFormatDescriptionRef videoInfo;
        CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault,
                                                     pixelBuffer,
                                                     &videoInfo);
        
        CMSampleTimingInfo timingInfo;
        timingInfo.duration = kCMTimeZero;
        timingInfo.decodeTimeStamp = kCMTimeInvalid;
        timingInfo.presentationTimeStamp = CMTimeMake(CACurrentMediaTime()*1000, 1000);
        
        CMSampleBufferRef sampleBuffer;
        CMSampleBufferCreateReadyWithImageBuffer(kCFAllocatorDefault,
                                                 pixelBuffer,
                                                 videoInfo,
                                                 &timingInfo,
                                                 &sampleBuffer);
        
        [self.zoepip_displayLayer enqueueSampleBuffer:sampleBuffer];
        if (self.zoepip_displayLayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
            [self.zoepip_displayLayer flush];
        }
        if (sampleBuffer != NULL){
            CMSampleBufferInvalidate(sampleBuffer);
            CFRelease(sampleBuffer);
        }
        
        if (pixelBuffer != NULL){
            CVPixelBufferRelease(pixelBuffer);

        }
    }
}




@end
