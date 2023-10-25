//
//  OWLMusicPrivateChatMsg.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/13.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicPrivateChatMsg : OWLBGMModuleBaseModel

/// 房间号
@property (nonatomic, assign) NSInteger dsb_roomID;
/// 是否开启（1：开启 2：关闭）
@property (nonatomic, assign) XYLModulePrivateChatStatusType dsb_privateState;

@end

NS_ASSUME_NONNULL_END
