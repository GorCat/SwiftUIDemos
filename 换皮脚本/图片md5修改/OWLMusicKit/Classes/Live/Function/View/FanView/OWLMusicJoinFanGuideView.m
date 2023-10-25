//
//  OWLMusicJoinFanGuideView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/11.
//

#import "OWLMusicJoinFanGuideView.h"

@interface OWLMusicJoinFanGuideView ()

/// 背景
@property (nonatomic, strong) UIImageView *xyp_guideView;

@end

@implementation OWLMusicJoinFanGuideView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    if (self) {
        [self xyf_setupTap];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    CGFloat bottomMargin = kXYLBottomTotalHeight - 18;
    CGFloat imageW = 271;
    CGFloat imageH = 166;
    CGFloat imageY = kXYLScreenHeight - bottomMargin - imageH;
    CGFloat imageX;
    if (OWLJConvertToolShared.xyf_isRTL) {
        imageX = 10;
    } else {
        imageX = kXYLScreenWidth - 10 - imageW;
    }
    self.xyp_guideView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    [self addSubview:self.xyp_guideView];
}

- (void)xyf_setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_clickAction)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Action
- (void)xyf_clickAction {
    [self xyf_dismiss];
}

#pragma mark - 动画
- (void)xyf_dismiss {
    [self removeFromSuperview];
}

#pragma mark - Lazy
- (UIImageView *)xyp_guideView {
    if (!_xyp_guideView) {
        _xyp_guideView = [[UIImageView alloc] init];
        _xyp_guideView.userInteractionEnabled = YES;
        [XYCUtil xyf_loadMainLanguageImage:_xyp_guideView iconStr:@"xyr_fan_guide_image"];
    }
    return _xyp_guideView;
}

@end
