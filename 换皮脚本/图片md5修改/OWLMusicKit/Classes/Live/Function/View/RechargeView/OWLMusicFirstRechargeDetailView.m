//
//  OWLMusicFirstRechargeDetailView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/21.
//

#import "OWLMusicFirstRechargeDetailView.h"

@interface OWLMusicFirstRechargeDetailView ()

#pragma mark - Views
/// 背景
@property (nonatomic, strong) UIImageView *xyp_bgIV;
/// 详情
@property (nonatomic, strong) UILabel *xyp_detailLabel;
/// 图标
@property (nonatomic, strong) UIImageView *xyp_iconIV;
/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;
/// 原价
@property (nonatomic, strong) UILabel *xyp_originLabel;

#pragma mark - Data
/// 类型
@property (nonatomic, assign) NSInteger xyp_type;
/// 商品模型
@property (nonatomic, strong) OWLMusicProductModel *xyp_productModel;

@end

@implementation OWLMusicFirstRechargeDetailView

- (instancetype)initWithType:(OWLMusicFirstRechargeDetailType)type
                productModel:(OWLMusicProductModel *)productModel {
    self = [super init];
    if (self) {
        self.xyp_type = type;
        self.xyp_productModel = productModel;
        [self xyf_setupView];
        [self xyf_setupData];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgIV];
    [self.xyp_bgIV addSubview:self.xyp_detailLabel];
    [self.xyp_bgIV addSubview:self.xyp_iconIV];
    [self.xyp_bgIV addSubview:self.xyp_titleLabel];
    
    [self.xyp_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.xyp_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_bgIV);
        make.top.equalTo(self.xyp_bgIV).offset(8);
    }];
    
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_bgIV);
        make.bottom.equalTo(self.xyp_bgIV).offset(-10);
    }];
    
    switch (self.xyp_type) {
        case OWLMusicFirstRechargeDetailType_Coin: {
            [self addSubview:self.xyp_originLabel];
            [self.xyp_originLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.xyp_titleLabel.mas_trailing).offset(4);
                make.bottom.equalTo(self.xyp_titleLabel.mas_bottom).offset(-1);
            }];
            
            [self.xyp_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.xyp_bgIV);
                make.height.width.mas_equalTo(26);
                make.top.equalTo(self.xyp_bgIV).offset(40);
            }];
        }
            break;
        case OWLMusicFirstRechargeDetailType_Vip: {
            [self.xyp_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.xyp_bgIV);
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(20.5);
                make.top.equalTo(self.xyp_bgIV).offset(42.5);
            }];
        }
            break;
    }
}

- (void)xyf_setupData {
    switch (self.xyp_type) {
        case OWLMusicFirstRechargeDetailType_Coin: {
            [XYCUtil xyf_loadIconImage:self.xyp_iconIV iconStr:@"xyr_discount_detail_coin_icon"];
            NSInteger totalCount = self.xyp_productModel.dsb_baseCount + self.xyp_productModel.dsb_extraCount;
            self.xyp_titleLabel.text = [NSString stringWithFormat:@"%ld",(long)totalCount];
            if (self.xyp_productModel.dsb_extraCount > 0) {
                NSString *originPriceStr = [NSString stringWithFormat:@"%ld",(long)self.xyp_productModel.dsb_baseCount];
                NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:originPriceStr];
                [atr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, atr.string.length)];
                [atr addAttributes:@{NSFontAttributeName: self.xyp_originLabel.font, NSForegroundColorAttributeName: self.xyp_originLabel.textColor} range:NSMakeRange(0, atr.string.length)];
                self.xyp_originLabel.attributedText = atr;
            }
            self.xyp_detailLabel.text = kXYLLocalString(@"Extra Coins");
        }
            break;
        case OWLMusicFirstRechargeDetailType_Vip: {
            self.xyp_detailLabel.text = kXYLLocalString(@"VIP Medal"); // duoyuyan
            self.xyp_titleLabel.text = kXYLLocalString(@"Permanent");
            [XYCUtil xyf_loadIconImage:self.xyp_iconIV iconStr:@"xyr_discount_detail_vip_icon"];
        }
            break;
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_bgIV {
    if (!_xyp_bgIV) {
        _xyp_bgIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_bgIV iconStr:@"xyr_discount_detail_bg_icon"];
    }
    return _xyp_bgIV;
}

- (UILabel *)xyp_detailLabel {
    if (!_xyp_detailLabel) {
        _xyp_detailLabel = [[UILabel alloc] init];
        _xyp_detailLabel.textColor = kXYLColorFromRGB(0xFFFFFE);
        _xyp_detailLabel.font = kXYLGilroyMediumFont(10);
    }
    return _xyp_detailLabel;
}

- (UIImageView *)xyp_iconIV {
    if (!_xyp_iconIV) {
        _xyp_iconIV = [[UIImageView alloc] init];
    }
    return _xyp_iconIV;
}

- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.textColor = kXYLColorFromRGB(0xFF7103);
        _xyp_titleLabel.font = kXYLGilroyBoldFont(16);
    }
    return _xyp_titleLabel;
}

- (UILabel *)xyp_originLabel {
    if (!_xyp_originLabel) {
        _xyp_originLabel = [[UILabel alloc] init];
        _xyp_originLabel.textColor = kXYLColorFromRGBA(0xFF7103, 0.4);
        _xyp_originLabel.font = kXYLGilroyBoldFont(12);
    }
    return _xyp_originLabel;
}

@end
