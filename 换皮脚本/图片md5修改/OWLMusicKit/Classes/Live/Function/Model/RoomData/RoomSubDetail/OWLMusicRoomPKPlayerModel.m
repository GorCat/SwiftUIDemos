//
//  OWLMusicRoomPKPlayerModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

/**
 * @功能描述：直播间房间详情模型 - PK数据 - 玩家数据
 * @创建时间：2023.2.21
 * @创建人：许琰
 */

#import "OWLMusicRoomPKPlayerModel.h"

@implementation OWLMusicRoomPKPlayerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_roomID": @"roomId",
        @"dsb_cover": @"roomCover",
        @"dsb_rtcRoomID" : @"agoraRoomId",
        @"dsb_roomStatus" : @"roomStatus",
        @"dsb_accountID" : @"hostAccountId",
        @"dsb_nickname" : @"hostName",
        @"dsb_avatar" : @"hostAvatar",
        @"dsb_wins" : @"wins"
    };
}

@end
