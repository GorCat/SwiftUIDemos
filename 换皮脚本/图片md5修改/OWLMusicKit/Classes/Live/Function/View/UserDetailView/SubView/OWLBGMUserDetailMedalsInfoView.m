//// OWLBGMUserDetailMedalsInfoView.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 奖章信息视图
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMUserDetailMedalsInfoView.h"

@interface OWLBGMUserDetailMedalsInfoView ()

/// 背景
@property (nonatomic, strong) UIImageView *xyp_bgView;
/// icon
@property (nonatomic, strong) UIImageView *xyp_iconIV;
/// 奖章
@property (nonatomic, strong) UILabel *xyp_medalLabel;
/// 数量
@property (nonatomic, strong) UILabel *xyp_numLabel;
/// 箭头
@property (nonatomic, strong) UIImageView *xyp_arrowIV;
/// 奖章图片
@property (nonatomic, strong) UIImageView *xyp_medalIV;

@end

@implementation OWLBGMUserDetailMedalsInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgView];
    
    [self.xyp_bgView addSubview:self.xyp_iconIV];
    [self.xyp_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(34);
        make.centerY.equalTo(self.xyp_bgView);
        make.leading.equalTo(self.xyp_bgView).offset(16);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_medalLabel];
    [self.xyp_medalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_iconIV).offset(-2);
        make.leading.equalTo(self.xyp_iconIV.mas_trailing).offset(15);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_numLabel];
    [self.xyp_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_medalLabel.mas_bottom).offset(3);
        make.leading.equalTo(self.xyp_iconIV.mas_trailing).offset(15);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_arrowIV];
    [self.xyp_arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(11);
        make.centerY.equalTo(self.xyp_bgView);
        make.trailing.equalTo(self.xyp_bgView).offset(-11);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_medalIV];
    [self.xyp_medalIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_bgView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(61);
        make.trailing.equalTo(self.xyp_arrowIV.mas_leading).offset(-11.5);
    }];
}

#pragma mark - Setter
- (void)setXyp_model:(OWLMusicAccountDetailInfoModel *)xyp_model {
    _xyp_model = xyp_model;
    NSInteger count = xyp_model.xyp_lables.count;
    self.xyp_numLabel.text = [NSString stringWithFormat:kXYLLocalString(@"Total %ld medals"), count];
    
    kXYLWeakSelf
    if (xyp_model.xyp_defaultEventLabel.length > 0) {
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:xyp_model.xyp_defaultEventLabel] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (error) {
                return;
            }
            CGFloat width = image.size.width * 20/image.size.height;
            UIImage * getImg = [XYCUtil xyf_scaleToSize:image size:CGSizeMake(width, 20)];
            [weakSelf.xyp_medalIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.xyp_bgView);
                make.size.mas_equalTo(CGSizeMake(width, 20));
                make.trailing.equalTo(self.xyp_arrowIV.mas_leading).offset(-11.5);
            }];
            weakSelf.xyp_medalIV.image = getImg;
        }];
    }
}

#pragma mark - Getter
/// 顶部间距
- (CGFloat)xyf_getTopMargin {
    return 12;
}

/// 背景高度
- (CGFloat)xyf_getBgViewHeight {
    return 63;
}

/// 底部间距
- (CGFloat)xyf_getBottomMargin {
    return 12;
}

/// 总高度
- (CGFloat)xyf_getHeight {
    return [self xyf_getTopMargin] + [self xyf_getBgViewHeight] + [self xyf_getBottomMargin];
}

#pragma mark - Actions
- (void)xyf_bgViewAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_liveUserDetailBaseViewClickAction:)]) {
        [self.delegate xyf_liveUserDetailBaseViewClickAction:OWLBGMUserDetailBaseViewClickType_ShowMedalsView];
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, [self xyf_getTopMargin], kXYLScreenWidth - 32, 64)];
        _xyp_bgView.userInteractionEnabled = YES;
        _xyp_bgView.image = [UIImage imageWithGradient:@[kXYLColorFromRGB(0xFFEFEF), kXYLColorFromRGB(0xFFFBFA)] size:_xyp_bgView.xyp_size direction:UIImageGradientDirectionHorizontal];
        _xyp_bgView.clipsToBounds = YES;
        _xyp_bgView.layer.cornerRadius = 16;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_bgViewAction)];
        [_xyp_bgView addGestureRecognizer:tap];
    }
    return _xyp_bgView;
}

- (UIImageView *)xyp_iconIV {
    if (!_xyp_iconIV) {
        _xyp_iconIV = [[UIImageView alloc] init];
        _xyp_iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_iconIV.clipsToBounds = YES;
        [XYCUtil xyf_loadIconImage:_xyp_iconIV iconStr:@"xyr_user_detail_medals_image"];
    }
    return _xyp_iconIV;
}

- (UILabel *)xyp_medalLabel {
    if (!_xyp_medalLabel) {
        _xyp_medalLabel = [[UILabel alloc] init];
        _xyp_medalLabel.font = kXYLGilroyBoldFont(17);
        _xyp_medalLabel.text = kXYLLocalString(@"Medals");
        _xyp_medalLabel.textColor = kXYLColorFromRGB(0x080808);
    }
    return _xyp_medalLabel;
}

- (UILabel *)xyp_numLabel {
    if (!_xyp_numLabel) {
        _xyp_numLabel = [[UILabel alloc] init];
        _xyp_numLabel.font = kXYLGilroyBoldFont(12);
        _xyp_numLabel.textColor = kXYLColorFromRGB(0xC8B2B3);
    }
    return _xyp_numLabel;
}

- (UIImageView *)xyp_arrowIV {
    if (!_xyp_arrowIV) {
        _xyp_arrowIV = [[UIImageView alloc] init];
        _xyp_arrowIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_arrowIV.clipsToBounds = YES;
        [XYCUtil xyf_loadMirrorImage:_xyp_arrowIV iconStr:@"xyr_user_detail_medals_arrow_icon"];
    }
    return _xyp_arrowIV;
}

- (UIImageView *)xyp_medalIV {
    if (!_xyp_medalIV) {
        _xyp_medalIV = [[UIImageView alloc] init];
        _xyp_medalIV.clipsToBounds = YES;
    }
    return _xyp_medalIV;
}

@end
