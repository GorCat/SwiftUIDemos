//
//  OWLPPGiftChooseView.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/24.
//

#import "OWLPPGiftChooseView.h"
#import "OWLMusicGiftConfigModel.h"
#import "OWLPPGiftItem.h"
#import "OWLPPGiftPageControl.h"
#import "UIButton+XYLExtention.h"
#import "OWLPPBannerDetailAlert.h"
#import "OWLBGMModuleVC.h"
#import "OWLMusicComboView.h"

#define kXYLHasShowluckyBoxDetail @"hasShowluckyBoxDetail"
#define kXYLHasCloseluckyBoxDetail @"hasCloseluckyBoxDetail"
 
@interface OWLPPGiftChooseView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray <OWLMusicGiftConfigModel *> * xyp_giftArray;//礼物数据

@property (nonatomic, strong) NSArray * xyp_countArray;

@property (nonatomic, strong) NSArray * xyp_collectionDataArray;//礼物Collection显示分页数据

@property (nonatomic, strong) UIView * xyp_popView;

@property (nonatomic, strong) UIButton * xyp_luckyBoxBtn;

@property (nonatomic, strong) UIScrollView * xyp_scrollView;//礼物填充collection

@property (nonatomic, assign) NSInteger xyp_classifyPage;//标题选择页码

@property (nonatomic, assign) NSInteger xyp_collectionPage;//当前分类滑动页码

@property (nonatomic, strong) OWLPPGiftPageControl * xyp_pageControl;////当前分类页码控件

@property (nonatomic, strong) UILabel * xyp_lastCoinLab;//剩余金额Lab

@property (nonatomic, strong) UIButton * xyp_rechargeBtn;//点击金币区域

@property (nonatomic, strong) UIScrollView * xyp_classifyScrollView;//底部分类view

@property (nonatomic, assign) NSInteger xyp_spaceSecond;//点击礼物间隔时间

@property (nonatomic, strong) OWLMusicGiftInfoModel * xyp_lastGift;//上次送出的礼物

@property (nonatomic, assign) NSInteger xyp_comboNum;//礼物连击数

/// 金额
@property (nonatomic, assign) NSInteger xyp_cutCoins;

@end

@implementation OWLPPGiftChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.xyp_cutCoins = OWLJConvertToolShared.xyf_userCoins;
        [self xyf_setupUI];
    }
    return self;
}

- (UIView *)xyp_popView {
    if (!_xyp_popView) {
        _xyp_popView = [[UIView alloc] initWithFrame:CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_popView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.82);
        _xyp_popView.layer.cornerRadius = 20;
        _xyp_popView.clipsToBounds = YES;
    }
    return _xyp_popView;
}

- (UIButton *)xyp_luckyBoxBtn {
    if (!_xyp_luckyBoxBtn) {
        _xyp_luckyBoxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat luckBoxBtnX = OWLJConvertToolShared.xyf_isRTL ? 15.5 : kXYLScreenWidth - 153.5;
        _xyp_luckyBoxBtn.frame = CGRectMake(luckBoxBtnX, kXYLScreenHeight, 138, 56);
        [_xyp_luckyBoxBtn setImage:[XYCUtil xyf_getIconWithNameInMainLanguage:@"xyr_gift_luckyBox"] forState:UIControlStateNormal];
        [_xyp_luckyBoxBtn addTarget:self action:@selector(xyf_luckyBoxButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        UIButton * xyp_closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        xyp_closeBtn.tag = 404;
        [xyp_closeBtn xyf_loadIconStr:@"xyr_luckybtn_close"];
        [xyp_closeBtn addTarget:self action:@selector(xyf_hideLuckyBoxBtn) forControlEvents:UIControlEventTouchUpInside];
        [_xyp_luckyBoxBtn addSubview:xyp_closeBtn];
        [xyp_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_xyp_luckyBoxBtn);
            make.trailing.equalTo(_xyp_luckyBoxBtn).offset(5);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kXYLHasShowluckyBoxDetail]) {
            [xyp_closeBtn setHidden:YES];
        }
    }
    return _xyp_luckyBoxBtn;
}

- (UIScrollView *)xyp_scrollView {
    if (!_xyp_scrollView) {
        _xyp_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, 230)];
        _xyp_scrollView.pagingEnabled = YES;
        _xyp_scrollView.showsHorizontalScrollIndicator = NO;
        _xyp_scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _xyp_scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _xyp_scrollView;
}

- (UIScrollView *)xyp_classifyScrollView {
    if (!_xyp_classifyScrollView) {
        CGFloat x = OWLJConvertToolShared.xyf_isRTL ? kXYLScreenWidth - 280 : 0;
        _xyp_classifyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 250, 280, 40)];
        _xyp_classifyScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _xyp_classifyScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _xyp_classifyScrollView;
}

- (UILabel *)xyp_lastCoinLab {
    if (!_xyp_lastCoinLab) {
        _xyp_lastCoinLab = [[UILabel alloc] init];
        _xyp_lastCoinLab.textColor = kXYLColorFromRGB(0xFFFCFD);
        _xyp_lastCoinLab.font = kXYLGilroyBoldFont(16);
        _xyp_lastCoinLab.textAlignment = NSTextAlignmentRight;
    }
    return _xyp_lastCoinLab;
}

- (UIButton *)xyp_rechargeBtn {
    if (!_xyp_rechargeBtn) {
        _xyp_rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xyp_rechargeBtn.backgroundColor = UIColor.clearColor;
        [_xyp_rechargeBtn addTarget:self action:@selector(xyf_rechargeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_rechargeBtn;
}

- (OWLPPGiftPageControl *)xyp_pageControl {
    if (!_xyp_pageControl) {
        _xyp_pageControl = [[OWLPPGiftPageControl alloc] initWithFrame:CGRectMake(0, 246, kXYLScreenWidth, 4)];
    }
    return _xyp_pageControl;
}

#pragma mark - UI
- (void) xyf_setupUI {
    self.xyp_spaceSecond = 0;
    self.xyp_comboNum = 0;
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = UIColor.clearColor;
    [closeBtn addTarget:self action:@selector(xyf_dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.xyp_popView];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kXYLHasCloseluckyBoxDetail] && !OWLJConvertToolShared.xyf_isGreen) {
        [self addSubview:self.xyp_luckyBoxBtn];
    }
    [self.xyp_popView addSubview:self.xyp_scrollView];
    UIImageView * xyp_rightImg = [[UIImageView alloc] init];
    [XYCUtil xyf_loadMirrorImage:xyp_rightImg iconStr:@"xyr_white_right"];
    [self.xyp_popView addSubview:xyp_rightImg];
    [xyp_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.xyp_popView).offset(-12);
        make.top.equalTo(self.xyp_scrollView.mas_bottom).offset(33);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    [self.xyp_popView addSubview:self.xyp_lastCoinLab];
    [self.xyp_lastCoinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(xyp_rightImg.mas_leading).offset(-5);
        make.centerY.equalTo(xyp_rightImg);
    }];
    UIImageView * xyp_coinIcon = [[UIImageView alloc] init];
    [XYCUtil xyf_loadIconImage:xyp_coinIcon iconStr:@"xyr_top_info_coin_icon"];
    [self.xyp_popView addSubview:xyp_coinIcon];
    [xyp_coinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.xyp_lastCoinLab.mas_leading).offset(-5);
        make.centerY.equalTo(self.xyp_lastCoinLab);
        make.width.height.mas_equalTo(16);
    }];
    [self.xyp_popView addSubview:self.xyp_rechargeBtn];
    [self.xyp_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.xyp_popView);
        make.leading.centerY.equalTo(xyp_coinIcon);
        make.height.mas_equalTo(40);
    }];
    [self xyf_refreshLeftCoins:OWLJConvertToolShared.xyf_userCoins];
    [self.xyp_popView addSubview:self.xyp_pageControl];
    [self.xyp_pageControl setHidden:YES];
    [self.xyp_popView addSubview:self.xyp_classifyScrollView];
    
    //接收金币改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xyf_refreshCoinNotification:)
                                                 name:xyl_user_update_coins
                                               object:nil];
    
    if (OWLJConvertToolShared.xyf_isRTL) {
        self.xyp_classifyScrollView.transform = CGAffineTransformMakeRotation(M_PI);
        self.xyp_scrollView.transform = CGAffineTransformMakeRotation(M_PI);
        self.xyp_pageControl.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

#pragma mark - 更新金币
- (void)xyf_refreshCoinNotification:(NSNotification *)notification {
    self.xyp_cutCoins = OWLJConvertToolShared.xyf_userCoins;
    [self xyf_refreshLeftCoins:OWLJConvertToolShared.xyf_userCoins];
}

#pragma mark - 定时器
- (void) xyf_nextSecond {
    if (self.xyp_lastGift == nil) {
        return;
    }
    if (self.xyp_spaceSecond < 4) {
        self.xyp_spaceSecond += 1;
    } else {
        self.xyp_lastGift = nil;
    }
}

#pragma mark - 更新剩余金币
- (void) xyf_refreshLeftCoins:(NSInteger)coins {
    NSString * xyp_coinStr = [NSString stringWithFormat:@"%ld",coins];
    self.xyp_lastCoinLab.text = xyp_coinStr;
    CGFloat xyp_coinWid = [xyp_coinStr boundingRectWithSize:CGSizeMake(0, 20) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.xyp_lastCoinLab.font} context:nil].size.width;
    self.xyp_classifyScrollView.xyp_w = kXYLScreenWidth - xyp_coinWid - 60;
    if (OWLJConvertToolShared.xyf_isRTL) {
        self.xyp_classifyScrollView.xyp_x = kXYLScreenWidth - self.xyp_classifyScrollView.xyp_w;
    }
}

#pragma mark - 查看盲盒玩法
- (void) xyf_luckyBoxButtonClicked {
    [OWLMusicInsideManagerShared xyf_removeComboView];
    OWLPPBannerDetailAlert * alert = [[OWLPPBannerDetailAlert alloc] initWithFrame:self.bounds];
    [self addSubview:alert];
    [alert xyf_setupUrl:@"https://sng-apps-configs.s3-us-west-2.amazonaws.com/136-up2u/icons/luckyboxRules.png"];
    [alert xyf_showAlert];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kXYLHasShowluckyBoxDetail];
    UIButton * xyp_closeBtn = [self.xyp_luckyBoxBtn viewWithTag:404];
    [xyp_closeBtn setHidden:NO];
}

/// 😊 大家可以用简单粗暴的方式替换字符串 不需要用特别复杂的加密等方法
- (NSString *)xyf_getRealStrWithUrl:(NSString *)url replaceString:(NSString *)replaceString {
    return [url stringByReplacingOccurrencesOfString:replaceString withString:@""];
}

#pragma mark - 隐藏盲盒玩法按钮
- (void) xyf_hideLuckyBoxBtn {
    [self.xyp_luckyBoxBtn removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kXYLHasCloseluckyBoxDetail];
}

#pragma mark - 弹出礼物选择弹窗
- (void) xyf_alertChooseGift {
    /// 如果盲盒按钮存在 并且 显示 =》 判断是否需要隐藏
    if (_xyp_luckyBoxBtn && !_xyp_luckyBoxBtn.hidden) {
        self.xyp_luckyBoxBtn.hidden = OWLMusicInsideManagerShared.xyp_vc.xyp_isUGC || OWLJConvertToolShared.xyf_isGreen;
    }
    kXYLWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.xyp_popView.xyp_y = (kXYLScreenHeight - 290 - kXYLIPhoneBottomHeight);
        weakSelf.xyp_luckyBoxBtn.xyp_y = kXYLScreenHeight - kXYLIPhoneBottomHeight - 290 - 59;
        if ([self.xyp_delegate respondsToSelector:@selector(xyf_giftAlertContenYChange:)]) {
            [self.xyp_delegate xyf_giftAlertContenYChange:weakSelf.xyp_popView.xyp_y];
        }
    }];
    
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventGiftPopupView];
}

#pragma mark - 关闭礼物弹窗
- (void) xyf_dismiss {
    kXYLWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.xyp_popView.xyp_y = kXYLScreenHeight;
        weakSelf.xyp_luckyBoxBtn.xyp_y = kXYLScreenHeight;
        if ([self.xyp_delegate respondsToSelector:@selector(xyf_giftAlertContenYChange:)]) {
            [self.xyp_delegate xyf_giftAlertContenYChange:weakSelf.xyp_popView.xyp_y];
        }
    } completion:^(BOOL finished) {
        [weakSelf setHidden:YES];
    }];
    
    [OWLMusicInsideManagerShared xyf_removeComboView];
}

#pragma mark - 填充数据
- (void) xyf_configGGData:(NSArray *) dataArray {
    self.xyp_giftArray = dataArray;
    NSMutableArray * resultArr = [NSMutableArray array];
    NSMutableArray * xyp_tempArr = [NSMutableArray array];
    NSMutableArray * xyp_indexArr = [NSMutableArray array];
    NSInteger smallCount = 0;
    for (int i = 0; i < dataArray.count; i ++) {
        smallCount = 0;
        OWLMusicGiftConfigModel * xyp_configModel = dataArray[i];
        for (int j = 0; j < xyp_configModel.dsb_giftList.count; j ++) {
            if (j % 8 == 0) {
                [xyp_tempArr removeAllObjects];
            }
            [xyp_tempArr addObject:xyp_configModel.dsb_giftList[j]];
            if ((j % 8 == 7) || (j == xyp_configModel.dsb_giftList.count - 1)) {
                [resultArr addObject:[xyp_tempArr copy]];
                smallCount += 1;
            }
        }
        if (i == 0) {
            if (xyp_configModel.dsb_giftList.count > 8) {
                self.xyp_pageControl.xyp_numberPages = xyp_configModel.dsb_giftList.count % 8 == 0 ? xyp_configModel.dsb_giftList.count / 8 : xyp_configModel.dsb_giftList.count / 8 + 1;
                self.xyp_pageControl.xyp_currentPage = 0;
                [self.xyp_pageControl setHidden:NO];
            }
        }
        [xyp_indexArr addObject:@(smallCount)];
    }
    self.xyp_collectionDataArray = [resultArr copy];
    self.xyp_countArray = [xyp_indexArr copy];
    [self xyf_refreshGGClassifyData];
    [self xyf_refreshGiftListData];
}

#pragma mark - 刷新所有collectionView
- (void) xyf_refreshAllCollectionView {
    for (int i = 0; i < self.xyp_collectionDataArray.count; i ++) {
        UICollectionView * xyp_collection = (UICollectionView *)[self.xyp_scrollView viewWithTag:500 + i];
        [xyp_collection reloadData];
    }
}

#pragma mark - 刷新底部礼物分类数据
- (void) xyf_refreshGGClassifyData {
    [self.xyp_classifyScrollView xyf_removeAllSubviews];
    CGFloat fromWid = 15;
    for (int i = 0; i < self.xyp_giftArray.count; i ++) {
        OWLMusicGiftConfigModel * xyp_configModel = self.xyp_giftArray[i];
        UIButton * xyp_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [xyp_Btn setTitle:xyp_configModel.dsb_title forState:UIControlStateNormal];
        [xyp_Btn setTitleColor:kXYLColorFromRGB(0x75737B) forState:UIControlStateNormal];
        [xyp_Btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        xyp_Btn.titleLabel.font = kXYLGilroyBoldFont(16);
        xyp_Btn.tag = 400 + i;
        if (i == 0) {
            [xyp_Btn setSelected:YES];
        }
        [xyp_Btn addTarget:self action:@selector(xyf_chooseGiftClassifyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [xyp_Btn sizeToFit];
        xyp_Btn.frame = CGRectMake(fromWid, 0, xyp_Btn.xyp_w, self.xyp_classifyScrollView.xyp_h);
        [self.xyp_classifyScrollView addSubview:xyp_Btn];
        fromWid += xyp_Btn.xyp_w + 21;
        if (OWLJConvertToolShared.xyf_isRTL) {
            xyp_Btn.transform = CGAffineTransformMakeRotation(M_PI);
        }
        if (xyp_configModel.dsb_iconUrl.length > 0) {
            if (xyp_configModel.dsb_iconType == 1 || xyp_configModel.dsb_iconType == 2) {
                if (i == 0 && xyp_configModel.dsb_iconType == 1) {
                    [self xyf_readGiftTag:xyp_configModel.dsb_title];
                } else {
                    UIImageView * xyp_tImg = [[UIImageView alloc] initWithFrame:CGRectMake(xyp_Btn.xyp_w - 10, 0, 20, 10)];
                    xyp_tImg.tag = 456;
                    [xyp_tImg sd_setImageWithURL:[NSURL URLWithString:xyp_configModel.dsb_iconUrl]];
                    [xyp_Btn addSubview:xyp_tImg];
                }
            }
        }
    }
    self.xyp_classifyScrollView.contentSize = CGSizeMake(fromWid - 6, self.xyp_classifyScrollView.xyp_h);
}

#pragma mark - 填充礼物数据
- (void) xyf_refreshGiftListData {
    [self.xyp_scrollView xyf_removeAllSubviews];
    for (int i = 0; i < self.xyp_collectionDataArray.count; i ++) {
        UICollectionViewFlowLayout * xyp_flowLayout = [[UICollectionViewFlowLayout alloc] init];
        xyp_flowLayout.itemSize = CGSizeMake((kXYLScreenWidth - 75) / 4, self.xyp_scrollView.xyp_h / 2);
        xyp_flowLayout.minimumLineSpacing = 0;
        xyp_flowLayout.minimumInteritemSpacing = 15;
        xyp_flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        UICollectionView * xyp_collection = [[UICollectionView alloc] initWithFrame:CGRectMake(kXYLScreenWidth * i, 0, kXYLScreenWidth, self.xyp_scrollView.xyp_h) collectionViewLayout:xyp_flowLayout];
        [xyp_collection registerClass:[OWLPPGiftItem class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"XYCGiftChooseItem%02d",i]];
        xyp_collection.backgroundColor = UIColor.clearColor;
        xyp_collection.showsVerticalScrollIndicator = NO;
        xyp_collection.showsHorizontalScrollIndicator = NO;
        xyp_collection.pagingEnabled = YES;
        xyp_collection.delegate = self;
        xyp_collection.dataSource = self;
        xyp_collection.tag = 500 + i;
        [self.xyp_scrollView addSubview:xyp_collection];
        if (OWLJConvertToolShared.xyf_isRTL) {
            xyp_collection.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }
    self.xyp_scrollView.contentSize = CGSizeMake(kXYLScreenWidth * self.xyp_collectionDataArray.count, self.xyp_scrollView.xyp_h);
}

#pragma mark - 选择礼物分类
- (void) xyf_chooseGiftClassifyButtonClicked:(UIButton *) sender {
    int xyp_index = (int)sender.tag - 400;
    [OWLMusicTongJiTool xyf_thinkingGiftThemeClick:sender.titleLabel.text];
    if (self.xyp_classifyPage == xyp_index) {
        return;
    }
    self.xyp_classifyPage = xyp_index;
    [self xyf_setupConfigTitleNeedScroll:YES];
}

#pragma mark - 设置礼物标题选中状态
- (void) xyf_setupConfigTitleNeedScroll:(BOOL) needScrol {
    kXYLWeakSelf;
    for (int i = 0; i < self.xyp_giftArray.count; i ++) {
        OWLMusicGiftConfigModel * xyp_configModel = self.xyp_giftArray[i];
        UIButton * xyp_btn = [self.xyp_classifyScrollView viewWithTag:400 + i];
        if (i == self.xyp_classifyPage) {
            [xyp_btn setSelected:YES];
            NSInteger xyp_allCount = [self.xyp_countArray[i] integerValue];
            NSInteger xyp_scrollIndex = 0;
            for (int j = 0; j < self.xyp_countArray.count; j ++) {
                if (j < self.xyp_classifyPage) {
                    xyp_scrollIndex += [self.xyp_countArray[j] integerValue];
                }
            }
            if (needScrol) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.xyp_scrollView.contentOffset = CGPointMake(weakSelf.xyp_scrollView.xyp_w * xyp_scrollIndex, 0);
                }];
            } else {
                if (self.xyp_classifyScrollView.contentSize.width > self.xyp_classifyScrollView.xyp_w) {
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.xyp_classifyScrollView.contentOffset = CGPointMake(weakSelf.xyp_classifyPage * 60, 0);
                    }];
                }
            }
            [self.xyp_pageControl setHidden:xyp_allCount < 2];
            self.xyp_pageControl.xyp_numberPages = xyp_allCount;
            self.xyp_collectionPage = 0;
            self.xyp_pageControl.xyp_currentPage = 0;
            if (xyp_configModel.dsb_iconUrl.length > 0) {
                if (xyp_configModel.dsb_iconType == 1) {
                    if ([xyp_btn viewWithTag:456] != nil) {
                        UIView * tagView = [xyp_btn viewWithTag:456];
                        [tagView setHidden:YES];
                        [self xyf_readGiftTag:xyp_configModel.dsb_title];
                    }
                }
            }
        } else {
            [xyp_btn setSelected:NO];
        }
    }
}

#pragma mark - 弹出充值弹窗
- (void) xyf_rechargeButtonClicked {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventGiftPopupRechargeClick];
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_showRechargeAlert)]) {
        [self.xyp_delegate xyf_showRechargeAlert];
    }
}

#pragma mark - 阅读礼物标签
- (void) xyf_readGiftTag:(NSString *) ggTitle {
    [OWLMusicRequestApiManager xyf_requestSeeGiftWithTitle:ggTitle completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        }];
}

#pragma mark - 礼物发送成功后转换
- (OWLMusicMessageModel *) xyf_getMessageModelWith:(OWLMusicGiftInfoModel *) gift andBlindId:(NSInteger) blindId {
    OWLMusicMessageModel * model;
    if (self.xyp_lastGift != nil) {
        if (self.xyp_spaceSecond < 4 && self.xyp_lastGift.dsb_giftID == gift.dsb_giftID) {
            self.xyp_comboNum += 1;
            self.xyp_spaceSecond = 0;
        } else {
            self.xyp_comboNum = 1;
        }
    } else {
        self.xyp_comboNum = 1;
    }
    if (gift.dsb_isBlindGift) {
        /// 如果是UGC房间 盲盒就当做普通盲盒。
        if (OWLMusicInsideManagerShared.xyp_vc.xyp_isUGC) {
            self.xyp_lastGift = gift;
            model = [OWLMusicMessageModel xyf_getSendGiftMsg:gift giftNum:self.xyp_comboNum];
            model.dsb_isblindGift = YES;
        } else {
            self.xyp_lastGift = [[OWLMusicGiftInfoModel alloc] init];
            self.xyp_lastGift.dsb_giftID = blindId;
            model = [OWLMusicMessageModel xyf_getSendGiftMsg:gift giftNum:self.xyp_comboNum];
            model.dsb_giftID = blindId;
            model.dsb_isblindGift = YES;
        }
    } else {
        self.xyp_lastGift = gift;
        model = [OWLMusicMessageModel xyf_getSendGiftMsg:gift giftNum:self.xyp_comboNum];
    }
    self.xyp_spaceSecond = 0;
    return model;
}

#pragma mark - 判断当前页是否是svip礼物
- (BOOL) xyf_judgeCurrentCollentionPageIsSpecial:(NSInteger) xyp_index {
    NSInteger xyp_addCount = 0;
    for (int i = 0; i < self.xyp_countArray.count; i ++) {
        if (xyp_addCount + [self.xyp_countArray[i] integerValue] > xyp_index) {
            OWLMusicGiftConfigModel * xyp_configModel = self.xyp_giftArray[i];
            if ([[xyp_configModel.dsb_title lowercaseString] isEqualToString:@"svip"]) {
                return YES;
            } else {
                return NO;
            }
        }
        xyp_addCount += [self.xyp_countArray[i] integerValue];
    }
    return NO;
}

#pragma mark - collectionView datasource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int xyp_indexNum = (int)collectionView.tag - 500;
    NSArray * xyp_arr = self.xyp_collectionDataArray[xyp_indexNum];
    return xyp_arr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    int xyp_indexNum = (int)collectionView.tag - 500;
    NSArray * xyp_arr = self.xyp_collectionDataArray[xyp_indexNum];
    OWLPPGiftItem * xyp_item = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"XYCGiftChooseItem%02d",xyp_indexNum] forIndexPath:indexPath];
    if (xyp_arr.count > indexPath.row) {
        xyp_item.xyp_isSvv = [self xyf_judgeCurrentCollentionPageIsSpecial:xyp_indexNum];
        xyp_item.xyp_ggModel = xyp_arr[indexPath.row];
    }
    kXYLWeakSelf
    xyp_item.xyp_sendGiftBlock = ^{
        [weakSelf xyf_clickItem:collectionView indexPath:indexPath];
    };
    
    return xyp_item;
}

#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (OWLJConvertToolShared.xyf_judgeNoNetworkAndShowNoNetTip) {
        return;
    }
    [self xyf_clickItem:collectionView indexPath:indexPath];
}

- (void)xyf_clickItem:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    int xyp_indexNum = (int)collectionView.tag - 500;
    NSArray * xyp_arr = self.xyp_collectionDataArray[xyp_indexNum];
    OWLMusicGiftInfoModel * ggModel = xyp_arr[indexPath.row];
    [OWLMusicTongJiTool xyf_thinkingGiftPopupGiftClick:ggModel];
    if ([self xyf_judgeCurrentCollentionPageIsSpecial:xyp_indexNum] && !OWLJConvertToolShared.xyf_userIsSvip) {
        //去svip
        if ([self.xyp_delegate respondsToSelector:@selector(xyf_jumpToSvip)]) {
            [self.xyp_delegate xyf_jumpToSvip];
        }
    } else {
        //送礼物
        if ([self.xyp_delegate respondsToSelector:@selector(xyf_clickedOneGift:)]) {
            [self.xyp_delegate xyf_clickedOneGift:ggModel];
        }
        NSInteger coins = self.xyp_cutCoins - ggModel.dsb_giftCoin;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if (coins >= 0) {
            self.xyp_cutCoins -= ggModel.dsb_giftCoin;
            if (ggModel.dsb_comboIconImage.length > 0) {
                [self xyf_refreshLeftCoins:self.xyp_cutCoins];
                [OWLMusicComboViewManager.shared xyf_ClickedGift:ggModel.dsb_giftID roomId:OWLMusicInsideManagerShared.xyp_hostID container:self.superview frame:[cell convertRect:cell.bounds toView:self.superview] isQuick:NO numberFont:kXYLGilroyBoldFont(16)];
            }
        } else {
            [OWLMusicInsideManagerShared xyf_removeComboView];
        }
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [OWLMusicInsideManagerShared xyf_removeComboView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.xyp_scrollView) {
        return;
    }
    NSInteger xyp_sIndex = (scrollView.contentOffset.x + scrollView.xyp_w / 2) / scrollView.xyp_w;
    NSInteger xyp_allcount = 0;
    NSInteger scrollIndex = self.xyp_collectionPage;
    NSInteger xyp_page = self.xyp_classifyPage;
    NSInteger xyp_allClassifyScrollCount = 0;
    for (int i = 0; i < self.xyp_countArray.count; i ++) {
        NSInteger indexCount = [self.xyp_countArray[i] integerValue];
        if ((xyp_sIndex < xyp_allcount + indexCount) && (xyp_sIndex >= xyp_allcount)) {
            xyp_page = i;
            scrollIndex = xyp_sIndex - xyp_allcount;
            xyp_allClassifyScrollCount = indexCount;
        }
        xyp_allcount += indexCount;
    }
        
    if (scrollIndex != self.xyp_collectionPage) {
        self.xyp_collectionPage = scrollIndex;
        self.xyp_pageControl.xyp_currentPage = scrollIndex;
    }
        
    if (xyp_page == self.xyp_classifyPage) {
        return;
    }
    self.xyp_classifyPage = xyp_page;
    self.xyp_pageControl.xyp_numberPages = xyp_allClassifyScrollCount;
    
    [self xyf_setupConfigTitleNeedScroll:NO];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
