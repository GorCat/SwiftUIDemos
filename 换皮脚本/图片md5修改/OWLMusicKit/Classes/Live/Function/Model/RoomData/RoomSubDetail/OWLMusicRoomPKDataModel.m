//
//  OWLMusicRoomPKDataModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

/**
 * @功能描述：直播间房间详情模型 - PK数据
 * @创建时间：2023.2.21
 * @创建人：许琰
 */

#import "OWLMusicRoomPKDataModel.h"

@implementation OWLMusicRoomPKDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_ownerPlayer": @"homePlayer",
        @"dsb_otherPlayer": @"awayPlayer",
        @"dsb_ownerPoint": @"homePoint",
        @"dsb_otherPoint" : @"awayPoint",
        @"dsb_startTime" : @"pkTime",
        @"dsb_maxTime" : @"pkMaxDuration",
        @"dsb_leftTime" : @"pkLeftTime",
        @"dsb_winAnchorData" : @"winner"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_ownerPlayer" : [OWLMusicRoomPKPlayerModel class],
        @"dsb_otherPlayer" : [OWLMusicRoomPKPlayerModel class],
        @"dsb_ownerPoint" : [OWLMusicRoomPKPointModel class],
        @"dsb_otherPoint" : [OWLMusicRoomPKPointModel class],
        @"dsb_winAnchorData" : [OWLMusicRoomPKWinnerModel class]
    };
}

@end
