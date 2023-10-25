//
//  NSMutableDictionary+XYLExtention.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (XYLExtention)

- (void)xyf_setObjectIfNotNil:(id)anObject forKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
