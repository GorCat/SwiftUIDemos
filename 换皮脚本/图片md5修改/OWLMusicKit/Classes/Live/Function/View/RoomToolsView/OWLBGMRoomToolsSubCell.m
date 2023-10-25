//// OWLBGMRoomToolsSubCell.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间工具视图弹窗 - 工具类型视图
 * @创建时间：2023.2.11
 * @创建人：许琰
 */

#import "OWLBGMRoomToolsSubCell.h"

@interface OWLBGMRoomToolsSubCell ()

/// 按钮
@property (nonatomic, strong) UIImageView *xyp_iconIV;
/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;

@end

@implementation OWLBGMRoomToolsSubCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_iconIV];
    [self.xyp_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.height.width.mas_equalTo(40);
    }];
    
    [self addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.xyp_iconIV.mas_bottom).offset(7);
    }];
}

#pragma mark - Setter
- (void)setXyp_type:(OWLBGMRoomToolsSubCellType)xyp_type {
    _xyp_type = xyp_type;
    switch (xyp_type) {
        case OWLBGMRoomToolsSubCellType_Recharge:
            self.xyp_titleLabel.text = kXYLLocalString(@"Recharge");
            [XYCUtil xyf_loadIconImage:self.xyp_iconIV iconStr:@"xyr_bottom_tools_recharge_icon"];
            break;
        case OWLBGMRoomToolsSubCellType_Broadcast:
            self.xyp_titleLabel.text = kXYLLocalString(@"Broadcast");
            if (OWLJConvertToolShared.xyf_isCloseBroadcast) {
                [XYCUtil xyf_loadIconImage:self.xyp_iconIV iconStr:@"xyr_bottom_tools_broadcast_off_icon"];
            } else {
                [XYCUtil xyf_loadIconImage:self.xyp_iconIV iconStr:@"xyr_bottom_tools_broadcast_on_icon"];
            }
            break;
        case OWLBGMRoomToolsSubCellType_StreamSettings:
            self.xyp_titleLabel.text = kXYLLocalString(@"Stream Settings");
            [XYCUtil xyf_loadIconImage:self.xyp_iconIV iconStr:@"xyr_bottom_tools_streamSettings_icon"];
            break;
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_iconIV {
    if (!_xyp_iconIV) {
        _xyp_iconIV = [[UIImageView alloc] init];
        _xyp_iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_iconIV.clipsToBounds = YES;
    }
    return _xyp_iconIV;
}

- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.textColor = kXYLColorFromRGB(0xAAABAF);
        _xyp_titleLabel.font = kXYLGilroyMediumFont(10);
        _xyp_titleLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_titleLabel.numberOfLines = 2;
    }
    return _xyp_titleLabel;
}

@end
