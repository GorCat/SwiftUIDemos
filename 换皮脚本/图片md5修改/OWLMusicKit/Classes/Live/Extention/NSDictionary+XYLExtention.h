//
//  NSDictionary+XYLExtention.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (XYLExtention)

- (nullable id)xyf_objectForKeyNotNil:(id)aKey;

+ (NSDictionary *)xyf_dicWithJsonStr:(NSString *)jsonStr;

@end

NS_ASSUME_NONNULL_END
