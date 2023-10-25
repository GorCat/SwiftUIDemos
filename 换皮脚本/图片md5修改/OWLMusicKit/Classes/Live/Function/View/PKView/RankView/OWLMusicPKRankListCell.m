//// OWLMusicPKRankListCell.m
// qianDuoDuo
//
// 
//


#import "OWLMusicPKRankListCell.h"

@interface OWLMusicPKRankListCell()

/// 用户视图
@property (nonatomic, strong) OWLBGMPKRankListUserInfoView *xyp_userView;

@end

@implementation OWLMusicPKRankListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.xyp_userView];
    [self.xyp_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - Setter
- (void)setXyp_model:(OWLMusicPKTopUserModel *)xyp_model {
    _xyp_model = xyp_model;
    self.xyp_userView.xyp_model = xyp_model;
}

- (void)setXyp_rank:(NSInteger)xyp_rank {
    _xyp_rank = xyp_rank;
    self.xyp_userView.xyp_rank = xyp_rank;
}

- (void)setDelegate:(id<OWLBGMPKRankListUserInfoViewDelegate>)delegate {
    self.xyp_userView.delegate = delegate;
}

#pragma mark - Lazy
- (OWLBGMPKRankListUserInfoView *)xyp_userView {
    if (!_xyp_userView) {
        _xyp_userView = [[OWLBGMPKRankListUserInfoView alloc] initWithIsTopOne:NO];
    }
    return _xyp_userView;
}

@end
