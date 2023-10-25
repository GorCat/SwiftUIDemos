//// OWLBGMRoomToolsAlertView.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间工具视图弹窗
 * @创建时间：2023.2.11
 * @创建人：许琰
 */

#import "OWLBGMRoomToolsAlertView.h"
#import "OWLBGMRoomToolsSubCell.h"

@interface OWLBGMRoomToolsAlertView () <UICollectionViewDelegate, UICollectionViewDataSource>

#pragma mark - Views
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;
/// 列表
@property (nonatomic, strong) UICollectionView *xyp_collectionView;

#pragma mark - Data
/// 列表数组
@property (nonatomic, strong) NSMutableArray *xyp_dataList;

#pragma mark - Layout
/// 总高度
@property (nonatomic, assign) CGFloat xyp_totalHeight;
/// cell大小
@property (nonatomic, assign) CGSize xyp_cellSize;
/// 列表上下左右距离视图的边距
@property (nonatomic, assign) UIEdgeInsets xyp_listMarginInsets;

#pragma mark - Block
/// 弹窗消失的回调
@property (nonatomic, copy, nullable) XYLVoidBlock xyp_dismissBlock;

@end

@implementation OWLBGMRoomToolsAlertView

+ (instancetype)xyf_showRoomToolsAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                targetView:(UIView *)targetView
                              dismissBlock:(XYLVoidBlock)dismissBlock {
    OWLBGMRoomToolsAlertView *view = [[OWLBGMRoomToolsAlertView alloc] initWithDismissBlock:dismissBlock];
    view.delegate = delegate;
    [view xyf_showInView:targetView];
    
    return view;
}

- (instancetype)initWithDismissBlock:(XYLVoidBlock)dismissBlock {
    self = [super init];
    if (self) {
        self.xyp_dismissBlock = dismissBlock;
        [self xyf_setupLayout];
        [XYCUtil xyf_clickRadius:20 alertView:self];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout {
    self.xyp_cellSize = CGSizeMake(60, 75);
    CGFloat bottomMargin = [XYCUtil xyf_isIPhoneX] ? 18 : 8;
    self.xyp_listMarginInsets = UIEdgeInsetsMake(44, 7.5, bottomMargin, 7.5);
    self.xyp_totalHeight = self.xyp_listMarginInsets.top + self.xyp_cellSize.height + self.xyp_listMarginInsets.bottom;
    self.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.xyp_totalHeight);
}

- (void)xyf_setupView {
    self.backgroundColor = kXYLColorFromRGB(0x1F1F22);
    
    [self addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(16);
        make.height.mas_equalTo(40);
        make.top.equalTo(self).offset(4);
        make.trailing.equalTo(self).offset(-16);
    }];
    
    [self addSubview:self.xyp_collectionView];
    [self.xyp_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.xyp_listMarginInsets.top);
        make.leading.trailing.equalTo(self);
        make.height.mas_equalTo(self.xyp_cellSize.height);
    }];
}

#pragma mark - 动画
/// 展示
- (void)xyf_showInView:(UIView *)superView {
    CGRect rect = self.frame;
    rect.origin.y = kXYLScreenHeight - self.xyp_totalHeight;
    [superView addSubview:self.xyp_overyView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = rect;
    }];
}

/// 消失
- (void)xyf_dismiss {
    CGRect rect = self.frame;
    rect.origin.y = kXYLScreenHeight;
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        !self.xyp_dismissBlock?:self.xyp_dismissBlock();
        [self removeFromSuperview];
        [self.xyp_overyView removeFromSuperview];
    }];
}

#pragma mark - Delegate
#pragma mark UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.xyp_dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *number = [self.xyp_dataList xyf_objectAtIndexSafe:indexPath.row];
    OWLBGMRoomToolsSubCellType type = number.integerValue;
    
    OWLBGMRoomToolsSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OWLBGMRoomToolsSubCell class]) forIndexPath:indexPath];
    cell.xyp_type = type;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *number = [self.xyp_dataList xyf_objectAtIndexSafe:indexPath.row];
    OWLBGMRoomToolsSubCellType type = number.integerValue;
    [self xyf_giveCallBackClickType:type];
}

#pragma mark - Action
- (void)xyf_overyViewAction {
    [self xyf_dismiss];
}

#pragma mark - 给回调
- (void)xyf_giveCallBackClickType:(OWLBGMRoomToolsSubCellType)type {
    XYLModuleBaseViewClickType callBackType = 0;
    
    switch (type) {
        case OWLBGMRoomToolsSubCellType_Recharge:
            [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickRecharge];
            callBackType = XYLModuleBaseViewClickType_ShowRechargeView;
            break;
        case OWLBGMRoomToolsSubCellType_StreamSettings:
            callBackType = XYLModuleBaseViewClickType_ClickStreamSettings;
            break;
        case OWLBGMRoomToolsSubCellType_Broadcast: {
            [OWLJConvertToolShared xyf_changeBroadcastState:![OWLJConvertToolShared xyf_isCloseBroadcast]];
            [self.xyp_collectionView reloadData];
            return;
        }
            break;
    }
    if (callBackType == 0) { return; }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickEvent:)]) {
        [self.delegate xyf_lModuleBaseViewClickEvent:callBackType];
    }
}

#pragma mark - Lazy
- (UIControl *)xyp_overyView {
    if (!_xyp_overyView) {
        _xyp_overyView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_overyView.backgroundColor = UIColor.clearColor;
        [_xyp_overyView addTarget:self action:@selector(xyf_overyViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_overyView;
}

- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.text = kXYLLocalString(@"Room tools");
        _xyp_titleLabel.textAlignment = NSTextAlignmentLeft;
        _xyp_titleLabel.textColor = kXYLColorFromRGB(0xffffff);
        _xyp_titleLabel.font = kXYLGilroyBoldFont(16);
        [_xyp_titleLabel xyf_atl];
    }
    return _xyp_titleLabel;
}

- (UICollectionView *)xyp_collectionView {
    if (!_xyp_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.xyp_cellSize;
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, self.xyp_listMarginInsets.left, 0, self.xyp_listMarginInsets.right);
        _xyp_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _xyp_collectionView.backgroundColor = UIColor.clearColor;
        _xyp_collectionView.showsVerticalScrollIndicator = NO;
        _xyp_collectionView.showsHorizontalScrollIndicator = NO;
        _xyp_collectionView.delegate = self;
        _xyp_collectionView.dataSource = self;
        [_xyp_collectionView registerClass:[OWLBGMRoomToolsSubCell class] forCellWithReuseIdentifier:NSStringFromClass([OWLBGMRoomToolsSubCell class])];
        if (@available(iOS 11.0, *)) {
            _xyp_collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _xyp_collectionView;
}

- (NSMutableArray *)xyp_dataList {
    if (!_xyp_dataList) {
        _xyp_dataList = OWLMusicInsideManagerShared.xyp_bottomManager.moreArray;
    }
    return _xyp_dataList;
}

@end
