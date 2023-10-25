//
//  OWLPPPageControl.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/23.
//

#import "OWLPPPageControl.h"

@interface OWLPPPageControl() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *xyp_collectionView;

@end

@implementation OWLPPPageControl

- (instancetype)initWithFrame:(CGRect)frame andAllPoint:(NSInteger) count {
    if (self = [super initWithFrame:frame]) {
        self.numberPages = count;
        [self xyf_setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

- (void)xyf_setupView {
    [self addSubview:self.xyp_collectionView];
    [self.xyp_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

//#pragma mark - 设置当前页码
//- (void)setCurrentPage:(NSInteger)currentPage {
//    for (int i = 0; i < self.numberPages; i ++) {
//        UIView * xyp_sView = [self.contentView viewWithTag:400 + i];
//        if (i == currentPage) {
//            xyp_sView.backgroundColor = UIColor.whiteColor;
//        } else {
//            xyp_sView.backgroundColor = kXYLColorFromRGBA(0xFFFFFF, 0.2);
//        }
//    }
//    if (currentPage > 4) {
//        NSInteger coefficient = currentPage / 5;
//        CGRect rect = self.contentView.frame;
//        rect.origin.x = -(50 * coefficient);
//        if (self.contentView.frame.origin.x != rect.origin.x) {
//            [UIView animateWithDuration:0.2 animations:^{
//                self.contentView.frame = rect;
//            }];
//        }
//    } else {
//        CGRect rect = self.contentView.frame;
//        rect.origin.x = 0;
//        [UIView animateWithDuration:0.2 animations:^{
//            self.contentView.frame = rect;
//        }];
//    }
//}

#pragma mark - 设置当前页码
- (void)setNumberPages:(NSInteger)numberPages {
    _numberPages = numberPages;
    [self.xyp_collectionView reloadData];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;

    UICollectionViewLayoutAttributes * att = [self.xyp_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];
    CGFloat width = self.xyp_collectionView.xyp_w;
    if(self.xyp_collectionView.contentSize.width > width) {
        if(att.frame.origin.x > width/2.f) {
            if(self.xyp_collectionView.contentSize.width - att.frame.origin.x - att.bounds.size.width/2.f > width/2.f) {
                CGPoint point = CGPointMake(att.frame.origin.x - width/2.f + att.bounds.size.width/2.f , 0);
                [self.xyp_collectionView setContentOffset:point animated:YES];
            }else {
                [self.xyp_collectionView setContentOffset:CGPointMake(self.xyp_collectionView.contentSize.width - width, 0) animated:YES];
            }
        }else {
            [self.xyp_collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    [self.xyp_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberPages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"XYCBannerPageCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.layer.cornerRadius = 2;
    cell.layer.masksToBounds = YES;
    if(_currentPage == indexPath.row){
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];;

    }
    return cell;
}


#pragma mark - Lazy
- (UICollectionView *)xyp_collectionView {
    if (!_xyp_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(4, 4);
        layout.minimumLineSpacing = 3.4;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _xyp_collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _xyp_collectionView.delegate = self;
        _xyp_collectionView.dataSource = self;
        _xyp_collectionView.pagingEnabled = true;
        _xyp_collectionView.backgroundColor = [UIColor clearColor];
        [_xyp_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"XYCBannerPageCell"];
        _xyp_collectionView.showsHorizontalScrollIndicator = false;
        _xyp_collectionView.userInteractionEnabled = NO;
    }
    return _xyp_collectionView;
}

@end
