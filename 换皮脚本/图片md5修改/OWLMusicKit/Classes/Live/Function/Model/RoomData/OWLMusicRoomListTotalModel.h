//
//  OWLMusicRoomListTotalModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

#import "OWLBGMModuleBaseModel.h"
#import "OWLMusicRoomDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRoomListTotalModel : OWLBGMModuleBaseModel

/// 房间列表
@property (nonatomic, strong) NSArray <OWLMusicRoomDetailModel *> *dsb_roomList;
/// 被禁言的声网房间号
@property (nonatomic, strong) NSArray <NSString *> *dsb_muteRTCRoomIDs;
/// 被踢出的声网房间号
@property (nonatomic, strong) NSArray <NSString *> *dsb_kickRTCRoomIDs;

@end

NS_ASSUME_NONNULL_END
