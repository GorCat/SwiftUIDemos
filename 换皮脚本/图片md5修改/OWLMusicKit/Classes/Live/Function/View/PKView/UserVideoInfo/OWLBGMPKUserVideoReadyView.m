//
//  OWLBGMPKUserVideoReadyView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层 - 用户pk信息视图 - 准备视图
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLBGMPKUserVideoReadyView.h"

@interface OWLBGMPKUserVideoReadyView ()

/// 自己的准备状态
@property (nonatomic, strong) UIButton *xyp_mineReadyButton;
/// 对方的准备状态
@property (nonatomic, strong) UIButton *xyp_otherReadyButton;

@end

@implementation OWLBGMPKUserVideoReadyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    self.layer.cornerRadius = 13.5;
    self.clipsToBounds = YES;
    [self addSubview:self.xyp_mineReadyButton];
    [self addSubview:self.xyp_otherReadyButton];
}

#pragma mark - Setter
- (void)setXyp_minePlayerModel:(OWLMusicRoomPKPlayerModel *)xyp_minePlayerModel {
    _xyp_minePlayerModel = xyp_minePlayerModel;
    self.xyp_mineReadyButton.hidden = xyp_minePlayerModel.dsb_roomStatus != XYLModuleRoomStateType_WaitNextPKing;
}

- (void)setXyp_otherPlayerModel:(OWLMusicRoomPKPlayerModel *)xyp_otherPlayerModel {
    _xyp_otherPlayerModel = xyp_otherPlayerModel;
    self.xyp_otherReadyButton.hidden = xyp_otherPlayerModel.dsb_roomStatus != XYLModuleRoomStateType_WaitNextPKing;
}

#pragma mark - Getter
- (CGRect)xyf_readyViewFrame {
    CGFloat width = 152;
    CGFloat height = 27;
    CGFloat x = (kXYLScreenWidth - width) / 2.0;
    CGFloat y = kXYLPKVideoViewHeight - height - 50;
    return CGRectMake(x, y, width, height);
}

#pragma mark - Lazy
- (UIButton *)xyp_mineReadyButton {
    if (!_xyp_mineReadyButton) {
        _xyp_mineReadyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 76, 27)];
        _xyp_mineReadyButton.userInteractionEnabled = NO;
        [_xyp_mineReadyButton setTitle:kXYLLocalString(@"Ready") forState:UIControlStateNormal];
        [_xyp_mineReadyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _xyp_mineReadyButton.titleLabel.font = kXYLGilroyBoldFont(14);
        [_xyp_mineReadyButton setBackgroundImage:[UIImage imageWithGradient:@[kXYLColorFromRGB(0xE93D64), kXYLColorFromRGB(0xED7799)] size:CGSizeMake(76, 27) direction:UIImageGradientDirectionHorizontal] forState:UIControlStateNormal];
        _xyp_mineReadyButton.hidden = YES;
    }
    return _xyp_mineReadyButton;
}

- (UIButton *)xyp_otherReadyButton {
    if (!_xyp_otherReadyButton) {
        _xyp_otherReadyButton = [[UIButton alloc] initWithFrame:CGRectMake(76, 0, 76, 27)];
        _xyp_otherReadyButton.userInteractionEnabled = NO;
        [_xyp_otherReadyButton setTitle:kXYLLocalString(@"Ready") forState:UIControlStateNormal];
        [_xyp_otherReadyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _xyp_otherReadyButton.titleLabel.font = kXYLGilroyBoldFont(14);
        [_xyp_otherReadyButton setBackgroundImage:[UIImage imageWithGradient:@[kXYLColorFromRGB(0x6E7BF6), kXYLColorFromRGB(0x304AF5)] size:CGSizeMake(76, 27) direction:UIImageGradientDirectionHorizontal] forState:UIControlStateNormal];
        _xyp_otherReadyButton.hidden = YES;
    }
    return _xyp_otherReadyButton;
}

@end
