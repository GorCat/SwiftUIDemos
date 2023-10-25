//
//  NSMutableArray+XYLExtention.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/9.
//

#import "NSMutableArray+XYLExtention.h"

@implementation NSMutableArray (XYLExtention)

- (void)xyf_removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (void)xyf_addObjectIfNotNil:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}

@end
