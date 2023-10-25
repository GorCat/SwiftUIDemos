//
//  OWLMusicEventLabelModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/22.
//

/**
 * @功能描述：直播间用户模型 - 活动标签模型
 * @创建时间：2023.2.22
 * @创建人：许琰
 */

#import "OWLMusicEventLabelModel.h"

@implementation OWLMusicEventLabelModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_labelUrl": @"imageUrl",
        @"dsb_labelTitle": @"title",
        @"dsb_labelTip": @"desc",
        @"dsb_leftTime": @"expirationTime",
        @"dsb_width": @"imageWidth",
        @"dsb_height": @"imageHeight",
        @"dsb_index": @"sequence"
    };
}

@end
