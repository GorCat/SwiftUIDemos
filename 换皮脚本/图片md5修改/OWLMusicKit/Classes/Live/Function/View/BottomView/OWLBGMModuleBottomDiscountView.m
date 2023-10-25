//
//  OWLBGMModuleBottomDiscountView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/24.
//

#import "OWLBGMModuleBottomDiscountView.h"

@interface OWLBGMModuleBottomDiscountView ()

/// 按钮
@property (nonatomic, strong) UIButton *xyp_discountButton;

@end

@implementation OWLBGMModuleBottomDiscountView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_hiddenView:YES];
        [self xyf_setupView];
        [self xyf_observeNotification:xyl_module_recharge_success];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_discountButton];
    [self.xyp_discountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)xyf_hiddenView:(BOOL)isHidden {
    self.hidden = isHidden;
    if (self.discountDelegate && [self.discountDelegate respondsToSelector:@selector(xyf_bottomDiscountViewIsHidden:)]) {
        [self.discountDelegate xyf_bottomDiscountViewIsHidden:isHidden];
    }
}

#pragma mark - 事件处理
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject *)obj {
    switch (type) {
        case XYLModuleEventType_UpdateDiscountButton: {
            BOOL isShow = [(NSNumber *)obj boolValue];
            [self xyf_hiddenView:!isShow];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_module_recharge_success]) {
        [self xyf_hiddenView:YES];
    }
}

#pragma mark - Lazy
- (UIButton *)xyp_discountButton {
    if (!_xyp_discountButton) {
        _xyp_discountButton = [[UIButton alloc] init];
        [_xyp_discountButton setBackgroundImage:[XYCUtil xyf_getIconWithName:@"xyr_discount_small_image"] forState:UIControlStateNormal];
    }
    return _xyp_discountButton;
}

@end
