//// OWLBGMUserDetailDataInfoSubView.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 数据信息视图 - 子视图
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMUserDetailDataInfoSubView.h"

@interface OWLBGMUserDetailDataInfoSubView()

/// 数据
@property (nonatomic, strong) UILabel *xyp_numLabel;
/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;

@end

@implementation OWLBGMUserDetailDataInfoSubView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_numLabel];
    [self.xyp_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self).offset(2);
        make.height.mas_equalTo(27);
    }];
    
    [self addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_numLabel.mas_bottom);
        make.leading.trailing.equalTo(self);
    }];
}

#pragma mark - Setter
- (void)setXyp_title:(NSString *)xyp_title {
    _xyp_title = xyp_title;
    self.xyp_titleLabel.text = xyp_title;
}

- (void)setXyp_num:(NSInteger)xyp_num {
    _xyp_num = xyp_num;
    self.xyp_numLabel.text = [XYCUtil xyf_getKiloNum:xyp_num];
}

#pragma mark - Lazy
- (UILabel *)xyp_numLabel {
    if (!_xyp_numLabel) {
        _xyp_numLabel = [[UILabel alloc] init];
        _xyp_numLabel.textColor = kXYLColorFromRGB(0x333333);
        _xyp_numLabel.font = kXYLGilroyBoldFont(16);
        _xyp_numLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_numLabel.text = @"0";
    }
    return _xyp_numLabel;
}

- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.textColor = kXYLColorFromRGB(0xB0B0B1);
        _xyp_titleLabel.font = kXYLGilroyMediumFont(12);
        _xyp_titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_titleLabel;
}

@end
