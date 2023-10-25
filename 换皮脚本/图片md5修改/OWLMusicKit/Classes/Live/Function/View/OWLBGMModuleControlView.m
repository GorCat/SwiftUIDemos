//
//  OWLBGMModuleControlView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间控制层视图（跟着手势划走的）
 * @创建时间：2023.2.9
 * @创建人：许琰
 * @备注：【顶部房间信息+房间目标+聊天+底部操作栏】
 */

#import "OWLBGMModuleControlView.h"

#pragma mark - Views
#import "OWLBGMTopRoomInfoView.h"
#import "OWLMusicBottomView.h"
#import "OWLPPAddAlertTool.h"
#import "OWLMusicBottomChatPrivateView.h"
#import "OWLPPBanner.h"
#import "OWLPPGiftPublicityView.h"
//#import "OWLBGMModuleBottomDiscountView.h"
#import "OWLMusicRandomTabelContainerView.h"
#import "OWLMusicRandomTableTipView.h"
#import "OWLMusicRandomTableMsgModel.h"
#import "OWLMusicEntryEffectPAGView.h"
#import "OWLMusicBottomDiscountCircleView.h"

@interface OWLBGMModuleControlView() /// <OWLBGMModuleBottomDiscountViewDelegate>

#pragma mark - Views
/// 顶部房间信息视图
@property (nonatomic, strong) OWLBGMTopRoomInfoView *xyp_topInfoView;
/// 底部操作视图
@property (nonatomic, strong) OWLMusicBottomView *xyp_bottomView;
/// 弹幕容器
@property (nonatomic, strong) UIView *xyp_messageView;
/// 私聊视图
@property (nonatomic, strong) OWLMusicBottomChatPrivateView *xyp_chatView;
/// 折扣视图
@property (nonatomic, strong) OWLMusicBottomDiscountCircleView *xyp_discountView;
/// 折扣视图
//@property (nonatomic, strong) UIButton *xyp_discountButton;
/// 转盘按钮
@property (nonatomic, strong) UIButton *xyp_randomTableButton;
/// 转盘
@property (nonatomic, strong) OWLMusicRandomTabelContainerView *xyp_randomTableView;
/// PAG进场特效
@property (nonatomic, strong) OWLMusicEntryEffectPAGView *xyp_enterEffectView;

#pragma mark - BOOL
/// 是否显示私聊按钮
@property (nonatomic, assign) BOOL xyp_isShowPrivateChat;
/// 是否显示转盘
@property (nonatomic, assign) BOOL xyp_isShowRandomTable;

#pragma mark - Data
/// 模型
@property (nonatomic, strong) OWLMusicRoomTotalModel *xyp_model;

@end

@implementation OWLBGMModuleControlView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
        [self xyf_observeNotification:xyl_module_remove_banner];
        [self xyf_observeNotification:xyl_module_refresh_private_image];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_topInfoView];
    
    [self addSubview:self.xyp_randomTableButton];
    
    [self addSubview:self.xyp_bottomView];
    [self.xyp_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(self);
        make.height.mas_equalTo(kXYLBottomTotalHeight);
        make.trailing.equalTo(self).offset(-57);
    }];
    
    [self addSubview:self.xyp_messageView];
    [[OWLPPAddAlertTool shareInstance] xyf_addBarrageShowView:self.xyp_messageView];
    
    [self.xyp_messageView addSubview:self.xyp_chatView];
    [self.xyp_chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.xyp_messageView);
        make.width.mas_equalTo(101);
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self.xyp_messageView).offset(-8);
    }];
    
    if (!OWLJConvertToolShared.xyf_isGreen) {
        [[OWLPPAddAlertTool shareInstance] xyf_addSmallBannerToView:self.xyp_messageView];
        [self addSubview:self.xyp_discountView];
        UIView *banner = [OWLPPAddAlertTool shareInstance].xyp_banner;
        if ([OWLPPAddAlertTool shareInstance].xyp_banner) {
            [[OWLPPAddAlertTool shareInstance].xyp_banner mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.xyp_chatView.mas_top);
                make.size.mas_equalTo([OWLPPAddAlertTool shareInstance].xyp_banner.xyp_size);
                make.trailing.equalTo(self).offset(-12);
            }];
            
            [self.xyp_discountView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(66);
                make.height.mas_equalTo(80);
                make.trailing.equalTo(self.xyp_messageView).offset(-7);
                make.bottom.equalTo(banner.mas_top);
            }];
        } else {
            [self.xyp_discountView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(66);
                make.height.mas_equalTo(80);
                make.trailing.equalTo(self.xyp_messageView).offset(-7);
                make.bottom.equalTo(self.xyp_chatView.mas_top);
            }];
        }
//        /// 🙏🏻愿天堂没有标准屏
//        [self addSubview:self.xyp_discountButton];
//        [self.xyp_discountButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.xyp_discountView);
//        }];
    }
    
    [self addSubview:self.xyp_randomTableView];
    [self.xyp_randomTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.xyp_enterEffectView];
}

- (void)setDelegate:(id<OWLBGMModuleBaseViewDelegate>)delegate {
    self.xyp_topInfoView.delegate = delegate;
    self.xyp_bottomView.delegate = delegate;
    self.xyp_chatView.delegate = delegate;
    self.xyp_discountView.delegate = delegate;
}

#pragma mark - 处理事件
/// 处理事件(触发事件)
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject * __nullable)obj {
    [self.xyp_topInfoView xyf_dealWithEvent:type obj:obj];
    [self.xyp_bottomView xyf_dealWithEvent:type obj:obj];
    [self.xyp_discountView xyf_dealWithEvent:type obj:obj];
    [self.xyp_randomTableView xyf_dealWithEvent:type obj:obj];
    switch (type) {
        case XYLModuleEventType_UpdatePrivateChat:
            [self xyf_dealWithUpdatePrivateChat:obj];
            break;
        case XYLModuleEventType_UpdateRandomTable:
            [self xyf_dealWithUpdateRandomTable:obj];
            break;
        case XYLModuleEventType_UpdateRandomTableIsShow:
            [self xyf_dealWithUpdateRandomTableIsShow:obj];
            break;
        case XYLModuleEventType_ShowEnterPagEffect:
            [self xyf_dealWithShowEnterPagEffect:obj];
            break;
        case XYLModuleEventType_ClearAllData:
            [self xyf_dealWithClearAllData];
            break;
        default:
            break;
    }
}

- (void)xyf_dealWithUpdatePrivateChat:(NSObject * __nullable)obj {
    XYLModulePrivateChatStatusType openState = [(NSNumber *)obj integerValue];
    [self xyf_updatePrivateChat:openState == XYLModulePrivateChatStatusType_Open];
}

- (void)xyf_dealWithUpdateRandomTable:(NSObject * __nullable)obj {
    OWLMusicRandomTableMsgModel *model = (OWLMusicRandomTableMsgModel *)obj;
    BOOL isOpen = model.dsb_turnTableIsOpen == 1;
    self.xyp_randomTableView.hidden = isOpen ? self.xyp_randomTableView.hidden : YES;
    BOOL isShowButton = isOpen && [self xyf_isCanShowRandomTabel] && self.xyp_randomTableView.hidden;
    self.xyp_randomTableButton.hidden = !isShowButton;
}

- (void)xyf_dealWithUpdateRandomTableIsShow:(NSObject * __nullable)obj {
    BOOL isShow = [(NSNumber *)obj boolValue];
    if (isShow) {
        [self xyf_updateRandomTableButton:YES];
    } else {
        self.xyp_randomTableView.hidden = YES;
        self.xyp_randomTableButton.hidden = YES;
    }
}

- (void)xyf_dealWithShowEnterPagEffect:(NSObject * __nullable)obj {
    OWLMusicEntryEffectPushMsg *model = (OWLMusicEntryEffectPushMsg *)obj;
    [self.xyp_enterEffectView xyf_loadModel:model];
}

- (void)xyf_dealWithClearAllData {
    [self.xyp_enterEffectView xyf_clear];
}

#pragma mark - 更新
/// 更新房间信息
- (void)xyf_updateRoomData:(OWLMusicRoomTotalModel *)model {
    self.xyp_model = model;
    [self.xyp_topInfoView xyf_updateRoomData:model];
    [self.xyp_bottomView xyf_updateRoomData:model];
    [self xyf_updatePrivateChat:model.xyp_detailModel.xyf_isOpenPrivate];
    [self.xyp_randomTableView xyf_updateRoomData:model];
    [self xyf_updateRandomTableButton:model.xyp_detailModel.dsb_circlePanState == 1];
}

/// 更新观众列表
- (void)xyf_updateMemberList:(NSMutableArray *)memberList {
    self.xyp_topInfoView.xyp_audienceList = memberList;
}

/// 键盘弹起更新消息frame
- (void)xyf_updateFrameWhenKeyboardChanged:(CGFloat)bottomHeight changeType:(XYLModuleChangeInputViewHeightType)changeType {
    
    CGFloat messageBGViewY; /// 弹幕容器背景Y
    CGFloat messageBGViewH; /// 弹幕容器背景高
    CGFloat giftViewBottomMargin; /// 礼物弹幕和弹幕容器之间的间距
    CGFloat messageViewH; /// 弹幕的高度
    CGFloat messageBGMoveHeight; /// 弹幕移动的距离
    switch (changeType) {
        case XYLModuleChangeInputViewHeightType_Dismiss:
            messageBGViewY = kXYLMessageBGViewTopMargin;
            messageBGViewH = kXYLMessageBGViewHeight;
            giftViewBottomMargin = kXYLGiftMessageBottomMargin;
            messageViewH = kXYLMessageViewHeight;
            break;
        case XYLModuleChangeInputViewHeightType_Show:
            messageBGViewH = kXYLMessageBGViewInputShowHeight;
            messageBGViewY = bottomHeight - messageBGViewH;
            giftViewBottomMargin = 12;
            messageViewH = kXYLMessageViewInputShowHeight;
            break;
        case XYLModuleChangeInputViewHeightType_Input:
            messageBGViewH = kXYLMessageBGViewInputShowHeight;
            messageBGViewY = bottomHeight - messageBGViewH;
            giftViewBottomMargin = 12;
            messageViewH = kXYLMessageViewInputShowHeight;
            break;
    }

    messageBGMoveHeight = messageBGViewY - self.xyp_messageView.xyp_y;
    
    /// 修改顶部视图
    self.xyp_topInfoView.xyp_y = self.xyp_topInfoView.xyp_y + messageBGMoveHeight;
    /// 修改转盘视图
    self.xyp_randomTableButton.xyp_y = self.xyp_randomTableButton.xyp_y + messageBGMoveHeight;
    /// 修改容器视图
    self.xyp_messageView.frame = CGRectMake(0, messageBGViewY, kXYLScreenWidth, messageBGViewH);
    /// 修改礼物弹幕：弹幕容器背景的y - 间距 - 礼物高度
    [OWLPPAddAlertTool shareInstance].xyp_receiveGiftView.xyp_y = messageBGViewY - giftViewBottomMargin - kXYLGiftMessageHeight;
    /// 修改弹幕视图
    CGFloat barrageViewX = OWLJConvertToolShared.xyf_isRTL ? kXYLScreenWidth - kXYLMessageViewWidth : 0;
    [[OWLPPAddAlertTool shareInstance] xyf_refreshBarragePartFrame:CGRectMake(barrageViewX, 0, kXYLMessageViewWidth, messageViewH) andIsRefresh:changeType != XYLModuleChangeInputViewHeightType_Input];
    [self layoutIfNeeded];
}

/// 更新私聊按钮
- (void)xyf_updatePrivateChat:(BOOL)isShow {
    BOOL isShowPrivate = NO;
    if (OWLJConvertToolShared.xyf_isShowPrivateChat) {
        if (self.xyp_model.xyp_detailModel.dsb_isUGCRoom) {
            isShowPrivate = NO;
        } else {
            isShowPrivate = self.xyp_model.xyp_detailModel.xyf_isPKState ? NO : isShow;
        }
    }
    [self.xyp_chatView xyf_changeAnimate:isShowPrivate];
    if (self.xyp_isShowPrivateChat == isShowPrivate) { return; }
    self.xyp_isShowPrivateChat = isShowPrivate;
    CGFloat height = isShowPrivate ? 54 : 0;
    [self.xyp_chatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    kXYLWeakSelf
    [UIView animateWithDuration:0.15 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

/// 更新转盘按钮
- (void)xyf_updateRandomTableButton:(BOOL)isShow {
    BOOL isShowTable = isShow ? [self xyf_isCanShowRandomTabel] : NO;
    self.xyp_randomTableButton.hidden = !isShowTable;
}

#pragma mark - Action
- (void)xyf_clickRandomTableButton {
    [self.xyp_randomTableView xyf_showView];
    [self xyf_updateRandomTableButton:NO];
}

- (void)xyf_clickDiscountButton {
    if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(xyf_lModuleBaseViewClickEvent:)]) {
        [self.controlDelegate xyf_lModuleBaseViewClickEvent:XYLModuleBaseViewClickType_ClickDiscountButton];
    }
}

#pragma mark - 转盘相关
/// 是否可以显示转盘
- (BOOL)xyf_isCanShowRandomTabel {
    /// 如果外部配置支持显示 并且 不是绿号 并且 不在PK状态 并且 当前房间转盘为开启状态
    if (OWLJConvertToolShared.xyf_isShowRandomTable &&
        !OWLJConvertToolShared.xyf_isGreen &&
        !self.xyp_model.xyp_detailModel.xyf_isPKState &&
        self.xyp_model.xyp_detailModel.dsb_circlePanState == 1) {
        return YES;
    }
    return NO;
}

/// 控制列表是否能滑动
- (void)xyf_tableViewCanScroll:(BOOL)canScroll {
    [OWLMusicInsideManagerShared xyf_tableViewCanScroll:canScroll];
}

/// 显示转盘结果
- (void)xyf_showRandomTableResult:(NSString *)result {
    if (![self xyf_isCanShowRandomTabel]) { return; }
    OWLMusicRandomTableTipView *tipView = [[OWLMusicRandomTableTipView alloc] init];
    tipView.hidden = YES;
    [self addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-50);
        make.centerX.equalTo(self);
        make.height.mas_greaterThanOrEqualTo(68);
        make.width.mas_greaterThanOrEqualTo(169);
        make.width.mas_lessThanOrEqualTo(kXYLScreenWidth-30);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [tipView xyf_updateResult:[result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        tipView.hidden = NO;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            tipView.hidden = YES;
        }];
    });
}

//#pragma mark OWLBGMModuleBottomDiscountViewDelegate
//- (void)xyf_bottomDiscountViewIsHidden:(BOOL)isHidden {
//    self.xyp_discountButton.hidden = isHidden;
//}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_module_remove_banner]) {
        if (!OWLJConvertToolShared.xyf_isGreen) {
            [self.xyp_discountView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(66);
                make.height.mas_equalTo(80);
                make.trailing.equalTo(self.xyp_messageView).offset(-7);
                make.bottom.equalTo(self.xyp_chatView.mas_top);
            }];
        }
    } else if ([notification.name isEqualToString:xyl_module_refresh_private_image]) {
        [self.xyp_chatView xyf_changeAnimate:self.xyp_isShowPrivateChat];
    }
}

#pragma mark - Lazy
- (OWLBGMTopRoomInfoView *)xyp_topInfoView {
    if (!_xyp_topInfoView) {
        _xyp_topInfoView = [[OWLBGMTopRoomInfoView alloc] initWithFrame:CGRectMake(0, kXYLRoomInfoHeaderViewTopMargin, kXYLScreenWidth, kXYLRoomInfoHeaderViewHeight)];
    }
    return _xyp_topInfoView;
}

- (OWLMusicBottomView *)xyp_bottomView {
    if (!_xyp_bottomView) {
        _xyp_bottomView = [[OWLMusicBottomView alloc] init];
    }
    return _xyp_bottomView;
}

- (UIView *)xyp_messageView {
    if (!_xyp_messageView) {
        _xyp_messageView = [[UIView alloc] initWithFrame:CGRectMake(0, kXYLMessageBGViewTopMargin, kXYLScreenWidth, kXYLMessageBGViewHeight)];
    }
    return _xyp_messageView;
}

- (OWLMusicBottomChatPrivateView *)xyp_chatView {
    if (!_xyp_chatView) {
        _xyp_chatView = [[OWLMusicBottomChatPrivateView alloc] init];
    }
    return _xyp_chatView;
}

- (OWLMusicBottomDiscountCircleView *)xyp_discountView {
    if (!_xyp_discountView) {
        _xyp_discountView = [[OWLMusicBottomDiscountCircleView alloc] init];
//        _xyp_discountView.discountDelegate = self;
    }
    return _xyp_discountView;
}

//- (UIButton *)xyp_discountButton {
//    if (!_xyp_discountButton) {
//        _xyp_discountButton = [[UIButton alloc] init];
//        [_xyp_discountButton addTarget:self action:@selector(xyf_clickDiscountButton) forControlEvents:UIControlEventTouchUpInside];
//        _xyp_discountButton.hidden = YES;
//    }
//    return _xyp_discountButton;
//}

- (UIButton *)xyp_randomTableButton {
    if (!_xyp_randomTableButton) {
        CGFloat x = OWLJConvertToolShared.xyf_isRTL ? 10 : kXYLScreenWidth - kXYLRandomTableSmallWH - 10;
        _xyp_randomTableButton = [[UIButton alloc] initWithFrame:CGRectMake(x, kXYLRandomTableSmallY, kXYLRandomTableSmallWH, kXYLRandomTableSmallWH)];
        [_xyp_randomTableButton setBackgroundImage:[XYCUtil xyf_getIconWithName:@"xyr_random_table_small"] forState:UIControlStateNormal];
        [_xyp_randomTableButton addTarget:self action:@selector(xyf_clickRandomTableButton) forControlEvents:UIControlEventTouchUpInside];
        _xyp_randomTableButton.hidden = YES;
    }
    return _xyp_randomTableButton;
}

- (OWLMusicRandomTabelContainerView *)xyp_randomTableView {
    if (!_xyp_randomTableView) {
        _xyp_randomTableView = [[OWLMusicRandomTabelContainerView alloc] init];
        kXYLWeakSelf
        _xyp_randomTableView.xyp_hiddenBlock = ^{
            [weakSelf xyf_updateRandomTableButton:YES];
            [weakSelf xyf_tableViewCanScroll:YES];
        };
        
        _xyp_randomTableView.xyp_showResultBlock = ^(NSString * _Nullable stringValue) {
            [weakSelf xyf_showRandomTableResult:stringValue];
        };
    }
    return _xyp_randomTableView;
}

- (OWLMusicEntryEffectPAGView *)xyp_enterEffectView {
    if (!_xyp_enterEffectView) {
        _xyp_enterEffectView = [[OWLMusicEntryEffectPAGView alloc] initWithFrame:CGRectMake(0, kXYLMessageBGViewTopMargin - 5 - kXYLScreenWidth, kXYLScreenWidth, kXYLScreenWidth)];
    }
    return _xyp_enterEffectView;
}

@end
