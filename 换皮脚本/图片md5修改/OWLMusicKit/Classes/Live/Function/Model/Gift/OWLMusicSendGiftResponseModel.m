//
//  OWLMusicSendGiftResponseModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/27.
//

#import "OWLMusicSendGiftResponseModel.h"

@implementation OWLMusicSendGiftResponseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_giftID" : @"giftId",
        @"dsb_leftCoins" : @"leftDiamond"
    };
}

@end
