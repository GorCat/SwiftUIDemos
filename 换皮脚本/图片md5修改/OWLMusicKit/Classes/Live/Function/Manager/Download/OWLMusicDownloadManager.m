//
//  OWLMusicDownloadManager.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/29.
//

#import "OWLMusicDownloadManager.h"

@implementation OWLMusicDownloadManager

+(void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [OWLMusicDownloadManager xyf_creatdirAtPath:kXYLDownloadPathPag];
    });
}

+ (instancetype)sharedInstance {
    static OWLMusicDownloadManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc]init];
    });
    return _sharedInstance;
}

/// 下载单个文件
+ (void)xyf_downloadWithUrl:(NSString *)xyp_urlStr
                    fileDir:(NSString *)xyp_fileDir
                    success:(XYLDownloadFileSuccess)xyp_success
                    failure:(XYLDownloadFileFailed)xyp_failure {

    if([self xyf_fileExistsAtPath:xyp_fileDir]){
        if(xyp_success){xyp_success(xyp_fileDir);}
        return;
    }
    // 创建下载路径
    NSURL *url = [NSURL URLWithString:xyp_urlStr];
    // 创建NSURLRequest请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 30;
    // 创建NSURLSession对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 创建下载任务
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if(error){
            if(xyp_failure){xyp_failure(error);}
        }else{
            // 移动文件到新路径 其中location为下载的临时文件路径（下载的文件存在沙盒，需要我们手动处理到指定文件夹）
            [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:xyp_fileDir error:nil];
            if(xyp_success){
                xyp_success(xyp_fileDir);
            }
        }
    }];

    // 开始下载任务
    [downloadTask resume];
}


+ (BOOL)xyf_creatdirAtPath:(NSString *)path{
    if(![self xyf_fileExistsAtPath:path]){
        NSError * error;
        return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }else{
        return NO;
    }
}

/// 根据路径判断文件是否存在
+ (BOOL)xyf_fileExistsAtPath:(NSString *)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

@end
