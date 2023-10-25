//
//  OWLMusicBroadcastCell.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/28.
//

#import "OWLMusicBroadcastCell.h"
#import "OWLMusicAttLabel.h"
#import "OWLMusicTimerManager.h"
#define BannerScale ((kXYLScreenWidth - 10) / 365.f)

@interface OWLMusicBroadcastCell ()
@property (nonatomic, strong) UIView * giftContentView;

@property (nonatomic, strong) UIImageView * giftBackIV;

@property (nonatomic, strong) UIView * giftLbContainerView;

@property (nonatomic, strong) OWLMusicAttLabel * giftContentLb;

@property (nonatomic, strong) UIView * takeContentView;

@property (nonatomic, strong) UIImageView * takeBackIV;

@property (nonatomic, strong) UIImageView * takeHeaderIV;

@property (nonatomic, strong) UIImageView * senderAvatarIV;

@property (nonatomic, strong) UIImageView * receiveAvatarIV;

@property (nonatomic, strong) OWLMusicAttLabel * takeContentLb;

@property (nonatomic, strong) UIView * takeLbContainerView;

@property (nonatomic, strong) OWLMusicBroadcastModel * xyp_model;

@property (nonatomic, strong) NSString * timer;

@property (nonatomic, assign) CGFloat stepLength;

@property (nonatomic, assign) NSInteger timerCount;

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@end

@implementation OWLMusicBroadcastCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self addAction];
    }
    return self;
}

#pragma mark public
- (void)xyf_loadModel:(OWLMusicBroadcastModel *)xyp_model{
    self.xyp_model = xyp_model;
    if(self.xyp_model){
        self.stepLength = 0;
        self.timerCount = 0;
        if(xyp_model.xyp_showType == XYLBroadcastShowTypeGift){
            [self xyf_setupGiftView];
            self.giftContentLb.attributedText = [xyp_model xyp_giftContentAttr];
            [self.giftContentLb sizeToFit];
            [self xyf_setupGiftContentLb];
        }else if (xyp_model.xyp_showType == XYLBroadcastShowTypeTake){
            [self xyf_setupTakeView];
            self.takeContentLb.attributedText = [xyp_model xyp_takeContentAttr];
            [self.takeContentLb sizeToFit];
            [self xyf_setupTakeContentLb];
            [XYCUtil xyf_loadSmallImage:self.senderAvatarIV url:xyp_model.xyp_senderAvatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
            [XYCUtil xyf_loadSmallImage:self.receiveAvatarIV url:xyp_model.xyp_recieverAvatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
        }
        [self xyf_cellWait];
    }else{
        [self.takeContentView removeFromSuperview];
        [self.giftContentView removeFromSuperview];
        [self cancelTimer];
    }
    
    xyp_model.refreshUIBlock = ^{
        if(xyp_model.xyp_showType == XYLBroadcastShowTypeGift){
            [self.giftContentLb setNeedsDisplay];
        }else if (xyp_model.xyp_showType == XYLBroadcastShowTypeTake){
            [self.takeContentLb setNeedsDisplay];
        }
    };
    
    if (OWLJConvertToolShared.xyf_isRTL) {
        self.frame = CGRectMake(-kXYLScreenWidth, kXYLStatusBarHeight + 35 , kXYLScreenWidth, BannerScale * 80);
    } else {
        self.frame = CGRectMake(kXYLScreenWidth, kXYLStatusBarHeight + 35 , kXYLScreenWidth, BannerScale * 80);
    }
    
}


- (void)xyf_cellWait{
    self.xyp_model.xyp_state = XYLBroadcastCellStateWait;
    self.userInteractionEnabled = NO;
    if(OWLJConvertToolShared.xyf_isRTL){
        self.frame = CGRectMake(-kXYLScreenWidth, kXYLStatusBarHeight + 35 , kXYLScreenWidth, BannerScale * 80);
    }else{
        self.frame = CGRectMake(kXYLScreenWidth, kXYLStatusBarHeight + 35 , kXYLScreenWidth, BannerScale * 80);
    }
    if(self.stateChangeBlock){
        self.stateChangeBlock(XYLBroadcastCellStateWait);
    }
    
}

- (void)xyf_cellEnter{
    self.xyp_model.xyp_state = XYLBroadcastCellStateEnter;
    [UIView animateWithDuration:self.xyp_model.moveDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, kXYLStatusBarHeight + 35, kXYLScreenWidth, BannerScale * 80);
    } completion:nil];
    if(self.cellWillStayBlock){
        self.cellWillStayBlock(self.xyp_model);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.xyp_model.moveDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        [self xyf_getStepLength];
        [self contentLbScrollBegin];
    });
    
    if(self.stateChangeBlock){
        self.stateChangeBlock(XYLBroadcastCellStateEnter);
    }
}





#pragma mark private

- (void)setupViews{
    
    self.backgroundColor = UIColor.clearColor;
    if(OWLJConvertToolShared.xyf_isRTL){
        self.frame = CGRectMake(-kXYLScreenWidth, kXYLStatusBarHeight + 35 , kXYLScreenWidth, BannerScale * 80);
    }else{
        self.frame = CGRectMake(kXYLScreenWidth, kXYLStatusBarHeight + 35 , kXYLScreenWidth, BannerScale * 80);
    }
    
}


- (void)addAction{
    
}

- (void)xyf_setupGiftView{
    [self.takeContentView removeFromSuperview];
    [self addSubview:self.giftContentView];
    [self.giftContentView addSubview:self.giftBackIV];
    [self.giftContentView addSubview:self.giftLbContainerView];
    [self.giftLbContainerView addSubview:self.giftContentLb];
    [self.giftContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(5);
        make.trailing.mas_equalTo(-5);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(BannerScale * 50);
    }];
    [self.giftBackIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.giftLbContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(76 / BannerScale);
        make.trailing.mas_equalTo(-76 / BannerScale);
    }];
    [self layoutIfNeeded];
    [self.giftContentView layoutIfNeeded];
    [self.giftContentView addGestureRecognizer:self.tapGesture];
}

- (void)xyf_setupTakeView{

    [self.giftContentView removeFromSuperview];
    [self addSubview:self.takeContentView];
    [self.takeContentView addSubview:self.takeBackIV];
    [self.takeContentView addSubview:self.senderAvatarIV];
    [self.takeContentView addSubview:self.receiveAvatarIV];
    [self.takeContentView addSubview:self.takeHeaderIV];
    [self.takeContentView addSubview:self.takeLbContainerView];
    [self.takeLbContainerView addSubview:self.takeContentLb];
    [self.takeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
    [self.takeBackIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(BannerScale * 70);
    }];
    [self.senderAvatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.takeContentView.mas_centerX);
        make.top.mas_equalTo(4);
        make.size.mas_equalTo(36);
    }];
    [self.receiveAvatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.takeContentView.mas_centerX);
        make.top.mas_equalTo(4);
        make.size.mas_equalTo(36);
    }];
    [self.takeHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(142, 50));
    }];
    [self.takeLbContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-17 * BannerScale);
        make.leading.mas_equalTo(30 * BannerScale);
        make.trailing.mas_equalTo(-30 * BannerScale);
        make.height.mas_equalTo(20);
    }];
    [self layoutIfNeeded];
    [self.takeContentView layoutIfNeeded];
}

- (void)xyf_setupGiftContentLb {
    CGFloat maxWidth = self.giftLbContainerView.xyp_w;
    if(maxWidth >= self.giftContentLb.xyp_w){
        [self.giftContentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        self.stepLength = 0;
    }else{
        [self.giftContentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(0);
        }];
        [self.giftLbContainerView layoutIfNeeded];

    }
    
}

- (void)xyf_getStepLength{
    if(self.xyp_model.xyp_showType == XYLBroadcastShowTypeGift){
        CGFloat maxWidth = self.giftLbContainerView.xyp_w;
        if(maxWidth >= self.giftContentLb.xyp_w){
            self.stepLength = 0;
        }else{
            if(self.xyp_model.fastStayDuration != 0){
                self.stepLength = (self.giftContentLb.xyp_w - maxWidth) /( self.xyp_model.fastStayDuration - 0.3) / 100.f;
            }else{
                self.stepLength = (self.giftContentLb.xyp_w - maxWidth) /( self.xyp_model.stayDuration - 0.5) / 100.f;
            }
        }
    }else if (self.xyp_model.xyp_showType == XYLBroadcastShowTypeTake){
        CGFloat maxWidth = self.takeLbContainerView.xyp_w;
        if(maxWidth >= self.takeContentLb.xyp_w){
            self.stepLength = 0;
        }else{
            if(self.xyp_model.fastStayDuration != 0){
                self.stepLength = (self.takeContentLb.xyp_w - maxWidth) /( self.xyp_model.fastStayDuration - 0.3) / 100.f;
            }else{
                self.stepLength = (self.takeContentLb.xyp_w - maxWidth) /( self.xyp_model.stayDuration - 0.5) / 100.f;
            }
        }
    }
    
}

- (void)xyf_setupTakeContentLb{
    CGFloat maxWidth = self.takeLbContainerView.xyp_w;
    if(maxWidth >= self.takeContentLb.xyp_w){
        [self.takeContentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        self.stepLength = 0;
    }else{
        [self.takeContentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(0);
        }];
        [self.takeLbContainerView layoutIfNeeded];
    }
}


- (void)contentLbScrollBegin{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.stepLength > 0){
            self.timer = [OWLMusicTimerManager xyf_timerTarget:self selector:@selector(contentLbScroll) delayTime:0 interval:0.01 repeats:YES async:YES];
        }else{
            if(self.xyp_model.fastStayDuration != 0){
                [self performSelector:@selector(cellExit) withObject:nil afterDelay:self.xyp_model.fastStayDuration];
            }else{
                [self performSelector:@selector(cellExit) withObject:nil afterDelay:self.xyp_model.stayDuration];
            }
            
        }
    });
    
}

- (void)contentLbScroll{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.xyp_model.xyp_state = XYLBroadcastCellStateShow;
        if(self.stateChangeBlock){
            self.stateChangeBlock(XYLBroadcastCellStateShow);
        }
        self.timerCount ++;
        float stayDuration = (self.xyp_model.fastStayDuration != 0 ? self.xyp_model.fastStayDuration : self.xyp_model.stayDuration);
        float scrollDuration = self.xyp_model.fastStayDuration != 0 ? (stayDuration - 0.3) : (stayDuration - 0.5);
        if(self.timerCount / 100.f == stayDuration ){
            [self cellExit];
            [OWLMusicTimerManager xyf_cancelTimer:self.timer];
        }else if(self.timerCount / 100.f <= scrollDuration){
            if(self.xyp_model.xyp_showType == XYLBroadcastShowTypeGift){
                if(OWLJConvertToolShared.xyf_isRTL){
                    self.giftContentLb.xyp_x += self.stepLength;
                }else{
                    self.giftContentLb.xyp_x -= self.stepLength;
                }
               
            }else{
                if(OWLJConvertToolShared.xyf_isRTL){
                    self.takeContentLb.xyp_x += self.stepLength;
                }else{
                    self.takeContentLb.xyp_x -= self.stepLength;
                }
            }
        }
        
    });
    
   
}

- (void)cellExit{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.xyp_model.xyp_state = XYLBroadcastCellStateExit;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:self.xyp_model.moveDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if(OWLJConvertToolShared.xyf_isRTL){
                self.frame = CGRectMake(kXYLScreenWidth, kXYLStatusBarHeight + 35, kXYLScreenWidth, BannerScale * 80);
            }else{
                self.frame = CGRectMake(-kXYLScreenWidth, kXYLStatusBarHeight + 35, kXYLScreenWidth, BannerScale * 80);
            }
           
        } completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.xyp_model.moveDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.xyp_model.xyp_state = XYLBroadcastCellStateEnd;
            if(self.stateChangeBlock){
                self.stateChangeBlock(XYLBroadcastCellStateEnd);
            }
        });
        
        if(self.stateChangeBlock){
            self.stateChangeBlock(XYLBroadcastCellStateExit);
        }
    });
    
}

- (void)cancelTimer{
    if(self.timer){
        [OWLMusicTimerManager xyf_cancelTimer:self.timer];
        self.timer = nil;
    }
}


- (void)tapGiftBannerClicked{
    if(self.tapChannalBannerBlock){
        self.tapChannalBannerBlock(self.xyp_model);
    }
}

#pragma mark setter


#pragma mark getter
- (UIView *)giftContentView{
    if(!_giftContentView){
        _giftContentView = [[UIView alloc]init];
        _giftContentView.userInteractionEnabled = YES;
        _giftContentView.backgroundColor = UIColor.clearColor;
    }
    return _giftContentView;
}

- (UIImageView *)giftBackIV{
    if(!_giftBackIV){
        _giftBackIV = [[UIImageView alloc]init];
        UIImage *image = [XYCUtil xyf_getIconWithName:@"xyr_channal_banner_gift"];
        _giftBackIV.image = [image stretchableImageWithLeftCapWidth:(image.size.width / 2) topCapHeight:0];
    }
    return _giftBackIV;
}

- (UIView *)giftLbContainerView{
    if(!_giftLbContainerView){
        _giftLbContainerView = [[UIView alloc]init];
        _giftLbContainerView.userInteractionEnabled = YES;
        _giftLbContainerView.backgroundColor = UIColor.clearColor;
        _giftLbContainerView.clipsToBounds = YES;
    }
    return _giftLbContainerView;
}

- (OWLMusicAttLabel *)giftContentLb{
    if(!_giftContentLb){
        _giftContentLb = [[OWLMusicAttLabel alloc]init];
    }
    return _giftContentLb;
}

- (UIView *)takeContentView{
    if(!_takeContentView){
        _takeContentView = [[UIView alloc]init];
        _takeContentView.userInteractionEnabled = YES;
        _takeContentView.backgroundColor = UIColor.clearColor;
    }
    return _takeContentView;
}

- (UIImageView *)takeBackIV{
    if(!_takeBackIV){
        _takeBackIV = [[UIImageView alloc]init];
        UIImage *image = [XYCUtil xyf_getIconWithName:@"xyr_channal_banner_take"];
        _takeBackIV.image = [image stretchableImageWithLeftCapWidth:(image.size.width / 2) topCapHeight:0];
    }
    return _takeBackIV;
}

- (UIImageView *)takeHeaderIV{
    if(!_takeHeaderIV){
        _takeHeaderIV = [[UIImageView alloc]init];
        _takeHeaderIV.image = [XYCUtil xyf_getIconWithName:@"xyr_channal_banner_takeHeader"];
    }
    return _takeHeaderIV;
}

- (UIImageView *)senderAvatarIV{
    if(!_senderAvatarIV){
        _senderAvatarIV = [[UIImageView alloc]init];
        _senderAvatarIV.contentMode = UIViewContentModeScaleAspectFill;
        _senderAvatarIV.layer.cornerRadius = 18;
        _senderAvatarIV.clipsToBounds = YES;
    }
    return _senderAvatarIV;
}

- (UIImageView *)receiveAvatarIV{
    if(!_receiveAvatarIV){
        _receiveAvatarIV = [[UIImageView alloc]init];
        _receiveAvatarIV.contentMode = UIViewContentModeScaleAspectFill;
        _receiveAvatarIV.layer.cornerRadius = 18;
        _receiveAvatarIV.clipsToBounds = YES;
    }
    return _receiveAvatarIV;
}


- (OWLMusicAttLabel *)takeContentLb{
    if(!_takeContentLb){
        _takeContentLb = [[OWLMusicAttLabel alloc]init];
    }
    return _takeContentLb;
}

- (UIView *)takeLbContainerView{
    if(!_takeLbContainerView){
        _takeLbContainerView = [[UIView alloc]init];
        _takeLbContainerView.userInteractionEnabled = YES;
        _takeLbContainerView.backgroundColor = UIColor.clearColor;
        _takeLbContainerView.clipsToBounds = YES;
    }
    return _takeLbContainerView;
}

- (UITapGestureRecognizer *)tapGesture{
    if(!_tapGesture){
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGiftBannerClicked)];
    }
    return _tapGesture;
}

@end
