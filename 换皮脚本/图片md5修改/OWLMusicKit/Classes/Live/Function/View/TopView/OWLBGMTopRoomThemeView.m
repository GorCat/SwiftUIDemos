//
//  OWLBGMTopRoomThemeView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

/**
 * @功能描述：直播间顶部视图-房间主题
 * @创建时间：2023.2.10
 * @创建人：许琰
 */

#import "OWLBGMTopRoomThemeView.h"
#import "OWLMusicAutoScrollLabel.h"

@interface OWLBGMTopRoomThemeView()

#pragma mark - Views
/// 背景
@property (nonatomic, strong) UIView *xyp_bgView;
/// 图标
@property (nonatomic, strong) UIImageView *xyp_iconIV;
/// 文本
@property (nonatomic, strong) OWLMusicAutoScrollLabel *xyp_themeLabel;

#pragma mark - Layout
/// 视图最大宽度
@property (nonatomic, assign) CGFloat xyp_maxViewWidth;
/// 文字左边间距
@property (nonatomic, assign) CGFloat xyp_textLeftMargin;
/// 文字右边间距
@property (nonatomic, assign) CGFloat xyp_textRightMargin;

@end

@implementation OWLBGMTopRoomThemeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.xyp_maxViewWidth = 120;
        self.xyp_textLeftMargin = 21;
        self.xyp_textRightMargin = 4;
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_iconIV];
    [self.xyp_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(12);
        make.leading.equalTo(self.xyp_bgView).offset(5);
        make.centerY.equalTo(self.xyp_bgView);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_themeLabel];
    [self.xyp_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.xyp_bgView);
        make.leading.equalTo(self.xyp_bgView).offset(self.xyp_textLeftMargin);
        make.trailing.equalTo(self.xyp_bgView).offset(-self.xyp_textRightMargin);
    }];
}

#pragma mark - 更新
- (void)xyf_updateNotice:(NSString *)notice {
    if ([self.xyp_themeLabel.text isEqualToString:notice]) {
        return;
    }
    
    self.xyp_themeLabel.text = notice;
    CGFloat contentWidth = [self.xyp_themeLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 18) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.xyp_themeLabel.font} context:nil].size.width;
    CGFloat totalWidth = ceil(contentWidth) + self.xyp_textLeftMargin + self.xyp_textRightMargin + 1;
    totalWidth = totalWidth < self.xyp_maxViewWidth ? totalWidth : self.xyp_maxViewWidth;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(totalWidth);
    }];
}

#pragma mark - Lazy
- (UIView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIView alloc] init];
        _xyp_bgView.clipsToBounds = YES;
        _xyp_bgView.layer.cornerRadius = 11;
        _xyp_bgView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.3);
    }
    return _xyp_bgView;
}

- (UIImageView *)xyp_iconIV {
    if (!_xyp_iconIV) {
        _xyp_iconIV = [[UIImageView alloc] init];
        _xyp_iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_iconIV.clipsToBounds = YES;
        [XYCUtil xyf_loadIconImage:_xyp_iconIV iconStr:@"xyr_top_info_notice_icon"];
    }
    return _xyp_iconIV;
}

- (OWLMusicAutoScrollLabel *)xyp_themeLabel {
    if (!_xyp_themeLabel) {
        _xyp_themeLabel = [OWLMusicAutoScrollLabel new];
        _xyp_themeLabel.textColor = kXYLColorFromRGB(0xFFFFFF);
        _xyp_themeLabel.font = kXYLGilroyMediumFont(12);
        _xyp_themeLabel.text = @"     ";
        [_xyp_themeLabel observeApplicationNotifications];
    }
    return _xyp_themeLabel;
}

@end
