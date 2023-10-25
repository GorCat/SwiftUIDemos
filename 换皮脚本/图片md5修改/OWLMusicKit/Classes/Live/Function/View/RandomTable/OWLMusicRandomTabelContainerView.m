//
//  OWLMusicRandomTabelContainerView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/25.
//

#import "OWLMusicRandomTabelContainerView.h"
#import "OWLMusicAutoScrollLabel.h"
#import "OWLMusicRandomTableView.h"
#import "OWLBGMModuleVC.h"
#import "OWLMusicRandomTableMsgModel.h"

@interface OWLMusicRandomTabelContainerView ()<CAAnimationDelegate>

@property (nonatomic, strong) UIButton *xyp_tapButton;

@property (nonatomic, strong) OWLMusicAutoScrollLabel *xyp_titleLabel;

@property (nonatomic, strong) UIView *xyp_mainView;

@property (nonatomic, strong) UIButton *xyp_mainBGButton;

@property (nonatomic, strong) UIButton *xyp_startBtn;

@property (nonatomic, strong) UIImageView *xyp_bannerBgView;

@property (nonatomic, strong) OWLMusicRandomTableView *xyp_circleView;

@property (nonatomic, assign) NSInteger xyp_selectedIndex;

@property (nonatomic, assign) BOOL xyp_isAnimation;

@property (nonatomic, strong) NSMutableArray *xyp_luckyItemArray;

@property (nonatomic, strong) OWLMusicRandomTableViewModel *xyp_curItem;

@property (nonatomic, strong) CABasicAnimation *xyp_rotationAnimation;

@end

@implementation OWLMusicRandomTabelContainerView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_observeNotification:xyl_live_clear_room_info];
        [self xyf_setupView];
        
        self.hidden = YES;
        
        self.xyp_isAnimation = NO;
        
        [self xyf_updateDataArray];
        
        //这里裁剪主要是为了防止误点到了四角空白
        self.xyp_mainView.layer.cornerRadius = (kXYLScreenWidth-30*2)/2;
        self.xyp_mainView.layer.masksToBounds = YES;
        
        [self.xyp_mainView addSubview:self.xyp_circleView];
        
        [self.xyp_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.xyp_mainView).offset(-10);
            make.leading.equalTo(self.xyp_mainView).offset(-10);
            make.bottom.equalTo(self.xyp_mainView).offset(10);
            make.trailing.equalTo(self.xyp_mainView).offset(10);
        }];
        
        [self.xyp_circleView.layer addAnimation:self.xyp_rotationAnimation forKey:@"autoRotationAnimation"];
        
        [self.xyp_mainView bringSubviewToFront:self.xyp_startBtn];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    
    [self addSubview:self.xyp_tapButton];
    [self.xyp_tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self addSubview:self.xyp_mainView];
    [self.xyp_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kXYLScreenWidth - 30*2);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-15);
    }];
    
    [self.xyp_mainView addSubview:self.xyp_mainBGButton];
    [self.xyp_mainBGButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.xyp_mainView);
    }];
    
    [self.xyp_mainView addSubview:self.xyp_startBtn];
    [self.xyp_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.xyp_mainView);
        make.width.mas_equalTo(66);
        make.height.mas_equalTo(76);
    }];
    
    [self addSubview:self.xyp_bannerBgView];
    [self.xyp_bannerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.xyp_mainView.mas_top).offset(-10);
    }];
    
    [self.xyp_bannerBgView addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.xyp_bannerBgView);
    }];
}

#pragma mark - 事件处理
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject *)obj {
    switch (type) {
        case XYLModuleEventType_UpdateRandomTable:
            [self xyf_dealEventUpdateRandomTable:obj];
            break;
        default:
            break;
    }
}

- (void)xyf_dealEventUpdateRandomTable:(NSObject *)obj {
    OWLMusicRandomTableMsgModel *model = (OWLMusicRandomTableMsgModel *)obj;
    [self xyf_updateDataArray];
    
    /// 移除之前绘制的layer信息
    [self xyf_removeCircleViewSubLayer];
    
    /// 更新转盘信息
    self.xyp_circleView.xyp_panBgColors = [self xyf_getColorsWithItems:self.xyp_luckyItemArray];
    
    self.xyp_circleView.xyp_luckyItemArray = self.xyp_luckyItemArray;
    
    /// -1表示修改title或者转盘开关状态更改
    if (model.dsb_selectedIndex != -1) {
        self.xyp_selectedIndex = model.dsb_selectedIndex;
        [self xyf_startAction];
    }
}

#pragma mark - Update
/// 更新数组
- (void)xyf_updateDataArray {
    OWLMusicRoomDetailModel *model = OWLMusicInsideManagerShared.xyp_vc.xyp_currentTotalModel.xyp_detailModel;
    self.xyp_titleLabel.text = model.dsb_circlePanTitle;
    self.xyp_luckyItemArray = [NSMutableArray array];
    
    NSArray * items = model.dsb_circlePanItems;
    for (int i = 0; i < items.count ; i++) {
        OWLMusicRandomTableViewModel *model = [[OWLMusicRandomTableViewModel alloc] init];
        if (items.count > i) {
            NSString * name = items[i];
            model.xyp_remark = name;
            model.xyp_index = i;
            model.xyp_displayIndex = i;
            model.xyp_imageName = nil;
            [self.xyp_luckyItemArray addObject:model];
        }
    }
    [self.xyp_luckyItemArray sortUsingComparator:^NSComparisonResult(OWLMusicRandomTableViewModel *  _Nonnull obj1, OWLMusicRandomTableViewModel * _Nonnull obj2) {
        return obj1.xyp_displayIndex > obj2.xyp_displayIndex;
    }];
}

/// 更新房间信息
- (void)xyf_updateRoomData:(OWLMusicRoomTotalModel *)model {
    [self xyf_removeCircleViewSubLayer];
    [self xyf_updateDataArray];
    self.xyp_circleView.xyp_panBgColors = [self xyf_getColorsWithItems:self.xyp_luckyItemArray];
    self.xyp_circleView.xyp_luckyItemArray = self.xyp_luckyItemArray;
}

/// 移除转盘上的子layer
- (void)xyf_removeCircleViewSubLayer {
    while (self.xyp_circleView.layer.sublayers.count) {
        [self.xyp_circleView.layer.sublayers.lastObject removeFromSuperlayer];
    }
}

#pragma mark - 动画
- (void)xyf_showView {
    self.hidden = NO;
    if (self.xyp_isAnimation) return;
    self.xyp_isShowing = YES;
    [self.xyp_circleView.layer addAnimation:self.xyp_rotationAnimation forKey:@"autoRotationAnimation"];
}

- (void)xyf_hiddenView {
    self.hidden = YES;
    self.xyp_isShowing = NO;
    [self.xyp_circleView.layer removeAllAnimations];
}

- (void)xyf_startAction {
    
    [self.xyp_circleView.layer removeAllAnimations];
    
    if (self.xyp_isAnimation) { return; }
    
    self.xyp_isAnimation = YES;
    
    self.xyp_curItem = [self xyf_getItemByIndex:self.xyp_selectedIndex];
    
    if (self.xyp_curItem) {
        OWLMusicRandomTableViewModel *item = [self xyf_getItemByIndex:self.xyp_curItem.xyp_index];
        if (item) {
            [self.xyp_circleView xyf_ramdomTabelToDisplayIndex:item.xyp_displayIndex];
        }
    }
}

#pragma mark - Action
- (void)xyf_clickTapAction {
    self.xyp_hiddenBlock();
    self.xyp_isShowing = NO;
    self.hidden = YES;
}

- (void)xyf_clickMainBGAction {
    
}

#pragma mark - Getter
- (NSArray *)xyf_getColorsWithItems:(NSArray *)items {
    if (items.count%2 == 0) {
        return @[kXYLColorFromRGBA(0xffffff,1),kXYLColorFromRGBA(0xffffff, 0.9)];
    } else {
        if (items.count == 3) {
            return @[kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9),kXYLColorFromRGBA(0xffffff, 0.8)];
        } else if (items.count == 5) {
            return @[kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9),kXYLColorFromRGBA(0xffffff, 0.8),kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9)];
        } else if (items.count == 7) {
            return @[kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9),kXYLColorFromRGBA(0xffffff, 0.8),kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9),kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.8)];
        } else if (items.count == 9){
            return @[kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9),kXYLColorFromRGBA(0xffffff, 0.8),kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9),kXYLColorFromRGBA(0xffffff, 0.8),kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9),kXYLColorFromRGBA(0xffffff, 0.8)];
        } else if(items.count == 11) {
            return @[kXYLColorFromRGBA(0xffffff,1),kXYLColorFromRGBA(0xffffff, 0.9),kXYLColorFromRGBA(0xffffff, 0.8),kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9),kXYLColorFromRGBA(0xffffff, 0.8),kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9),kXYLColorFromRGBA(0xffffff, 0.8),kXYLColorFromRGBA(0xffffff, 1),kXYLColorFromRGBA(0xffffff, 0.9)];
            
        } else {
            return nil;
        }
    }
}

- (OWLMusicRandomTableViewModel *)xyf_getItemByIndex:(NSInteger)index {
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"SELF.xyp_index == %d",index];
    NSArray * result = [self.xyp_luckyItemArray filteredArrayUsingPredicate:pre];
    OWLMusicRandomTableViewModel * item = result.firstObject;
    return item;
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_live_clear_room_info]) {
        [self xyf_hiddenView];
    }
}

#pragma mark - Lazy
- (UIButton *)xyp_tapButton {
    if (!_xyp_tapButton) {
        _xyp_tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xyp_tapButton addTarget:self action:@selector(xyf_clickTapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_tapButton;
}

- (UIView *)xyp_mainView {
    if (!_xyp_mainView) {
        _xyp_mainView = [[UIView alloc] init];
    }
    return _xyp_mainView;
}

- (UIButton *)xyp_mainBGButton {
    if (!_xyp_mainBGButton) {
        _xyp_mainBGButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xyp_mainBGButton addTarget:self action:@selector(xyf_clickMainBGAction) forControlEvents:UIControlEventTouchUpInside];
        [_xyp_mainBGButton setBackgroundImage:[XYCUtil xyf_getIconWithName:@"xyr_random_table_bg"] forState:UIControlStateNormal];
    }
    return _xyp_mainBGButton;
}

- (UIButton *)xyp_startBtn {
    if (!_xyp_startBtn) {
        _xyp_startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xyp_startBtn setImage:[XYCUtil xyf_getIconWithName:@"xyr_random_table_start"] forState:UIControlStateNormal];
    }
    return _xyp_startBtn;
}

- (UIImageView *)xyp_bannerBgView {
    if (!_xyp_bannerBgView) {
        _xyp_bannerBgView = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_bannerBgView iconStr:@"xyr_random_table_remindView_bg"];
        _xyp_bannerBgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xyp_bannerBgView;
}

- (OWLMusicAutoScrollLabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [OWLMusicAutoScrollLabel new];
        _xyp_titleLabel.layer.masksToBounds = YES;
        _xyp_titleLabel.layer.cornerRadius = 4;
        _xyp_titleLabel.textColor = UIColor.whiteColor;
        _xyp_titleLabel.backgroundColor = [UIColor clearColor];
        _xyp_titleLabel.font = kXYLGilroyBoldFont(14);//字体大小
        _xyp_titleLabel.labelSpacing = 40; // 开始和结束标签之间的距离
        _xyp_titleLabel.pauseInterval = 1.0; // 一秒的停顿之后再开始滚动
        _xyp_titleLabel.scrollSpeed = 30; // 每秒像素
        _xyp_titleLabel.textAlignment = NSTextAlignmentCenter; // 不使用自动滚动时的中心文本
        _xyp_titleLabel.fadeLength = 12.f;
        _xyp_titleLabel.scrollDirection = AutoScrollDirectionLeft;
        
        [_xyp_titleLabel observeApplicationNotifications];
    }
    return _xyp_titleLabel;
}

- (CABasicAnimation *)xyp_rotationAnimation {
    if (!_xyp_rotationAnimation) {
        _xyp_rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _xyp_rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
        _xyp_rotationAnimation.duration = 25;
        _xyp_rotationAnimation.delegate = self;
        _xyp_rotationAnimation.repeatCount = MAXFLOAT;
    }
    return _xyp_rotationAnimation;
}

- (OWLMusicRandomTableView *)xyp_circleView {
    if (!_xyp_circleView) {
        _xyp_circleView = [[OWLMusicRandomTableView alloc] init];
        NSDictionary *attributes = @{
            NSForegroundColorAttributeName:UIColor.whiteColor,
            NSFontAttributeName:[UIFont boldSystemFontOfSize:10]
        };
        CGFloat scale = [UIScreen mainScreen].scale;
        if (scale == 2) {
            _xyp_circleView.xyp_circleWidth = 27.f;
        }else{
            _xyp_circleView.xyp_circleWidth = 31.f;
        }
        _xyp_circleView.xyp_imageSize = CGSizeMake(35, 35);
        
        _xyp_circleView.xyp_attributes = attributes;
        _xyp_circleView.xyp_panBgColors = [self xyf_getColorsWithItems:self.xyp_luckyItemArray];
        kXYLWeakSelf;
        [_xyp_circleView setLunckyAnimationDidStopBlock:^(BOOL flag, OWLMusicRandomTableViewModel *item) {
            weakSelf.xyp_isAnimation = NO;
            //假如父级view已经被销毁了则不用显示结果
            if(weakSelf.superview != nil) {
                weakSelf.xyp_showResultBlock(item.xyp_remark);
            }
        }];
        _xyp_circleView.xyp_luckyItemArray = self.xyp_luckyItemArray;
    }
    return _xyp_circleView;
}

@end
