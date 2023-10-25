//
//  OWLMusicRandomTableMsgModel.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/25.
//

#import "OWLMusicRandomTableMsgModel.h"

@implementation OWLMusicRandomTableMsgModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_selectedIndex": @"selectedIndex",
        @"dsb_turnTableInfoList": @"turnTableInfoList",
        @"dsb_turnTableIsOpen" : @"turnTableIsOpen",
        @"dsb_turnTableTitle" : @"turnTableTitle"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_turnTableInfoList" : [NSString class]
    };
}

@end
