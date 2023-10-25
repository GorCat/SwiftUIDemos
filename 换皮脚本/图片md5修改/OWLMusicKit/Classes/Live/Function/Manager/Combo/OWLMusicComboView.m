//
//  OWLMusicComboView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/27.
//

#import "OWLMusicComboView.h"
#import "OWLMusicRippleView.h"
#import "OWLMusicCountDownView.h"

@interface OWLMusicComboView ()

@property (nonatomic, assign) NSInteger xyp_comboCount;

@property (nonatomic, assign) BOOL xyp_isQuickGift;

@property (nonatomic, retain) OWLMusicRippleView *xyp_rippleView;

@property (nonatomic, retain) OWLMusicCountDownView *xyp_countDownView;

@property (nonatomic, retain) UIImageView *xyp_countBarView;

@property (nonatomic, retain) UILabel *xyp_countLabel;

@property (nonatomic, retain) UIImageView *xyp_goodView;

@end

@implementation OWLMusicComboView

- (instancetype)initWithIsQuickGift:(BOOL)isQuick numberFont:(UIFont*)font
{
    self = [super init];
    if (self) {
        self.xyp_isQuickGift = isQuick;
        if (font) {
            self.xyp_countLabel.font = font;
        }
        [self xyf_setupSubviews];
        [self layoutIfNeeded];
    }
    return self;
}

-(void)xyf_finishCountDown {
    if ([self.delegate respondsToSelector:@selector(xyf_comboViewDidFinish:)]) {
        [self.delegate xyf_comboViewDidFinish:self];
    }
}

-(void)xyf_raise {
    self.xyp_comboCount++;
}

- (void)xyf_setupSubviews {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.xyp_rippleView];
    [self addSubview:self.xyp_countDownView];
    [self addSubview:self.xyp_countLabel];
    [self addSubview:self.xyp_goodView];
    
    if (self.xyp_isQuickGift) {
        [self.xyp_rippleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(51, 51));
            make.center.mas_equalTo(self);
        }];
        
        [self.xyp_countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(18.5);
            make.top.equalTo(self.xyp_rippleView).offset(2.0);
            make.width.mas_equalTo(25.0);
            make.height.mas_equalTo(14.0);
        }];
        
        [self.xyp_goodView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(49.0, 27.0));
            make.bottom.equalTo(self.xyp_countDownView.mas_top).offset(-3);
            make.centerX.equalTo(self.xyp_countDownView);
        }];
    } else {
        [self addSubview:self.xyp_countBarView];
        [self sendSubviewToBack:self.xyp_countBarView];
        
        [self.xyp_rippleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72, 72));
            make.bottom.equalTo(self).offset(-35.0);
            make.centerX.equalTo(self);
        }];
        
        [self.xyp_countBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.xyp_rippleView.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(44.5);
            make.centerX.equalTo(self);
        }];
        
        [self.xyp_countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.xyp_countBarView);
            make.bottom.equalTo(self.xyp_countBarView.mas_top).offset(5.5);
            make.height.mas_equalTo(30.0);
            make.width.mas_equalTo(30.0);
        }];
        
        [self.xyp_goodView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(49.0, 27.0));
            make.top.equalTo(self.xyp_countDownView).offset(-1);
            make.right.equalTo(self.xyp_countDownView).offset(19);
        }];
    }
    
    [self.xyp_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.xyp_rippleView);
        make.size.equalTo(self.xyp_rippleView);
    }];
}

-(OWLMusicRippleView *)xyp_rippleView {
    if(!_xyp_rippleView) {
        _xyp_rippleView = [[OWLMusicRippleView alloc] init];
    }
    return _xyp_rippleView;
}
- (UIImageView *)xyp_countBarView {
    if (!_xyp_countBarView) {
        _xyp_countBarView = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_countBarView iconStr:@"xyr_bg_count_bar"];
    }
    return _xyp_countBarView;
}

- (OWLMusicCountDownView *)xyp_countDownView {
    if(!_xyp_countDownView){
        _xyp_countDownView = [[OWLMusicCountDownView alloc] init];
    }
    return _xyp_countDownView;
}

- (UIImageView *)xyp_goodView {
    if(!_xyp_goodView){
        _xyp_goodView = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_goodView iconStr:@"xyr_icon_combo_good"];
    }
    return _xyp_goodView;
}

- (UILabel *)xyp_countLabel {
    if(!_xyp_countLabel){
        _xyp_countLabel = [[UILabel alloc] init];
        _xyp_countLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_countLabel.layer.masksToBounds = YES;
        _xyp_countLabel.text = @"1";
        
        if (self.xyp_isQuickGift) {
            _xyp_countLabel.backgroundColor = [UIColor whiteColor];
            _xyp_countLabel.layer.cornerRadius = 7.0;
            _xyp_countLabel.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightBlack];
            _xyp_countLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:126.0/255.0 alpha:1.0];
        } else {
            _xyp_countLabel.backgroundColor = [UIColor whiteColor];
            _xyp_countLabel.layer.cornerRadius = 15.0;
            _xyp_countLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBlack];
            _xyp_countLabel.textColor = [UIColor colorWithRed:1.0 green:7.0/255.0 blue:127.0/255.0 alpha:1.0];
        }
    }
    return _xyp_countLabel;
}

-(void)setXyp_comboCount:(NSInteger)xyp_comboCount {
    _xyp_comboCount = xyp_comboCount;
    
    self.xyp_goodView.hidden = xyp_comboCount < 10;
    self.xyp_countLabel.text = [NSString stringWithFormat:@"%@",@(xyp_comboCount)];
    [self.xyp_countDownView xyf_startCountDown];
    [self.xyp_rippleView xyf_addRipple];
    
    if (self.xyp_isQuickGift) {
        if (xyp_comboCount < 100) {
            [self.xyp_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(25);
            }];
        } else if(xyp_comboCount < 1000) {
            [self.xyp_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(32);
            }];
        }else {
            [self.xyp_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(39);
            }];
        }
    } else {
        CGFloat xyp_heightOffset = MIN(62.0, (xyp_comboCount - 1) * 7.0);
        CGFloat xyp_height = 44.5 + xyp_heightOffset;
        [self.xyp_countBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(xyp_height);
        }];
        
        if (xyp_comboCount < 100) {
            [self.xyp_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(30);
            }];
        } else if(xyp_comboCount < 1000) {
            [self.xyp_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(41);
            }];
        }else {
            [self.xyp_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(51);
            }];
        }
    }
}

@end

#pragma mark - OWLMusicComboViewManager

@interface OWLMusicComboViewManager () <OWLMusicComboViewDelegate>

@property (nonatomic, retain) NSMutableArray <OWLMusicComboView *> * xyp_comboViewArray;

@property (nonatomic, retain) OWLMusicComboView * xyp_currentComboView;

@end

@implementation OWLMusicComboViewManager

+ (instancetype)shared {
    static OWLMusicComboViewManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}

- (void)xyf_ClickedGift:(NSInteger)xyp_giftId roomId:(NSInteger)xyp_roomId container:(UIView *)xyp_container frame:(CGRect)xyp_frame isQuick:(BOOL)xyp_isQuick numberFont:(UIFont *)xyp_font {
    OWLMusicComboView *xyp_comboView = nil;
    
    NSPredicate *xyp_predicate = [NSPredicate predicateWithBlock:^BOOL(OWLMusicComboView*  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return (evaluatedObject.xyp_giftId == xyp_giftId && evaluatedObject.xyp_roomId == xyp_roomId);
    }];
    
    NSArray<OWLMusicComboView *> *xyp_filterdArray = [self.xyp_comboViewArray filteredArrayUsingPredicate:xyp_predicate];
    if (xyp_filterdArray.count > 0) {
        if (xyp_filterdArray.firstObject.xyp_isQuickGift == xyp_isQuick) {
            xyp_comboView = xyp_filterdArray.firstObject;
        } else {
            OWLMusicComboView *xyp_newComboView = [[OWLMusicComboView alloc] initWithIsQuickGift:xyp_isQuick numberFont:xyp_font];
            if (xyp_font) {
                xyp_newComboView.xyp_countLabel.font = xyp_font;
            }
            xyp_newComboView.frame = xyp_frame;
            xyp_newComboView.xyp_giftId = xyp_giftId;
            xyp_newComboView.xyp_roomId = xyp_roomId;
            xyp_newComboView.xyp_comboCount = xyp_filterdArray.firstObject.xyp_comboCount;
            xyp_newComboView.userInteractionEnabled = NO;
            xyp_newComboView.delegate = self;
            
            [self.xyp_comboViewArray addObject:xyp_newComboView];
            xyp_comboView = xyp_newComboView;
            [self.xyp_comboViewArray removeObject:xyp_filterdArray.firstObject];
        }
    }else {
        OWLMusicComboView *xyp_newComboView = [[OWLMusicComboView alloc] initWithIsQuickGift:xyp_isQuick numberFont:xyp_font];
        if (xyp_font) {
            xyp_newComboView.xyp_countLabel.font = xyp_font;
        }
        xyp_newComboView.frame = xyp_frame;
        xyp_newComboView.xyp_giftId = xyp_giftId;
        xyp_newComboView.xyp_roomId = xyp_roomId;
        xyp_newComboView.userInteractionEnabled = NO;
        xyp_newComboView.delegate = self;
        
        [self.xyp_comboViewArray addObject:xyp_newComboView];
        xyp_comboView = xyp_newComboView;
    }
    
    self.xyp_currentComboView = xyp_comboView;
    [xyp_container addSubview:xyp_comboView];
    xyp_comboView.hidden = NO;
    [xyp_comboView xyf_raise];
}

- (void)xyf_removeCurrentComboViewFromSuperView {
    self.xyp_currentComboView.hidden = YES;
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

- (void)xyf_comboViewDidFinish:(OWLMusicComboView *)xyp_comboView {
    [xyp_comboView removeFromSuperview];
    [self.xyp_comboViewArray removeObject:xyp_comboView];
}

#pragma mark - Setters & Getters
- (void)setXyp_currentComboView:(OWLMusicComboView *)xyp_currentComboView {
    _xyp_currentComboView.hidden = YES;
    _xyp_currentComboView = xyp_currentComboView;
}

- (NSMutableArray<OWLMusicComboView *> *)xyp_comboViewArray {
    if (!_xyp_comboViewArray) {
        _xyp_comboViewArray = [NSMutableArray array];
    }
    return _xyp_comboViewArray;
}
@end
