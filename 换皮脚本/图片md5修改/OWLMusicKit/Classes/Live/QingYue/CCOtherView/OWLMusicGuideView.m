//
//  OWLMusicGuideView.m
//  qianDuoDuo
//
//  Created by wdys on 2023/3/6.
//

#import "OWLMusicGuideView.h"

@implementation OWLMusicGuideView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    if (self) {
        [self xyf_setupUI];
    }
    return self;
}

- (void)xyf_setupUI {
    self.userInteractionEnabled = NO;

    UIView * xyp_bgView = [[UIView alloc] init];
    xyp_bgView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.7);
    xyp_bgView.layer.cornerRadius = 26;
    xyp_bgView.layer.masksToBounds = YES;
    [self addSubview:xyp_bgView];
    [xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(206);
    }];
    UIImageView * xyp_icon = [[UIImageView alloc] init];
    [XYCUtil xyf_loadIconImage:xyp_icon iconStr:@"xyr_guide_slide"];
    [xyp_bgView addSubview:xyp_icon];
    [xyp_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(xyp_bgView);
        make.top.equalTo(xyp_bgView).offset(24.5);
        make.width.height.mas_equalTo(99);
    }];
    UILabel * xyp_lab = [[UILabel alloc] init];
    xyp_lab.text = kXYLLocalString(@"Swipe up and down to switch rooms quickly");
    xyp_lab.textAlignment = NSTextAlignmentCenter;
    xyp_lab.textColor = UIColor.whiteColor;
    xyp_lab.font = kXYLGilroyMediumFont(14);
    xyp_lab.numberOfLines = 0;
    xyp_lab.lineBreakMode = NSLineBreakByWordWrapping;
    [xyp_bgView addSubview:xyp_lab];
    [xyp_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(xyp_bgView).offset(25);
        make.trailing.equalTo(xyp_bgView).offset(-25);
        make.top.equalTo(xyp_icon.mas_bottom).offset(16);
    }];
}

@end
