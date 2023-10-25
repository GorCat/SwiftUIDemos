//
//  OWLMusicEntryEffectPushMsg.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/29.
//

#import "OWLMusicEntryEffectPushMsg.h"
#import "OWLMusicDownloadManager.h"

@implementation OWLMusicEntryEffectPushMsg

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_userId": @"userId",
        @"dsb_userName": @"userName",
        @"dsb_avater": @"avater",
        @"dsb_effectUrl": @"effectUrl",
        @"dsb_roomId": @"roomId",
        @"dsb_hostId": @"hostId"
    };
}

- (void)xyf_getFilePath:(void (^)(  NSString * _Nullable p ))completion {
    if(self.dsb_effectUrl.length == 0){
        if(completion){
            completion(nil);
        }
        return;
    }
    
    NSString * path = [kXYLDownloadPathPag stringByAppendingPathComponent:[self.dsb_effectUrl xyf_md5]];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        if(completion){
            completion(path);
        }
        return ;
    }
    [OWLMusicDownloadManager xyf_downloadWithUrl:self.dsb_effectUrl fileDir:path success:^(NSString * _Nonnull filePath) {
        if(completion){
            completion(filePath);
        }
    }failure:^(NSError * _Nonnull error) {
        if(completion){
            completion(nil);
        }
    }];
}

@end
