//
//  OWLMusicBottomChatPrivateView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/2.
//

#import "OWLMusicBottomChatPrivateView.h"
@interface OWLMusicBottomChatPrivateView()

/// 私聊动图
@property (nonatomic, strong) UIImageView *xyp_gifIV;
/// 私聊按钮
@property (nonatomic, strong) UIButton *xyp_chatButton;
/// 图片数组
@property (nonatomic, strong) NSMutableArray *xyp_imageList;

@end

@implementation OWLMusicBottomChatPrivateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_gifIV];
    [self.xyp_gifIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.top.equalTo(self);
        make.width.mas_equalTo(102);
    }];
    
    [self addSubview:self.xyp_chatButton];
    [self.xyp_chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.xyp_gifIV);
    }];
}

#pragma mark - Actions
- (void)xyf_clickChatAction {
    [OWLMusicTongJiTool xyf_thinkingWithName:XYLThinkingEventClickPrivateButton];
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickEvent:)]) {
        [self.delegate xyf_lModuleBaseViewClickEvent:XYLModuleBaseViewClickType_ShowPrivateChatView];
    }
}

- (void)xyf_changeAnimate:(BOOL)isShow {
    if (isShow) {
        NSLog(@"xytest 隐私按钮 显示");
        if (!self.xyp_gifIV.isAnimating) {
            self.xyp_gifIV.animationImages = self.xyp_imageList;
            self.xyp_gifIV.animationDuration = 2;
            [self.xyp_gifIV startAnimating];
        }
    } else {
        NSLog(@"xytest 隐私按钮 隐藏");
        if (self.xyp_gifIV.isAnimating) {
            [self.xyp_gifIV stopAnimating];
        }
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_gifIV {
    if (!_xyp_gifIV) {
        _xyp_gifIV = [[UIImageView alloc] init];
    }
    return _xyp_gifIV;
}

- (UIButton *)xyp_chatButton {
    if (!_xyp_chatButton) {
        _xyp_chatButton = [[UIButton alloc] init];
        _xyp_chatButton.backgroundColor = UIColor.clearColor;
        [_xyp_chatButton addTarget:self action:@selector(xyf_clickChatAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_chatButton;
}

- (NSMutableArray *)xyp_imageList {
    if (!_xyp_imageList) {
        _xyp_imageList = [[NSMutableArray alloc] init];
        for (int i = 0; i < 40; i ++) {
            NSString *str = [NSString stringWithFormat:@"xyr_take_private_000%02d",i];
            if ([OWLJConvertToolShared.xyf_currentLanguage isEqualToString:@"ar"]) {
                str = [NSString stringWithFormat:@"xyr_take_private_ar_000%02d",i];
            }
            [_xyp_imageList xyf_addObjectIfNotNil:[XYCUtil xyf_getPngIconWithName:str]];
        }
    }
    return _xyp_imageList;
}

@end
