//
//  NSObject+XYLExtention.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XYLExtention)

- (void)xyf_handleNotification:(NSNotification *)notification;  // 处理通知

- (void)xyf_observeNotification:(NSString *)name;               // 注册观察者
- (void)xyf_unobserveNotification:(NSString *)name;             // 反注册观察者
- (void)xyf_unobserveAllNotifications;                          // 反注册所有通知

- (BOOL)xyf_postNotification:(NSString *)name;                                  // 发送通知
- (BOOL)xyf_postNotification:(NSString *)name withObject:(NSObject *)object;    // 发送通知 with 对象


@end

NS_ASSUME_NONNULL_END
