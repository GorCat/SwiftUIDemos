//
//  OWLMusicSystemAuthManager.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/7.
//

#import "OWLMusicSystemAuthManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation OWLMusicSystemAuthManager

+ (instancetype)sharedInstance {
    static OWLMusicSystemAuthManager *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

#pragma mark - Public Method
- (void)xyf_checkAndRequestAuthorition:(XYLSystemAuthType)type checkHandler:(void(^)(XYLSystemAuthStatusType status,BOOL isAuthorized))checkHandler requestHandler:(void(^)(XYLSystemAuthStatusType status,BOOL isAuthorized))requestHandler{
    switch (type) {
            //相册
        case XYLSystemAuthTypePhotoLibrary:
        {
            XYLSystemAuthStatusType status = [self requestPhotoLibraryHander:requestHandler];
            if (status != XYLSystemAuthStatusTypeNotDetermined) {
                checkHandler(status,status == XYLSystemAuthStatusTypeAuthorized);
            }
        }
            break;
            //相机
        case XYLSystemAuthTypeCamera:
        {
            XYLSystemAuthStatusType status = [self requestCameraHander:requestHandler];
            if (status != XYLSystemAuthStatusTypeNotDetermined) {
                checkHandler(status,status == XYLSystemAuthStatusTypeAuthorized);
            }
        }
            break;
            //麦克风
        case XYLSystemAuthTypeAudio:
        {
            XYLSystemAuthStatusType status = [self requestAudioHander:requestHandler];
            if (status != XYLSystemAuthStatusTypeNotDetermined) {
                checkHandler(status,status == XYLSystemAuthStatusTypeAuthorized);
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private Method
#pragma mark - 请求权限
//请求相册权限
- (XYLSystemAuthStatusType)requestPhotoLibraryHander:(void(^)(XYLSystemAuthStatusType stauts, BOOL isAuthorized))handler {
    XYLSystemAuthStatusType photoLibraryStatus = [self checkPhotoLibrary];
    if (photoLibraryStatus == XYLSystemAuthStatusTypeNotDetermined) {
        
        if (@available(iOS 14, *)) {
            PHAccessLevel level = PHAccessLevelReadWrite;
            [PHPhotoLibrary requestAuthorizationForAccessLevel:level handler:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusNotDetermined) {
                        handler(XYLSystemAuthStatusTypeNotDetermined,NO);
                    } else if (status == PHAuthorizationStatusAuthorized) {
                        handler(XYLSystemAuthStatusTypeAuthorized,YES);
                    } else if (status == PHAuthorizationStatusLimited) {
                        handler(XYLSystemAuthStatusTypeLimited,NO);
                    } else {
                        handler(XYLSystemAuthStatusTypeDenied,NO);
                    }
                });
            }];
                    
        } else {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusNotDetermined) {
                        handler(XYLSystemAuthStatusTypeNotDetermined,NO);
                    } else if (status == PHAuthorizationStatusAuthorized) {
                        handler(XYLSystemAuthStatusTypeAuthorized,YES);
                    } else {
                        handler(XYLSystemAuthStatusTypeDenied,NO);
                    }
                });
            }];
        }
        
    }
    return photoLibraryStatus;
}

//请求相机权限
- (XYLSystemAuthStatusType)requestCameraHander:(void(^)(XYLSystemAuthStatusType stauts,BOOL isAuthorized))handler {
    XYLSystemAuthStatusType cameraStatus = [self checkCamera];
    if (cameraStatus == XYLSystemAuthStatusTypeNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    handler(XYLSystemAuthStatusTypeAuthorized,granted);
                } else {
                    handler(XYLSystemAuthStatusTypeDenied,granted);
                }
            });
        }];
    }
    return cameraStatus;
}

//请求麦克风权限
- (XYLSystemAuthStatusType)requestAudioHander:(void(^)(XYLSystemAuthStatusType stauts,BOOL isAuthorized))handler {
    XYLSystemAuthStatusType status = [self checkAudio];
    if (status == XYLSystemAuthStatusTypeNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    handler(XYLSystemAuthStatusTypeAuthorized,granted);
                } else {
                    handler(XYLSystemAuthStatusTypeDenied,granted);
                }
            });
        }];
    }
    return status;
}

#pragma mark - 权限状态
//检查相册权限状态
- (XYLSystemAuthStatusType)checkPhotoLibrary {
    
    if (@available(iOS 14, *)) {
        PHAccessLevel level = PHAccessLevelReadWrite;
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:level];
        
        if (status == PHAuthorizationStatusNotDetermined) {
            return XYLSystemAuthStatusTypeNotDetermined;
        } else if (status == PHAuthorizationStatusAuthorized) {
            return XYLSystemAuthStatusTypeAuthorized;
        } else if (status == PHAuthorizationStatusLimited) {
            return XYLSystemAuthStatusTypeLimited;
        } else {
            return XYLSystemAuthStatusTypeDenied;
        }
        
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusNotDetermined) {
            return XYLSystemAuthStatusTypeNotDetermined;
        } else if (status == PHAuthorizationStatusAuthorized) {
            return XYLSystemAuthStatusTypeAuthorized;
        } else {
            return XYLSystemAuthStatusTypeDenied;
        }
    }
}

//检查相机权限状态
- (XYLSystemAuthStatusType)checkCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        return XYLSystemAuthStatusTypeNotDetermined;
    } else if (status == AVAuthorizationStatusAuthorized) {
        return XYLSystemAuthStatusTypeAuthorized;
    } else {
        return XYLSystemAuthStatusTypeDenied;
    }
}

//检查麦克风权限状态
- (XYLSystemAuthStatusType)checkAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined) {
        return XYLSystemAuthStatusTypeNotDetermined;
    } else if (status == AVAuthorizationStatusAuthorized) {
        return XYLSystemAuthStatusTypeAuthorized;
    } else {
        return XYLSystemAuthStatusTypeDenied;
    }
}


- (void)xyf_showRefuseView:(XYLSystemAuthType)type {
    NSString *message;
    switch (type) {
        //相册
        case XYLSystemAuthTypePhotoLibrary:
            message = kXYLLocalString(@"Please allow the access of your photos in the \"Settings - Privacy - Photos\" option");
            break;
        //相机
        case XYLSystemAuthTypeCamera:
            message = kXYLLocalString(@"Please allow the access of your camera in the \"Settings - Privacy - Camera\" option");
            break;
            //麦克风
        case XYLSystemAuthTypeAudio:
            message = kXYLLocalString(@"Please allow the access of your microphone in the \"Settings - Privacy - Microphone\" option");
            break;
        default:
            break;
    }
    
    if (OWLJConvertToolShared.xyf_isJustMain) {
        NSString *text = message;
        if (OWLBGMModuleManagerShared.dataSource && [OWLBGMModuleManagerShared.dataSource respondsToSelector:@selector(xyf_outsideModuleGetRefuseAuthErrorTip:)]) {
            text = [OWLBGMModuleManagerShared.dataSource xyf_outsideModuleGetRefuseAuthErrorTip:type];
        }
        if (text.length <= 0) { text = message; }
        [OWLJConvertToolShared xyf_showNotiTip:message];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kXYLLocalString(@"Alert") message:[NSString stringWithFormat:@"%@",message] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kXYLLocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kXYLLocalString(@"Setting") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [OWLJConvertToolShared.xyf_getCurrentVC presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 麦克风、语音权限检查
/// 检查请求相机权限
/// - Parameter completion: 回调
- (void)xyf_checkHasCameraAuth:(void(^)(BOOL succeed))completion {
    [self xyf_checkAndRequestAuthorition:XYLSystemAuthTypeCamera checkHandler:^(XYLSystemAuthStatusType status, BOOL isAuthorized) {
        if (completion) { completion(isAuthorized); }
        if (!isAuthorized) { [self xyf_showRefuseView:XYLSystemAuthTypeCamera]; }
    } requestHandler:^(XYLSystemAuthStatusType status, BOOL isAuthorized) {
        if (completion) { completion(isAuthorized); }
        if (!isAuthorized) { [self xyf_showRefuseView:XYLSystemAuthTypeCamera]; }
    }];
}

/// 检查请求麦克风权限
/// - Parameter completion: 回调
- (void)xyf_checkHasAudioAuth:(void(^)(BOOL succeed))completion {
    [self xyf_checkAndRequestAuthorition:XYLSystemAuthTypeAudio checkHandler:^(XYLSystemAuthStatusType status, BOOL isAuthorized) {
        if (completion) { completion(isAuthorized); }
        if (!isAuthorized) { [self xyf_showRefuseView:XYLSystemAuthTypeAudio]; }
    } requestHandler:^(XYLSystemAuthStatusType status, BOOL isAuthorized) {
        if (completion) { completion(isAuthorized); }
        if (!isAuthorized) { [self xyf_showRefuseView:XYLSystemAuthTypeAudio]; }
    }];
}

#pragma mark - 打开相册
/// 打开相册
- (void)xyf_openAlbum:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate {
    [self xyf_checkAndRequestAuthorition:XYLSystemAuthTypePhotoLibrary checkHandler:^(XYLSystemAuthStatusType status, BOOL isAuthorized) {
        if (isAuthorized) {
            [self xyf_presentPhotoVC:delegate];
        } else {
            [self xyf_showRefuseView:XYLSystemAuthTypePhotoLibrary];
        }
    } requestHandler:^(XYLSystemAuthStatusType status, BOOL isAuthorized) {
        if (isAuthorized) {
            [self xyf_presentPhotoVC:delegate];
        } else {
            [self xyf_showRefuseView:XYLSystemAuthTypePhotoLibrary];
        }
    }];
}

/// 展示相册vc
- (void)xyf_presentPhotoVC:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.allowsEditing = NO;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    controller.mediaTypes = mediaTypes;
    controller.delegate = delegate;
    controller.videoQuality = UIImagePickerControllerQualityTypeLow;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [OWLJConvertToolShared.xyf_getCurrentVC presentViewController:controller animated:YES completion:^{
        
    }];
}


@end
