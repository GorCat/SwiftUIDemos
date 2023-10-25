//
//  OWLMusicRoomPKWinnerModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

/**
 * @功能描述：直播间房间详情模型 - PK数据 - 赢家数据
 * @创建时间：2023.2.21
 * @创建人：许琰
 */

#import "OWLMusicRoomPKWinnerModel.h"

@implementation OWLMusicRoomPKWinnerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_accountID": @"hostAccountId",
        @"dsb_winTime": @"wins"
    };
}

@end
