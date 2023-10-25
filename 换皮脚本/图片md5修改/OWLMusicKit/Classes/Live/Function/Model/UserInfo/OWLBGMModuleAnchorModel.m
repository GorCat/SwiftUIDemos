//
//  OWLBGMModuleAnchorModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#import "OWLBGMModuleAnchorModel.h"

@implementation OWLBGMModuleAnchorModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_accountId": @"accountId",
        @"dsb_displayAccountId": @"displayAccountId",
        @"dsb_avatar": @"avatar",
        @"dsb_nickName": @"anchorName",
        @"dsb_mood": @"mood",
        @"dsb_age": @"age",
        @"dsb_commentUp": @"commentUp",
        @"dsb_commentDown": @"commentDown",
        @"dsb_flag": @"anchorFlag",
        @"dsb_isFollow": @"isFollowed",
        @"dsb_gender": @"gender",
        @"dsb_followers": @"followers",
        @"dsb_followings": @"followerings",
        @"dsb_lables": @"eventLables",
        @"dsb_defaultEventLabel": @"defaultEventLabel",
        @"dsb_blockType": @"blacklistStatus"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_lables": [NSString class]
    };
}


@end
