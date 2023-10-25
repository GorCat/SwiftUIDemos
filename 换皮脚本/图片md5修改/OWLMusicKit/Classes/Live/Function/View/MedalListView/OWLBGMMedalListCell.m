//
//  OWLBGMMedalListCell.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

/**
 * @功能描述：直播间用户奖章弹窗 - cell
 * @创建时间：2023.2.13
 * @创建人：许琰
 */

#import "OWLBGMMedalListCell.h"

@interface OWLBGMMedalListCell()

/// 背景
@property (nonatomic, strong) UIView *xyp_bgView;
/// 图标
@property (nonatomic, strong) UIImageView *xyp_iconIV;
/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;
/// 副标题
@property (nonatomic, strong) UILabel *xyp_subtitleLabel;
/// 时间背景
@property (nonatomic, strong) UIView *xyp_timeBGView;
/// 时间
@property (nonatomic, strong) UILabel *xyp_timeLabel;
/// 选中图标
@property (nonatomic, strong) UIImageView *xyp_selectImg;

@end

@implementation OWLBGMMedalListCell

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
    
    [self.contentView addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(16);
        make.trailing.equalTo(self).offset(-16);
        make.top.bottom.equalTo(self);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_iconIV];
    [self.xyp_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_bgView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(86);
        make.leading.equalTo(self.xyp_bgView).offset(10);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_bgView).offset(15);
        make.leading.equalTo(self.xyp_iconIV.mas_trailing).offset(9.5);
        make.trailing.equalTo(self.xyp_bgView).offset(-14);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_subtitleLabel];
    [self.xyp_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_titleLabel.mas_bottom).offset(4);
        make.leading.equalTo(self.xyp_iconIV.mas_trailing).offset(9.5);
        make.trailing.equalTo(self.xyp_bgView).offset(-14);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_timeBGView];
    [self.xyp_timeBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self.xyp_bgView);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(65);
    }];
    
    [self.xyp_timeBGView addSubview:self.xyp_timeLabel];
    [self.xyp_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.xyp_timeBGView);
    }];
    
    [XYCUtil xyf_loadMainLanguageImage:self.xyp_selectImg iconStr:@"xyr_medal_selected"];
    [self.xyp_bgView addSubview:self.xyp_selectImg];
    [self.xyp_selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.equalTo(self.xyp_bgView);
        make.size.mas_equalTo(CGSizeMake(31, 15));
    }];
}

#pragma mark - Setter
- (void)setXyp_model:(OWLMusicEventLabelModel *)xyp_model {
    _xyp_model = xyp_model;
    self.xyp_titleLabel.text = xyp_model.dsb_labelTitle;
    self.xyp_subtitleLabel.text = xyp_model.dsb_labelTip;
    [XYCUtil xyf_loadOriginImage:self.xyp_iconIV url:xyp_model.dsb_labelUrl placeholder:nil];
    NSInteger timeInterval = xyp_model.dsb_leftTime - ([[NSDate date] timeIntervalSince1970] - [self xyf_timeStampFrom1907To2017]);
    NSInteger timeStr = timeInterval / 3600 / 24;
    self.xyp_timeLabel.text = timeStr > 3650 ? kXYLLocalString(@"Permanent") : [NSString stringWithFormat:kXYLLocalString(@"%ld days"), timeStr];
}

- (void)xyf_setCellSelected:(BOOL)xy_select {
    [self.xyp_selectImg setHidden:!xy_select];
    if (xy_select) {
        self.xyp_bgView.layer.borderColor = kXYLColorFromRGB(0xE94179).CGColor;
    } else {
        self.xyp_bgView.layer.borderColor = kXYLColorFromRGB(0xF3F4F7).CGColor;
    }
}

/// 2017年到现在的时间戳
- (NSInteger)xyf_timeStampFrom1907To2017 {
    NSString *str = @"2017-01-01 00:00:00 +0000";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([self xyf_is12HourFormat]) {
        formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss Z";
    }else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    }
    
    NSDate *date = [formatter dateFromString:str];
    NSTimeInterval newDate = [date timeIntervalSince1970];
    NSInteger second = [[NSNumber numberWithDouble:newDate] integerValue];
    return second;
}

/// 是否是12小时制
- (BOOL)xyf_is12HourFormat {
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA =[formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM =containsA.location != NSNotFound;
    return hasAMPM;
}

#pragma mark - Lazy
- (UIView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIView alloc] init];
        _xyp_bgView.backgroundColor = kXYLColorFromRGB(0xF3F4F7);
        _xyp_bgView.layer.cornerRadius = 15;
        _xyp_bgView.layer.borderWidth = 1;
        _xyp_bgView.layer.borderColor = kXYLColorFromRGB(0xF3F4F7).CGColor;
        _xyp_bgView.clipsToBounds = YES;
    }
    return _xyp_bgView;
}

- (UIImageView *)xyp_iconIV {
    if (!_xyp_iconIV) {
        _xyp_iconIV = [[UIImageView alloc] init];
        _xyp_iconIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _xyp_iconIV;
}

- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.font = kXYLGilroyBoldFont(14);
        _xyp_titleLabel.textColor = kXYLColorFromRGB(0x080808);
        _xyp_titleLabel.textAlignment = NSTextAlignmentLeft;
        [_xyp_titleLabel xyf_atl];
    }
    return _xyp_titleLabel;
}

- (UILabel *)xyp_subtitleLabel {
    if (!_xyp_subtitleLabel) {
        _xyp_subtitleLabel = [[UILabel alloc] init];
        _xyp_subtitleLabel.font = kXYLGilroyMediumFont(11);
        _xyp_subtitleLabel.textColor = kXYLColorFromRGB(0x838393);
        _xyp_subtitleLabel.textAlignment = NSTextAlignmentLeft;
        [_xyp_subtitleLabel xyf_atl];
    }
    return _xyp_subtitleLabel;
}

- (UIView *)xyp_timeBGView {
    if (!_xyp_timeBGView) {
        _xyp_timeBGView = [[UIView alloc] init];
        _xyp_timeBGView.clipsToBounds = YES;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kXYLColorFromRGB(0xE6E8EE);
        view.layer.cornerRadius = 15;
        [_xyp_timeBGView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.equalTo(_xyp_timeBGView);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(90);
        }];
    }
    return _xyp_timeBGView;
}

- (UILabel *)xyp_timeLabel {
    if (!_xyp_timeLabel) {
        _xyp_timeLabel = [[UILabel alloc] init];
        _xyp_timeLabel.font = kXYLGilroyMediumFont(9);
        _xyp_timeLabel.textColor = kXYLColorFromRGB(0x838393);
        _xyp_timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_timeLabel;
}

- (UIImageView *)xyp_selectImg {
    if (!_xyp_selectImg) {
        _xyp_selectImg = [[UIImageView alloc] init];
    }
    return _xyp_selectImg;
}

@end
