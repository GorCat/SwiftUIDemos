//// NSArray+XYLExtention.m
// qianDuoDuo
//
// 
//


#import "NSArray+XYLExtention.h"

@implementation NSArray (XYLExtention)

- (nullable id)xyf_objectAtIndexSafe:(NSUInteger)index {
    if (index < self.count) {
        return self[index];
    }
    return nil;
}

@end
