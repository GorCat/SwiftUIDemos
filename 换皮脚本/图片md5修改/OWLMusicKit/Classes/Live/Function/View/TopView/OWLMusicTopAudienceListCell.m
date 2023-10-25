//
//  OWLMusicTopAudienceListCell.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间顶部视图观众列表头像cell
 * @创建时间：2023.2.9
 * @创建人：许琰
 */

#import "OWLMusicTopAudienceListCell.h"

@interface OWLMusicTopAudienceListCell ()

@property (nonatomic, strong) UIImageView *xyp_avatarIV;

@end

@implementation OWLMusicTopAudienceListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.xyp_avatarIV];
    [self.xyp_avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(30);
        make.center.equalTo(self.contentView);
    }];
}

#pragma mark - Setter
- (void)setModel:(OWLMusicMemberModel *)model {
    _model = model;
    [XYCUtil xyf_loadSmallImage:self.xyp_avatarIV url:model.xyp_avatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
}

#pragma mark - Actions
- (void)xyf_avatarAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_topAudienceListCellClickUser:)]) {
        [self.delegate xyf_topAudienceListCellClickUser:self.model];
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_avatarIV {
    if (!_xyp_avatarIV) {
        _xyp_avatarIV = [[UIImageView alloc] init];
        _xyp_avatarIV.clipsToBounds = YES;
        _xyp_avatarIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_avatarIV.layer.cornerRadius = 15;
        _xyp_avatarIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_avatarAction)];
        [_xyp_avatarIV addGestureRecognizer:tap];
    }
    return _xyp_avatarIV;
}

@end
