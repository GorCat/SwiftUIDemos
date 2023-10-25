//// OWLMusicGameMenuView.m
// XYYCuteKit
//
// 
//


#import "OWLMusicGameMenuView.h"
#import "OWLMusicGameItemCell.h"
#import "UIButton+XYLExtention.h"
#import "OWLMusicGamePopView.h"

@interface OWLMusicGameMenuView () <UICollectionViewDelegate,UICollectionViewDataSource>

#pragma mark - Views
@property (nonatomic, strong) UIView *xyp_contentView;

@property (nonatomic, strong) UIImageView *xyp_bgIV;

@property (nonatomic, strong) UIButton *xyp_closeButton;

@property (nonatomic, strong) UICollectionView *xyp_collectionView;

#pragma mark - Model
@property (nonatomic, strong) OWLMusicGameInfoModel *xyp_gameModel;

@property (nonatomic, strong) NSMutableArray *xyp_gameList;

#pragma mark - Layout
/// 背景图片高度
@property (nonatomic, assign) CGFloat xyp_bgIVHeight;
/// 总高度
@property (nonatomic, assign) CGFloat xyp_contentHeight;

@end

@implementation OWLMusicGameMenuView

- (instancetype)initWithGameModel:(OWLMusicGameInfoModel *)model {
    self = [super init];
    if (self) {
        self.xyp_gameModel = model;
        [self xyf_setupLayout];
        [self xyf_setupData];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout {
    self.xyp_bgIVHeight = ceilf(294.0 / 375.0 * kXYLScreenWidth);
    self.xyp_contentHeight = self.xyp_bgIVHeight + 22.5;
}

- (void)xyf_setupData {
    self.xyp_gameList = [self.xyp_gameModel xyf_getAllOpenGame];
}

- (void)xyf_setupView {
    self.frame = CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight);
    [self addSubview:self.xyp_contentView];
    
    [self.xyp_contentView addSubview:self.xyp_bgIV];
    [self.xyp_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.xyp_contentView);
        make.height.mas_equalTo(self.xyp_bgIVHeight);
    }];
    
    [self.xyp_contentView addSubview:self.xyp_collectionView];
    [self.xyp_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.xyp_contentView);
        make.top.equalTo(self.xyp_bgIV).offset(66);
    }];
    
    [self.xyp_contentView addSubview:self.xyp_closeButton];
    [self.xyp_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(155);
        make.top.centerX.equalTo(self.xyp_contentView);
    }];
}

#pragma mark - Animate
- (void)xyf_showInView:(UIView *)view {
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.xyp_contentView.frame = CGRectMake(0, kXYLScreenHeight - self.xyp_contentHeight, kXYLScreenWidth, self.xyp_contentHeight);
    }];
}

- (void)xyf_dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.xyp_contentView.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth,self.xyp_contentHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.xyp_gameList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OWLMusicGameItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OWLMusicGameItemCell class]) forIndexPath:indexPath];
    cell.xyp_model = [self.xyp_gameList xyf_objectAtIndexSafe:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.xyp_collectionView.userInteractionEnabled = NO;
    
    OWLMusicGameConfigModel *model = [self.xyp_gameList xyf_objectAtIndexSafe:indexPath.row];
    OWLMusicGameConfigModel *chatModel = [OWLJConvertToolShared xyf_chatCurrentGameModel];

    [OWLMusicTongJiTool xyf_thinkingClickGameIconWithGameID:model.dsb_gameId];
    if (chatModel) {
        if (model.dsb_gameId == chatModel.dsb_gameId) {
            [self xyf_dismiss];
            [OWLJConvertToolShared xyf_showChatRoomGame];
        } else {
            [OWLJConvertToolShared xyf_closeChatRoomGame];
            OWLMusicGameItemCell * cell = (OWLMusicGameItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.xyp_isShowActivity = YES;
            OWLMusicGamePopView *popView = [[OWLMusicGamePopView alloc] init];
            OWLMusicInsideManagerShared.xyp_gamePopView = popView;
            [popView xyf_loadModel:model initBig:YES];
            kXYLWeakSelf
            popView.showBlock = ^{
                [weakSelf xyf_dismiss];
                cell.xyp_isShowActivity = NO;
            };
        }
    } else {
        if (model.dsb_gameId == OWLMusicInsideManagerShared.xyp_gamePopView.game.dsb_gameId) {
            [self xyf_dismiss];
            [OWLMusicInsideManagerShared.xyp_gamePopView xyf_big];
        } else {
            [OWLMusicInsideManagerShared.xyp_gamePopView xyf_close];
            OWLMusicGameItemCell * cell = (OWLMusicGameItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.xyp_isShowActivity = YES;
            OWLMusicGamePopView *popView = [[OWLMusicGamePopView alloc] init];
            OWLMusicInsideManagerShared.xyp_gamePopView = popView;
            [popView xyf_loadModel:model initBig:YES];
            kXYLWeakSelf
            popView.showBlock = ^{
                [weakSelf xyf_dismiss];
                cell.xyp_isShowActivity = NO;
            };
        }
    }
}

#pragma mark - Action
- (void)xyf_closeButtonAction {
    [self xyf_dismiss];
}

#pragma mark - Lazy
- (UIView *)xyp_contentView {
    if (!_xyp_contentView) {
        _xyp_contentView = [[UIView alloc] init];
        _xyp_contentView.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth,self.xyp_contentHeight);
    }
    return _xyp_contentView;
}

- (UIImageView *)xyp_bgIV {
    if (!_xyp_bgIV) {
        _xyp_bgIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_bgIV iconStr:@"xyr_game_bg"];
    }
    return _xyp_bgIV;
}

- (UIButton *)xyp_closeButton {
    if (!_xyp_closeButton) {
        _xyp_closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xyp_closeButton addTarget:self action:@selector(xyf_closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_xyp_closeButton xyf_loadIconStr:@"xyr_game_close"];
    }
    return _xyp_closeButton;
}

- (UICollectionView *)xyp_collectionView {
    if (!_xyp_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 17;
        flowLayout.minimumInteritemSpacing = floor((kXYLScreenWidth - 38 * 2 - 55 * 4) / 3.f);
        flowLayout.itemSize = CGSizeMake(55, 55);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 38, 0, 38);
        _xyp_collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _xyp_collectionView.backgroundColor = UIColor.clearColor;
        [_xyp_collectionView registerClass:[OWLMusicGameItemCell class] forCellWithReuseIdentifier:NSStringFromClass([OWLMusicGameItemCell class])];
        _xyp_collectionView.delegate = self;
        _xyp_collectionView.dataSource = self;
        _xyp_collectionView.showsVerticalScrollIndicator = YES;
    }
    return _xyp_collectionView;
}

- (NSMutableArray *)xyp_gameList {
    if (!_xyp_gameList) {
        _xyp_gameList = [[NSMutableArray alloc] init];
    }
    return _xyp_gameList;
}

@end
