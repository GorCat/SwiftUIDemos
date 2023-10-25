//
//  OWLMusicBannerInfoModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/24.
//

#import "OWLMusicBannerInfoModel.h"

@implementation OWLMusicBannerInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_bannerList": @"bannerInfo"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_bannerList" : [OWLMusicBannerModel class]
    };
}
    
@end

@implementation OWLMusicBannerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_imageUrl": @"imgAddr",
        @"dsb_jumpAddr": @"redirectAddr",
        @"dsb_type": @"type",
        @"dsb_otherData" : @"extraData",
        @"dsb_name": @"name",
    };
}

@end
