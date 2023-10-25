//
//  OWLBGMModuleMainView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

/**
 * @功能描述：直播间主页面
 * @创建时间：2023.2.10
 * @创建人：许琰
 * @备注：没有必要在每个cell中都创建这么多元素。所以采用 一个VC持有一个主页面的方案，在滑动的时候添加移除，在请求到数据之后更新【滑动+控制层+关闭按钮等ui】
 */

#import "OWLBGMModuleMainView.h"
#import "OWLBGMModuleControlView.h"
#import "OWLBGMPKControlView.h"
#import "UIImage+GIF.h"
#import "OWLMusciCompressionTool.h"
#import "OWLMusicGiftSVGAView.h"
#import "OWLPPAddAlertTool.h"
#import "OWLPPGiftPublicityView.h"
#import "OWLMusicBaseScrollView.h"

@interface OWLBGMModuleMainView() <UIScrollViewDelegate>

#pragma mark - Views
/// 关闭按钮
@property (nonatomic, strong) UIImageView *xyp_closeButton;
/// PK控制层
@property (nonatomic, strong) OWLBGMPKControlView *xyp_pkControlView;
/// 滑动视图
@property (nonatomic, strong) OWLMusicBaseScrollView *xyp_scrollView;
/// 控制层
@property (nonatomic, strong) OWLBGMModuleControlView *xyp_controlView;
/// 礼物按钮
@property (nonatomic, strong) UIView *xyp_giftButton;
/// 送礼视图
@property (nonatomic, strong) OWLMusicGiftSVGAView *xyp_svgView;

#pragma mark - Data
/// 当前房间数据
@property (nonatomic, strong) OWLMusicRoomTotalModel *xyp_totalModel;

@end

@implementation OWLBGMModuleMainView

- (void)dealloc {
    NSLog(@"xytest 控制层dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_updateControlViewIsShow:NO];
        [self xyf_setupView];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *responseView = nil;
    CGPoint pkPoint = [self.xyp_pkControlView convertPoint:point fromView:self];
    CGRect bounds = self.xyp_pkControlView.bounds;
    /// PK的点击事件被盖在最底下了，所以如果在PK区域的点击事件，就去PK区域重新找
    if (CGRectContainsPoint(bounds, pkPoint)) {
        responseView = [self.xyp_pkControlView hitTest:pkPoint withEvent:event];
    }
    if (!responseView) {
        responseView = [super hitTest:point withEvent:event];
    }
    
    return responseView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_pkControlView];
    [self addSubview:self.xyp_scrollView];
    
    [self.xyp_scrollView addSubview:self.xyp_controlView];
    
    [self addSubview:self.xyp_giftButton];
    [self.xyp_giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(36);
        make.trailing.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-kXYLBottomInputMargin);
    }];
    
    [self addSubview:self.xyp_closeButton];
    [self.xyp_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(24);
        make.trailing.equalTo(self).offset(-12);
        make.top.equalTo(self).offset(kXYLRoomInfoHeaderViewTopMargin + 5.5);
    }];
    
    [[OWLPPAddAlertTool shareInstance] xyf_addSendGiftShowView:self];
    [OWLPPAddAlertTool shareInstance].xyp_receiveGiftView.xyp_y = [self xyf_getGiftViewInitY];
    
    [self addSubview:self.xyp_svgView];
    
    if (OWLJConvertToolShared.xyf_isRTL) {
        self.xyp_scrollView.transform = CGAffineTransformMakeRotation(M_PI);
        self.xyp_controlView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

#pragma mark - 更新
- (void)xyf_updateRoomData:(OWLMusicRoomTotalModel *)model {
    [self xyf_updateControlViewIsShow:model != nil];
    if (model == nil) {
        [self.xyp_scrollView setContentOffset:CGPointZero animated:NO];
    }
    self.xyp_totalModel = model;
    [self.xyp_controlView xyf_updateRoomData:model];
    [self xyf_updatePKData:model.xyp_detailModel.dsb_pkData];
    if (model.xyp_detailModel.xyf_isPKState) {
        [self xyf_dealWithEvent:XYLModuleEventType_PKMatchSuccess obj:model.xyp_detailModel.dsb_pkData];
        if (model.xyp_detailModel.dsb_pkData.dsb_leftTime <= 0) {
            [self.xyp_pkControlView xyf_dealWithEvent:XYLModuleEventType_PKTimeEnd obj:model.xyp_detailModel.dsb_pkData];
        }
    }
}

/// 更新观众列表
- (void)xyf_updateMemberList:(NSMutableArray *)memberList {
    [self.xyp_controlView xyf_updateMemberList:memberList];
}

/// 更新PK数据
- (void)xyf_updatePKData:(OWLMusicRoomPKDataModel *)pkModel {
    self.xyp_pkControlView.xyp_pkData = pkModel;
}

/// 键盘弹起更新消息frame
- (void)xyf_updateFrameWhenKeyboardChanged:(CGFloat)bottomHeight changeType:(XYLModuleChangeInputViewHeightType)changeType {
    [self.xyp_controlView xyf_updateFrameWhenKeyboardChanged:bottomHeight changeType:changeType];
}

/// 礼物弹窗弹起更新礼物弹幕frame
- (void)xyf_updateGiftWhenPopGiftView:(CGFloat)viewY {
    if ([XYCUtil xyf_isIPhoneX]) {
        return;
    }
    
    NSLog(@"xytest viewY = %f",viewY);
    UIView *receiveGiftView = [OWLPPAddAlertTool shareInstance].xyp_receiveGiftView;
    if (CGRectGetMaxY(receiveGiftView.frame) > viewY) {
        receiveGiftView.xyp_y = viewY - receiveGiftView.xyp_h - kXYLGiftMessageBottomMargin;
    } else if (viewY == kXYLScreenHeight) {
        receiveGiftView.xyp_y = kXYLMessageBGViewTopMargin - kXYLGiftMessageBottomMargin - [OWLPPAddAlertTool shareInstance].xyp_receiveGiftView.xyp_h;
    }
}

/// 更新页面显示隐藏
- (void)xyf_updateControlViewIsShow:(BOOL)isShow {
    self.xyp_scrollView.hidden = !isShow;
    self.xyp_pkControlView.hidden = !isShow;
    self.xyp_giftButton.hidden = !isShow;
}

/// 送礼
- (void)xyf_receiveGiftMessage:(OWLMusicGiftInfoModel *)model {
    [self.xyp_svgView xyf_dealGiftMessage:model];
}

/// 清空礼物
- (void)xyf_removeGift {
    [self.xyp_svgView xyf_removeGift];
}

#pragma mark - 处理事件
/// 处理事件(触发事件)
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject * __nullable)obj {
    [self.xyp_pkControlView xyf_dealWithEvent:type obj:obj];
    [self.xyp_controlView xyf_dealWithEvent:type obj:obj];
    
    switch (type) {
        case XYLModuleEventType_ClearAllData:
            [self xyf_dealWithClearData];
            break;
        case XYLModuleEventType_PKMatchSuccess:
            [self xyf_dealWithPKMatchSuccess];
            break;
        default:
            break;
    }
    
}

- (void)xyf_dealWithClearData {
    [self xyf_updateRoomData:nil];
}

- (void)xyf_dealWithPKMatchSuccess {
    [OWLMusicTongJiTool xyf_thinkingWithTimeEventName:XYLThinkingEventTimeForOnePK];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == kXYLScreenWidth) {
        [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventEnterPureMode];
    }
}


#pragma mark - Setter
- (void)setDelegate:(id<OWLBGMModuleBaseViewDelegate>)delegate {
    self.xyp_controlView.delegate = delegate;
    self.xyp_controlView.controlDelegate = delegate;
    self.xyp_pkControlView.delegate = delegate;
}

#pragma mark - Getter
- (CGFloat)xyf_getGiftViewInitY {
    return kXYLMessageBGViewTopMargin - kXYLGiftMessageBottomMargin - kXYLGiftMessageHeight;
}

#pragma mark - Actions
- (void)xyf_clickScrollViewAction {
    [self endEditing:YES];
}

- (void)xyf_giftClickAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickGiftsButton];
    [self xyf_giveCallBackClickType:XYLModuleBaseViewClickType_ShowGiftList];
}

- (void)xyf_closeClickAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickCloseButton];
    [self xyf_giveCallBackClickType:XYLModuleBaseViewClickType_ClickCloseButton];
}

#pragma mark - 给回调
- (void)xyf_giveCallBackClickType:(XYLModuleBaseViewClickType)type {
    if (self.mainDelegate && [self.mainDelegate respondsToSelector:@selector(xyf_lModuleBaseViewClickEvent:)]) {
        [self.mainDelegate xyf_lModuleBaseViewClickEvent:type];
    }
}

#pragma mark - Lazy
- (OWLBGMPKControlView *)xyp_pkControlView {
    if (!_xyp_pkControlView) {
        _xyp_pkControlView = [[OWLBGMPKControlView alloc] initWithFrame:CGRectMake(0, kXYLRoomInfoHeaderViewTopMargin + kXYLRoomInfoHeaderViewHeight + kXYLPKVideoTopMargin, kXYLScreenWidth, kXYLPKControlTotalHeight)];
        _xyp_pkControlView.hidden = YES;
    }
    return _xyp_pkControlView;
}

- (OWLMusicBaseScrollView *)xyp_scrollView {
    if (!_xyp_scrollView) {
        _xyp_scrollView = [[OWLMusicBaseScrollView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_scrollView.clipsToBounds = YES;
        _xyp_scrollView.showsHorizontalScrollIndicator = NO;
        _xyp_scrollView.pagingEnabled = YES;
        _xyp_scrollView.bounces = false;
        _xyp_scrollView.contentSize = CGSizeMake(kXYLScreenWidth * 2, kXYLScreenHeight);
        _xyp_scrollView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_clickScrollViewAction)];
        _xyp_scrollView.userInteractionEnabled = YES;
        [_xyp_scrollView addGestureRecognizer:tap];
        if (@available(iOS 11.0, *)) {
            _xyp_scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _xyp_scrollView;
}

- (OWLBGMModuleControlView *)xyp_controlView {
    if (!_xyp_controlView) {
        _xyp_controlView = [[OWLBGMModuleControlView alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    }
    return _xyp_controlView;
}

- (UIView *)xyp_giftButton {
    if (!_xyp_giftButton) {
        _xyp_giftButton = [[UIView alloc] init];
        UIImageView * gImg = [[UIImageView alloc] init];
        NSString * gifPath = [OWLMusciCompressionTool xyf_getPreparedGifPathFrom:@"xyr_sendGift_btn"];
        NSData * gifData = [NSData dataWithContentsOfFile:gifPath];
        gImg.image = [UIImage sd_imageWithGIFData:gifData];
        [_xyp_giftButton addSubview:gImg];
        [gImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_xyp_giftButton);
            make.leading.equalTo(_xyp_giftButton).offset(-1);
            make.top.equalTo(_xyp_giftButton).offset(-1);
        }];
        _xyp_giftButton.layer.cornerRadius = 18;
        _xyp_giftButton.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_giftClickAction)];
        [_xyp_giftButton addGestureRecognizer:tap];
        _xyp_giftButton.userInteractionEnabled = YES;
    }
    return _xyp_giftButton;
}

- (UIImageView *)xyp_closeButton {
    if (!_xyp_closeButton) {
        _xyp_closeButton = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_closeButton iconStr:@"xyr_top_info_close_icon"];
        _xyp_closeButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_closeClickAction)];
        [_xyp_closeButton addGestureRecognizer:tap];
    }
    return _xyp_closeButton;
}

- (OWLMusicGiftSVGAView *)xyp_svgView {
    if (!_xyp_svgView) {
        _xyp_svgView = [[OWLMusicGiftSVGAView alloc] init];
    }
    return _xyp_svgView;
}

@end
