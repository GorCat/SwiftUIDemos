//
//  UIScrollView+XYLExtention.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/9.
//

#import "UIScrollView+XYLExtention.h"

@implementation UIScrollView (XYLExtention)

- (void)xyf_scrollToBottom {
    [self xyf_scrollToBottomAnimated:YES];
}

- (void)xyf_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}
@end
