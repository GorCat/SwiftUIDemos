//
//  OWLPPBannerItem.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/23.
//

#import "OWLPPBannerItem.h"

@interface OWLPPBannerItem()

@property (nonatomic, strong) UIImageView * xyp_img;

@end

@implementation OWLPPBannerItem

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

#pragma mark - Update
- (void)xyf_updateBannerModel:(OWLMusicBannerModel *)model {
    [XYCUtil xyf_loadOriginImage:self.xyp_img url:model.dsb_imageUrl placeholder:nil];
}

#pragma mark - Action
- (void)xyp_clickAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_bannerItemClick:)]) {
        [self.delegate xyf_bannerItemClick:self.xyp_index];
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_img {
    if (!_xyp_img) {
        _xyp_img = [[UIImageView alloc] init];
        _xyp_img.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_img.layer.cornerRadius = 10;
        _xyp_img.clipsToBounds = YES;
        _xyp_img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyp_clickAction)];
        [_xyp_img addGestureRecognizer:tap];
    }
    return _xyp_img;
}

@end
