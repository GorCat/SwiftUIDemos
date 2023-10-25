//
//  OWLBGMPKTopThreeSeatAvatarView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层 - 前三名座位 - 单个头像
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLBGMPKTopThreeSeatAvatarView.h"

@interface OWLBGMPKTopThreeSeatAvatarView()

/// 座位背景
@property (nonatomic, strong) UIImageView *xyp_seatIV;
/// 头像
@property (nonatomic, strong) UIImageView *xyp_avatarIV;
/// 数字
@property (nonatomic, strong) UIImageView *xyp_numIV;

@end

@implementation OWLBGMPKTopThreeSeatAvatarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_seatIV];
    [self.xyp_seatIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.xyp_avatarIV];
    [self.xyp_avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.width.mas_equalTo(23);
    }];
    
    [self addSubview:self.xyp_numIV];
    [self.xyp_numIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.equalTo(self);
        make.height.width.mas_equalTo(9);
    }];
}

#pragma mark - Update
- (void)xyf_updateSeatNum:(NSInteger)num isOther:(BOOL)isOther {
    NSString *colorStr = isOther ? @"blue" : @"red";
    NSString *numIcon = [NSString stringWithFormat:@"xyr_pk_rank_seat_%ld_%@_icon",(long)num,colorStr];
    [XYCUtil xyf_loadIconImage:self.xyp_numIV iconStr:numIcon];
    
    NSString *seatIcon = [NSString stringWithFormat:@"xyr_pk_rank_seat_%@_icon",colorStr];
    [XYCUtil xyf_loadIconImage:self.xyp_seatIV iconStr:seatIcon];
}

#pragma mark - Setter
- (void)setXyp_avatar:(NSString *)xyp_avatar {
    _xyp_avatar = xyp_avatar;
    if (xyp_avatar == nil) {
        self.xyp_avatarIV.image = nil;
    } else {
        [XYCUtil xyf_loadSmallImage:self.xyp_avatarIV url:xyp_avatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_seatIV {
    if (!_xyp_seatIV) {
        _xyp_seatIV = [[UIImageView alloc] init];
    }
    return _xyp_seatIV;
}

- (UIImageView *)xyp_avatarIV {
    if (!_xyp_avatarIV) {
        _xyp_avatarIV = [[UIImageView alloc] init];
        _xyp_avatarIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_avatarIV.clipsToBounds = YES;
        _xyp_avatarIV.layer.cornerRadius = 11.5;
    }
    return _xyp_avatarIV;
}

- (UIImageView *)xyp_numIV {
    if (!_xyp_numIV) {
        _xyp_numIV = [[UIImageView alloc] init];
        _xyp_numIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_numIV.clipsToBounds = YES;
    }
    return _xyp_numIV;
}

@end
