//
//  OWLMusicGiftConfigModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/24.
//

#import "OWLMusicGiftConfigModel.h"

@implementation OWLMusicGiftConfigModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_title": @"title",
        @"dsb_iconUrl": @"tagIconUrl",
        @"dsb_giftList": @"gifts",
        @"dsb_iconType" : @"tagIconType",
        @"dsb_canBePrivateGift" : @"canSetPrivate"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_giftList" : [OWLMusicGiftInfoModel class],
    };
}

@end

@implementation OWLMusicGiftListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_giftList": @"giftConfig"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_giftList" : [OWLMusicGiftInfoModel class],
    };
}

@end

@implementation OWLMusicGiftInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_giftID": @"giftId",
        @"dsb_giftCoin": @"giftPrice",
        @"dsb_giftOriginCoin": @"giftOriPrice",
        @"dsb_iconImageUrl" : @"iconUrl",
        @"dsb_giftName" : @"giftName",
        @"dsb_gifUrl" : @"svgUrl",
        @"dsb_isBlindGift": @"isBlindBox",
        @"dsb_bundleUrl": @"fuBundleUrl",
        @"dsb_bundleDuration" : @"fuBundleDuration",
        @"dsb_voiceChangeConfig" : @"voiceChanger",
        @"dsb_comboNum" : @"comboSize",
        @"dsb_comboIconImage": @"comboIconUrl"
    };
}

@end
