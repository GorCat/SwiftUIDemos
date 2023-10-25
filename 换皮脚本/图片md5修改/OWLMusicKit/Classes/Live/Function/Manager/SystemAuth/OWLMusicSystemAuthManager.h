//
//  OWLMusicSystemAuthManager.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 当前权限状态枚举
typedef NS_ENUM(NSUInteger, XYLSystemAuthStatusType) {
    XYLSystemAuthStatusTypeNotDetermined,      //未选择
    XYLSystemAuthStatusTypeAuthorized,      //授权
    XYLSystemAuthStatusTypeDenied,        //拒绝授权
    XYLSystemAuthStatusTypeUnidentified,  //未识别
    XYLSystemAuthStatusTypeLimited // 用户已授权此应用程序进行有限照片库访问
};

#define OWLMusicSystemAuthShared [OWLMusicSystemAuthManager sharedInstance]

@interface OWLMusicSystemAuthManager : NSObject

#pragma mark - 单例
+ (instancetype)sharedInstance;

#pragma mark - 麦克风、语音权限检查
/// 检查请求相机权限
/// - Parameter completion: 回调
- (void)xyf_checkHasCameraAuth:(void(^)(BOOL succeed))completion;


/// 检查请求麦克风权限
/// - Parameter completion: 回调
- (void)xyf_checkHasAudioAuth:(void(^)(BOOL succeed))completion;


#pragma mark - 打开相册
/// 打开相册
- (void)xyf_openAlbum:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
