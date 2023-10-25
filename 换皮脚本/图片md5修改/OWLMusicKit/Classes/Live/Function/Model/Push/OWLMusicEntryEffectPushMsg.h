//
//  OWLMusicEntryEffectPushMsg.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/29.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicEntryEffectPushMsg : OWLBGMModuleBaseModel

@property (nonatomic, assign) NSInteger dsb_userId;

@property (nonatomic, copy) NSString *dsb_userName;

@property (nonatomic, copy) NSString *dsb_avater;

@property (nonatomic, copy) NSString *dsb_effectUrl;

@property (nonatomic, assign) NSInteger dsb_roomId;

@property (nonatomic, assign) NSInteger dsb_hostId;

- (void)xyf_getFilePath:(void (^)(  NSString * _Nullable p ))completion;

@end

NS_ASSUME_NONNULL_END
