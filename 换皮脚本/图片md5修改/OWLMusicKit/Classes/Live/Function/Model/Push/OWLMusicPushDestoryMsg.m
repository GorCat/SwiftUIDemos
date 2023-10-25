//
//  OWLMusicPushDestoryMsg.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/8.
//

#import "OWLMusicPushDestoryMsg.h"

@implementation OWLMusicPushDestoryMsg

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_destoryOne": @"destroyedRoom",
        @"dsb_newOne": @"newRoom",
        @"dsb_destroyType" : @"destroyReason"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_destoryOne": [OWLMusicRoomDetailModel class],
        @"dsb_newOne": [OWLMusicRoomDetailModel class]
    };
}

@end
