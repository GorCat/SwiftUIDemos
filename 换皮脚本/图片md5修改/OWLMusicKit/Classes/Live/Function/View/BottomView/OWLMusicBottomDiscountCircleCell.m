//
//  OWLMusicBottomDiscountCircleCell.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/7/15.
//

#import "OWLMusicBottomDiscountCircleCell.h"

@interface OWLMusicBottomDiscountCircleCell()

@property (nonatomic, strong) UIImageView *xyp_img;

@end

@implementation OWLMusicBottomDiscountCircleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self.contentView addSubview:self.xyp_img];
    [self.xyp_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Setter
- (void)setType:(XYLModuleCycleInfoType)type {
    _type = type;
    switch (type) {
        case XYLModuleCycleInfoType_PayDiscount:
            [XYCUtil xyf_loadIconImage:self.xyp_img iconStr:@"xyr_discount_small_image"];
            break;
        case XYLModuleCycleInfoType_OneCoinTest:
            [XYCUtil xyf_loadIconImage:self.xyp_img iconStr:@"xyr_onetest_small_image"];
            break;
    }
}

#pragma mark - Action
- (void)xyp_clickAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_BottomDiscountCircleClickWithType:)]) {
        [self.delegate xyf_BottomDiscountCircleClickWithType:self.type];
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_img {
    if (!_xyp_img) {
        _xyp_img = [[UIImageView alloc] init];
        _xyp_img.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_img.clipsToBounds = YES;
        _xyp_img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyp_clickAction)];
        [_xyp_img addGestureRecognizer:tap];
    }
    return _xyp_img;
}

@end
