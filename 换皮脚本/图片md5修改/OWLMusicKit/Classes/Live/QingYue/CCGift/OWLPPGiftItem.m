//
//  OWLPPGiftItem.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/27.
//

#import "OWLPPGiftItem.h"

@interface OWLPPGiftItem()

@property (nonatomic, strong) UIImageView * xyp_iconImg;

@property (nonatomic, strong) UILabel * xyp_nameLab;

@property (nonatomic, strong) UIView * xyp_coinView;

@property (nonatomic, strong) UIImageView * xyp_coinIcon;

@property (nonatomic, strong) UILabel * xyp_coinLab;

@property (nonatomic, strong) UIImageView * xyp_lockImg;

@property (nonatomic, strong) UILongPressGestureRecognizer *xyp_longGes;

@end

@implementation OWLPPGiftItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self xyf_setupUI];
    }
    return self;
}

- (UIImageView *)xyp_iconImg {
    if (!_xyp_iconImg) {
        _xyp_iconImg = [[UIImageView alloc] init];
        _xyp_iconImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xyp_iconImg;
}

- (UILabel *)xyp_nameLab {
    if (!_xyp_nameLab) {
        _xyp_nameLab = [[UILabel alloc] init];
        _xyp_nameLab.textColor = kXYLColorFromRGB(0xFFFCFD);
        _xyp_nameLab.font = kXYLGilroyMediumFont(10);
        _xyp_nameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_nameLab;
}

- (UIView *)xyp_coinView {
    if (!_xyp_coinView) {
        _xyp_coinView = [[UIView alloc] init];
        _xyp_coinView.backgroundColor = UIColor.clearColor;
    }
    return _xyp_coinView;
}

- (UIImageView *)xyp_coinIcon {
    if (!_xyp_coinIcon) {
        _xyp_coinIcon = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_coinIcon iconStr:@"xyr_top_info_coin_icon"];
    }
    return _xyp_coinIcon;
}

- (UILabel *)xyp_coinLab {
    if (!_xyp_coinLab) {
        _xyp_coinLab = [[UILabel alloc] init];
        _xyp_coinLab.textColor = kXYLColorFromRGB(0xFFFCFD);
        _xyp_coinLab.font = kXYLGilroyMediumFont(9);
        _xyp_coinLab.textAlignment = NSTextAlignmentRight;
    }
    return _xyp_coinLab;
}

- (UIImageView *)xyp_lockImg {
    if (!_xyp_lockImg) {
        _xyp_lockImg = [[UIImageView alloc] init];
    }
    return _xyp_lockImg;
}

#pragma mark - UI
- (void) xyf_setupUI {
    [self.contentView addSubview:self.xyp_iconImg];
    [self.xyp_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self);
        make.top.mas_equalTo(14);
        make.height.mas_equalTo(75);
    }];
    [self.contentView addSubview:self.xyp_nameLab];
    [self.xyp_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self);
        make.top.equalTo(self.xyp_iconImg.mas_bottom);
    }];
    [self.contentView addSubview:self.xyp_coinView];
    [self.xyp_coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_nameLab.mas_bottom).offset(3);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(11);
    }];
    [self.xyp_coinView addSubview:self.xyp_coinIcon];
    [self.xyp_coinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.equalTo(self.xyp_coinView);
        make.width.height.mas_equalTo(9);
    }];
    [self.xyp_coinView addSubview:self.xyp_coinLab];
    [self.xyp_coinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_coinIcon.mas_trailing).offset(2);
        make.trailing.centerY.equalTo(self.xyp_coinView);
    }];
    [self.contentView addSubview:self.xyp_lockImg];
    [self.xyp_lockImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(14);
        make.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(8, 10));
    }];
    [XYCUtil xyf_loadIconImage:self.xyp_lockImg iconStr:@"xyr_gAlert_lock"];
    
    self.xyp_longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouch:)];
    self.xyp_longGes.minimumPressDuration = 0.3;
    [self.contentView addGestureRecognizer:self.xyp_longGes];
}

#pragma mark - 填充数据
- (void)setXyp_ggModel:(OWLMusicGiftInfoModel *)xyp_ggModel {
    _xyp_ggModel = xyp_ggModel;
    [self.xyp_iconImg sd_setImageWithURL:[NSURL URLWithString:xyp_ggModel.dsb_iconImageUrl]];
    self.xyp_nameLab.text = xyp_ggModel.dsb_giftName;
    self.xyp_coinLab.text = [NSString stringWithFormat:@"%ld", xyp_ggModel.dsb_giftCoin];
    if (self.xyp_isSvv && !OWLJConvertToolShared.xyf_userIsSvip) {
        [self.xyp_lockImg setHidden:NO];
        self.xyp_iconImg.alpha = 0.65;
    } else {
        [self.xyp_lockImg setHidden:YES];
        self.xyp_iconImg.alpha = 1;
    }
    [self.contentView removeGestureRecognizer:self.xyp_longGes];
    if (xyp_ggModel.dsb_comboIconImage.length > 0) {
        [self.contentView addGestureRecognizer:self.xyp_longGes];
    }
    
}

- (void)longTouch:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        if (OWLJConvertToolShared.xyf_judgeNoNetworkAndShowNoNetTip) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(xyf_giftFast) object:nil];
            return;
        }
        
        // 开始触发
        OWLMusicInsideManagerShared.comboing = 1;
        [self xyf_giftFast];
        UIApplication.sharedApplication.delegate.window.userInteractionEnabled = NO;
    }
    if (ges.state == UIGestureRecognizerStateEnded ||
        ges.state == UIGestureRecognizerStateCancelled) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(xyf_giftFast) object:nil];
        OWLMusicInsideManagerShared.comboing = -1;
        UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    }
    if (ges.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [ges locationInView:self];
        BOOL b = [self.layer containsPoint:point];
        if (b) {
        } else {
            [ges setState:UIGestureRecognizerStateEnded];
        }
    }
}

- (void)xyf_giftFast {
    if (OWLMusicInsideManagerShared.comboing == -1) {
        [self.xyp_longGes setState:UIGestureRecognizerStateEnded];
        return;
    }
    if (OWLMusicInsideManagerShared.comboing == 1) {
        if (self.xyp_sendGiftBlock) self.xyp_sendGiftBlock();
        [self performSelector:@selector(xyf_giftFast) withObject:nil afterDelay:0.5];
    }
}

@end
