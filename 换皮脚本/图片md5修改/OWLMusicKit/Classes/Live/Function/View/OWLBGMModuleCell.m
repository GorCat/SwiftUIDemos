//
//  OWLBGMModuleCell.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/20.
//

#import "OWLBGMModuleCell.h"

@interface OWLBGMModuleCell ()

/// 背景
@property (nonatomic, strong) UIImageView *xyp_coverIV;
/// 模糊
@property (nonatomic, strong) UIVisualEffectView *xyp_maskView;

@end

@implementation OWLBGMModuleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.xyp_coverIV];
    [self.xyp_coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.xyp_maskView];
    [self.xyp_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - Setter
- (void)setXyp_cover:(NSString *)xyp_cover {
    _xyp_cover = xyp_cover;
    [XYCUtil xyf_loadSmallImage:self.xyp_coverIV url:xyp_cover placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
}

#pragma mark - Lazy
- (UIImageView *)xyp_coverIV {
    if (!_xyp_coverIV) {
        _xyp_coverIV = [[UIImageView alloc] init];
        _xyp_coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_coverIV.clipsToBounds = YES;
    }
    return _xyp_coverIV;
}

- (UIVisualEffectView *)xyp_maskView {
    if (!_xyp_maskView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _xyp_maskView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _xyp_maskView.alpha = 0.97;
    }
    return _xyp_maskView;
}

@end
