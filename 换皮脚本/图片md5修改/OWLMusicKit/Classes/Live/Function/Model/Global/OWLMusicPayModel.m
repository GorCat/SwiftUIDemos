//
//  OWLMusicPayModel.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/21.
//

#import "OWLMusicPayModel.h"

@implementation OWLMusicPayModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_payType": @"type",
        @"dsb_title": @"title",
        @"dsb_payUrlSuffix" : @"payUrlSuffix",
        @"dsb_coefficient" : @"coefficient",
        @"dsb_products" : @"products"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_products" : [OWLMusicProductModel class]
    };
}

@end

@implementation OWLMusicProductModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_productId": @"productId",
        @"dsb_priceUSD": @"priceUSD",
        @"dsb_baseCount" : @"baseCount",
        @"dsb_extraCount" : @"extraCount",
        @"dsb_productType" : @"productType",
        @"dsb_isBought" : @"isBought",
        @"dsb_oriPriceUSD" : @"oriPriceUSD"
    };
}

@end

@implementation OWLMusicPayOtherInfoModel


@end
