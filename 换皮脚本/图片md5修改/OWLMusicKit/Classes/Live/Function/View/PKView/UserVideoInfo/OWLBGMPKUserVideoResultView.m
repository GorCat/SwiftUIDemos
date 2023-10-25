//
//  OWLBGMPKUserVideoResultView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层 - 用户pk信息视图 - pk结果视图
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLBGMPKUserVideoResultView.h"
@interface OWLBGMPKUserVideoResultView()

/// 自己主播结果
@property (nonatomic, strong) UIImageView *xyp_myResultIV;
/// 对方主播结果
@property (nonatomic, strong) UIImageView *xyp_otherResultIV;

@end

@implementation OWLBGMPKUserVideoResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_myResultIV];
    [self addSubview:self.xyp_otherResultIV];
}

#pragma mark - 事件处理
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject *)obj {
    switch (type) {
        case XYLModuleEventType_PKTimeEnd:
            [self xyf_dealPKTimeUp:obj];
            break;
        case XYLModuleEventType_PKMatchSuccess:
            [self xyf_dealPKMatchSuccess];
            break;
        default:
            break;
    }
}

- (void)xyf_dealPKTimeUp:(NSObject *)obj {
    OWLMusicRoomPKDataModel *xyp_pkDataModel = (OWLMusicRoomPKDataModel *)obj;
    NSInteger mineAnchorID = xyp_pkDataModel.dsb_ownerPlayer.dsb_accountID;
    NSInteger winAnchorID = xyp_pkDataModel.dsb_winAnchorData.dsb_accountID;
    if (mineAnchorID == winAnchorID) { /// 自己主播赢
        [XYCUtil xyf_loadIconImage:self.xyp_myResultIV iconStr:@"xyr_pk_result_win_image"];
        [XYCUtil xyf_loadIconImage:self.xyp_otherResultIV iconStr:@"xyr_pk_result_lose_image"];
    } else if (winAnchorID == 0) { /// 平局
        [XYCUtil xyf_loadIconImage:self.xyp_myResultIV iconStr:@"xyr_pk_result_draw_image"];
        [XYCUtil xyf_loadIconImage:self.xyp_otherResultIV iconStr:@"xyr_pk_result_draw_image"];
    } else { /// 对方主播赢
        [XYCUtil xyf_loadIconImage:self.xyp_myResultIV iconStr:@"xyr_pk_result_lose_image"];
        [XYCUtil xyf_loadIconImage:self.xyp_otherResultIV iconStr:@"xyr_pk_result_win_image"];
    }
    
    self.xyp_myResultIV.hidden = NO;
    self.xyp_otherResultIV.hidden = NO;
}

- (void)xyf_dealPKMatchSuccess {
    self.xyp_myResultIV.hidden = YES;
    self.xyp_otherResultIV.hidden = YES;
}

#pragma mark - Getter
- (CGRect)xyf_resultViewFrame {
    CGFloat width = 132;
    CGFloat height = 45;
    CGFloat x = (kXYLScreenWidth - width) / 2.0;
    return CGRectMake(x, 5, width, height);
}

#pragma mark - Lazy
- (UIImageView *)xyp_myResultIV {
    if (!_xyp_myResultIV) {
        _xyp_myResultIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 56, 45)];
        _xyp_myResultIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_myResultIV.clipsToBounds = YES;
        _xyp_myResultIV.hidden = YES;
    }
    return _xyp_myResultIV;
}

- (UIImageView *)xyp_otherResultIV {
    if (!_xyp_otherResultIV) {
        _xyp_otherResultIV = [[UIImageView alloc] initWithFrame:CGRectMake(76, 0, 56, 45)];
        _xyp_otherResultIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_otherResultIV.clipsToBounds = YES;
        _xyp_otherResultIV.hidden = YES;
    }
    return _xyp_otherResultIV;
}

@end
