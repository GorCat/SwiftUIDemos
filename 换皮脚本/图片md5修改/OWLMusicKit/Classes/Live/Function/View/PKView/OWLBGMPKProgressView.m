//
//  OWLBGMPKProgressView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK - PK进度条视图
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLBGMPKProgressView.h"
#import "OWLMusciCompressionTool.h"

@interface OWLBGMPKProgressView ()

#pragma mark - Views
/// 红方
@property (nonatomic, strong) UIView *xyp_redView;
/// 红方数字
@property (nonatomic, strong) UILabel *xyp_redNumLabel;
/// 蓝方
@property (nonatomic, strong) UIView *xyp_blueView;
/// 蓝方数字
@property (nonatomic, strong) UILabel *xyp_blueNumLabel;
/// 高亮图标
@property (nonatomic, strong) UIImageView *xyp_highlightIV;

#pragma mark - Data
/// 百分比
@property (nonatomic, assign) CGFloat xyp_progress;

@end

@implementation OWLBGMPKProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_redView];
    [self addSubview:self.xyp_blueView];
    [self addSubview:self.xyp_highlightIV];
    
    [self addSubview:self.xyp_redNumLabel];
    [self.xyp_redNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.xyp_blueNumLabel];
    [self.xyp_blueNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.top.bottom.equalTo(self);
    }];
}

#pragma mark - Setter
- (void)setXyp_pkData:(OWLMusicRoomPKDataModel *)xyp_pkData {
    _xyp_pkData = xyp_pkData;
    self.xyp_redNumLabel.text = [NSString stringWithFormat:@"%ld",(long)xyp_pkData.dsb_ownerPoint.dsb_points];
    self.xyp_blueNumLabel.text = [NSString stringWithFormat:@"%ld",(long)xyp_pkData.dsb_otherPoint.dsb_points];
    if (xyp_pkData.dsb_ownerPoint.dsb_points == xyp_pkData.dsb_otherPoint.dsb_points) {
        self.xyp_progress = 0.5;
    } else {
        self.xyp_progress = (CGFloat)xyp_pkData.dsb_ownerPoint.dsb_points / (CGFloat)(xyp_pkData.dsb_ownerPoint.dsb_points + xyp_pkData.dsb_otherPoint.dsb_points);
    }
}

- (void)setXyp_progress:(CGFloat)xyp_progress {
    _xyp_progress = xyp_progress;
    CGFloat point0Width = 56;
    CGFloat totalWidth = kXYLScreenWidth - point0Width * 2;
    CGFloat mineWidth = totalWidth * xyp_progress + point0Width;
    self.xyp_redView.frame = CGRectMake(0, 0, mineWidth, kXYLPKProgressViewHeight);
    self.xyp_blueView.frame = CGRectMake(mineWidth, 0, kXYLScreenWidth - mineWidth, kXYLPKProgressViewHeight);
    self.xyp_highlightIV.center = CGPointMake(mineWidth, self.xyp_highlightIV.center.y);
}

#pragma mark - Getter
- (CGSize)xyf_getHighlightSize {
    return CGSizeMake(60, 24);
}

#pragma mark - Lazy
- (UIView *)xyp_redView {
    if (!_xyp_redView) {
        _xyp_redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth / 2, kXYLPKProgressViewHeight)];
        _xyp_redView.backgroundColor = kXYLColorFromRGB(0xE94179);
    }
    return _xyp_redView;
}

- (UILabel *)xyp_redNumLabel {
    if (!_xyp_redNumLabel) {
        _xyp_redNumLabel = [[UILabel alloc] init];
        _xyp_redNumLabel.textColor = kXYLColorFromRGB(0x670E2C);
        _xyp_redNumLabel.font = kXYLGilroyBoldFont(12);
        _xyp_redNumLabel.text = @"0";
    }
    return _xyp_redNumLabel;
}

- (UIView *)xyp_blueView {
    if (!_xyp_blueView) {
        _xyp_blueView = [[UIView alloc] initWithFrame:CGRectMake(kXYLScreenWidth / 2, 0, kXYLScreenWidth / 2, kXYLPKProgressViewHeight)];
        _xyp_blueView.backgroundColor = kXYLColorFromRGB(0x499BF7);
    }
    return _xyp_blueView;
}

- (UILabel *)xyp_blueNumLabel {
    if (!_xyp_blueNumLabel) {
        _xyp_blueNumLabel = [[UILabel alloc] init];
        _xyp_blueNumLabel.textColor = kXYLColorFromRGB(0x0E437D);
        _xyp_blueNumLabel.font = kXYLGilroyBoldFont(12);
        _xyp_blueNumLabel.text = @"0";
    }
    return _xyp_blueNumLabel;
}

- (UIImageView *)xyp_highlightIV {
    if (!_xyp_highlightIV) {
        CGFloat width = [self xyf_getHighlightSize].width;
        CGFloat height = [self xyf_getHighlightSize].height;
        CGFloat x = (kXYLScreenWidth - width) / 2;
        CGFloat y = (kXYLPKProgressViewHeight - height) / 2;
        _xyp_highlightIV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _xyp_highlightIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_highlightIV.clipsToBounds = YES;
        NSString *flagUrl = OWLJConvertToolShared.xyf_pkFlagURL;
        if (OWLJConvertToolShared.xyf_pkFlagURL.length > 0) {
            [_xyp_highlightIV sd_setImageWithURL:[NSURL URLWithString:flagUrl]];
        } else {
            NSString * gifPath = [OWLMusciCompressionTool xyf_getPreparedGifPathFrom:@"xyr_pking"];
            NSData * gifData = [NSData dataWithContentsOfFile:gifPath];
            _xyp_highlightIV.image = [UIImage sd_imageWithGIFData:gifData];
        }
    }
    return _xyp_highlightIV;
}

@end
