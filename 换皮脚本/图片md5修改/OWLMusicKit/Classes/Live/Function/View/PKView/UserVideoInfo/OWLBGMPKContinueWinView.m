//
//  OWLBGMPKContinueWinView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

#import "OWLBGMPKContinueWinView.h"

@interface OWLBGMPKContinueWinView ()

/// 自己连胜图片
@property (nonatomic, strong) UIImageView *xyp_mineWinIV;
/// 自己连胜数量
@property (nonatomic, strong) UILabel *xyp_mineNumLabel;
/// 自己连胜图标
@property (nonatomic, strong) UIImageView *xyp_redWinIV;
/// 对方连胜图片
@property (nonatomic, strong) UIImageView *xyp_otherWinIV;
/// 对方连胜数量
@property (nonatomic, strong) UILabel *xyp_otherNumLabel;
/// 自己连胜图标
@property (nonatomic, strong) UIImageView *xyp_blueWinIV;

@end

@implementation OWLBGMPKContinueWinView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_mineWinIV];
    
    [self.xyp_mineWinIV addSubview:self.xyp_redWinIV];
    [self.xyp_redWinIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(11);
        make.centerY.equalTo(self.xyp_mineWinIV);
        make.leading.equalTo(self.xyp_mineWinIV).offset(6);
    }];
    
    [self.xyp_mineWinIV addSubview:self.xyp_mineNumLabel];
    [self.xyp_mineNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_mineWinIV).offset(18.5);
        make.trailing.equalTo(self.xyp_mineWinIV).offset(-6);
        make.centerY.equalTo(self.xyp_mineWinIV);
    }];
    
    [self addSubview:self.xyp_otherWinIV];
    
    [self.xyp_otherWinIV addSubview:self.xyp_blueWinIV];
    [self.xyp_blueWinIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(11);
        make.centerY.equalTo(self.xyp_otherWinIV);
        make.leading.equalTo(self.xyp_otherWinIV).offset(6);
    }];
    
    [self.xyp_otherWinIV addSubview:self.xyp_otherNumLabel];
    [self.xyp_otherNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_otherWinIV).offset(18.5);
        make.trailing.equalTo(self.xyp_otherWinIV).offset(-6);
        make.centerY.equalTo(self.xyp_otherWinIV);
    }];
}

#pragma mark - Setter
- (void)setXyp_minePlayerModel:(OWLMusicRoomPKPlayerModel *)xyp_minePlayerModel {
    _xyp_minePlayerModel = xyp_minePlayerModel;
    self.xyp_mineWinIV.hidden = xyp_minePlayerModel.dsb_wins <= 1;
    self.xyp_mineNumLabel.text = [NSString stringWithFormat:@"%ld wins",(long)xyp_minePlayerModel.dsb_wins];
}

- (void)setXyp_otherPlayerModel:(OWLMusicRoomPKPlayerModel *)xyp_otherPlayerModel {
    _xyp_otherPlayerModel = xyp_otherPlayerModel;
    self.xyp_otherWinIV.hidden = xyp_otherPlayerModel.dsb_wins <= 1;
    self.xyp_otherNumLabel.text = [NSString stringWithFormat:@"%ld wins",(long)xyp_otherPlayerModel.dsb_wins];
}

#pragma mark - Lazy
- (UIImageView *)xyp_mineWinIV {
    if (!_xyp_mineWinIV) {
        _xyp_mineWinIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 64, 24)];
        _xyp_mineWinIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_mineWinIV.clipsToBounds = YES;
        _xyp_mineWinIV.hidden = YES;
        [XYCUtil xyf_loadIconImage:_xyp_mineWinIV iconStr:@"xyr_pk_continue_win_red_bg"];
    }
    return _xyp_mineWinIV;
}

- (UILabel *)xyp_mineNumLabel {
    if (!_xyp_mineNumLabel) {
        _xyp_mineNumLabel = [[UILabel alloc] init];
        _xyp_mineNumLabel.textColor = UIColor.whiteColor;
        _xyp_mineNumLabel.font = kXYLGilroyMediumFont(11);
        _xyp_mineNumLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_mineNumLabel.text = @"0 Wins";
    }
    return _xyp_mineNumLabel;
}

- (UIImageView *)xyp_redWinIV {
    if (!_xyp_redWinIV) {
        _xyp_redWinIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_redWinIV iconStr:@"xyr_pk_continue_win_red_icon"];
    }
    return _xyp_redWinIV;
}

- (UIImageView *)xyp_otherWinIV {
    if (!_xyp_otherWinIV) {
        _xyp_otherWinIV = [[UIImageView alloc] initWithFrame:CGRectMake(kXYLScreenWidth - 10 - 64, 0, 64, 24)];
        _xyp_otherWinIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_otherWinIV.clipsToBounds = YES;
        _xyp_otherWinIV.hidden = YES;
        [XYCUtil xyf_loadIconImage:_xyp_otherWinIV iconStr:@"xyr_pk_continue_win_blue_bg"];
    }
    return _xyp_otherWinIV;
}

- (UILabel *)xyp_otherNumLabel {
    if (!_xyp_otherNumLabel) {
        _xyp_otherNumLabel = [[UILabel alloc] init];
        _xyp_otherNumLabel.textColor = UIColor.whiteColor;
        _xyp_otherNumLabel.font = kXYLGilroyMediumFont(11);
        _xyp_otherNumLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_otherNumLabel.text = @"0 Wins";
    }
    return _xyp_otherNumLabel;
}

- (UIImageView *)xyp_blueWinIV {
    if (!_xyp_blueWinIV) {
        _xyp_blueWinIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_blueWinIV iconStr:@"xyr_pk_continue_win_blue_icon"];
    }
    return _xyp_blueWinIV;
}

@end
