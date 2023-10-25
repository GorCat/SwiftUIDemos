//
//  NSMutableArray+XYLExtention.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (XYLExtention)

- (void)xyf_removeFirstObject;

- (void)xyf_addObjectIfNotNil:(id)anObject;

@end

NS_ASSUME_NONNULL_END
