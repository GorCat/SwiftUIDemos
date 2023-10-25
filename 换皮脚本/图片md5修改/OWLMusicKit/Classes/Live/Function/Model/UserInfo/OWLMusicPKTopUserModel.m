//// OWLMusicPKTopUserModel.m
// qianDuoDuo
//
// 
//


#import "OWLMusicPKTopUserModel.h"

@implementation OWLMusicPKTopUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_userID": @"accountId",
        @"dsb_userAvatar": @"avatar",
        @"dsb_nickname": @"userName",
        @"dsb_isVipUser": @"isVip",
        @"dsb_isSVipUser": @"isSVip",
        @"dsb_userGoals": @"points",
        @"dsb_userAge": @"age"
    };
}

@end
