//
//  OWLBGMTopTargetCoinsView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

/**
 * @功能描述：直播间顶部视图-目标金额
 * @创建时间：2023.2.10
 * @创建人：许琰
 */

#import "OWLBGMTopTargetCoinsView.h"

@interface OWLBGMTopTargetCoinsView ()

#pragma mark - Views
/// 背景
@property (nonatomic, strong) UIView *xyp_bgView;
/// icon
@property (nonatomic, strong) UIImageView *xyp_icon;
/// 当前进度
@property (nonatomic, strong) UIView *xyp_currentProgressView;
/// 数字
@property (nonatomic, strong) UILabel *xyp_numLabel;

#pragma mark - Layout
/// 文字左边间距
@property (nonatomic, assign) CGFloat xyp_textLeftMargin;
/// 文字右边间距
@property (nonatomic, assign) CGFloat xyp_textRightMargin;
/// 视图最大宽度
@property (nonatomic, assign) CGFloat xyp_maxViewWidth;
/// 视图最小宽度
@property (nonatomic, assign) CGFloat xyp_minViewWidth;

#pragma mark - Data
/// 目标模型
@property (nonatomic, strong) OWLMusicRoomGoalModel *xyp_goalModel;
/// 目标数量的数字个数
@property (nonatomic, assign) NSInteger xyp_goalNumCount;

@end

@implementation OWLBGMTopTargetCoinsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupLayout];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout {
    self.xyp_textLeftMargin = 27.5;
    self.xyp_textRightMargin = 10;
    self.xyp_maxViewWidth = kXYLScreenWidth - 140 - 94;
    self.xyp_minViewWidth = 85;
}

- (void)xyf_setupView {
    [self addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_currentProgressView];
    
    [self.xyp_bgView addSubview:self.xyp_icon];
    [self.xyp_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(12);
        make.centerY.equalTo(self.xyp_bgView);
        make.leading.equalTo(self.xyp_bgView).offset(5);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_numLabel];
    [self.xyp_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_bgView).offset(self.xyp_textLeftMargin);
        make.trailing.equalTo(self.xyp_bgView).offset(-self.xyp_textRightMargin);
        make.centerY.equalTo(self.xyp_bgView);
    }];
}

#pragma mark - Public
- (void)xyf_updateRoomGoal:(OWLMusicRoomGoalModel *)model {
    /// 更新最大宽度
    [self xyf_updateMaxWidth:model];
    
    /// 更新数值
    [self xyf_updateNum:model];
    
    self.xyp_goalModel = model;
}

/// 更新最大宽度
- (void)xyf_updateMaxWidth:(OWLMusicRoomGoalModel *)model {
    if (self.xyp_goalModel.dsb_goalCoin == model.dsb_goalCoin) {
        return;
    }
    NSString *goalStr = [NSString stringWithFormat:@"%ld",(long)model.dsb_goalCoin];
    if (self.xyp_goalNumCount == goalStr.length) {
        return;
    }
    self.xyp_goalNumCount = goalStr.length;
    NSMutableString *singleMaxStr = [NSMutableString new];
    for (int i = 0; i < goalStr.length; i++) {
        [singleMaxStr appendString:@"0"];
    }
    NSString *maxStr = [NSString stringWithFormat:@"%@/%@",singleMaxStr, singleMaxStr];
    
    CGFloat contentWidth = [maxStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 18) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.xyp_numLabel.font} context:nil].size.width;
    CGFloat totalWidth = ceil(contentWidth) + self.xyp_textLeftMargin + self.xyp_textRightMargin;
    if (totalWidth > self.xyp_maxViewWidth) {
        totalWidth = self.xyp_maxViewWidth;
    } else if (totalWidth < self.xyp_minViewWidth) {
        totalWidth = self.xyp_minViewWidth;
    }
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(totalWidth);
//    }];
}

/// 更新数值
- (void)xyf_updateNum:(OWLMusicRoomGoalModel *)model {
    self.xyp_numLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)model.dsb_currentCoin,(long)model.dsb_goalCoin];
    double progress = [model xyf_getCurrentProgress];
    [self.xyp_currentProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self.xyp_bgView);
        make.width.equalTo(self.xyp_bgView).multipliedBy(progress);
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

- (UIView *)xyp_currentProgressView {
    if (!_xyp_currentProgressView) {
        _xyp_currentProgressView = [[UIView alloc] init];
        _xyp_currentProgressView.backgroundColor = kXYLColorFromRGB(0xE94179);
    }
    return _xyp_currentProgressView;
}

- (UIImageView *)xyp_icon {
    if (!_xyp_icon) {
        _xyp_icon = [[UIImageView alloc] init];
        _xyp_icon.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_icon.clipsToBounds = YES;
        [XYCUtil xyf_loadIconImage:_xyp_icon iconStr:@"xyr_top_info_coin_icon"];
    }
    return _xyp_icon;
}

- (UILabel *)xyp_numLabel {
    if (!_xyp_numLabel) {
        _xyp_numLabel = [[UILabel alloc] init];
        _xyp_numLabel.textColor = UIColor.whiteColor;
        _xyp_numLabel.font = kXYLGilroyMediumFont(12);
        _xyp_numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_numLabel;
}

@end
