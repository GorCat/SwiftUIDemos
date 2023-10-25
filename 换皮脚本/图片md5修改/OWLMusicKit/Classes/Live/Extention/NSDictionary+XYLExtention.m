//
//  NSDictionary+XYLExtention.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

#import "NSDictionary+XYLExtention.h"

@implementation NSDictionary (XYLExtention)

- (nullable id)xyf_objectForKeyNotNil:(id)aKey {
    if ([[self allKeys] containsObject:aKey]) {
        if ([[self objectForKey:aKey] isKindOfClass:[NSNull class]]) {
            return nil;
        }else{
            return [self objectForKey:aKey];
        }
    }
    return nil;
}

+ (NSDictionary *)xyf_dicWithJsonStr:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dict;
}

@end
