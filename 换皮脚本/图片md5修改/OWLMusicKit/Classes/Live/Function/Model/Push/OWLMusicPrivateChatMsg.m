//
//  OWLMusicPrivateChatMsg.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/13.
//

#import "OWLMusicPrivateChatMsg.h"

@implementation OWLMusicPrivateChatMsg

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_roomID": @"roomId",
        @"dsb_privateState": @"privateChatFlag"
    };
}

@end
