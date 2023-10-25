//
//  OWLPPAddAlertTool.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/27.
//

#import "OWLPPAddAlertTool.h"
#import "OWLPPBanner.h"
#import "OWLPPOpenBannerView.h"
#import "OWLPPBannerDetailAlert.h"
#import "OWLPPGiftChooseView.h"
#import "OWLPPGiftPublicityView.h"
#import "OWLPPEnjoyBarrageView.h"
#import "OWLMusicTakeHerAlert.h"
#import "OWLPPPairShowView.h"
#import "NSString+XYLExtention.h"
#import "NSMutableDictionary+XYLExtention.h"

@interface OWLPPAddAlertTool()<OWLPPBannerDelegate, OWLPPGiftChooseViewDelegate, OWLPPEnjoyBarrageViewDelegate>

@property (nonatomic, strong) OWLMusicBannerInfoModel * xyp_bannerModel;//登录时保存的banner数据

@property (nonatomic, strong) OWLPPGiftChooseView * xyp_giftView;//gift列表

@property (nonatomic, strong) OWLPPGiftPublicityView * xyp_receiveGiftView;//收到礼物显示容器

@property (nonatomic, strong) OWLPPEnjoyBarrageView * xyp_barrageView;//弹幕容器

@property (nonatomic, strong) NSTimer * xyp_timer;//计时器

@property (nonatomic, assign) NSInteger xyp_second;//计时秒数

@property (nonatomic, assign) NSInteger xyp_refreshSecond;//20分钟后刷新

@property (nonatomic, strong) OWLPPBanner * xyp_banner; //banner

@end

@implementation OWLPPAddAlertTool

#pragma mark - 单例
+ (instancetype)shareInstance {
    static OWLPPAddAlertTool * alertTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertTool = [[super allocWithZone:NULL] init];
    });
    return alertTool;
}

#pragma mark - 是否在当前直播间发送过弹幕
- (BOOL)xyf_hasSendBarrage {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_isSendBarrageInCurrentRoom)]) {
        return [self.xyp_delegate xyf_isSendBarrageInCurrentRoom];
    }
    return NO;
}

#pragma mark - 是否在当前直播间送过礼物
- (BOOL)xyf_hasSendGift {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_isSendGiftInCurrentRoom)]) {
        return [self.xyp_delegate xyf_isSendGiftInCurrentRoom];
    }
    return NO;
}

#pragma mark - 是否关注了当前主播
- (BOOL)xyf_hasFollowed {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_isFollowedHostInCurrentRoom)]) {
        return [self.xyp_delegate xyf_isFollowedHostInCurrentRoom];
    }
    return NO;
}
#pragma mark - 当前主播头像
-  (NSString *)xyf_hostAvatar {
    NSString * str = @"";
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_currentHostAvatar)]) {
        str = [self.xyp_delegate xyf_currentHostAvatar];
    }
    return str;
}

#pragma mark - 进入后激活定时器
- (void) xyf_activationTimer {
    [self xyf_stopTimer];
    self.xyp_second = 0;
    self.xyp_refreshSecond = 0;
    self.xyp_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(xyf_carouselNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.xyp_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 销毁定时器
- (void) xyf_stopTimer {
    if (self.xyp_timer != nil) {
        [self.xyp_timer invalidate];
        self.xyp_timer = nil;
    }
}

#pragma mark - 离开前销毁定时器及UI控件
- (void) xyf_destroyTimer {
    [self xyf_stopTimer];
    if (self.xyp_banner != nil) {
        [self.xyp_banner removeFromSuperview];
        self.xyp_banner = nil;
    }
    if (self.xyp_giftView != nil) {
        [self.xyp_giftView removeFromSuperview];
        self.xyp_giftView = nil;
    }
    if (self.xyp_receiveGiftView != nil) {
        [self.xyp_receiveGiftView removeFromSuperview];
        self.xyp_receiveGiftView = nil;
    }
    if (self.xyp_barrageView != nil) {
        [self.xyp_barrageView removeFromSuperview];
        self.xyp_barrageView = nil;
    }
}

#pragma mark - 清理上一个直播间的显示数据
- (void) xyf_clearAllData {
    self.xyp_second = 0;
    if (self.xyp_receiveGiftView != nil) {
        [self.xyp_receiveGiftView xyf_cleanData];
    }
    if (self.xyp_barrageView != nil) {
        [self.xyp_barrageView xyf_cleanData];
    }
}

#pragma mark - 开始新的直播间(RTM连接成功)
- (void) xyf_startNewRoom {
    self.xyp_second = 0;
    [self.xyp_barrageView xyf_joinRoomSuccess];
}

#pragma mark - 定时器方法
- (void) xyf_carouselNextPage {
    self.xyp_second += 1;
    self.xyp_refreshSecond += 1;
    if (self.xyp_second == 60) {
        if ([self.xyp_delegate respondsToSelector:@selector(xyf_showFollowAlert)]) {
            [self.xyp_delegate xyf_showFollowAlert];
        }
    }
    
    if (self.xyp_refreshSecond == 1200) {
        OWLMusicInsideManagerShared.xyp_isNeedRefreshHomeList = YES;
    }
    
    if (self.xyp_banner != nil) {
        [self.xyp_banner xyf_carouselNextPage];
    }
    if (self.xyp_giftView != nil) {
        [self.xyp_giftView xyf_nextSecond];
    }
    [self.xyp_receiveGiftView xyf_nextSecond];
    [self.xyp_barrageView xyf_nextSecondAction];
}

/////*****************************     内部方法     *******************************//////
#pragma mark - 内部方法
#pragma mark - 通过礼物id查找礼物url
- (OWLMusicGiftInfoModel *) xyf_inquireGiftModelWith:(NSInteger) xyp_giftId {
    OWLMusicGiftInfoModel * xyp_findModel;
    OWLMusicGiftListModel * xyp_config = OWLJConvertToolShared.xyp_giftInfo;
    for (int i = 0; i < xyp_config.dsb_giftList.count; i ++) {
        OWLMusicGiftInfoModel * xyp_gModel = xyp_config.dsb_giftList[i];
        if (xyp_gModel.dsb_giftID == xyp_giftId) {
            xyp_findModel = xyp_gModel;
        }
    }
    return xyp_findModel;
}

/////*****************************     banner part     *******************************//////

- (OWLMusicBannerInfoModel *)xyp_bannerModel {
    return OWLJConvertToolShared.xyp_bannerInfo;
}

#pragma mark - 添加小banner
- (void) xyf_addSmallBannerToView:(UIView *) showView {
    if (self.xyp_banner != nil) {
        [self.xyp_banner removeFromSuperview];
        self.xyp_banner = nil;
    }
    if (self.xyp_bannerModel.dsb_bannerList.count == 0) {
        return;
    }
    self.xyp_banner = [[OWLPPBanner alloc] initWithFrame:CGRectMake(0, 0, kXYLBannerWidth, kXYLBannerHeight)];
    self.xyp_banner.xyp_delegate = self;
    [showView addSubview:self.xyp_banner];
    [self.xyp_banner xyf_configBannerData:self.xyp_bannerModel.dsb_bannerList];
}

#pragma mark - 查看banner详情
- (void)xyf_bannerItemButtonClicked:(NSInteger)index {
    if (index >= self.xyp_bannerModel.dsb_bannerList.count) {
        return;
    }
    OWLMusicBannerModel *model = self.xyp_bannerModel.dsb_bannerList[index];
    [OWLMusicTongJiTool xyf_thinkingClickBannerWithName:model.dsb_name];
    switch (model.dsb_type) {
        case 1: /// 普通跳转
            [self xyf_showWebView:model.dsb_jumpAddr];
            break;
        case 6: /// 新星榜
            {
                if (model.dsb_jumpAddr.length == 0) { return; }
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic xyf_setObjectIfNotNil:OWLJConvertToolShared.xyf_userSession forKey:@"session"];
                [dic xyf_setObjectIfNotNil:@"1" forKey:@"type"];
                
            #ifdef DEBUG
                [dic xyf_setObjectIfNotNil:@"develop" forKey:@"env"];
            #endif
                
                NSString *url = [OWLMusciCompressionTool xyf_appendUrl:model.dsb_jumpAddr dic:dic];
                [self xyf_showWebView:url];
            }
            break;
        case 7: /// 进入主播详情
            [OWLJConvertToolShared xyf_enterUserDetailVCWithAccountID:model.dsb_otherData.intValue nickname:@"" avatar:@"" displayID:@"" isAnchor:YES];
            break;
        default:
            break;
    }
}

/// 展示web视图
- (void)xyf_showWebView:(NSString *)url {
    UIView *view = [self xyf_getView];
    if (view == nil) { return; }
    if (url.length == 0) { return; }
    
    OWLPPBannerDetailAlert * alert = [[OWLPPBannerDetailAlert alloc] initWithFrame:view.bounds];
    [view addSubview:alert];
    [alert xyf_setupUrl:url];
    [alert xyf_showAlert];
}

#pragma mark - OWLPPBannerDelegate
/** 点击item */
- (void) xyf_didSelectOneItemByIndex:(NSInteger) index andBanner:(OWLPPBanner *) banner {
    [self xyf_bannerItemButtonClicked:index];
}

/** 点击关闭banner按钮 */
- (void) xyf_clickedCloseBanner {
    if (self.xyp_banner == nil) {
        return;
    }
    [self xyf_postNotification:xyl_module_remove_banner];
    [self.xyp_banner removeFromSuperview];
    self.xyp_banner = nil;
}

/** 点击more按钮 */
- (void) xyf_clickedLookMore {
    UIView * view = [self xyf_getView];
    if (view == nil) { return; }
    kXYLWeakSelf;
    OWLPPOpenBannerView * openView = [[OWLPPOpenBannerView alloc] initWithFrame:view.bounds];
    openView.xyp_bannerDetail = ^(NSInteger index) {
        [weakSelf xyf_bannerItemButtonClicked:index];
    };
    [view addSubview:openView];
    [openView xyf_configListData:self.xyp_bannerModel.dsb_bannerList];
    [openView xyf_showOpenView];
}

/////*****************************     礼物 part     *******************************//////
#pragma mark - 礼物 part
#pragma mark - 添加选择礼物列表view
- (void) xyf_addGiftChooseToView:(UIView *) showView andDataArray:(NSArray *) ggArray {
    if (ggArray.count < 1) {
        return;
    }
    if (self.xyp_giftView != nil) {
        [self.xyp_giftView xyf_configGGData:ggArray];
        [self.xyp_giftView setHidden:YES];
        return;
    }
    self.xyp_giftView = [[OWLPPGiftChooseView alloc] initWithFrame:showView.bounds];
    self.xyp_giftView.xyp_delegate = self;
    [showView addSubview:self.xyp_giftView];
    [self.xyp_giftView xyf_configGGData:ggArray];
    [self.xyp_giftView setHidden:YES];
}

#pragma mark - 显示礼物列表弹窗
- (void) xyf_showGiftAlert {
    if (self.xyp_giftView == nil) {
        return;
    }
    if (self.xyp_giftView.superview != nil) {
        [self.xyp_giftView.superview bringSubviewToFront:self.xyp_giftView];
        [self.xyp_giftView setHidden:NO];
        [self.xyp_giftView xyf_alertChooseGift];
        return;
    }
}

#pragma mark - 刷新礼物列表数据
- (void) xyf_refreshGiftArray:(NSArray *) ggArray {
    if (self.xyp_giftView == nil) {
        return;
    }
    [self.xyp_giftView xyf_configGGData:ggArray];
}

#pragma mark - 购买svip后刷新礼物列表
- (void) xyf_refreshGiftViewAfterBuy {
    if (self.xyp_giftView == nil) {
        return;
    }
    [self.xyp_giftView xyf_refreshAllCollectionView];
}

#pragma mark - 礼物发送成功后转换
- (OWLMusicMessageModel *) xyf_convertMessageModelWith:(OWLMusicGiftInfoModel *) gift andBlindId:(NSInteger) blindId {
    if (self.xyp_giftView == nil) {
        return nil;
    }
    return [self.xyp_giftView xyf_getMessageModelWith:gift andBlindId:blindId];
}

#pragma mark - 显示充值弹窗
- (void)xyf_showRechargeAlert {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_showRechargeView)]) {
        [self.xyp_delegate xyf_showRechargeView];
    }
}

#pragma mark - 跳转svip页面
- (void) xyf_jumpToSvip {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_jumpToSpecialPage)]) {
        [self.xyp_delegate xyf_jumpToSpecialPage];
    }
}

#pragma mark - 点击送出礼物
- (void) xyf_clickedOneGift:(OWLMusicGiftInfoModel *)gift {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_clickedGift:)]) {
        [self.xyp_delegate xyf_clickedGift:gift];
    }
}

#pragma mark - 弹出礼物弹窗是y改变
- (void)xyf_giftAlertContenYChange:(double)xyp_y {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_chooseGiftAlertYChanged:)]) {
        [self.xyp_delegate xyf_chooseGiftAlertYChanged:xyp_y];
    }
}

/////***************************     礼物送出显示 part     *****************************//////

#pragma mark - 礼物送出显示 part
- (OWLPPGiftPublicityView *)xyp_receiveGiftView {
    if (!_xyp_receiveGiftView) {
        CGFloat giftViewX = OWLJConvertToolShared.xyf_isRTL ? kXYLScreenWidth - kXYLGiftMessageWidth : 0;
        _xyp_receiveGiftView = [[OWLPPGiftPublicityView alloc] initWithFrame:CGRectMake(giftViewX, 0, kXYLGiftMessageWidth, kXYLGiftMessageHeight)];
        _xyp_receiveGiftView.userInteractionEnabled = NO;
    }
    return _xyp_receiveGiftView;
}

#pragma mark -  添加礼物送出显示容器
- (void) xyf_addSendGiftShowView:(UIView *) showView {
    if (self.xyp_receiveGiftView != nil) {
        [self.xyp_receiveGiftView removeFromSuperview];
        [self.xyp_receiveGiftView xyf_cleanData];
    }
    [showView addSubview:self.xyp_receiveGiftView];
}

#pragma mark - 显示送礼物弹窗
- (void) xyf_showSendGiftEffectWith:(OWLMusicMessageModel *) msg {
    [self.xyp_receiveGiftView xyf_appendOneGiftMessage:msg];
}

/////*****************************     弹幕 part     *******************************//////
#pragma mark - 添加弹幕显示容器
- (void) xyf_addBarrageShowView:(UIView *) showView {
    if (self.xyp_barrageView != nil) {
        [self.xyp_barrageView xyf_cleanData];
        [self.xyp_barrageView removeFromSuperview];
    }
    self.xyp_barrageView = [[OWLPPEnjoyBarrageView alloc] initWithFrame:CGRectMake(0, 0, kXYLMessageViewWidth, kXYLMessageViewHeight)];
    self.xyp_barrageView.xyp_delegate = self;
    CGFloat barrageX = [OWLJConvertToolShared xyf_isRTL] ? kXYLScreenWidth - kXYLMessageViewWidth : 0;
    self.xyp_barrageView.frame = CGRectMake(barrageX, 0, kXYLMessageViewWidth, kXYLMessageViewHeight);
    [showView addSubview:self.xyp_barrageView];
}

#pragma mark - 添加显示弹幕信息
- (void) xyf_showOneBarrageEffectWith:(OWLMusicMessageModel *) xyp_msg andImmediatelyMsg:(BOOL)xyp_isImmediately {
    if (self.xyp_barrageView == nil) {
        return;
    }
    if (xyp_isImmediately) {
        [self.xyp_barrageView xyf_addImmediatelyBarrageWith:xyp_msg];
    } else {
        [self.xyp_barrageView xyf_addOneBarrageToPoolWith:xyp_msg];
    }
}

#pragma mark - 修改弹幕区域位置
- (void) xyf_refreshBarragePartFrame:(CGRect) xyp_rect andIsRefresh:(BOOL)xyp_isRefresh {
    if (self.xyp_barrageView == nil) {
        return;
    }
    self.xyp_barrageView.frame = xyp_rect;
    if (xyp_isRefresh) {
        [self.xyp_barrageView xyf_outsideChangeTableViewFrame];
    }
}

#pragma mark - barrageView delegate

/** 发送Hi */
- (void) xyf_sayHi {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_sendHiToHost)]) {
        [self.xyp_delegate xyf_sendHiToHost];
    }
}

/** 打开送礼界面 */
- (void) xyf_openSendGiftAlert {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_showSendGiftAlert)]) {
        [self.xyp_delegate xyf_showSendGiftAlert];
    }
}

/** 关注当前主播 */
- (void) xyf_followHer {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_followCurrentHost)]) {
        [self.xyp_delegate xyf_followCurrentHost];
    }
}

/** 点击弹幕用户名字 */
- (void) xyf_clickNickname:(NSInteger)accoundId andType:(OWLMusicMessageUserType)type {
    if ([self.xyp_delegate respondsToSelector:@selector(xyf_clickBarrageNickname:andType:)]) {
        [self.xyp_delegate xyf_clickBarrageNickname:accoundId andType:type];
    }
}

 #pragma mark - 播放完成目标svg
- (void) xyf_addAchieveGoalsSvgTo:(UIView *) xyp_showView andName:(NSString *) xyp_name {
    OWLPPPairShowView *playView = [[OWLPPPairShowView alloc] initWithFrame:xyp_showView.bounds];
    [xyp_showView addSubview:playView];
    [playView xyf_preparePlaySvgWithShowName:xyp_name];
}

 #pragma mark - 播放svip进入房间svg
- (void) xyf_addJoinRoomSvgTo:(UIView *) xyp_showView andAvatar:(NSString *) xyp_avatar andName:(NSString *) xyp_name {
    OWLPPPairShowView * xyp_playView = [[OWLPPPairShowView alloc] initWithFrame:xyp_showView.bounds];
    [xyp_showView addSubview:xyp_playView];
    [xyp_playView xyf_preparePlayJoinRoomSvgWithAvatar:xyp_avatar andName:xyp_name];
}

 #pragma mark - 代理
- (UIView *) xyf_getView {
    UIView *view;
    if (self.xyp_delegate && [self.xyp_delegate respondsToSelector:@selector(xyf_getVCView)]) {
        view = [self.xyp_delegate xyf_getVCView];
    }
    return view;
}

@end
