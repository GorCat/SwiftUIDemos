//
//  XYCModulePushMessageModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/23.
//

#import "XYCModulePushMessageModel.h"

@implementation XYCModulePushMessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"xyp_opCode": @"opCode",
        @"xyp_subCode": @"subCode",
        @"xyp_retCode": @"retCode",
        @"xyp_message" : @"message",
        @"xyp_data" : @"data"
    };
}

@end
