//
//  OWLPPBanner.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/23.
//

#import "OWLPPBanner.h"
#import "OWLPPBannerItem.h"
#import "UIButton+XYLExtention.h"
#import "OWLPPPageControl.h"

@interface OWLPPBanner()<UICollectionViewDelegate, UICollectionViewDataSource, OWLPPBannerItemDelegate>

@property (nonatomic, strong) UICollectionView * xyp_contentCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout * xyp_flowLayout;

@property (nonatomic, strong) NSArray * xyp_listArray;//数据数组

@property (nonatomic, strong) OWLPPPageControl * xyp_pageControl;//页码

@property (nonatomic, assign) NSInteger xyp_totalItemCount;

@property (nonatomic, assign) BOOL xyp_stopTimer;

@property (nonatomic, assign) NSInteger xyp_timerSecond;

@property (nonatomic, strong) UIStackView *xyp_moreStackView;

@end

@implementation OWLPPBanner

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_addDefaultConfig];
        [self xyf_setupUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self xyf_addDefaultConfig];
        [self xyf_setupUI];
    }
    return self;
}

- (UICollectionViewFlowLayout *)xyp_flowLayout {
    if (!_xyp_flowLayout) {
        _xyp_flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _xyp_flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _xyp_flowLayout.itemSize = CGSizeMake(kXYLBannerWidth, 97);
        _xyp_flowLayout.minimumLineSpacing = 0;
    }
    return  _xyp_flowLayout;
}

- (UICollectionView *)xyp_contentCollectionView {
    if (!_xyp_contentCollectionView) {
        _xyp_contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kXYLBannerWidth, kXYLBannerHeight - 8) collectionViewLayout:self.xyp_flowLayout];
        [_xyp_contentCollectionView registerClass:[OWLPPBannerItem class] forCellWithReuseIdentifier:NSStringFromClass([OWLPPBannerItem class])];
        [_xyp_contentCollectionView setPagingEnabled:YES];
        _xyp_contentCollectionView.backgroundColor = UIColor.clearColor;
        _xyp_contentCollectionView.showsVerticalScrollIndicator = NO;
        _xyp_contentCollectionView.showsHorizontalScrollIndicator = NO;
        _xyp_contentCollectionView.delegate = self;
        _xyp_contentCollectionView.dataSource = self;
        _xyp_contentCollectionView.layer.cornerRadius = 10;
        _xyp_contentCollectionView.layer.masksToBounds = YES;
        _xyp_contentCollectionView.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
    }
    return _xyp_contentCollectionView;
}

- (UIStackView *)xyp_moreStackView {
    if (!_xyp_moreStackView){
        _xyp_moreStackView = [[UIStackView alloc]init];
        _xyp_moreStackView.axis = UILayoutConstraintAxisHorizontal;
        _xyp_moreStackView.spacing = 3;
        _xyp_moreStackView.distribution = UIStackViewDistributionFill;
        _xyp_moreStackView.alignment = UIStackViewAlignmentCenter;
        UILabel *label = [[UILabel alloc] init];
        label.text = kXYLLocalString(@"More");
        label.textColor = UIColor.whiteColor;
        label.font = kXYLGilroyMediumFont(9);
        UIImageView *image = [[UIImageView alloc] init];
        [XYCUtil xyf_loadMirrorImage:image iconStr:@"xyr_banner_more"];
        image.contentMode = UIViewContentModeScaleAspectFit;
        
        [_xyp_moreStackView addArrangedSubview:label];
        [_xyp_moreStackView addArrangedSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(4);
        }];
        
        _xyp_moreStackView.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_moreButtonClicked)];
        [_xyp_moreStackView addGestureRecognizer:tap];
    }
    return _xyp_moreStackView;
}

#pragma mark - 设置默认配置
- (void) xyf_addDefaultConfig {
    self.xyp_isCarousel = YES;
    self.xyp_carouselTime = 5;
    self.xyp_placeImage = [UIImage imageNamed:@""];
}

#pragma mark - UI
- (void) xyf_setupUI {
    self.backgroundColor = kXYLColorFromRGBA(0x000000, 0.5);
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    [self addSubview:self.xyp_contentCollectionView];
    [self.xyp_contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 8, 0));
    }];
    // 关闭按钮
    UIButton * xyp_closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xyp_closeBtn xyf_loadIconStr:@"xyr_banner_close"];
    [xyp_closeBtn addTarget:self action:@selector(xyf_dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:xyp_closeBtn];
    [xyp_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self);
        make.width.height.mas_equalTo(19);
    }];
    
    [self addSubview:self.xyp_moreStackView];
    [self.xyp_moreStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(20);
        make.leading.equalTo(self).offset(52);
        make.trailing.equalTo(self).offset(-5);
    }];
}

#pragma mark - 填充数据
- (void)xyf_configBannerData:(NSArray *)dataArray {
    self.xyp_listArray = dataArray;
    self.xyp_totalItemCount = dataArray.count * 100;
    if (dataArray.count > 1) {
        [self.xyp_contentCollectionView setScrollEnabled:YES];
    } else {
        [self.xyp_contentCollectionView setScrollEnabled:NO];
    }
    [self.xyp_contentCollectionView reloadData];
    if (self.xyp_totalItemCount > 0) {
        NSInteger centerIndex = self.xyp_totalItemCount / 2;
        [self.xyp_contentCollectionView setContentOffset:CGPointMake(kXYLBannerWidth * centerIndex, 0)];
    }
    [self xyf_setupPageControl];
}

#pragma mark - pageControl
- (void) xyf_setupPageControl {
    if (self.xyp_pageControl != nil) {
        [self.xyp_pageControl removeFromSuperview];
        self.xyp_pageControl = nil;
    }
    if (self.xyp_listArray.count < 1) {
        return;
    }
    self.xyp_pageControl = [[OWLPPPageControl alloc] initWithFrame:CGRectZero];
    self.xyp_pageControl.numberPages = self.xyp_listArray.count;
    [self insertSubview:self.xyp_pageControl atIndex:1];
    [self.xyp_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(6);
        make.bottom.equalTo(self).offset(-8);
        make.trailing.equalTo(self).offset(-38);
        make.height.mas_equalTo(4);
    }];
    
    [self xyf_setupPageFrameAccordingtoIndex];
}

#pragma mark - 根据当前页码设置pageControl frame
- (void) xyf_setupPageFrameAccordingtoIndex {
    NSInteger pageIndex = [self xyf_pageControlIndexWithCurrentCellIndex:[self xyf_currentIndex]];
    self.xyp_pageControl.currentPage = pageIndex;
}

#pragma mark - 轮播下一页
- (void) xyf_carouselNextPage {
    if (self.xyp_listArray.count < 1) {
        return;
    }
    if (!self.xyp_isCarousel) {
        return;
    }
    if (self.xyp_stopTimer) {
        return;
    }
    if (self.xyp_totalItemCount < 1) {
        return;
    }
    if (self.xyp_contentCollectionView.isDragging) {
        return;
    }
    
    _xyp_timerSecond += 1;
    if (_xyp_timerSecond % 5 == 0) {
        NSInteger index = [self xyf_currentIndex] + 1;
        [self xyf_scrollToSpecifyIndex:index];
    }
}

#pragma mark - 获取当前pageControl下标对应的cell位置
- (NSInteger) xyf_pageControlIndexWithCurrentCellIndex:(NSInteger) index {
    return self.xyp_listArray.count == 0 ? 0 : (index % self.xyp_listArray.count);
}

#pragma mark - 滚动到指定位置
- (void) xyf_scrollToSpecifyIndex:(NSInteger) tIndex {
    kXYLWeakSelf
    if (tIndex >= self.xyp_totalItemCount) {
        self.xyp_contentCollectionView.contentOffset = CGPointMake(kXYLBannerWidth * (self.xyp_totalItemCount / 2), 0);
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.xyp_contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:tIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }];
    }
}

#pragma mark - 获取当前位置
- (NSInteger) xyf_currentIndex {
    if (self.xyp_contentCollectionView.bounds.size.width == 0 || self.xyp_contentCollectionView.bounds.size.height == 0) {
        return 0;
    }
    NSInteger currentX = self.xyp_contentCollectionView.contentOffset.x + kXYLBannerWidth / 2;
    NSInteger index = currentX / self.xyp_flowLayout.itemSize.width;
    return index < 0 ? 0 : index;
}

#pragma mark - 查看更多
- (void)xyf_moreButtonClicked {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_clickedLookMore)]) {
        [self.xyp_delegate xyf_clickedLookMore];
    }
}

#pragma mark - 关闭banner
- (void)xyf_dismiss {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_clickedCloseBanner)]) {
        [self.xyp_delegate xyf_clickedCloseBanner];
    }
}

#pragma mark - collectionView datasource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.xyp_totalItemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OWLPPBannerItem * item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OWLPPBannerItem class]) forIndexPath:indexPath];
    NSInteger pageIndex = [self xyf_pageControlIndexWithCurrentCellIndex:indexPath.row];
    if ((self.xyp_listArray.count > pageIndex) && (pageIndex >= 0)) {
        [item xyf_updateBannerModel:self.xyp_listArray[pageIndex]];
        item.xyp_index = pageIndex;
        item.delegate = self;
    }
    return item;
}

#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_didSelectOneItemByIndex:andBanner:)]) {
        [self.xyp_delegate xyf_didSelectOneItemByIndex:[self xyf_pageControlIndexWithCurrentCellIndex:indexPath.item] andBanner:self];
    }
}

#pragma mark - scrollView delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.xyp_listArray.count < 1) {
        return;
    }
    [self xyf_setupPageFrameAccordingtoIndex];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.xyp_stopTimer = YES;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.xyp_listArray.count < 1) {
        return;
    }
    if (self.xyp_isCarousel) {
        self.xyp_stopTimer = NO;
    }
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.xyp_listArray.count < 1) {
        return;
    }
    if (self.xyp_isCarousel) {
        self.xyp_stopTimer = NO;
    }
}

#pragma mark - OWLPPBannerItemDelegate
- (void) xyf_bannerItemClick:(NSInteger)index {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_didSelectOneItemByIndex:andBanner:)]) {
        [self.xyp_delegate xyf_didSelectOneItemByIndex:index andBanner:self];
    }
}

@end
