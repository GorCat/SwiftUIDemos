//
//  OWLMusicMemberModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

/**
 * @功能描述：直播间房间详情模型 - 房间用户模型
 * @创建时间：2023.2.21
 * @创建人：许琰
 */

#import "OWLMusicMemberModel.h"

@implementation OWLMusicMemberModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"xyp_accountId": @"accountId",
        @"xyp_displayAccountId": @"displayAccountId",
        @"xyp_roleType": @"roleType",
        @"xyp_avatar": @"avatar",
        @"xyp_nickName": @"nickName",
        @"xyp_giftCost": @"giftCost",
        @"xyp_commentUp": @"commentUp",
        @"xyp_age": @"age",
        @"xyp_gender": @"gender",
        @"xyp_level": @"level",
        @"xyp_isVip": @"isVip",
        @"xyp_isSVip": @"isSVip",
        @"xyp_isMysteriousMan": @"isMysteriousMan",
        @"xyp_isAdmin": @"isAdmin",
    };
}

@end
