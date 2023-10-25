//
//  NSMutableDictionary+XYLExtention.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/13.
//

#import "NSMutableDictionary+XYLExtention.h"

@implementation NSMutableDictionary (XYLExtention)

- (void)xyf_setObjectIfNotNil:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
