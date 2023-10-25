//
//  NSObject+XYLExtention.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

#import "NSObject+XYLExtention.h"

@implementation NSObject (XYLExtention)

- (void)xyf_handleNotification:(NSNotification *)notification
{
    
}

- (void)xyf_observeNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xyf_handleNotification:)
                                                 name:name
                                               object:nil];
}

- (void)xyf_unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)xyf_unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)xyf_postNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    return YES;
}

- (BOOL)xyf_postNotification:(NSString *)name withObject:(NSObject *)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    return YES;
}

-(NSString *)xyf_className {
    return NSStringFromClass([self class]);
}


@end
