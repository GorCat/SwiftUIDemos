//// OWLBGMAudienceAlertView.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间观众列表弹窗
 * @创建时间：2023.2.11
 * @创建人：许琰
 */

#import "OWLBGMAudienceAlertView.h"
#import "OWLBGMAudienceAlertCell.h"

@interface OWLBGMAudienceAlertView() <UITableViewDelegate, UITableViewDataSource>

#pragma mark - Views
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;
/// 灰色背景
@property (nonatomic, strong) UIView *xyp_grayView;
/// 用户
@property (nonatomic, strong) UILabel *xyp_userLabel;
/// 金币
@property (nonatomic, strong) UILabel *xyp_coinsLabel;
/// 列表
@property (nonatomic, strong) UITableView *xyp_tableView;
/// 展示提示
@property (nonatomic, strong) UILabel *xyp_showTipLabel;

#pragma mark - Layout
/// 列表底部间距
@property (nonatomic, assign) CGFloat xyp_listBottomMargin;
/// 总高度
@property (nonatomic, assign) CGFloat xyp_totalHeight;

#pragma mark - Block
/// 弹窗消失的回调
@property (nonatomic, copy, nullable) XYLVoidBlock xyp_dismissBlock;

@end

@implementation OWLBGMAudienceAlertView

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
    self.xyp_listBottomMargin = [XYCUtil xyf_isIPhoneX] ? 26 + 15 : 26;
    self.xyp_totalHeight = kXYLScreenHeight * 0.6;
    self.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.xyp_totalHeight);
}

- (void)xyf_setupView {
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.xyp_grayView];
    [self.xyp_grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_titleLabel.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.mas_equalTo(24.5);
    }];
    
    [self.xyp_grayView addSubview:self.xyp_userLabel];
    [self.xyp_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_grayView);
        make.leading.equalTo(self.xyp_grayView).offset(16);
    }];
    
    [self.xyp_grayView addSubview:self.xyp_coinsLabel];
    [self.xyp_coinsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_grayView);
        make.trailing.equalTo(self.xyp_grayView).offset(-16);
    }];
    
    [self addSubview:self.xyp_tableView];
    [self.xyp_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.xyp_grayView.mas_bottom);
        make.bottom.equalTo(self).offset(-self.xyp_listBottomMargin);
    }];
    
    [self addSubview:self.xyp_showTipLabel];
    [self.xyp_showTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(26);
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.xyp_tableView.mas_bottom);
    }];
}

#pragma mark - Setter
- (void)setXyp_dataList:(NSMutableArray *)xyp_dataList {
    _xyp_dataList = xyp_dataList;
    [self.xyp_tableView reloadData];
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
        !self.xyp_dismissBlock?:self.xyp_dismissBlock();
        [self removeFromSuperview];
        [self.xyp_overyView removeFromSuperview];
    }];
}

#pragma mark - Delegate
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xyp_dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OWLMusicMemberModel *model = (OWLMusicMemberModel *)[self.xyp_dataList xyf_objectAtIndexSafe:indexPath.row];
    
    OWLBGMAudienceAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OWLBGMAudienceAlertCell class])];
    if (!cell) {
        cell = [[OWLBGMAudienceAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([OWLBGMAudienceAlertCell class])];
    }
    cell.xyp_model = model;
    cell.xyp_index = indexPath.row + 1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OWLMusicMemberModel *model = (OWLMusicMemberModel *)[self.xyp_dataList xyf_objectAtIndexSafe:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickInfoEvent:accountID:avatar:nickname:displayAccountID:isAnchor:)]) {
        [self.delegate xyf_lModuleBaseViewClickInfoEvent:XYLModuleBaseViewInfoClickType_ShowUserDetailView accountID:model.xyp_accountId avatar:@"" nickname:@"" displayAccountID:@"" isAnchor:model.xyp_roleType == XYLModuleMemberType_Anchor];
    }
}

#pragma mark - Action
- (void)xyf_overyViewAction {
    [self xyf_dismiss];
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
        _xyp_titleLabel.text = kXYLLocalString(@"Viewers");
        _xyp_titleLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_titleLabel.textColor = kXYLColorFromRGB(0x080808);
        _xyp_titleLabel.font = kXYLGilroyBoldFont(16);
    }
    return _xyp_titleLabel;
}

- (UIView *)xyp_grayView {
    if (!_xyp_grayView) {
        _xyp_grayView = [[UIView alloc] init];
        _xyp_grayView.backgroundColor = kXYLColorFromRGB(0xF3F4F7);
    }
    return _xyp_grayView;
}

- (UILabel *)xyp_userLabel {
    if (!_xyp_userLabel) {
        _xyp_userLabel = [[UILabel alloc] init];
        _xyp_userLabel.text = kXYLLocalString(@"Users");
        _xyp_userLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_userLabel.textColor = kXYLColorFromRGB(0xB2B5B8);
        _xyp_userLabel.font = kXYLGilroyBoldFont(12);
    }
    return _xyp_userLabel;
}

- (UILabel *)xyp_coinsLabel {
    if (!_xyp_coinsLabel) {
        _xyp_coinsLabel = [[UILabel alloc] init];
        _xyp_coinsLabel.text = kXYLLocalString(@"Send coins");
        _xyp_coinsLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_coinsLabel.textColor = kXYLColorFromRGB(0xB2B5B8);
        _xyp_coinsLabel.font = kXYLGilroyBoldFont(12);
    }
    return _xyp_coinsLabel;
}

- (UITableView *)xyp_tableView {
    if (!_xyp_tableView) {
        _xyp_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _xyp_tableView.backgroundColor = [UIColor clearColor];
        _xyp_tableView.delegate = self;
        _xyp_tableView.dataSource = self;
        _xyp_tableView.showsVerticalScrollIndicator = NO;
        _xyp_tableView.showsHorizontalScrollIndicator = NO;
        _xyp_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _xyp_tableView.estimatedSectionFooterHeight = 0;
        _xyp_tableView.estimatedSectionHeaderHeight = 0;
        _xyp_tableView.estimatedRowHeight = 0;
        _xyp_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_xyp_tableView registerClass:[OWLBGMAudienceAlertCell class] forCellReuseIdentifier:NSStringFromClass([OWLBGMAudienceAlertCell class])];
        if (@available(iOS 11.0, *)) {
            _xyp_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _xyp_tableView;
}

- (UILabel *)xyp_showTipLabel {
    if (!_xyp_showTipLabel) {
        _xyp_showTipLabel = [[UILabel alloc] init];
        _xyp_showTipLabel.text = kXYLLocalString(@"Only show the top 100 viewers");
        _xyp_showTipLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_showTipLabel.textColor = kXYLColorFromRGB(0xB2B5B8);
        _xyp_showTipLabel.font = kXYLGilroyBoldFont(10);
    }
    return _xyp_showTipLabel;
}

@end
