//// OWLMusicGameItemCell.m
// XYYCuteKit
//
// 
//

#import "OWLMusicGameItemCell.h"

@interface OWLMusicGameItemCell ()

@property (nonatomic, strong) UIImageView *xyp_gameIV;

@property (nonatomic, strong) UIActivityIndicatorView *xyp_activityView;

@property (nonatomic, strong) UIView *xyp_loadingView;

@end

@implementation OWLMusicGameItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    self.contentView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.xyp_gameIV];
    [self.xyp_gameIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.xyp_loadingView];
    [self.xyp_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.xyp_loadingView addSubview:self.xyp_activityView];
    [self.xyp_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.xyp_loadingView);
    }];
}

#pragma mark - Setter
- (void)setXyp_model:(OWLMusicGameConfigModel *)xyp_model {
    _xyp_model = xyp_model;
    [XYCUtil xyf_loadOriginImage:self.xyp_gameIV url:xyp_model.dsb_picture placeholder:nil];
}

- (void)setXyp_isShowActivity:(BOOL)xyp_isShowActivity {
    _xyp_isShowActivity = xyp_isShowActivity;
    if (xyp_isShowActivity) {
        self.xyp_loadingView.hidden = NO;
        [self.xyp_activityView startAnimating];
    } else {
        self.xyp_loadingView.hidden = YES;
        [self.xyp_activityView stopAnimating];
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_gameIV {
    if(!_xyp_gameIV){
        _xyp_gameIV = [[UIImageView alloc] init];
        _xyp_gameIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xyp_gameIV;
}

- (UIActivityIndicatorView *)xyp_activityView {
    if (!_xyp_activityView) {
        _xyp_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _xyp_activityView;
}

- (UIView *)xyp_loadingView {
    if (!_xyp_loadingView) {
        _xyp_loadingView = [[UIView alloc]init];
        _xyp_loadingView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.5);
        _xyp_loadingView.layer.cornerRadius = 10;
        _xyp_loadingView.clipsToBounds = YES;
        _xyp_loadingView.hidden = YES;
    }
    return _xyp_loadingView;
}

@end
