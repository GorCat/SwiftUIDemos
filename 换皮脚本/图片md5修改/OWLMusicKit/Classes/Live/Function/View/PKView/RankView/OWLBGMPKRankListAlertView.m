//
//  OWLBGMPKRankListAlertView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/15.
//

/**
 * @功能描述：直播间PK - 送礼排行榜弹窗
 * @创建时间：2023.2.15
 * @创建人：许琰
 */

#import "OWLBGMPKRankListAlertView.h"
#import "OWLBGMPKRankListTopOneUserView.h"
#import "OWLMusicPKRankListCell.h"
#import "OWLBGMModuleVC.h"

@interface OWLBGMPKRankListAlertView () <
UITableViewDelegate,
UITableViewDataSource,
OWLBGMPKRankListUserInfoViewDelegate
>

#pragma mark - Views
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 第一名
@property (nonatomic, strong) OWLBGMPKRankListTopOneUserView *xyp_topView;
/// 列表
@property (nonatomic, strong) UITableView *xyp_tableView;
/// 空态视图
@property (nonatomic, strong) UIView *xyp_emptyView;

#pragma mark - Layout
/// 总高度
@property (nonatomic, assign) CGFloat xyp_totalHeight;

#pragma mark - BOOL
/// 是否是对面主播
@property (nonatomic, assign) BOOL xyp_isOtherAnchor;

#pragma mark - Data
/// 数据列表
@property (nonatomic, strong) NSMutableArray *xyp_datalist;
/// 主播ID
@property (nonatomic, assign) NSInteger xyp_anchorID;
/// 当前房间ID
@property (nonatomic, assign) NSInteger xyp_roomID;

#pragma mark - Block
/// 弹窗消失的回调
@property (nonatomic, copy, nullable) XYLVoidBlock xyp_dismissBlock;

@end

@implementation OWLBGMPKRankListAlertView

+ (instancetype)xyf_showPKRankListAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                 targetView:(UIView *)targetView
                              isOtherAnchor:(BOOL)isOtherAnchor
                                   anchorID:(NSInteger)anchorID
                                     roomID:(NSInteger)roomID
                               dismissBlock:(XYLVoidBlock)dismissBlock {
    OWLBGMPKRankListAlertView *view = [[OWLBGMPKRankListAlertView alloc] initWithIsOtherAnchor:isOtherAnchor anchorID:anchorID roomID:roomID dismissBlock:dismissBlock];
    view.delegate = delegate;
    [view xyf_showInView:targetView];
    
    return view;
}

- (instancetype)initWithIsOtherAnchor:(BOOL)isOtherAnchor
                             anchorID:(NSInteger)anchorID
                               roomID:(NSInteger)roomID
                         dismissBlock:(XYLVoidBlock)dismissBlock {
    self = [super init];
    if (self) {
        self.xyp_anchorID = anchorID;
        self.xyp_roomID = roomID;
        self.xyp_isOtherAnchor = isOtherAnchor;
        self.xyp_dismissBlock = dismissBlock;
        [self xyf_setupLayout];
        [XYCUtil xyf_clickRadius:20 alertView:self];
        [self xyf_setupView];
        [self xyf_requestData];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout {
    self.xyp_totalHeight = kXYLScreenHeight * 0.5;
    self.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.xyp_totalHeight);
}

- (void)xyf_setupView {
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.xyp_topView];
    [self addSubview:self.xyp_emptyView];
    [self addSubview:self.xyp_tableView];
    
    [self.xyp_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.mas_equalTo(84);
    }];
    
    [self.xyp_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(self.xyp_topView.mas_bottom);
    }];
    
    [self.xyp_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_tableView).offset(-12);
        make.leading.trailing.equalTo(self);
        make.height.mas_equalTo(106);
    }];
}

#pragma mark - Network
- (void)xyf_requestData {
    kXYLWeakSelf
    [OWLMusicRequestApiManager xyf_requestPKTopListWithAnchorID:self.xyp_anchorID roomID:self.xyp_roomID completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        if (aResponse.xyf_success) {
            NSArray *dicArr = [aResponse.data xyf_objectForKeyNotNil:@"data"];
            NSArray *arr = [OWLMusicPKTopUserModel mj_objectArrayWithKeyValuesArray:dicArr];
            [weakSelf xyf_dealWithList:arr];
        } else if (aResponse.xyf_requestSuccessWithWrongCode) {
            
        } else {
            
        }
    }];
}

/// 处理列表数据
- (void)xyf_dealWithList:(NSArray *)arr {
    self.xyp_emptyView.hidden = arr.count > 1;
    self.xyp_tableView.hidden = arr.count <= 0;
    self.xyp_topView.xyp_model = arr.firstObject;
    if (arr.count == 0) { return; }
    self.xyp_datalist = [NSMutableArray arrayWithArray:arr];
    [self.xyp_datalist xyf_removeFirstObject];
    [self.xyp_tableView reloadData];
}

#pragma mark - Delegate
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xyp_datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OWLMusicPKTopUserModel *model = (OWLMusicPKTopUserModel *)[self.xyp_datalist xyf_objectAtIndexSafe:indexPath.row];
    OWLMusicPKRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OWLMusicPKRankListCell class])];
    if (!cell) {
        cell = [[OWLMusicPKRankListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([OWLMusicPKRankListCell class])];
    }
    cell.delegate = self;
    cell.xyp_model = model;
    cell.xyp_rank = indexPath.row + 2;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

#pragma mark - OWLBGMPKRankListUserInfoViewDelegate 点击事件
/// 点击展示用户详情
- (void)xyf_pkRankListUserInfoClickAction:(OWLMusicPKTopUserModel *)model {
    XYLModuleBaseViewInfoClickType type = self.xyp_isOtherAnchor ? XYLModuleBaseViewInfoClickType_ShowPKOtherUserDetailView : XYLModuleBaseViewInfoClickType_ShowUserDetailView;
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickInfoEvent:accountID:avatar:nickname:displayAccountID:isAnchor:)]) {
        [self.delegate xyf_lModuleBaseViewClickInfoEvent:type accountID:model.dsb_userID avatar:@"" nickname:@"" displayAccountID:@"" isAnchor:NO];
    }
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

#pragma mark - Action
- (void)xyf_overyViewAction {
    [self xyf_dismiss];
}

#pragma mark - 给回调


#pragma mark - Lazy
- (UIControl *)xyp_overyView {
    if (!_xyp_overyView) {
        _xyp_overyView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_overyView.backgroundColor = UIColor.clearColor;
        [_xyp_overyView addTarget:self action:@selector(xyf_overyViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_overyView;
}

- (OWLBGMPKRankListTopOneUserView *)xyp_topView {
    if (!_xyp_topView) {
        _xyp_topView = [[OWLBGMPKRankListTopOneUserView alloc] initWithIsOtherAnchor:self.xyp_isOtherAnchor];
        _xyp_topView.delegate = self;
    }
    return _xyp_topView;
}

- (UIView *)xyp_emptyView {
    if (!_xyp_emptyView) {
        _xyp_emptyView = [[UIView alloc] init];
        _xyp_emptyView.hidden = YES;
        UIImageView *emptyIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:emptyIV iconStr:@"xyr_pk_rank_empty_image"];
        emptyIV.contentMode = UIViewContentModeScaleAspectFill;
        
        UILabel *emptyLabel = [[UILabel alloc] init];
        if (OWLJConvertToolShared.xyf_isGreen || OWLMusicInsideManagerShared.xyp_vc.xyp_isUGC) {
            emptyLabel.text = kXYLLocalString(@"Help the user win");
        } else {
            emptyLabel.text = kXYLLocalString(@"Help the host win");
        }
        
        emptyLabel.textColor = kXYLColorFromRGB(0xC4CACD);
        emptyLabel.font = kXYLGilroyBoldFont(12);
        
        [_xyp_emptyView addSubview:emptyIV];
        [emptyIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(_xyp_emptyView);
            make.height.mas_equalTo(80.5);
            make.width.mas_equalTo(86.5);
        }];
        
        [_xyp_emptyView addSubview:emptyLabel];
        [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(_xyp_emptyView);
        }];
    }
    return _xyp_emptyView;
}

- (UITableView *)xyp_tableView {
    if (!_xyp_tableView) {
        _xyp_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _xyp_tableView.backgroundColor = [UIColor whiteColor];
        _xyp_tableView.delegate = self;
        _xyp_tableView.dataSource = self;
        _xyp_tableView.showsVerticalScrollIndicator = NO;
        _xyp_tableView.showsHorizontalScrollIndicator = NO;
        _xyp_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        CGFloat height = [XYCUtil xyf_isIPhoneX] ? 20 : 5;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, height)];
        _xyp_tableView.tableFooterView = footerView;
        _xyp_tableView.estimatedSectionFooterHeight = 0;
        _xyp_tableView.estimatedSectionHeaderHeight = 0;
        _xyp_tableView.estimatedRowHeight = 0;
        [_xyp_tableView registerClass:[OWLMusicPKRankListCell class] forCellReuseIdentifier:NSStringFromClass([OWLMusicPKRankListCell class])];
        if (@available(iOS 11.0, *)) {
            _xyp_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _xyp_tableView;
}

@end
