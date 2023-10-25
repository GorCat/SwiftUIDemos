//
//  UITableView+XYLExtention.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (XYLExtention)

- (void)xyf_insertSection:(NSUInteger)section withAnimation:(UITableViewRowAnimation)animation;

- (void)xyf_deleteSection:(NSUInteger)section withAnimation:(UITableViewRowAnimation)animation;

- (void)xyf_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
