//
//  OWLBGMMedalListAlertView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

/**
 * @功能描述：直播间用户奖章弹窗
 * @创建时间：2023.2.13
 * @创建人：许琰
 */

#import "OWLBGMMedalListAlertView.h"
#import "OWLBGMMedalListCell.h"

@interface OWLBGMMedalListAlertView () <
UITableViewDelegate,
UITableViewDataSource>
 
#pragma mark - Views
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;
/// 列表
@property (nonatomic, strong) UITableView *xyp_tableView;
/// 空白页
@property (nonatomic, strong) UIView * xyp_emptyView;

#pragma mark - Data
/// 账号ID
@property (nonatomic, assign) NSInteger xyp_accountID;
/// 列表
@property (nonatomic, strong) NSArray *xyp_datalist;
///tag选中行
@property (nonatomic, assign) NSInteger xyp_selectIndex;

#pragma mark - Layout
/// 总高度
@property (nonatomic, assign) CGFloat xyp_totalHeight;

@end

@implementation OWLBGMMedalListAlertView

- (instancetype)initWithAccountID:(NSInteger)accountID {
    self = [super init];
    if (self) {
        self.xyp_selectIndex = 0;
        self.xyp_accountID = accountID;
        [self xyf_setupLayout];
        [XYCUtil xyf_clickRadius:20 alertView:self];
        [self xyf_setupView];
        [self xyf_requestList];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout {
    self.xyp_totalHeight = kXYLScreenHeight * 0.6;
    self.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.xyp_totalHeight);
}

- (void)xyf_setupView {
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.xyp_tableView];
    [self.xyp_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(self.xyp_titleLabel.mas_bottom);
    }];
    [self.xyp_tableView addSubview:self.xyp_emptyView];
    [self.xyp_emptyView setHidden:YES];
}

#pragma mark - 页面初始化
- (void)xyf_requestList {
    kXYLWeakSelf
    [OWLMusicRequestApiManager xyf_requestEventLabelList:self.xyp_accountID completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        if (aResponse.xyf_success) {
            NSArray *dicArr = [aResponse.data xyf_objectForKeyNotNil:@"data"];
            weakSelf.xyp_datalist = [OWLMusicEventLabelModel mj_objectArrayWithKeyValuesArray:dicArr];
        } else if (aResponse.xyf_requestSuccessWithWrongCode) {
            [OWLJConvertToolShared xyf_showErrorTip:aResponse.message];
        } else {
            [OWLJConvertToolShared xyf_noNetwork];
        }
        [weakSelf.xyp_emptyView setHidden:self.xyp_datalist.count > 0];
        [weakSelf.xyp_tableView reloadData];
        if (!weakSelf.xyp_isJustShow) {
            [weakSelf xyf_appointOneSelect:OWLJConvertToolShared.xyf_configTagTitle];
        }
    }];
}

#pragma mark - 指定选中某个标签
- (void)xyf_appointOneSelect:(NSString *)xy_tagTitle {
    for (int i = 0; i < self.xyp_datalist.count; i ++) {
        OWLMusicEventLabelModel *model = self.xyp_datalist[i];
        if ([model.dsb_labelTitle isEqualToString:xy_tagTitle]) {
            self.xyp_selectIndex = i + 1;
            [self.xyp_tableView reloadData];
            return;
        }
    }
}

#pragma mark - 动画
/// 展示
- (void)xyf_showInView:(UIView *)superView {
    CGRect rect = self.frame;
    rect.origin.y = kXYLScreenHeight - self.xyp_totalHeight;
    [superView addSubview:self.xyp_overyView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    }];
}

/// 消失
- (void)xyf_dismiss {
    CGRect rect = self.frame;
    rect.origin.y = kXYLScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.xyp_overyView removeFromSuperview];
    }];
}

#pragma mark - Delegate
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.xyp_datalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OWLBGMMedalListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OWLBGMMedalListCell class])];
    if (!cell) {
        cell = [[OWLBGMMedalListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([OWLBGMMedalListCell class])];
    }
    OWLMusicEventLabelModel *model = (OWLMusicEventLabelModel *)[self.xyp_datalist xyf_objectAtIndexSafe:indexPath.section];
    BOOL isselect = self.xyp_selectIndex == indexPath.section + 1;
    [cell xyf_setCellSelected:isselect];
    cell.xyp_model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.xyp_isJustShow) {
        return;
    }
    if (self.xyp_selectIndex == indexPath.section + 1) {
        self.xyp_selectIndex = 0;
        [self.xyp_tableView reloadData];
        [OWLMusicRequestApiManager xyf_requestSetDefaultLabel:@"" completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
            
        }];
        /// 更新标签
        [self xyf_giveCallBackUpdateLabel:[OWLMusicEventLabelModel new]];
        return;
    }
    /// 选择标签刷新页面
    OWLMusicEventLabelModel *model = (OWLMusicEventLabelModel *)[self.xyp_datalist xyf_objectAtIndexSafe:indexPath.section];
    self.xyp_selectIndex = indexPath.section + 1;
    [self.xyp_tableView reloadData];
    
    /// 小xy添加选择标签接口
    [OWLMusicRequestApiManager xyf_requestSetDefaultLabel:model.dsb_labelTitle completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        
    }];
    
    /// 更新标签
    [self xyf_giveCallBackUpdateLabel:model];
}

#pragma mark - Action
- (void)xyf_overyViewAction {
    [self xyf_dismiss];
}

#pragma mark - 给回调
- (void)xyf_giveCallBackUpdateLabel:(OWLMusicEventLabelModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewUpdateLabel:)]) {
        [self.delegate xyf_lModuleBaseViewUpdateLabel:model];
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

- (UITableView *)xyp_tableView {
    if (!_xyp_tableView) {
        _xyp_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _xyp_tableView.backgroundColor = [UIColor clearColor];
        _xyp_tableView.delegate = self;
        _xyp_tableView.dataSource = self;
        _xyp_tableView.showsVerticalScrollIndicator = NO;
        _xyp_tableView.showsHorizontalScrollIndicator = NO;
        _xyp_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, 4)];
        _xyp_tableView.tableHeaderView = headerView;
        CGFloat height = [XYCUtil xyf_isIPhoneX] ? 24 : 10;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, height)];
        _xyp_tableView.tableFooterView = footerView;
        _xyp_tableView.estimatedSectionFooterHeight = 0;
        _xyp_tableView.estimatedSectionHeaderHeight = 0;
        _xyp_tableView.estimatedRowHeight = 0;
        [_xyp_tableView registerClass:[OWLBGMMedalListCell class] forCellReuseIdentifier:NSStringFromClass([OWLBGMMedalListCell class])];
        if (@available(iOS 11.0, *)) {
            _xyp_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _xyp_tableView;
}

- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.text = kXYLLocalString(@"Medal list");
        _xyp_titleLabel.font = kXYLGilroyBoldFont(18);
        _xyp_titleLabel.textColor = kXYLColorFromRGB(0x080808);
        _xyp_titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_titleLabel;
}

- (UIView *)xyp_emptyView {
    if (!_xyp_emptyView) {
        _xyp_emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kXYLScreenWidth, 240)];
        UIImageView *iconIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:iconIV iconStr:@"xyr_tag_emptyimg"];
        [_xyp_emptyView addSubview:iconIV];
        [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_xyp_emptyView);
            make.top.equalTo(_xyp_emptyView).offset(52);
            make.width.height.mas_equalTo(106);
        }];
        UILabel *emptyLab = [[UILabel alloc] init];
        emptyLab.text = kXYLLocalString(@"Oops, you haven't got any medals for now~");
        emptyLab.textColor = kXYLColorFromRGB(0xB0B0B1);
        emptyLab.font = kXYLGilroyMediumFont(12);
        [_xyp_emptyView addSubview:emptyLab];
        [emptyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_xyp_emptyView);
            make.top.equalTo(iconIV.mas_bottom).offset(14.5);
        }];
    }
    return _xyp_emptyView;
}

@end
