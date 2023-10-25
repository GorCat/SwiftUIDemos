//
//  OWLMusicBottomDiscountCircleView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/7/15.
//

#import "OWLMusicBottomDiscountCircleView.h"
#import "OWLMusicBottomDiscountCircleCell.h"
#import "OWLMusicPageControl.h"

//轮播间隔
static CGFloat ScrollInterval = 3.0f;

@interface OWLMusicBottomDiscountCircleView() <
UICollectionViewDelegate,
UICollectionViewDataSource,
OWLMusicBottomDiscountCircleCellDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) OWLMusicPageControl *pageControl;

@property (nonatomic, strong) UICollectionViewFlowLayout *xyp_flowLayout;

@property (nonatomic, assign) BOOL isShowPayDiscount;

@property (nonatomic, assign) BOOL isShowOneCoin;

@end

@implementation OWLMusicBottomDiscountCircleView

- (void)dealloc {
    NSLog(@"xytest 轮播view dealloc");
    [self xyf_unobserveAllNotifications];
    [self xyf_stopTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupNotification];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    [self addSubview:self.pageControl];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:ScrollInterval target:self selector:@selector(xyf_showNext) userInfo:nil repeats:true];
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)xyf_setupNotification {
    [self xyf_observeNotification:xyl_module_success_open_onecoin_turntable];
    [self xyf_observeNotification:xyl_module_recharge_success];
}

#pragma mark - Update
- (void)xyf_updateArray:(BOOL)isShowPayDiscount isShowOneCoin:(BOOL)isShowOneCoin {
    self.isShowPayDiscount = isShowPayDiscount;
    self.isShowOneCoin = isShowOneCoin;
    
    [self.dataArray removeAllObjects];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    if (isShowOneCoin) { [list addObject:@(XYLModuleCycleInfoType_OneCoinTest)]; }
    if (isShowPayDiscount) { [list addObject:@(XYLModuleCycleInfoType_PayDiscount)]; }
    self.pageControl.numberOfPages = list.count;
    self.pageControl.hidden = list.count <= 1;
    if (list.count == 0) {
        self.timer.fireDate = [NSDate distantFuture];
        [self.collectionView reloadData];
        self.hidden = YES;
        return;
    }
    
    self.hidden = NO;
    self.dataArray = [NSMutableArray arrayWithArray:list];
    if (list.count == 1) {
        [self.collectionView reloadData];
        self.timer.fireDate = [NSDate distantFuture];
        return;
    }
    [self.dataArray addObject:list.firstObject];
    [self.dataArray insertObject:list.lastObject atIndex:0];
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:ScrollInterval];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width, 0)];
    });
    [self.collectionView reloadData];
}

#pragma mark - Private
- (void)xyf_showNext {
    //手指拖拽是禁止自动轮播
    if (self.collectionView.isDragging) { return; }
    CGFloat targetX =  self.collectionView.contentOffset.x + self.collectionView.bounds.size.width;
    [self.collectionView setContentOffset:CGPointMake(targetX, 0) animated:true];
}

- (void)xyf_cycleScroll {
    NSInteger page = self.collectionView.contentOffset.x/self.collectionView.bounds.size.width;
    if (page == 0) {//滚动到左边
        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width * (self.dataArray.count - 2), 0);
        self.pageControl.currentPage = self.dataArray.count - 3;
    } else if (page == self.dataArray.count - 1){//滚动到右边
        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width, 0);
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = page - 1;
    }
}

- (void)xyf_stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - 事件处理
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject *)obj {
    switch (type) {
        case XYLModuleEventType_UpdateCycleInfoView:
            [self xyf_dealUpdateCycleInfoView:obj];
            break;
        default:
            break;
    }
}

- (void)xyf_dealUpdateCycleInfoView:(NSObject *)obj {
    NSDictionary *dic = (NSDictionary *)obj;
    BOOL isShowPayDiscount = [[dic xyf_objectForKeyNotNil:kXYLNotificationPayDiscountStateKey] boolValue];
    BOOL isShowOneCoin = [[dic xyf_objectForKeyNotNil:kXYLNotificationOneCoinStateKey] boolValue];
    [self xyf_updateArray:isShowPayDiscount isShowOneCoin:isShowOneCoin];
}

#pragma mark - CollectionViewDelegate&DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"OWLMusicBottomDiscountCircleCell";
    OWLMusicBottomDiscountCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    XYLModuleCycleInfoType type = (XYLModuleCycleInfoType)[(NSNumber *)self.dataArray[indexPath.row] intValue];
    cell.type = type;
    cell.delegate = self;
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self xyf_cycleScroll];
    //拖拽动作后间隔3s继续轮播
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:ScrollInterval];
}

//自动轮播结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self xyf_cycleScroll];
}

#pragma mark - OWLMusicBottomDiscountCircleCellDelegate
- (void)xyf_BottomDiscountCircleClickWithType:(XYLModuleCycleInfoType)type {
    switch (type) {
        case XYLModuleCycleInfoType_PayDiscount:
            [self xyf_callBackClickPayDiscount];
            break;
        case XYLModuleCycleInfoType_OneCoinTest:
            [OWLJConvertToolShared xyf_showOneCoinTest:YES];
            break;
    }
}

#pragma mark - 给回调
- (void)xyf_callBackClickPayDiscount {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickEvent:)]) {
        [self.delegate xyf_lModuleBaseViewClickEvent:XYLModuleBaseViewClickType_ClickDiscountButton];
    }
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_module_recharge_success]) {
        [self xyf_updateArray:NO isShowOneCoin:self.isShowOneCoin];
    } else if ([notification.name isEqualToString:xyl_module_success_open_onecoin_turntable]) {
        [self xyf_updateArray:self.isShowPayDiscount isShowOneCoin:NO];
    }
}

#pragma mark - lazy
- (UICollectionViewFlowLayout *)xyp_flowLayout {
    if (!_xyp_flowLayout) {
        _xyp_flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _xyp_flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _xyp_flowLayout.itemSize = CGSizeMake(66, 66);
        _xyp_flowLayout.minimumLineSpacing = 0;
    }
    return  _xyp_flowLayout;
}

-(UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.xyp_flowLayout];
        _collectionView.semanticContentAttribute = OWLJConvertToolShared.xyf_isRTL ? UISemanticContentAttributeForceRightToLeft : UISemanticContentAttributeForceLeftToRight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = true;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[OWLMusicBottomDiscountCircleCell class] forCellWithReuseIdentifier:@"OWLMusicBottomDiscountCircleCell"];
        _collectionView.showsHorizontalScrollIndicator = false;
    }
    return _collectionView;
}

- (OWLMusicPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[OWLMusicPageControl alloc] initWithFrame:CGRectMake(0, 73, 66, 4)];
        _pageControl.otherPointSize = CGSizeMake(3, 3);
        _pageControl.currentPointSize = CGSizeMake(6, 3);
        _pageControl.currentColor = [UIColor whiteColor];
        _pageControl.otherColor = kXYLColorFromRGBA(0xffffff, 0.5);
        _pageControl.pointCornerRadius = 1.5;
        _pageControl.controlSpacing = 3;
    }
    return _pageControl;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
