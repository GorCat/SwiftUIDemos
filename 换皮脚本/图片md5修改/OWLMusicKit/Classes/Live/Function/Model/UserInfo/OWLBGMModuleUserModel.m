//
//  OWLBGMModuleUserModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#import "OWLBGMModuleUserModel.h"

@implementation OWLBGMModuleUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_accountId": @"accountId",
        @"dsb_displayAccountId": @"displayAccountId",
        @"dsb_avatar": @"avatar",
        @"dsb_nickName": @"userName",
        @"dsb_mood": @"mood",
        @"dsb_age": @"age",
        @"dsb_followers": @"followers",
        @"dsb_followings": @"followings",
        @"dsb_giftCost": @"giftCost",
        @"dsb_isFollow": @"isFollowed",
        @"dsb_gender": @"gender",
        @"dsb_lables": @"eventLables",
        @"dsb_defaultEventLabel": @"defaultEventLabel",
        @"dsb_isSvip": @"isSVip",
        @"dsb_blockType": @"blacklistStatus",
        @"dsb_level": @"level"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_lables": [NSString class]
    };
}

@end
