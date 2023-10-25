//
//  OWLBGMTopRoomDetailInfoAlertView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

/**
 * @功能描述：直播间顶部视图-房间信息详情弹窗
 * @创建时间：2023.2.10
 * @创建人：许琰
 */

#import "OWLBGMTopRoomDetailInfoAlertView.h"

@interface OWLBGMTopRoomDetailInfoAlertView ()

#pragma mark - 容器
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 背景view
@property (nonatomic, strong) UIImageView *xyp_bgView;
/// 容器view
@property (nonatomic, strong) UIView *xyp_contentView;

#pragma mark - 目标金币
/// 金币容器
@property (nonatomic, strong) UIView *xyp_coinBGView;
/// 金币图标
@property (nonatomic, strong) UIImageView *xyp_coinIV;
/// 金币标题
@property (nonatomic, strong) UILabel *xyp_coinTitleLabel;
/// 金币数量
@property (nonatomic, strong) UILabel *xyp_coinNumLabel;
/// 总进度条
@property (nonatomic, strong) UIView *xyp_totalProgressView;
/// 当前进度条
@property (nonatomic, strong) UIView *xyp_currentProgressView;

#pragma mark - 房间主题
/// 主题图标
@property (nonatomic, strong) UIImageView *xyp_themeIV;
/// 主题标题
@property (nonatomic, strong) UILabel *xyp_themeTitleLabel;
/// 主题
@property (nonatomic, strong) UILabel *xyp_themeLabel;

#pragma mark - 礼物按钮
/// 礼物按钮
@property (nonatomic, strong) UIButton *xyp_giftButton;

#pragma mark - Data
/// 房间目标模型
@property (nonatomic, strong) OWLMusicRoomGoalModel *goalModel;
/// 左边间距
@property (nonatomic, assign) CGFloat xyp_leftMargin;

#pragma mark - Block
/// 页面消失的回调
@property (nonatomic, copy, nullable) XYLVoidBlock xyp_dismissBlock;

@end

@implementation OWLBGMTopRoomDetailInfoAlertView

+ (instancetype)xyf_showRoomDetailAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                 targetView:(UIView *)targetView
                                       goal:(OWLMusicRoomGoalModel *)goalModel
                                 leftMargin:(CGFloat)leftMargin
                               dismissBlock:(XYLVoidBlock)dismissBlock {
    OWLBGMTopRoomDetailInfoAlertView *view = [[OWLBGMTopRoomDetailInfoAlertView alloc] initWithGoal:goalModel leftMargin:leftMargin];
    view.xyp_dismissBlock = dismissBlock;
    view.delegate = delegate;
    [view xyf_showInView:targetView];
    
    return view;
}

- (instancetype)initWithGoal:(OWLMusicRoomGoalModel *)goalModel leftMargin:(CGFloat)leftMargin {
    self = [super init];
    if (self) {
        [self xyf_setupLayout:leftMargin];
        [self xyf_setupView];
        [self xyf_updateRoomGoal:goalModel isInit:YES];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout:(CGFloat)leftMargin {
    CGFloat maxLeftMargin = kXYLScreenWidth - [self xyf_getTotalWidth] - 12;
    self.xyp_leftMargin = leftMargin > maxLeftMargin ? maxLeftMargin : leftMargin;
    self.frame = CGRectMake([self xyf_getViewPoint].x, [self xyf_getViewPoint].y, [self xyf_getTotalWidth], 0);
}

- (void)xyf_setupView {
    self.clipsToBounds = YES;
    
    [self addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_contentView];
    [self.xyp_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.xyp_bgView);
        make.top.equalTo(self.xyp_bgView).offset([self xyf_getContentViewTopMargin]);
    }];
    
    /// ---- 目标金币视图 ----
    [_xyp_contentView addSubview:self.xyp_coinBGView];
    [self.xyp_coinBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(_xyp_contentView);
        make.height.mas_equalTo(34);
        make.top.equalTo(_xyp_contentView).offset(10);
    }];
    
    /// ---- 房间主题视图 ----
    [_xyp_contentView addSubview:self.xyp_themeIV];
    [self.xyp_themeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(12);
        make.leading.equalTo(_xyp_contentView).offset(6);
        make.top.equalTo(self.xyp_coinBGView.mas_bottom).offset(11);
    }];
    
    [_xyp_contentView addSubview:self.xyp_themeTitleLabel];
    [self.xyp_themeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_themeIV.mas_trailing).offset(1);
        make.trailing.equalTo(_xyp_contentView).offset(-6);
        make.centerY.equalTo(self.xyp_themeIV);
    }];
    
    [_xyp_contentView addSubview:self.xyp_themeLabel];
    [self.xyp_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_xyp_contentView).offset([self xyf_getThemeLabelInsets].left);
        make.trailing.equalTo(_xyp_contentView).offset(-[self xyf_getThemeLabelInsets].right);
        make.top.equalTo(_xyp_contentView).offset([self xyf_getThemeLabelInsets].top);
        make.bottom.equalTo(_xyp_contentView).offset(-[self xyf_getThemeLabelInsets].bottom);
    }];

    /// ---- 礼物按钮视图 ----
    [_xyp_contentView addSubview:self.xyp_giftButton];
    [self.xyp_giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_xyp_contentView).offset(-12);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(28);
        make.centerX.equalTo(_xyp_contentView);
    }];
}

#pragma mark - 更新
/// 更新数据
- (void)xyf_updateRoomGoal:(OWLMusicRoomGoalModel *)goal isInit:(BOOL)isInit {
    self.goalModel = goal;
    self.xyp_themeLabel.text = goal.dsb_desc;
    NSString * str = [NSString stringWithFormat:@"%ld/%ld",goal.dsb_currentCoin,goal.dsb_goalCoin];
    self.xyp_coinNumLabel.text = str;
    
    double progress = [goal xyf_getCurrentProgress];
    [self.xyp_currentProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self.xyp_totalProgressView);
        make.width.equalTo(self.xyp_totalProgressView).multipliedBy(progress);
    }];
    if (!isInit) {
        [self xyf_refreshViewHeight];
    }
}

/// 更新view高度
- (void)xyf_refreshViewHeight {
    CGFloat textH = [self xyf_getTextHeight:self.goalModel.dsb_desc];
    CGFloat viewH = [self xyf_getTotalHeight:textH];
    [UIView animateWithDuration:0.3 animations:^{
        self.xyp_h = viewH;
    }];
}

#pragma mark - 动画
/// 展示
- (void)xyf_showInView:(UIView *)view {
    [view addSubview:self.xyp_overyView];
    [view addSubview:self];
    [self xyf_refreshViewHeight];
}

/// 消失
- (void)xyf_dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.xyp_overyView removeFromSuperview];
            [self removeFromSuperview];
            !self.xyp_dismissBlock?:self.xyp_dismissBlock();
        }
    }];
}

#pragma mark - Actions
/// 点击礼物按钮
- (void)xyf_giftButtonAction {
    [self xyf_dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickEvent:)]) {
        [self.delegate xyf_lModuleBaseViewClickEvent:XYLModuleBaseViewClickType_ShowGiftList];
    }
}

/// 消失
- (void)xyf_overyViewAction {
    [self xyf_dismiss];
}

#pragma mark - Getter
/// 获取整体point
- (CGPoint)xyf_getViewPoint {
    return CGPointMake(self.xyp_leftMargin, kXYLRoomInfoHeaderViewTopMargin + kXYLRoomInfoHeaderViewHeight + 5);
}

/// 获取整体宽度
- (CGFloat)xyf_getTotalWidth {
    return kXYLDetailRoomWidth;
}

/// 获取整体高度
- (CGFloat)xyf_getTotalHeight:(CGFloat)textHeight {
    /// 整体高度 = 内容视图顶部间距 + 主题顶部间距 + 主题高度 + 主题底部间距
    return [self xyf_getContentViewTopMargin] + [self xyf_getThemeLabelInsets].top + textHeight + [self xyf_getThemeLabelInsets].bottom;
}

/// 获取文本高度
- (CGFloat)xyf_getTextHeight:(NSString *)text {
    CGSize size = [self.xyp_themeLabel sizeThatFits:CGSizeMake([self xyf_getTotalWidth] - [self xyf_getThemeLabelInsets].left - [self xyf_getThemeLabelInsets].right, MAXFLOAT)];
    return size.height + 1;
}

/// 内容视图顶部间距
- (CGFloat)xyf_getContentViewTopMargin {
    return 10;
}

/// 获取主题四周间距
- (UIEdgeInsets)xyf_getThemeLabelInsets {
    return UIEdgeInsetsMake(67, 8, 52, 8);
}

#pragma mark - Lazy
- (UIControl *)xyp_overyView {
    if (!_xyp_overyView) {
        _xyp_overyView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_overyView.backgroundColor = UIColor.clearColor;
        [_xyp_overyView addTarget:self action:@selector(xyf_overyViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_overyView;
}

- (UIImageView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIImageView alloc] init];
        UIImage * img = [XYCUtil xyf_getIconWithName:@"xyr_top_alert_bg_image"].xyf_getMirroredImage;
        _xyp_bgView.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
        _xyp_bgView.userInteractionEnabled = YES;
    }
    return _xyp_bgView;
}

- (UIView *)xyp_contentView {
    if (!_xyp_contentView) {
        _xyp_contentView = [[UIView alloc] init];
        _xyp_contentView.backgroundColor = UIColor.clearColor;
        _xyp_contentView.layer.cornerRadius = 12;
    }
    return _xyp_contentView;
}

- (UIView *)xyp_coinBGView {
    if (!_xyp_coinBGView) {
        _xyp_coinBGView = [[UIView alloc] init];
        
        [_xyp_coinBGView addSubview:self.xyp_coinIV];
        [self.xyp_coinIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(10);
            make.top.equalTo(_xyp_coinBGView);
            make.leading.equalTo(_xyp_coinBGView).offset(8);
        }];
        
        [_xyp_coinBGView addSubview:self.xyp_coinTitleLabel];
        [self.xyp_coinTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.xyp_coinIV.mas_trailing).offset(1);
            make.centerY.equalTo(self.xyp_coinIV);
            make.trailing.equalTo(self.xyp_coinBGView);
        }];
        
        [_xyp_coinBGView addSubview:self.xyp_coinNumLabel];
        [self.xyp_coinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.xyp_coinIV.mas_bottom).offset(5);
            make.leading.equalTo(_xyp_coinBGView).offset(8);
            make.trailing.equalTo(_xyp_coinBGView).offset(-8);
        }];
        
        [_xyp_coinBGView addSubview:self.xyp_totalProgressView];
        [self.xyp_totalProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_xyp_coinBGView).offset(8);
            make.trailing.equalTo(_xyp_coinBGView).offset(-8);
            make.bottom.equalTo(_xyp_coinBGView);
            make.height.mas_equalTo(3);
        }];
        
        [self.xyp_totalProgressView addSubview:self.xyp_currentProgressView];
        [self.xyp_currentProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self.xyp_totalProgressView);
            make.width.equalTo(self.xyp_totalProgressView).multipliedBy(0.0);
        }];
    }
    return _xyp_coinBGView;
}

- (UIImageView *)xyp_coinIV {
    if (!_xyp_coinIV) {
        _xyp_coinIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_coinIV iconStr:@"xyr_top_info_coin_icon"];
        _xyp_coinIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xyp_coinIV;
}

- (UILabel *)xyp_coinTitleLabel {
    if (!_xyp_coinTitleLabel) {
        _xyp_coinTitleLabel = [[UILabel alloc] init];
        _xyp_coinTitleLabel.textColor = kXYLColorFromRGBA(0xffffff, 0.7);
        _xyp_coinTitleLabel.font = kXYLGilroyMediumFont(11);
        _xyp_coinTitleLabel.text = kXYLLocalString(@"Room Quota");
    }
    return _xyp_coinTitleLabel;
}

- (UILabel *)xyp_coinNumLabel {
    if (!_xyp_coinNumLabel) {
        _xyp_coinNumLabel = [[UILabel alloc] init];
        _xyp_coinNumLabel.textColor = UIColor.whiteColor;
        _xyp_coinNumLabel.font = kXYLGilroyExtraBoldItalicFont(11);
    }
    return _xyp_coinNumLabel;
}

- (UIView *)xyp_totalProgressView {
    if (!_xyp_totalProgressView) {
        _xyp_totalProgressView = [[UIView alloc] init];
        _xyp_totalProgressView.backgroundColor = kXYLColorFromRGBA(0xffffff, 0.3);
        _xyp_totalProgressView.layer.cornerRadius = 1.5;
        _xyp_totalProgressView.clipsToBounds = YES;
    }
    return _xyp_totalProgressView;
}

- (UIView *)xyp_currentProgressView {
    if (!_xyp_currentProgressView) {
        _xyp_currentProgressView = [[UIView alloc] init];
        _xyp_currentProgressView.backgroundColor = kXYLColorFromRGB(0xffffff);
        _xyp_currentProgressView.layer.cornerRadius = 1.5;
        _xyp_currentProgressView.clipsToBounds = YES;
    }
    return _xyp_currentProgressView;
}

- (UIImageView *)xyp_themeIV {
    if (!_xyp_themeIV) {
        _xyp_themeIV = [[UIImageView alloc] init];
        _xyp_themeIV.contentMode = UIViewContentModeScaleAspectFill;
        [XYCUtil xyf_loadIconImage:_xyp_themeIV iconStr:@"xyr_top_alert_notice_icon"];
    }
    return _xyp_themeIV;
}

- (UILabel *)xyp_themeTitleLabel {
    if (!_xyp_themeTitleLabel) {
        _xyp_themeTitleLabel = [[UILabel alloc] init];
        _xyp_themeTitleLabel.textColor = kXYLColorFromRGBA(0xffffff, 0.7);
        _xyp_themeTitleLabel.font = kXYLGilroyMediumFont(11);
        _xyp_themeTitleLabel.text = kXYLLocalString(@"Notice");
    }
    return _xyp_themeTitleLabel;
}

- (UILabel *)xyp_themeLabel {
    if (!_xyp_themeLabel) {
        _xyp_themeLabel = [[UILabel alloc] init];
        _xyp_themeLabel.textColor = UIColor.whiteColor;
        _xyp_themeLabel.font = kXYLGilroyBoldFont(11);
        _xyp_themeLabel.numberOfLines = 0;
    }
    return _xyp_themeLabel;
}

- (UIButton *)xyp_giftButton {
    if (!_xyp_giftButton) {
        _xyp_giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xyp_giftButton setBackgroundColor:UIColor.whiteColor];
        [_xyp_giftButton setTitle:kXYLLocalString(@"Send gift") forState:UIControlStateNormal];
        [_xyp_giftButton setTitleColor:kXYLColorFromRGB(0xEA417F) forState:UIControlStateNormal];
        _xyp_giftButton.titleLabel.font = kXYLGilroyBoldFont(13);
        _xyp_giftButton.layer.cornerRadius = 14;
        _xyp_giftButton.clipsToBounds = YES;
        [_xyp_giftButton addTarget:self action:@selector(xyf_giftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_giftButton;
}

@end
