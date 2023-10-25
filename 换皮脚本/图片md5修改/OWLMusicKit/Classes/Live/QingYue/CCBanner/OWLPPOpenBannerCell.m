//
//  OWLPPOpenBannerCell.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/24.
//

#import "OWLPPOpenBannerCell.h"

@interface OWLPPOpenBannerCell()

@property (nonatomic, strong) UIImageView *xyp_img;

@end

@implementation OWLPPOpenBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self xyf_setupUI];
    }
    return self;
}

- (UIImageView *)xyp_img {
    if (!_xyp_img) {
        _xyp_img = [[UIImageView alloc] init];
        _xyp_img.layer.cornerRadius = 10;
        _xyp_img.layer.masksToBounds = YES;
        _xyp_img.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xyp_img;
}

- (void)xyf_setupUI {
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.xyp_img];
    [self.xyp_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.leading.equalTo(self).offset(7.5);
    }];
}
- (void)xyf_configDataWith:(OWLMusicBannerModel *) model {
    [XYCUtil xyf_loadOriginImage:self.xyp_img url:model.dsb_imageUrl placeholder:nil];
}

@end
