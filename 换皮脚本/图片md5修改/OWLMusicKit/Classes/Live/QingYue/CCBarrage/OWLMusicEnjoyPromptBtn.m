//
//  OWLMusicEnjoyPromptBtn.m
//  qianDuoDuo
//
//  Created by wdys on 2023/3/2.
//

#import "OWLMusicEnjoyPromptBtn.h"
#import "OWLPPAddAlertTool.h"

@interface OWLMusicEnjoyPromptBtn()

@property (nonatomic, strong) UIImageView * xyp_colorView;

@property (nonatomic, strong) UIImageView * xyp_iconImg;

@property (nonatomic, strong) UILabel * xyp_msgLab;

@property (nonatomic, strong) UIImageView * xyp_avatar;

@property (nonatomic, assign) XYLPromptType xyp_myType;

@end

@implementation OWLMusicEnjoyPromptBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupUI];
    }
    return self;
}

- (UIImageView *)xyp_colorView {
    if (!_xyp_colorView) {
        _xyp_colorView = [[UIImageView alloc] init];
        _xyp_colorView.layer.cornerRadius = 19;
        _xyp_colorView.userInteractionEnabled = YES;
        _xyp_colorView.clipsToBounds = YES;
    }
    return _xyp_colorView;
}

- (UIImageView *)xyp_iconImg {
    if (!_xyp_iconImg) {
        _xyp_iconImg = [[UIImageView alloc] init];
    }
    return _xyp_iconImg;
}

- (UILabel *)xyp_msgLab {
    if (!_xyp_msgLab) {
        _xyp_msgLab = [[UILabel alloc] init];
        _xyp_msgLab.textColor = UIColor.whiteColor;
        _xyp_msgLab.font = kXYLGilroyBoldFont(14);
        _xyp_msgLab.numberOfLines = 0;
        _xyp_msgLab.lineBreakMode = NSLineBreakByWordWrapping;
        _xyp_msgLab.textAlignment = NSTextAlignmentLeft;
        [_xyp_msgLab xyf_atl];
    }
    return _xyp_msgLab;
}

- (UIImageView *)xyp_avatar {
    if (!_xyp_avatar) {
        _xyp_avatar = [[UIImageView alloc] init];
        _xyp_avatar.layer.cornerRadius = 15;
        _xyp_avatar.layer.borderColor = UIColor.whiteColor.CGColor;
        _xyp_avatar.layer.borderWidth = 1;
        _xyp_avatar.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_avatar.clipsToBounds = YES;
    }
    return _xyp_avatar;
}

- (void) xyf_setupUI {
    self.xyp_colorView.image = [UIImage imageWithGradient:@[kXYLColorFromRGB(0xEA4182), kXYLColorFromRGB(0xE94268)] size:CGSizeMake(184, 38) direction:UIImageGradientDirectionHorizontal];
    [self addSubview:self.xyp_colorView];
    [self.xyp_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(10.5);
        make.height.mas_equalTo(38);
        make.trailing.lessThanOrEqualTo(self).offset(-4.5);
    }];
    [self.xyp_colorView addSubview:self.xyp_iconImg];
    [self.xyp_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_colorView);
        make.leading.equalTo(self.xyp_colorView).offset(12);
        make.width.height.mas_equalTo(18);
    }];
    [self.xyp_colorView addSubview:self.xyp_msgLab];
    [self.xyp_msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_colorView).offset(35);
        make.trailing.equalTo(self.xyp_colorView).offset(-12.5);
        make.centerY.equalTo(self.xyp_colorView);
    }];
    [self.xyp_colorView addSubview:self.xyp_avatar];
    [self.xyp_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_colorView);
        make.trailing.equalTo(self.xyp_colorView).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_promptTap)];
    [self.xyp_colorView addGestureRecognizer:tap];
}

#pragma mark - 点击提示
- (void) xyf_promptTap {
    if (self.xyp_myType == 0) {
        return;
    }
    if (self.xyp_tapPromptThis) {
        self.xyp_tapPromptThis(self.xyp_myType);
    }
}

#pragma mark - 设置按钮类型
- (void)xyf_setupButtonType:(XYLPromptType)xyp_type {
    self.xyp_myType = xyp_type;
    switch (xyp_type) {
        case XYLPromptType_SayHi:
        {
            [self xyf_changeFrameHasAvatar:NO];
            self.xyp_colorView.image = [UIImage imageWithGradient:@[kXYLColorFromRGB(0xEA4182), kXYLColorFromRGB(0xE94268)] size:CGSizeMake(216, 38) direction:UIImageGradientDirectionHorizontal];
            [XYCUtil xyf_loadIconImage:self.xyp_iconImg iconStr:@"xyr_prompt_sayhi"];
            self.xyp_msgLab.text = kXYLLocalString(@"Say hi to the livestreamer!");
        }
            break;
        case XYLPromptType_SendGift:
        {
            [self xyf_changeFrameHasAvatar:NO];
            self.xyp_colorView.image = [UIImage imageWithGradient:@[kXYLColorFromRGB(0xEA4182), kXYLColorFromRGB(0xE94268)] size:CGSizeMake(184, 38) direction:UIImageGradientDirectionHorizontal];
            [XYCUtil xyf_loadIconImage:self.xyp_iconImg iconStr:@"xyr_prompt_gift"];
            self.xyp_msgLab.text = kXYLLocalString(@"Like her? Send a gift!");
        }
            break;
        case XYLPromptType_Follow:
        {
            [self xyf_changeFrameHasAvatar:YES];
            self.xyp_colorView.image = [UIImage imageWithGradient:@[kXYLColorFromRGB(0xEA4182), kXYLColorFromRGB(0xE94268)] size:CGSizeMake(246, 38) direction:UIImageGradientDirectionHorizontal];
            [XYCUtil xyf_loadIconImage:self.xyp_iconImg iconStr:@"xyr_prompt_follow"];
            self.xyp_msgLab.text = kXYLLocalString(@"Don't miss each precious moment of her");
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 修改约束位置
- (void) xyf_changeFrameHasAvatar:(BOOL)xyp_hasAvatar {
    if (xyp_hasAvatar) {
        [XYCUtil xyf_loadSmallImage:self.xyp_avatar url:[OWLPPAddAlertTool shareInstance].xyf_hostAvatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
        [self.xyp_avatar setHidden:NO];
        [self.xyp_msgLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.xyp_colorView).offset(35);
            make.trailing.equalTo(self.xyp_colorView).offset(-45.5);
            make.centerY.equalTo(self.xyp_colorView);
        }];
    } else {
        [self.xyp_avatar setHidden:YES];
        [self.xyp_msgLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.xyp_colorView).offset(35);
            make.trailing.equalTo(self.xyp_colorView).offset(-12.5);
            make.centerY.equalTo(self.xyp_colorView);
        }];
    }
}

@end
