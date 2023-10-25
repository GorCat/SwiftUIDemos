//// OWLBGMReportUploadImageCell.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间举报弹窗 - 上传图片cell
 * @创建时间：2023.2.11
 * @创建人：许琰
 */

#import "OWLBGMReportUploadImageCell.h"
#import "UIButton+XYLExtention.h"

@interface OWLBGMReportUploadImageCell ()

/// 图片容器
@property (nonatomic, strong) UIView *xyp_bgView;
/// 竖线
@property (nonatomic, strong) UIView *xyp_line1View;
/// 横线
@property (nonatomic, strong) UIView *xyp_line2View;
/// 图片
@property (nonatomic, strong) UIImageView *xyp_imageView;
/// 删除按钮
@property (nonatomic, strong) UIButton *xyp_deleteButton;

@end

@implementation OWLBGMReportUploadImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyc_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyc_setupView {
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(4);
        make.trailing.equalTo(self.contentView).offset(-4);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_line1View];
    [self.xyp_line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(2);
        make.center.equalTo(self.xyp_bgView);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_line2View];
    [self.xyp_line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(12);
        make.center.equalTo(self.xyp_bgView);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_imageView];
    [self.xyp_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.xyp_bgView);
    }];
    
    [self.contentView addSubview:self.xyp_deleteButton];
    [self.xyp_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self.contentView);
        make.height.width.mas_equalTo(20);
    }];
    self.xyp_deleteButton.hidden = YES;
}

#pragma mark - 填充图片
- (void)xyf_setupPicture:(nullable UIImage *)image {
    if (image) {
        self.xyp_imageView.hidden = NO;
        self.xyp_imageView.image = image;
        self.xyp_deleteButton.hidden = NO;
    } else {
        self.xyp_imageView.hidden = YES;
        self.xyp_deleteButton.hidden = YES;
    }
}

#pragma mark - Actions
- (void)xyf_deleteButtonAction {
    if (self.xyp_deleltePicture) {
        self.xyp_deleltePicture();
    }
}

#pragma mark - Lazy
- (UIView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIView alloc] init];
        _xyp_bgView.backgroundColor = kXYLColorFromRGB(0xF4F4F4);
        _xyp_bgView.layer.cornerRadius = 10;
        _xyp_bgView.clipsToBounds = YES;
    }
    return _xyp_bgView;
}

- (UIView *)xyp_line1View {
    if (!_xyp_line1View) {
        _xyp_line1View = [[UIView alloc] init];
        _xyp_line1View.backgroundColor = kXYLColorFromRGB(0xD4D4D4);
    }
    return _xyp_line1View;
}

- (UIView *)xyp_line2View {
    if (!_xyp_line2View) {
        _xyp_line2View = [[UIView alloc] init];
        _xyp_line2View.backgroundColor = kXYLColorFromRGB(0xD4D4D4);
    }
    return _xyp_line2View;
}

- (UIImageView *)xyp_imageView {
    if (!_xyp_imageView) {
        _xyp_imageView = [[UIImageView alloc] init];
        _xyp_imageView.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_imageView.clipsToBounds = YES;
    }
    return _xyp_imageView;
}

- (UIButton *)xyp_deleteButton {
    if (!_xyp_deleteButton) {
        _xyp_deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xyp_deleteButton addTarget:self action:@selector(xyf_deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_xyp_deleteButton xyf_loadIconStr:@"xyr_user_detail_report_delete_icon"];
    }
    return _xyp_deleteButton;
}

@end
