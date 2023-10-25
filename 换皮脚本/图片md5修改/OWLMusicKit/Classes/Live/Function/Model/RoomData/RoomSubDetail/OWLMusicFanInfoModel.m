//
//  OWLMusicFanInfoModel.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/11.
//

#import "OWLMusicFanInfoModel.h"

@implementation OWLMusicFanInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_isFan": @"isStan",
        @"dsb_fanIconUrl": @"stanLabelUrl",
        @"dsb_isGainedFan" : @"isStanLabelGained"
    };
}

@end
