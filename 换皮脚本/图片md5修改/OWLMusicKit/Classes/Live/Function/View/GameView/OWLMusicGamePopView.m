//
//  OWLMusicGamePopView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/6/25.
//

#import "OWLMusicGamePopView.h"
#import <WebKit/WebKit.h>
#import "UIButton+XYLExtention.h"

@interface OWLMusicGamePopView () <WKNavigationDelegate,UIGestureRecognizerDelegate>

#pragma mark - Views
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *closeBt;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UIButton *minCloseBt;

#pragma mark - Ges
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, strong) UIPanGestureRecognizer * pan;

#pragma mark - Model
@property (nonatomic, strong) OWLMusicGameConfigModel *game;

@property (nonatomic, assign) CGFloat popHeight;

#pragma mark - Bool
@property (nonatomic, assign) BOOL mini;

@property (nonatomic, assign) BOOL show;

@property (nonatomic, assign) BOOL initIsBig;

@end

@implementation OWLMusicGamePopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
        [self xyf_addAction];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    self.mini = NO;
    self.show = NO;
    self.backgroundColor = UIColor.clearColor;
    self.userInteractionEnabled = YES;
    self.frame = CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight);
    self.clipsToBounds = YES;
    [self addSubview:self.contentView];
    [self addSubview:self.iconView];
    [self addSubview:self.closeBt];
    [self addSubview:self.minCloseBt];
    [self.contentView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, kXYLIPhoneBottomHeight, 0));
    }];
    self.contentView.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth,self.popHeight);
    self.closeBt.frame = CGRectMake((kXYLScreenWidth - 155) / 2.f, kXYLScreenHeight, 155,35);
    [XYCUtil xyf_clickRadius:32 alertView:self.contentView];
    
    self.iconView.frame = [XYCUtil xyf_arlTargetRect:CGRectMake(5, 5, 55, 55) bySuperRect:CGRectMake(0, 0, 60, 60)];
    self.minCloseBt.frame = [XYCUtil xyf_arlTargetRect:CGRectMake(44, 0, 16, 16) bySuperRect:CGRectMake(0, 0, 60, 60)];
    self.minCloseBt.hidden = YES;
    self.iconView.hidden = YES;
}

- (void)xyf_addAction {
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Public
- (void)xyf_loadModel:(OWLMusicGameConfigModel *)xyp_model initBig:(BOOL)xyp_initBig{
    self.game = xyp_model;
    self.initIsBig = xyp_initBig;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:xyp_model.dsb_gameAdress]]];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [XYCUtil xyf_loadOriginImage:self.iconView url:xyp_model.dsb_picture placeholder:nil];
    if(!xyp_initBig){
        self.mini = YES;
        self.webView.configuration.allowsInlineMediaPlayback = NO;
        self.contentView.alpha = 0;
        self.closeBt.alpha = 0;
        CGRect frame = CGRectMake(kXYLScreenWidth - 60, kXYLScreenHeight - (kXYLBottomTotalHeight + 310), 60, 60);
        self.frame = [XYCUtil xyf_arlTargetRect:frame bySuperRect:kXYLScreenBounds];
        self.contentView.frame = CGRectMake(0, kXYLScreenHeight - self.popHeight, kXYLScreenWidth,self.popHeight);
        self.closeBt.frame = CGRectMake((kXYLScreenWidth - 155) / 2.f, kXYLScreenHeight - self.popHeight - 35, 155,35);
        self.iconView.hidden = NO;
        self.minCloseBt.hidden = NO;
        self.webView.hidden = YES;
        [self.webView removeFromSuperview];
        [self addGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.pan];
    }
   
}

- (void)xyf_show{
    self.contentView.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.popHeight);
    self.closeBt.frame = CGRectMake((kXYLScreenWidth - 155) / 2.f, kXYLScreenHeight, 155,35);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, kXYLScreenHeight - self.popHeight, kXYLScreenWidth,self.popHeight);
        self.closeBt.frame = CGRectMake((kXYLScreenWidth - 155) / 2.f, kXYLScreenHeight - self.popHeight - 35, 155,35);
        [self layoutIfNeeded];
        [XYCUtil xyf_clickRadius:32 alertView:self.contentView];
    } completion:^(BOOL finished) {
        [XYCUtil xyf_clickRadius:32 alertView:self.contentView];
    }];
}


- (void)xyf_big{
    self.mini = NO;
    self.webView.configuration.allowsInlineMediaPlayback = YES;
    self.iconView.hidden = YES;
    self.minCloseBt.hidden = YES;
    [self removeGestureRecognizer:self.tapGesture];
    [self removeGestureRecognizer:self.pan];
    [UIView animateWithDuration:0.3 animations:^{
        self.webView.hidden = NO;
        self.contentView.alpha = 1;
        self.closeBt.alpha = 1;
        self.frame = CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight);
        [self layoutIfNeeded];
        [XYCUtil xyf_clickRadius:32 alertView:self.contentView];
    } completion:^(BOOL finished) {
        if(!self.webView.superview){
            [self.contentView addSubview:self.webView];
        }
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, kXYLIPhoneBottomHeight, 0));
        }];
        [XYCUtil xyf_clickRadius:32 alertView:self.contentView];
    }];
}

- (void)xyf_mini{
    [OWLJConvertToolShared xyf_needUpdateUserCoins];
    self.mini = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.alpha = 0;
        self.closeBt.alpha = 0;
        CGRect frame = CGRectMake(kXYLScreenWidth - 60, kXYLScreenHeight - (kXYLBottomTotalHeight + 310), 60, 60);
        self.frame = [XYCUtil xyf_arlTargetRect:frame bySuperRect:kXYLScreenBounds];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.webView.hidden = YES;
        [self.webView removeFromSuperview];
        self.iconView.hidden = NO;
        self.minCloseBt.hidden = NO;
        [self addGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.pan];
        [XYCUtil xyf_clickRadius:32 alertView:self.contentView];
    }];
}

- (void)xyf_hide{
    self.mini = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth,self.popHeight);
        self.closeBt.frame = CGRectMake((kXYLScreenWidth - 155) / 2.f, kXYLScreenHeight, 155,35);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self xyf_close];
        [XYCUtil xyf_clickRadius:32 alertView:self.contentView];
    }];
}


- (void)xyf_close{
    [OWLJConvertToolShared xyf_needUpdateUserCoins];
    self.game = nil;
    OWLMusicInsideManagerShared.xyp_gamePopView = nil;
    [self removeFromSuperview];
}

#pragma mark - WKNavigationDelegate
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    if(!self.initIsBig){
        return;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        BOOL loadFinish = _webView.estimatedProgress >= 0.99;
        if(loadFinish && !self.show){
            if(self.showBlock){
                self.showBlock();
            }
            self.show = YES;
            [self xyf_show];
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{

    // 在发送请求之前，决定是否跳转
    NSURL *url = navigationAction.request.URL;
    if ([url.absoluteString rangeOfString:@"protocol://app?"].location != NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isEqual:self]){
        return YES;
    }
    return NO;
}

#pragma mark - Action
- (void)panAction:(UIPanGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateChanged){
        CGPoint transPoint = [gesture translationInView:self];
        CGFloat x = self.center.x + transPoint.x;
        CGFloat y = self.center.y + transPoint.y;
        self.center = CGPointMake(x,  y);
        [self.pan setTranslation:CGPointZero inView:self];
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        CGPoint transPoint = [gesture translationInView:self];
        CGFloat y = self.center.y + transPoint.y;
        y = MAX(y, kXYLStatusBarHeight + 30);
        y = MIN(y, kXYLScreenHeight - kXYLBottomTotalHeight - 30);
        if(OWLJConvertToolShared.xyf_isRTL){
            self.center = CGPointMake(30,y);
        }else{
            self.center = CGPointMake(kXYLScreenWidth - 30,y);
        }
        [self.pan setTranslation:CGPointZero inView:self];
    }
}

- (void)xyf_tapAction {
    [OWLJConvertToolShared xyf_tongjiGameBallClick:self.game.dsb_gameId];
    [self xyf_big];
}

#pragma mark - Getter
- (CGFloat)popHeight{
    if (self.game.dsb_rate > 0) {
        return self.game.dsb_rate * kXYLScreenWidth + kXYLIPhoneBottomHeight;
    } else {
        return kXYLScreenWidth + kXYLIPhoneBottomHeight;
    }
}

#pragma mark - Lazy
- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = UIColor.blackColor;
    }
    return _contentView;
}

- (WKWebView *)webView{
    if(!_webView){
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        _webView.backgroundColor = UIColor.blackColor;
        _webView.opaque = NO;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIButton *)closeBt{
    if(!_closeBt){
        _closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBt xyf_loadIconStr:@"xyr_game_close"];
        [_closeBt addTarget:self action:@selector(xyf_mini) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBt;
}

- (UIButton *)minCloseBt{
    if(!_minCloseBt){
        _minCloseBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minCloseBt xyf_loadIconStr:@"xyr_game_small_close"];
        [_minCloseBt addTarget:self action:@selector(xyf_close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minCloseBt;
}

- (UITapGestureRecognizer *)tapGesture {
    if(!_tapGesture){
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xyf_tapAction)];
    }
    return _tapGesture;
}

- (UIImageView *)iconView {
    if(!_iconView){
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}

- (UIPanGestureRecognizer *)pan {
    if(!_pan){
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    }
    return _pan;
}

@end
