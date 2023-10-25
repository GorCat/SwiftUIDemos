//
//  UITableView+XYLExtention.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/1.
//

#import "UITableView+XYLExtention.h"

@implementation UITableView (XYLExtention)

- (void)xyf_insertSection:(NSUInteger)section withAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self insertSections:sections withRowAnimation:animation];
}

- (void)xyf_deleteSection:(NSUInteger)section withAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self deleteSections:sections withRowAnimation:animation];
}

- (void)xyf_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}
@end
