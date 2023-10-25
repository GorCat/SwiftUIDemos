//
//  OWLPPOpenBannerView.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/24.
//

#import "OWLPPOpenBannerView.h"
#import "OWLPPOpenBannerCell.h"

@interface OWLPPOpenBannerView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView * xyp_contentView;

@property (nonatomic, strong) UITableView * xyp_listTableView;

@property (nonatomic, strong) NSArray * xyp_dataArray;

@end

@implementation OWLPPOpenBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self xyf_setupUI];
    }
    return self;
}

- (UITableView *)xyp_listTableView {
    if (!_xyp_listTableView) {
        _xyp_listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _xyp_listTableView.backgroundColor = UIColor.clearColor;
        _xyp_listTableView.delegate = self;
        _xyp_listTableView.dataSource = self;
        _xyp_listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _xyp_listTableView.rowHeight = 97;
        _xyp_listTableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _xyp_listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _xyp_listTableView;
}

#pragma mark - UI
- (void) xyf_setupUI {
    self.backgroundColor = UIColor.clearColor;
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = UIColor.clearColor;
    [closeBtn addTarget:self action:@selector(xyf_dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    CGRect contentViewFrame = OWLJConvertToolShared.xyf_isRTL ? CGRectMake(-100, 0, 100, kXYLScreenHeight) : CGRectMake(kXYLScreenWidth, 0, 100, kXYLScreenHeight);
    self.xyp_contentView = [[UIView alloc] initWithFrame:contentViewFrame];
    self.xyp_contentView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.5);
    [self addSubview:self.xyp_contentView];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = self.xyp_contentView.bounds;
    [self.xyp_contentView addSubview:visualView];

    UILabel *moreLab = [[UILabel alloc] init];
    moreLab.text = kXYLLocalString(@"More Events");
    moreLab.textColor = UIColor.whiteColor;
    moreLab.font = kXYLGilroyBoldFont(12);
    [self.xyp_contentView addSubview:moreLab];
    [moreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_contentView);
        make.top.equalTo(self.xyp_contentView).offset(kXYLStatusBarHeight + 7);
    }];
    [self.xyp_contentView addSubview:self.xyp_listTableView];
    CGFloat contentY = kXYLStatusBarHeight + 29;
    [self.xyp_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_contentView).offset(contentY);
        make.trailing.leading.bottom.equalTo(self.xyp_contentView);
    }];
}

#pragma mark - 填充数据
- (void)xyf_configListData:(NSArray *)array {
    self.xyp_dataArray = array;
    [self.xyp_listTableView reloadData];
}

#pragma mark - 显示
- (void)xyf_showOpenView {
    [UIView animateWithDuration:0.3 animations:^{
        self.xyp_contentView.xyp_x = OWLJConvertToolShared.xyf_isRTL ? 0 : kXYLScreenWidth - 100;
    }];
}

#pragma mark - 消失
- (void)xyf_dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.xyp_contentView.xyp_x = OWLJConvertToolShared.xyf_isRTL ? -100 : kXYLScreenWidth;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - tableview datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.xyp_dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OWLPPOpenBannerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OWLMusicOpenBannerCell"];
    if (!cell) {
        cell = [[OWLPPOpenBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OWLMusicOpenBannerCell"];
    }
    if (self.xyp_dataArray.count > indexPath.row) {
        [cell xyf_configDataWith:self.xyp_dataArray[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kXYLIPhoneBottomHeight + 8;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - tableview delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.xyp_bannerDetail) {
        self.xyp_bannerDetail(indexPath.row);
    }
}

@end
