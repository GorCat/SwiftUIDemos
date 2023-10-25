//
//  ZOEPIP_PIPManager.m
//  ZBNChatRoomDemo
//
//  Created by zzzzzzzzzz on 2023/6/26.
//
static CGSize ZOEPIPMultibeamMainSize(BOOL isSwiftUI){
    
    if (isSwiftUI == YES){
        return CGSizeMake([UIApplication sharedApplication].keyWindow .frame.size.width*0.8 , [UIApplication sharedApplication].keyWindow.frame.size.height*0.8 );
    }
    
    return CGSizeMake([[UIApplication sharedApplication].delegate window].frame.size.width*0.8  , [[UIApplication sharedApplication].delegate window].frame.size.height*0.8 );
};


static CGSize ZOEPIPLiveMainSize(BOOL isSwiftUI){
    
    if (isSwiftUI == YES){
        return CGSizeMake([UIApplication sharedApplication].keyWindow.frame.size.width , [UIApplication sharedApplication].keyWindow.frame.size.height );
    }
    
    
    return CGSizeMake([[UIApplication sharedApplication].delegate window].frame.size.width , [[UIApplication sharedApplication].delegate window].frame.size.height );
};


static CGSize ZOEPIPMultibeamViewSize(){
    return CGSizeMake(300, 300);
};

static CGSize ZOEPIPLivePKMainSize(BOOL isSwiftUI){
    if (isSwiftUI == YES){
        return CGSizeMake([UIApplication sharedApplication].keyWindow.frame.size.width , [UIApplication sharedApplication].keyWindow.frame.size.height/2 );
    }
    return CGSizeMake([[UIApplication sharedApplication].delegate window].frame.size.width  , [[UIApplication sharedApplication].delegate window].frame.size.height/2 );
};


#import "ZOEPIP_PIPManager.h"
@interface ZOEPIP_PIPManager()<AVPictureInPictureControllerDelegate,AgoraVideoFrameDelegate>
@property (nonatomic,assign)ZOEPIP_PIPVCType zoepip_vcType;
@property (nonatomic,weak)AgoraRtcEngineKit * zoepip_rtcKit;
@property (nonatomic,weak)UIViewController * zoepip_fatherVc;
@property (nonatomic,assign)BOOL zoepip_isPk;
@property (nonatomic,strong) UIImageView * zoepip_screenCoveringPicView;
@property (nonatomic,weak) UIView * zoepip_screenCoveringView;
@property (nonatomic,strong) CIImage * zoepip_lastImage;
@property (nonatomic,strong)ZOEPIP_SampleBufferRender * zoepip_videoView;
@property (nonatomic, strong)ZOEPIP_AVPIPController *zoepip_pipController;
@property (nonatomic,strong) CIContext * context;
@property (nonatomic,strong) UITextField * zoepip_screenCaptureTFView;
@property (nonatomic,assign) BOOL zoepip_isStartPIP;
@property (nonatomic,assign) BOOL zoepip_isOpen;
@property (nonatomic,strong) UIImageView * zoepip_transitionAniView;
@property (nonatomic,assign) CGSize zoepip_beamMainSize;
@property (nonatomic,assign) CGSize zoepip_livePkSize;
@property (nonatomic,assign) CGSize zoepip_liveSize;
@property (nonatomic,strong) UIImageView * zoepip_bgImageView;
@property (nonatomic,strong) UIImage * clearImg;

@property (nonatomic,strong) NSMutableArray<NSValue *>* zoepip_multibeamFrameArr;
@property (nonatomic,strong) UIImageView * pipMainView;
@property (nonatomic,weak) UIView * zoepip_anyView;
@property (nonatomic,assign) BOOL zoepip_isclosePIP;
@property (nonatomic,assign) BOOL zoepip_isInBack;
@property (nonatomic,assign) BOOL zoepip_isSwiftUI;

@property (nonatomic,assign) NSInteger zoepip_lostPiccount;
//@property (nonatomic,assign) BOOL zoepip_isNewBack;


@end
@implementation ZOEPIP_PIPManager
- (instancetype)initAndRtcKit:(AgoraRtcEngineKit *)rtcKit
                   WithvcType:(ZOEPIP_PIPVCType)vcType
                       WithVC:(UIViewController *)vc
                 WithDelegate:(id<ZOEPIPPictureInPictureManagerDelegate>)delegate
                   WithIsOpen:(BOOL)isOpen
        {
    
    if(self = [super init]){
        if (@available(iOS 15.0, *)) {
            self.delegate = delegate;
            self.zoepip_rtcKit = rtcKit;
            self.zoepip_fatherVc = vc;
            self.zoepip_vcType = vcType;
            self.zoepip_isSwiftUI = NO;
            self.zoepip_isOpen = isOpen;

            if (isOpen){
                [self setConfig];
            }
        };
    }
    return self;
}

- (instancetype)initAndRtcKit:(AgoraRtcEngineKit *)rtcKit
                   WithvcType:(ZOEPIP_PIPVCType)vcType
                       WithVC:(UIViewController *)vc
                 WithDelegate:(id<ZOEPIPPictureInPictureManagerDelegate>)delegate
                WithIsSwiftUI:(BOOL)isSwiftUI
                   WithIsOpen:(BOOL)isOpen{
    if(self = [super init]){
        if (@available(iOS 15.0, *)) {
            self.delegate = delegate;
            self.zoepip_rtcKit = rtcKit;
            self.zoepip_fatherVc = vc;
            self.zoepip_vcType = vcType;
            self.zoepip_isSwiftUI = isSwiftUI;
            self.zoepip_isOpen = isOpen;
            if (isOpen){
                [self setConfig];
            }
        };
    }
    return self;
}


- (void)setConfig{
    if (@available(iOS 15.0, *)) {
        
        self.zoepip_beamMainSize = ZOEPIPMultibeamMainSize(self.zoepip_isSwiftUI);
        self.zoepip_livePkSize = ZOEPIPLivePKMainSize(self.zoepip_isSwiftUI);
        self.zoepip_liveSize = ZOEPIPLiveMainSize(self.zoepip_isSwiftUI);
        self.zoepip_isStartPIP = NO;
        self.zoepip_isPk = NO;
        self.zoepip_isclosePIP = YES;
        self.zoepip_isInBack = NO;
        self.zoepip_lostPiccount = 0;
//        self.zoepip_isNewBack = NO;
        if (!self.zoepip_videoView){
            if(self.zoepip_isSwiftUI){
                self.zoepip_videoView = [[ZOEPIP_SampleBufferRender alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
                [[UIApplication sharedApplication].keyWindow addSubview:self.zoepip_videoView];
                [[UIApplication sharedApplication].keyWindow sendSubviewToBack:self.zoepip_videoView];
            }else{
                self.zoepip_videoView = [[ZOEPIP_SampleBufferRender alloc]initWithFrame:[[UIApplication sharedApplication].delegate window].bounds];
                [[[UIApplication sharedApplication].delegate window] addSubview:self.zoepip_videoView];
                [[[UIApplication sharedApplication].delegate window] sendSubviewToBack:self.zoepip_videoView];
            }
        }
        
        

        if (!self.zoepip_pipController){
            self.zoepip_pipController = [[ZOEPIP_AVPIPController alloc]initWithDisplayView:self.zoepip_videoView];
        }
        if (@available(iOS 14.2, *)) {
            self.zoepip_pipController.zoepip_pipController.canStartPictureInPictureAutomaticallyFromInline = YES;
        }
        self.zoepip_pipController.zoepip_pipController.delegate = self;
        [self.zoepip_rtcKit setDefaultAudioRouteToSpeakerphone:YES];
        [self.zoepip_rtcKit setVideoFrameDelegate:self];
        [self.zoepip_pipController.zoepip_pipController startPictureInPicture];
        self.context = [CIContext contextWithOptions:nil];
        
        __weak typeof(self) weakSelf = self;
        
        if (@available(iOS 11.0, *)) {
            [[NSNotificationCenter defaultCenter] addObserverForName:UIScreenCapturedDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                UIScreen *screen = note.object;
                [strongSelf zoepip_screenshotsWithscreen:screen];
            }];
        } else {
            // Fallback on earlier versions
        }
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [self zoepip_clearLastPicture];
        
    }
}

- (void)handleEnterForeground{
    
    
    if (self.zoepip_isStartPIP){
        self.zoepip_isStartPIP = NO;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self zoepip_stopPIP];

    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.zoepip_isInBack = NO;
    });

}

- (void)handleEnterBackground{
    if (self.zoepip_pipController.zoepip_pipController.isPictureInPictureActive == NO) {
        [self goPIP];
    }
    self.zoepip_isInBack = YES;

}

- (NSMutableArray <NSValue *>*)zoepip_multibeamFrameArr{
    if(!_zoepip_multibeamFrameArr){
        _zoepip_multibeamFrameArr = [[NSMutableArray alloc]initWithObjects:[NSValue valueWithCGRect:CGRectZero],[NSValue valueWithCGRect:CGRectZero],[NSValue valueWithCGRect:CGRectZero],[NSValue valueWithCGRect:CGRectZero],[NSValue valueWithCGRect:CGRectZero],[NSValue valueWithCGRect:CGRectZero],[NSValue valueWithCGRect:CGRectZero],[NSValue valueWithCGRect:CGRectZero], nil];
    }
    return _zoepip_multibeamFrameArr;
}


- (UIImageView *)pipMainView{
    if(!_pipMainView){
        _pipMainView = [[UIImageView alloc]init];
        _pipMainView.clipsToBounds = YES;
        _pipMainView.contentMode = UIViewContentModeScaleAspectFit;
        _pipMainView.backgroundColor = [UIColor clearColor];
    }
    return _pipMainView;
}

- (UIImageView *)zoepip_bgImageView{
    if(!_zoepip_bgImageView){
        _zoepip_bgImageView = [[UIImageView alloc]init];
        _zoepip_bgImageView.clipsToBounds = YES;
        _zoepip_bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _zoepip_bgImageView.backgroundColor = [UIColor clearColor];
    }
    return _zoepip_bgImageView;
}



- (UIImage *)clearImg{
    if(!_clearImg){
        _clearImg = [ZOEPIP_PIPManager imageWithColor:[UIColor clearColor]];
    }
    return _clearImg;
}


- (UIImageView *)zoepip_transitionAniView{
    if(!_zoepip_transitionAniView){
        _zoepip_transitionAniView = [[UIImageView alloc]init];
        _zoepip_transitionAniView.backgroundColor = [UIColor blackColor];
        _zoepip_transitionAniView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _zoepip_screenCoveringPicView;
}

- (UIImageView *)zoepip_screenCoveringPicView{
    if(!_zoepip_screenCoveringPicView){
        _zoepip_screenCoveringPicView = [[UIImageView alloc]init];
        _zoepip_screenCoveringPicView.backgroundColor = [UIColor blackColor];
    }
    return _zoepip_screenCoveringPicView;
}

- (UITextField *)zoepip_screenCaptureTFView{
    if(!_zoepip_screenCaptureTFView){
        _zoepip_screenCaptureTFView = [[UITextField alloc]init];
        _zoepip_screenCaptureTFView.backgroundColor = [UIColor blackColor];
        _zoepip_screenCaptureTFView.secureTextEntry = YES;
        _zoepip_screenCaptureTFView.userInteractionEnabled = NO;
        _zoepip_screenCaptureTFView.subviews.firstObject.userInteractionEnabled = NO;
        [_zoepip_screenCaptureTFView.subviews.firstObject addSubview:self.zoepip_bgImageView];
        [_zoepip_screenCaptureTFView.subviews.firstObject addSubview:self.pipMainView];
        [self.pipMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(_zoepip_screenCaptureTFView);
        }];
        [self.zoepip_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(_zoepip_screenCaptureTFView);
        }];
    }
    return _zoepip_screenCaptureTFView;
}


- (void)zoepip_stopPIP{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.zoepip_pipController.zoepip_pipController.isPictureInPictureActive == YES) {
            [self.zoepip_pipController.zoepip_pipController stopPictureInPicture];;
        }
    });

}

- (void)goPIP{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.zoepip_pipController.zoepip_pipController.isPictureInPictureActive == NO) {
            [self.zoepip_pipController.zoepip_pipController startPictureInPicture];
        }
    });
}


//销毁画中画，vc销毁前、前调用、一定要调不然后面用的时候会唤不起画中画
- (void)zoepip_destroyPIP{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [self.zoepip_rtcKit setVideoFrameDelegate:nil];
    [self.zoepip_pipController zoepip_releasePIP];
    self.zoepip_videoView = nil;
    self.zoepip_pipController = nil;
    self.zoepip_lastImage = nil;
    self.zoepip_multibeamBgImage = nil;
    self.context = nil;
    
}

-(UIImage*)zoepip_captureView:(UIView *)theView{
    CGRect rect = theView.frame;
    if ([theView isKindOfClass:[UIScrollView class]]) {
        rect.size = ((UIScrollView *)theView).contentSize;
        
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//直播间调用、进入pk传yes  退出pk直播穿no
- (void)zoepip_isPK:(BOOL)ispk{
    self.zoepip_isPk = ispk;
    [self zoepip_clearLastPicture];
}

- (void)zoepip_swichOpen:(BOOL)isOpen{
    self.zoepip_isOpen = isOpen;
    if (isOpen){
        [self setConfig];
    }else{
        [self zoepip_destroyPIP];
    }
}

//清除上一帧画面，切直播间或语聊房的时候调用或者重新进入vc时最好调用一下
- (void)zoepip_clearLastPicture{
    if (@available(iOS 15.0, *)) {
        if (!self.zoepip_isOpen){
            return;
        }
        
        self.zoepip_lastImage = nil;
        AgoraOutputVideoFrame * newVideoFrame = [[AgoraOutputVideoFrame alloc]init];
        if (self.zoepip_vcType == ZOEPIP_PIPVCTypeMultibeam){
            newVideoFrame.pixelBuffer = [self zoepip_mergeMultibeamFramePixelBuffer:[ZOEPIP_CVPBufferTool zoepip_getPixelBufferFromUIImage:self.clearImg] withviewIndex:-1 WithUid:-1 channelId:@""];
        }else if (self.zoepip_vcType == ZOEPIP_PIPVCTypeLiveRoom){
            newVideoFrame.pixelBuffer = [self zoepip_mergeLiveRoomPixelBuffer:[ZOEPIP_CVPBufferTool zoepip_getPixelBufferFromUIImage:self.clearImg] withviewIndex:-1 WithUid:-1 channelId:@""];
        }else if (self.zoepip_vcType == ZOEPIP_PIPVCTypePrivateChat){
            newVideoFrame.pixelBuffer = [self zoepip_mergePrivateChatPixelBuffer:[ZOEPIP_CVPBufferTool zoepip_getPixelBufferFromUIImage:self.clearImg] WithUid:-1 channelId:@""];
        }
        newVideoFrame.width = (int)CVPixelBufferGetWidth(newVideoFrame.pixelBuffer);
        newVideoFrame.height = (int)CVPixelBufferGetHeight(newVideoFrame.pixelBuffer);
//        UIImage * img = [ZOEPIP_CVPBufferTool zoepip_getUIImageFromCVPixelBuffer:newVideoFrame.pixelBuffer];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pipMainView.image =  [UIImage imageWithCIImage:self.zoepip_lastImage];
            if (self.zoepip_anyView){
                UIWindow *firstWindow = [UIApplication sharedApplication].windows.firstObject;
                [firstWindow addSubview:self.zoepip_anyView];
                if (self.zoepip_isPk){
                    [self.zoepip_anyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.leading.top.bottom.equalTo(firstWindow);
                        make.trailing.equalTo(firstWindow.mas_centerX);
                    }];
                }else{
                    [self.zoepip_anyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_equalTo(firstWindow);
                    }];
                }
            }
        });
        
        [self.zoepip_videoView zoepip_renderVideoPixelBuffer:newVideoFrame];
    }
}

- (void)zoepip_screenshotsWithscreen:(UIScreen *)screen{
    if (self.zoepip_isStartPIP){
        if(screen.isCaptured) {
            //Do sth...
            UIWindow *firstWindow = [UIApplication sharedApplication].windows.firstObject;
            if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getScreenCoverView)]){
                self.zoepip_screenCoveringView = [self.delegate zoepip_getScreenCoverView];
            }
            if (self.zoepip_screenCoveringView){
                self.zoepip_screenCoveringView.frame = firstWindow.bounds;
                [firstWindow addSubview:self.zoepip_screenCoveringView];
            }else{
                NSString * imgStr = nil;
                if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getScreenCoverImgString)]){
                    imgStr = [self.delegate zoepip_getScreenCoverImgString];
                }
                if (imgStr){
                    if ([imgStr.lowercaseString hasPrefix:@"http"] || [imgStr.lowercaseString hasPrefix:@"https"] ) {
                        [self.zoepip_screenCoveringPicView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil];
                    }else{
                        self.zoepip_screenCoveringPicView.image = [UIImage imageNamed:imgStr];
                    }
                }else{
                    self.zoepip_screenCoveringPicView.frame = firstWindow.bounds;
                    [firstWindow addSubview:self.zoepip_screenCoveringPicView];
                }
                
            }
            
        }else{
            if (self.zoepip_screenCoveringView){
                [self.zoepip_screenCoveringView removeFromSuperview];
            }else{
                [self.zoepip_screenCoveringPicView removeFromSuperview];
            }
            
        }
    }
}


- (CVPixelBufferRef)zoepip_mergeMultibeamFramePixelBuffer:(CVPixelBufferRef)pixelBuffer  withviewIndex:(NSInteger)viewindex WithUid:(NSUInteger)uid channelId:(NSString * _Nonnull)channelId{
    CVPixelBufferRetain(pixelBuffer);
    CGSize mainSize = CGSizeMake(-1, -1);
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getPIPMainWindowSizeWithUid:channelId:)]){
        mainSize  =  [self.delegate zoepip_getPIPMainWindowSizeWithUid:uid channelId:channelId];
    }
    
    if ((mainSize.width == -1 && mainSize.height == -1 ) || CGSizeEqualToSize(mainSize, CGSizeZero)){
        mainSize = self.zoepip_beamMainSize;
    }
    
    CVPixelBufferRef output;
 

    
    output = [ZOEPIP_CVPBufferTool zoepip_creatPixelBufferSameStyleWithOtherPixelBuffer:pixelBuffer withSize:mainSize];
    if (!self.zoepip_isInBack){

        CVPixelBufferRelease(pixelBuffer);
        return output;
    }
    CGSize size = CGSizeMake(CVPixelBufferGetWidth(output), CVPixelBufferGetHeight(output)); // (1)
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    //开辟像素区域
    UInt32 *imagePiexl = (UInt32 *)calloc(size.width*size.height, sizeof(UInt32));


//        //创建上下文
    CGContextRef contextRef = CGBitmapContextCreate(NULL,
                                                    size.width,
                                                    size.height,
                                                            8,
                                                            4*size.width,
                                                            colorSpaceRef,
                                                            kCGImageAlphaPremultipliedLast);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.0);
    CGContextFillRect(contextRef, CGRectMake(0, 0, size.width, size.height));

    if (self.zoepip_lastImage){
        CGContextDrawImage(contextRef, CGRectMake(0, 0, size.width, size.height), self.zoepip_lastImage.CGImage);
    }

 
    CGImageRef imageRef =  [ZOEPIP_CVPBufferTool zoepip_getCGImageFromCVPixelBuffer:pixelBuffer];;
    __block CGRect viewFrame = CGRectZero;
    
    
    if (viewindex >= 0 && viewindex <=7){
        viewFrame = [self.zoepip_multibeamFrameArr[viewindex] CGRectValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (CGRectEqualToRect(viewFrame, CGRectZero)){
                if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getPIPViewFrameWithUid:channelId:)]){
                    viewFrame  =  [self.delegate zoepip_getPIPViewFrameWithUid:uid channelId:channelId];
                    viewFrame = CGRectMake(viewFrame.origin.x * 0.8, viewFrame.origin.y * 0.8 , viewFrame.size.width * 0.8, viewFrame.size.height * 0.8);
                    viewFrame = CGRectMake(viewFrame.origin.x , size.height -  viewFrame.origin.y - viewFrame.size.height , viewFrame.size.width , viewFrame.size.height);
                    [self.zoepip_multibeamFrameArr replaceObjectAtIndex:viewindex withObject:[NSValue valueWithCGRect:viewFrame]];
                }
            }
        });
    }

    CGFloat imageRefW = (CGFloat)CGImageGetWidth(imageRef);
    CGFloat imageRefH = (CGFloat)CGImageGetHeight(imageRef);
    
    CGFloat winScale = viewFrame.size.width/viewFrame.size.height;
    CGFloat refScale = imageRefW/imageRefH;
    if (winScale > refScale){
        CGFloat newH = imageRefW*viewFrame.size.height/viewFrame.size.width;
        CGFloat newy = (imageRefH - newH)/2;
        CGImageRef finalImageRef =CGImageCreateWithImageInRect(imageRef,CGRectMake(0,newy, imageRefW, newH));
        CGImageRelease(imageRef);
        imageRef = finalImageRef;
    }

    if (winScale < refScale ){
        CGFloat newW = imageRefH*winScale;
        CGFloat newx = (imageRefW - newW)/2;
        CGImageRef finalImageRef =CGImageCreateWithImageInRect(imageRef,CGRectMake(newx,0, newW, imageRefH));
        CGImageRelease(imageRef);
        imageRef = finalImageRef;
    }
    

    CGContextDrawImage(contextRef, viewFrame, imageRef);


    CGImageRef resultRef = CGBitmapContextCreateImage(contextRef);
    CIImage * image = [[CIImage alloc]initWithCGImage:resultRef];
    
      
//    [self.context render:image toCVPixelBuffer:output];
    self.zoepip_lastImage = image;
            //释放用过的内存
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    free(imagePiexl);
    CGImageRelease(imageRef);
    CGImageRelease(resultRef);
    CVPixelBufferRelease(pixelBuffer);
    return output;
}





- (CVPixelBufferRef)zoepip_mergeMultibeamPixelBuffer:(CVPixelBufferRef)pixelBuffer  withviewIndex:(NSInteger)viewindex WithUid:(NSUInteger)uid channelId:(NSString * _Nonnull)channelId{
    CVPixelBufferRetain(pixelBuffer);
    CGSize mainSize = CGSizeMake(-1, -1);
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getPIPMainWindowSizeWithUid:channelId:)]){
        mainSize  =  [self.delegate zoepip_getPIPMainWindowSizeWithUid:uid channelId:channelId];
    }
    
    if ((mainSize.width == -1 && mainSize.height == -1 ) || CGSizeEqualToSize(mainSize, CGSizeZero)){
        mainSize = CGSizeMake(900, 900);
    }
    
    CVPixelBufferRef output;
    

    
    output = [ZOEPIP_CVPBufferTool zoepip_creatPixelBufferSameStyleWithOtherPixelBuffer:pixelBuffer withSize:mainSize];
    if (!self.zoepip_isInBack){

        CVPixelBufferRelease(pixelBuffer);
        return output;
    }
    CGSize size = CGSizeMake(CVPixelBufferGetWidth(output), CVPixelBufferGetHeight(output)); // (1)
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //开辟像素区域
    UInt32 *imagePiexl = (UInt32 *)calloc(size.width*size.height, sizeof(UInt32));
        //创建上下文
    CGContextRef contextRef = CGBitmapContextCreate(imagePiexl,
                                                    size.width,
                                                    size.height,
                                                            8,
                                                            4*size.width,
                                                            colorSpaceRef,
                                                            kCGImageAlphaNoneSkipLast);
                //设置大图上下文背景填充颜色（这里是黑色）
                CGContextSetFillColorWithColor(contextRef, [UIColor clearColor].CGColor);
                //设置大图上下文背景填充区域（全部区域）
                CGContextFillRect(contextRef, CGRectMake(0, 0, size.width, size.height));
    
    
    
    if (self.zoepip_lastImage){
        CGContextDrawImage(contextRef, CGRectMake(0, 0, size.width, size.height), self.zoepip_lastImage.CGImage);
    }
    
    CGImageRef imageRef =  [ZOEPIP_CVPBufferTool zoepip_getCGImageFromCVPixelBuffer:pixelBuffer];;
  __block  CGSize viewSize = CGSizeMake(-1, -1);
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getPIPViewSizeWithUid:channelId:)]){
        viewSize  =  [self.delegate zoepip_getPIPViewSizeWithUid:uid channelId:channelId];
    }
    
        if ((viewSize.width == -1 && viewSize.height == -1 ) || CGSizeEqualToSize(viewSize, CGSizeZero)){

            viewSize = ZOEPIPMultibeamViewSize();
    }
    
    NSUInteger width = viewSize.width!=-1?viewSize.width: CGImageGetWidth(imageRef);
    NSUInteger height = viewSize.height!=-1?viewSize.height:CGImageGetHeight(imageRef);
    if(viewindex == 0){
        CGContextDrawImage(contextRef, CGRectMake(0, mainSize.height - height, width, height), imageRef);

    }else if (viewindex == 1){
        CGContextDrawImage(contextRef, CGRectMake(mainSize.width - (width * 2), mainSize.height - height, width, height), imageRef);

    }else{
        if (viewindex >= 2 && viewindex <=4 ){
            CGContextDrawImage(contextRef, CGRectMake( (viewindex - 2) * width, mainSize.height - (height * 2), width, height), imageRef);
        }else{
            CGContextDrawImage(contextRef, CGRectMake( (viewindex - 5) * width, mainSize.height - (height * 3), width, height), imageRef);
        }
    }

    CGImageRef resultRef = CGBitmapContextCreateImage(contextRef);
    CIImage * image = [[CIImage alloc]initWithCGImage:resultRef];
    [self.context render:image toCVPixelBuffer:output];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    

            //释放用过的内存
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    free(imagePiexl);
    CGImageRelease(imageRef);
    CGImageRelease(resultRef);
    CVPixelBufferRelease(pixelBuffer);
    return output;
}

- (CVPixelBufferRef)zoepip_mergeLiveRoomPixelBuffer:(CVPixelBufferRef)pixelBuffer  withviewIndex:(NSInteger)viewindex WithUid:(NSUInteger)uid channelId:(NSString * _Nonnull)channelId{
    if (self.zoepip_isPk){
        CVPixelBufferRetain(pixelBuffer);
        CGSize mainSize = CGSizeMake(-1, -1);
        if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getPIPMainWindowSizeWithUid:channelId:)]){
            mainSize  =  [self.delegate zoepip_getPIPMainWindowSizeWithUid:uid channelId:channelId];
        }
        
        if ((mainSize.width == -1 && mainSize.height == -1 ) || CGSizeEqualToSize(mainSize, CGSizeZero)){
            mainSize = self.zoepip_livePkSize;
        }
        
        CVPixelBufferRef output;
        output = [ZOEPIP_CVPBufferTool zoepip_creatPixelBufferSameStyleWithOtherPixelBuffer:pixelBuffer withSize:mainSize];
        if (!self.zoepip_isInBack){

            CVPixelBufferRelease(pixelBuffer);
            return output;
        }
        CGSize size = CGSizeMake(CVPixelBufferGetWidth(output), CVPixelBufferGetHeight(output)); // (1)
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        //开辟像素区域
        UInt32 *imagePiexl = (UInt32 *)calloc(size.width*size.height, sizeof(UInt32));
            //创建上下文
        CGContextRef contextRef = CGBitmapContextCreate(NULL,
                                                        size.width,
                                                        size.height,
                                                                8,
                                                                4*size.width,
                                                                colorSpaceRef,
                                                                kCGImageAlphaPremultipliedLast);
        CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.0);
        CGContextFillRect(contextRef, CGRectMake(0, 0, size.width, size.height));
        
        if (self.zoepip_lastImage){
            CGContextDrawImage(contextRef, CGRectMake(0, 0, size.width, size.height), self.zoepip_lastImage.CGImage);
        }
        

        CGImageRef imageRef =  [ZOEPIP_CVPBufferTool zoepip_getCGImageFromCVPixelBuffer:pixelBuffer];
        CGFloat imageRefW = (CGFloat)CGImageGetWidth(imageRef);
        CGFloat imageRefH = (CGFloat)CGImageGetHeight(imageRef);
        
        CGFloat winScale = (size.width/2)/size.height;
        CGFloat refScale = imageRefW/imageRefH;
        if (winScale > refScale){
            CGFloat newH = imageRefW*size.height/(size.width/2);
            CGFloat newy = (imageRefH - newH)/2;
            CGImageRef finalImageRef =CGImageCreateWithImageInRect(imageRef,CGRectMake(0,newy, imageRefW, newH));
            CGImageRelease(imageRef);
            imageRef = finalImageRef;
        }

        if (winScale < refScale ){
            CGFloat newW = imageRefH*winScale;
            CGFloat newx = (imageRefW - newW)/2;
            CGImageRef finalImageRef =CGImageCreateWithImageInRect(imageRef,CGRectMake(newx,0, newW, imageRefH));
            CGImageRelease(imageRef);
            imageRef = finalImageRef;
        }
        CGSize viewSize = CGSizeMake(-1, -1);
        if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getPIPViewSizeWithUid:channelId:)]){
            viewSize  =  [self.delegate zoepip_getPIPViewSizeWithUid:uid channelId:channelId];
        }
        
        if ((viewSize.width == -1 && viewSize.height == -1 ) || CGSizeEqualToSize(viewSize, CGSizeZero)){
            viewSize = CGSizeMake(size.width/2, size.height);
        }
        
        NSUInteger width = viewSize.width;
        NSUInteger height = viewSize.height;
        if(viewindex == 0){
            CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);

        }else if (viewindex == 1){
            CGContextDrawImage(contextRef, CGRectMake(width, 0, width, height), imageRef);

        }

        CGImageRef resultRef = CGBitmapContextCreateImage(contextRef);
        CIImage * image = [[CIImage alloc]initWithCGImage:resultRef];
//        [self.context render:image toCVPixelBuffer:output];
        self.zoepip_lastImage = image;

                //释放用过的内存
        CGContextRelease(contextRef);
        CGColorSpaceRelease(colorSpaceRef);
        free(imagePiexl);
        CGImageRelease(imageRef);
        CGImageRelease(resultRef);
        CVPixelBufferRelease(pixelBuffer);
        return output;
    }else{
        if (viewindex == 0){
            return [self zoepip_mergePrivateChatPixelBuffer:pixelBuffer WithUid:uid channelId:channelId];
        }else{
            CGSize mainSize = CGSizeMake(CVPixelBufferGetWidth(pixelBuffer) , CVPixelBufferGetHeight(pixelBuffer));
            CVPixelBufferRef output = [ZOEPIP_CVPBufferTool zoepip_creatPixelBufferSameStyleWithOtherPixelBuffer:pixelBuffer withSize:mainSize];
            return [self zoepip_mergePrivateChatPixelBuffer:output WithUid:uid channelId:channelId];
        }
    }
}

- (CVPixelBufferRef)zoepip_mergePrivateChatPixelBuffer:(CVPixelBufferRef)pixelBuffer WithUid:(NSUInteger)uid channelId:(NSString * _Nonnull)channelId{
    CVPixelBufferRetain(pixelBuffer);
    CGSize mainSize = CGSizeMake(-1, -1);
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getPIPMainWindowSizeWithUid:channelId:)]){
        mainSize  =  [self.delegate zoepip_getPIPMainWindowSizeWithUid:uid channelId:channelId];
    }
    
    if ((mainSize.width == -1 && mainSize.height == -1 ) || CGSizeEqualToSize(mainSize, CGSizeZero)){
        mainSize = self.zoepip_liveSize;
    }
    
    CVPixelBufferRef output;
    

    output = [ZOEPIP_CVPBufferTool zoepip_creatPixelBufferSameStyleWithOtherPixelBuffer:pixelBuffer withSize:mainSize];
    

    if (!self.zoepip_isInBack){

        CVPixelBufferRelease(pixelBuffer);
        return output;
    }
    
    CGSize size = CGSizeMake(CVPixelBufferGetWidth(output), CVPixelBufferGetHeight(output)); // (1)
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //开辟像素区域
    UInt32 *imagePiexl = (UInt32 *)calloc(size.width*size.height, sizeof(UInt32));
        //创建上下文
    CGContextRef contextRef = CGBitmapContextCreate(NULL,
                                                    size.width,
                                                    size.height,
                                                            8,
                                                            4*size.width,
                                                            colorSpaceRef,
                                                            kCGImageAlphaPremultipliedLast);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.0);
    CGContextFillRect(contextRef, CGRectMake(0, 0, size.width, size.height));
    
    if (self.zoepip_lastImage){
        CGContextDrawImage(contextRef, CGRectMake(0, 0, size.width, size.height), self.zoepip_lastImage.CGImage);
    }
    


    

    CGImageRef imageRef =  [ZOEPIP_CVPBufferTool zoepip_getCGImageFromCVPixelBuffer:pixelBuffer];
    CGFloat imageRefW = (CGFloat)CGImageGetWidth(imageRef);
    CGFloat imageRefH = (CGFloat)CGImageGetHeight(imageRef);
    
    CGFloat winScale = size.width/size.height;
    CGFloat refScale = imageRefW/imageRefH;
    if (winScale > refScale){
        CGFloat newH = imageRefW*size.height/size.width;
        CGFloat newy = (imageRefH - newH)/2;
        CGImageRef finalImageRef =CGImageCreateWithImageInRect(imageRef,CGRectMake(0,newy, imageRefW, newH));
        CGImageRelease(imageRef);
        imageRef = finalImageRef;
    }

    if (winScale < refScale ){
        CGFloat newW = imageRefH*winScale;
        CGFloat newx = (imageRefW - newW)/2;
        CGImageRef finalImageRef =CGImageCreateWithImageInRect(imageRef,CGRectMake(newx,0, newW, imageRefH));
        CGImageRelease(imageRef);
        imageRef = finalImageRef;
    }
    CGSize viewSize = CGSizeMake(-1, -1);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getPIPViewSizeWithUid:channelId:)]){
        viewSize  =  [self.delegate zoepip_getPIPViewSizeWithUid:uid channelId:channelId];
    }
    if ((viewSize.width == -1 && viewSize.height == -1 ) || CGSizeEqualToSize(viewSize, CGSizeZero)){
        viewSize = CGSizeMake(size.width, size.height);
    }
    
    NSUInteger width = viewSize.width;
    NSUInteger height = viewSize.height;
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef resultRef = CGBitmapContextCreateImage(contextRef);
    CIImage * image = [[CIImage alloc]initWithCGImage:resultRef];
//    [self.context render:image toCVPixelBuffer:output];
    self.zoepip_lastImage = image;

            //释放用过的内存
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    free(imagePiexl);
    CGImageRelease(imageRef);
    CGImageRelease(resultRef);
    CVPixelBufferRelease(pixelBuffer);
    return output;
}


#pragma mark - AgoraRtcEngineDelegate
- (BOOL)onCaptureVideoFrame:(AgoraOutputVideoFrame * _Nonnull)videoFrame{
    return YES;
}

- (AgoraVideoFormat)getVideoFormatPreference{
    return AgoraVideoFormatCVPixelBGRA;
}

- (BOOL)getRotationApplied{
    return YES;

}
- (BOOL)onRenderVideoFrame:(AgoraOutputVideoFrame * _Nonnull)videoFrame uid:(NSUInteger)uid channelId:(NSString * _Nonnull)channelId {
    
    if (!self){
        return NO;
    }
    
    
    if(self.zoepip_vcType == ZOEPIP_PIPVCTypeMultibeam){
        if(self.zoepip_lostPiccount == 2){
            self.zoepip_lostPiccount = 0;
            return YES;
        }
        self.zoepip_lostPiccount = self.zoepip_lostPiccount + 1;
    }
    
    NSInteger viewIndex = -1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getPIPViewIndexWithUid:channelId:)]){
        viewIndex  =  [self.delegate zoepip_getPIPViewIndexWithUid:uid channelId:channelId];
    }
    
    
    AgoraOutputVideoFrame * newVideoFrame = [[AgoraOutputVideoFrame alloc]init];
    newVideoFrame.width = videoFrame.width;
    newVideoFrame.height = videoFrame.height;
    if (self.zoepip_vcType == ZOEPIP_PIPVCTypeMultibeam){
        newVideoFrame.pixelBuffer = [self zoepip_mergeMultibeamFramePixelBuffer:videoFrame.pixelBuffer withviewIndex:viewIndex WithUid:uid channelId:channelId];

    }else if (self.zoepip_vcType == ZOEPIP_PIPVCTypeLiveRoom){
        newVideoFrame.pixelBuffer = [self zoepip_mergeLiveRoomPixelBuffer:videoFrame.pixelBuffer withviewIndex:viewIndex WithUid:uid channelId:channelId];

    }else if (self.zoepip_vcType == ZOEPIP_PIPVCTypePrivateChat){
        newVideoFrame.pixelBuffer = [self zoepip_mergePrivateChatPixelBuffer:videoFrame.pixelBuffer WithUid:uid channelId:channelId];

    }
    newVideoFrame.width = (int)CVPixelBufferGetWidth(newVideoFrame.pixelBuffer);
    newVideoFrame.height = (int)CVPixelBufferGetHeight(newVideoFrame.pixelBuffer);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pipMainView.image = [UIImage imageWithCIImage:self.zoepip_lastImage];
        if (self.zoepip_anyView){
            UIWindow *firstWindow = [UIApplication sharedApplication].windows.firstObject;
            [firstWindow addSubview:self.zoepip_anyView];
            if (self.zoepip_isPk){
                [self.zoepip_anyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.top.bottom.equalTo(firstWindow);
                    make.trailing.equalTo(firstWindow.mas_centerX);
                }];
            }else{
                [self.zoepip_anyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(firstWindow);
                }];
            }
        }
    });
    
    [self.zoepip_videoView zoepip_renderVideoPixelBuffer:newVideoFrame];
    
    return YES;
}


#pragma mark - AVPictureInPictureControllerDelegate


- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    self.zoepip_isInBack = NO;
    self.zoepip_isStartPIP = YES;
    self.zoepip_isclosePIP = YES;
    // 注意是 first window，不是 last window 也不是 key window
    UIWindow *firstWindow = [UIApplication sharedApplication].windows.firstObject;
    [firstWindow addSubview:self.zoepip_screenCaptureTFView];

    [self.zoepip_screenCaptureTFView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(firstWindow);
    }];
    
    
    UIScreen * sc = [UIScreen mainScreen];
     if (@available(iOS 11.0, *)) {
         [self zoepip_screenshotsWithscreen:sc];
     }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_getAnyViewAddtoPIPWithWindowFrame:)]){
        self.zoepip_anyView =  [self.delegate zoepip_getAnyViewAddtoPIPWithWindowFrame:firstWindow.bounds];
        [firstWindow addSubview:self.zoepip_anyView];
        if (self.zoepip_isPk){
            [self.zoepip_anyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.bottom.equalTo(firstWindow);
                make.trailing.equalTo(firstWindow.mas_centerX);
            }];
        }else{
            [self.zoepip_anyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(firstWindow);
            }];
        }
    }
}

- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {

}


- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{


}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    self.zoepip_isStartPIP = NO;
    [self.zoepip_anyView removeFromSuperview];
    self.zoepip_anyView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_finishAnyViewRemovetoPIP)]){
        [self.delegate zoepip_finishAnyViewRemovetoPIP];
    }
    if (self.zoepip_isInBack){
        if (self.zoepip_isclosePIP){
            if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_closePIPWindowInBackMode)]){
                [self.delegate zoepip_closePIPWindowInBackMode];
            }
        }
    }


}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler{
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoepip_finishPIPGoBigSizeView)]){
        [self.delegate zoepip_finishPIPGoBigSizeView];
    }

    self.zoepip_isclosePIP = NO;
}


#pragma  make tool

+ (UIImage *)imageWithColor:(UIColor *)color {

    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);

    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    
    return image;

}

- (void)setZoepip_multibeamBgImage:(UIImage *)zoepip_multibeamBgImage{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.zoepip_bgImageView.image = zoepip_multibeamBgImage;
    });
    _zoepip_multibeamBgImage = nil;;
}

- (void)setZoepip_isInBack:(BOOL)zoepip_isInBack{
    _zoepip_isInBack = zoepip_isInBack;

}


@end
