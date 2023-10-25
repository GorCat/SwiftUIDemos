//
//  OWLMusicDownloadManager.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 下载成功block
typedef void(^ _Nullable XYLDownloadFileSuccess)(NSString * path);
/// 下载失败block
typedef void(^ _Nullable XYLDownloadFileFailed)(NSError * error);

@interface OWLMusicDownloadManager : NSObject

+ (instancetype)sharedInstance;

/// 下载单个文件
+ (void)xyf_downloadWithUrl:(NSString *)xyp_urlStr
                    fileDir:(NSString *)xyp_fileDir
                    success:(XYLDownloadFileSuccess)xyp_success
                    failure:(XYLDownloadFileFailed)xyp_failure;

@end

NS_ASSUME_NONNULL_END
