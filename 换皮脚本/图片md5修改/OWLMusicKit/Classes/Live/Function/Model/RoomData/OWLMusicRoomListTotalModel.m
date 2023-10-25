//
//  OWLMusicRoomListTotalModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

#import "OWLMusicRoomListTotalModel.h"

@implementation OWLMusicRoomListTotalModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_roomList": @"videoChatRooms",
        @"dsb_muteRTCRoomIDs": @"mutedAgoraRoomIds",
        @"dsb_kickRTCRoomIDs": @"kickedAgoraRoomIds"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_roomList": [OWLMusicRoomDetailModel class],
        @"dsb_muteRTCRoomIDs": [NSString class],
        @"dsb_kickRTCRoomIDs": [NSString class]
    };
}

@end
