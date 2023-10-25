//
//  OWLMusicEnterPrivateChatModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/7.
//

#import "OWLMusicEnterPrivateChatModel.h"

@implementation OWLMusicEnterPrivateChatModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_roleType": @"roleType",
        @"dsb_roomID": @"roomId",
        @"dsb_userAccountID": @"userId",
        @"dsb_anchorAccountID": @"anchorId",
        @"dsb_leftCoins": @"leftDiamond",
        @"dsb_userName": @"userNickName",
        @"dsb_anchorName": @"anchorNickName",
        @"dsb_callTime": @"callTime",
        @"dsb_initialPrice": @"initialPrice",
        @"dsb_anchorAvatar": @"anchorAvatar",
        @"dsb_isFollow": @"isFollowed",
        @"dsb_anchorAge": @"anchorAge",
        @"dsb_anchorSex": @"anchorGender",
        @"dsb_takePrice": @"takeAnchorPrice",
        @"dsb_userAvatar": @"userAvatar"
    };
}

@end
