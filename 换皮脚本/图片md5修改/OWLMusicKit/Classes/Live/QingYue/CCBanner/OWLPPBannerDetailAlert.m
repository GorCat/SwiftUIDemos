//
//  OWLPPBannerDetailAlert.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/24.
//

#import "OWLPPBannerDetailAlert.h"
#import "OWLMusicProgressView.h"
#import <WebKit/WebKit.h>

@interface OWLPPBannerDetailAlert()<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView * xyp_webView;

@property (nonatomic, strong) OWLMusicProgressView * xyp_progressView;//加载进度条

@property (nonatomic, strong) UIView * xyp_popView;

@end

@implementation OWLPPBannerDetailAlert

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupUI];
    }
    return self;
}

#pragma mark - Lazy
- (WKWebView *)xyp_webView {
    if (!_xyp_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
        _xyp_webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight- kXYLIPhoneBottomHeight) configuration:config];
        _xyp_webView.opaque = NO;
        _xyp_webView.navigationDelegate = self;
        _xyp_webView.backgroundColor = UIColor.whiteColor;
    }
    return _xyp_webView;
}

- (OWLMusicProgressView *)xyp_progressView {
    if (!_xyp_progressView) {
        _xyp_progressView = [[OWLMusicProgressView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, 2)];
    }
    return _xyp_progressView;
}

#pragma mark - UI
- (void) xyf_setupUI {
    self.xyp_popView = [[UIView alloc] initWithFrame:CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, kXYLScreenHeight)];
    self.xyp_popView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.xyp_popView];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = UIColor.clearColor;
    [closeBtn addTarget:self action:@selector(xyf_dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.xyp_popView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.xyp_popView);
    }];
    
    UIView * xyp_contentView = [[UIView alloc] init];
    xyp_contentView.backgroundColor = UIColor.whiteColor;
    xyp_contentView.layer.cornerRadius = 10;
    xyp_contentView.clipsToBounds = YES;
    [self.xyp_popView addSubview:xyp_contentView];
    [xyp_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.width.equalTo(self.xyp_popView);
        make.height.mas_equalTo(kXYLScreenHeight * 0.66);
    }];
    [xyp_contentView addSubview:self.xyp_webView];
    [self.xyp_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(xyp_contentView);
    }];
    [xyp_contentView addSubview:self.xyp_progressView];
    
    [self xyf_addScriptMessage];
}

#pragma mark - 显示弹窗
- (void) xyf_showAlert {
    [UIView animateWithDuration:0.3 animations:^{
        self.xyp_popView.frame = CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight);
    }];
}

#pragma mark - 关闭弹窗
- (void) xyf_dismiss {
    [self xyf_removeScriptMessage];
    [self xyf_removeWKWebCacheAction];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.xyp_popView.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, kXYLScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Private
- (void)xyf_removeScriptMessage {
    [self.xyp_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)xyf_addScriptMessage {
    [self.xyp_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - WKWebView清除缓存
- (void)xyf_removeWKWebCacheAction {
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] completionHandler:^(NSArray * __nonnull records) {
        
    }];
}

#pragma mark - Setter
- (void)xyf_setupUrl:(NSString *)url {
    self.xyp_webView.hidden = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
             timeoutInterval:30];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.xyp_webView loadRequest:request];
}

#pragma mark - 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.xyp_webView) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1) {
                self.xyp_progressView.hidden = YES;
                self.xyp_progressView.xyp_progress = 0;
            } else {
                self.xyp_progressView.hidden = NO;
                self.xyp_progressView.xyp_progress = newprogress;
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    
    if ([url.absoluteString rangeOfString:@"protocol://app?"].location != NSNotFound) {
        if ([url.absoluteString containsString:@"code=detail"]) {
            // 拆分地址（*b）
            NSDictionary *dic = [self xyf_parameterWithURL:url];
            NSString *accountId = dic[@"data"];
            NSString *type = dic[@"type"];
            BOOL isAnchor = ![type isEqualToString:@"1"];
            // 进入主播 / 用户详情（1：用户）
            [OWLJConvertToolShared xyf_enterUserDetailVCWithAccountID:accountId.intValue nickname:@"" avatar:@"" displayID:@"" isAnchor:isAnchor];
        }
        if ([url.absoluteString containsString:@"code=decreaseCoins"]) {
            // 拆分地址（*b）
            NSDictionary *dict = [self xyf_parameterWithURL:url];
            NSString *data = dict[@"data"];
            // 消耗金币（*d）
            NSInteger leftCoins = OWLJConvertToolShared.xyf_userCoins - data.integerValue;
            // 更新金币
            [OWLJConvertToolShared xyf_updateUserCoins:leftCoins];
            // 埋点
            [OWLMusicTongJiTool xyf_firebaseSpendCoin:data.integerValue spendWay:@"activity"];
        }
        if ([url.absoluteString containsString:@"code=refreshCoins"]) {
            // 拆分地址（*b）
            NSDictionary *dict = [self xyf_parameterWithURL:url];
            NSInteger coins = [dict[@"data"] integerValue];
            if (coins > 0) {
                // 更新金币
                [OWLJConvertToolShared xyf_updateUserCoins:coins];
            }
        }
        if ([url.absoluteString containsString:@"code=toRecharge"]) {
            // 跳转至个人中心的购买页
            [OWLJConvertToolShared xyf_enterRechargeVC];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else if ([url.absoluteString containsString:@"code=toast"]) {
        // 调起原生提示（*b）
        NSDictionary *dic = [self xyf_parameterWithURL:url];
        NSString *msg = dic[@"data"];
        [OWLJConvertToolShared xyf_showNotiTip:msg];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - URL相关
- (NSDictionary *)xyf_parameterWithURL:(NSURL *)url {
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}

@end
