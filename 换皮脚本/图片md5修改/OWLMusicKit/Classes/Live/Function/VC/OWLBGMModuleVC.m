//
//  OWLBGMModuleVC.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#import "OWLBGMModuleVC.h"

#pragma mark - Views
#import "OWLBGMModuleCell.h"
#import "OWLMusicBottomInputView.h"
#import "OWLMusicFloatWindow.h"
#import "OWLMusicGuideView.h"
#import "OWLMusicTableviewBaseView.h"

#pragma mark - Manager
#import "OWLMusicTotalManager.h"
#import "ZOEPIP_PIPManager.h"

@interface OWLBGMModuleVC () <
UITableViewDelegate,
UITableViewDataSource,
OWLMusicTotalManagerDelegate,
XYCTapClickBaseTableViewDelegate,
ZOEPIPPictureInPictureManagerDelegate
>

#pragma mark - Views
/// 列表
@property (nonatomic, strong) OWLMusicTableviewBaseView *xyp_tableView;
/// 输入框
@property (nonatomic, strong) OWLMusicBottomInputView *xyp_inputView;
/// 引导弹窗
@property (nonatomic, strong) OWLMusicGuideView *xyp_guideView;

#pragma mark - Manager
/// 管理类
@property (nonatomic, strong) OWLMusicTotalManager *xyp_manager;
/// 画中画管理类
@property (nonatomic, strong) ZOEPIP_PIPManager *xyp_pipManager;

#pragma mark - BOOL
/// 是否是第一次加载
@property (nonatomic, assign) BOOL xyp_hasLoad;

@end

@implementation OWLBGMModuleVC

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
    NSLog(@"xytest 直播间vc - dealloc");
}

- (instancetype)initWithAnchorID:(NSInteger)anchorID {
    self = [super init];
    if (self) {
        self.xyp_compairCurrentHostID = anchorID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (OWLJConvertToolShared.xyf_isRTL) {
        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        [UICollectionView appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    } else {
        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        [UICollectionView appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
    }
    
    [self xyf_setupView];
    [self xyf_setupManager];
    [self xyf_setupPipManager];
    [self xyf_reloadTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xyf_appEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    self.xyp_hasLoad = YES;
    
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.xyp_hasLoad) {
        [self xyf_resumeVideoView];
    }
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleViewWillAppear)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleViewWillAppear];
    }
    
    [self.navigationController.navigationBar setHidden:YES];
    if ([UIScreen mainScreen].isCaptured && [[UIDevice currentDevice] systemVersion].floatValue < 13.2) {
        [OWLJConvertToolShared xyf_showNoScreenView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleViewWillDisappear)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleViewWillDisappear];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        [self.xyp_manager xyf_closeOrFloatWindow:YES];
        if (![self.xyp_manager.xyp_currentTotalModel.xyp_detailModel xyf_beActive]) {
            OWLMusicInsideManagerShared.xyp_isNeedRefreshHomeList = YES;
        }
        if (OWLMusicInsideManagerShared.xyp_isNeedRefreshHomeList) {
            [OWLJConvertToolShared xyf_insideRefreshHomepage];
        }
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - 页面初始化
/// 初始化UI
- (void)xyf_setupView {
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.xyp_tableView];
    [self.xyp_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.xyp_inputView];
}

/// 初始化管理类
- (void)xyf_setupManager {
    self.xyp_manager.xyp_targetVC = self;
    self.xyp_manager.xyp_targetView = self.view;
    self.xyp_manager.xyp_inputView = self.xyp_inputView;
    /// 初始化管理类
    [self.xyp_manager xyf_setupManager];
    /// 加入房间
    [self.xyp_manager xyf_joinRoomWithConfigModel:self.xyp_configModel];
}

/// 初始化画中画管理类
- (void)xyf_setupPipManager {
    /// 有PIP功能 并且 PIP功能开关是开的
    BOOL isOpenPIP = OWLMusicInsideManagerShared.xyp_hasPIPFunc && OWLMusicInsideManagerShared.xyp_isOpenWindowOutApp;
    self.xyp_pipManager = [[ZOEPIP_PIPManager alloc] initAndRtcKit:OWLJConvertToolShared.xyf_rtcKit WithvcType:ZOEPIP_PIPVCTypeLiveRoom WithVC:self WithDelegate:self WithIsOpen:isOpenPIP];
    /// 给管理类去调用
    self.xyp_manager.xyp_pipManager = self.xyp_pipManager;
}

#pragma mark - Public
/// 处理推送消息
- (void)xyf_handleOpcode3Data:(XYCModulePushMessageModel *)model {
    [self.xyp_manager xyf_handleOpcode3Data:model];
}

/// 关闭房间或者最小化房间
- (void)xyf_closeSelfOrChangeFloatState {
    [self.xyp_manager xyf_closeOrFloatWindow:NO];
}

/// 关闭直播间
- (void)xyf_closeSelf:(BOOL)isNeedPopVC {
    [self.xyp_manager xyf_exitLiveRoom:isNeedPopVC];
}

/// 仅pop直播页面
- (void)xyf_onlyPopSelf {
    if (self.navigationController) [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 控制列表能否滑动
- (void)xyf_tableViewIsEnable:(BOOL)isEnable {
    self.xyp_tableView.scrollEnabled = isEnable;
}

/// 点击横幅进入其他房间
- (void)xyf_enterOtherRoomByBroadcast:(OWLMusicBroadcastModel *)model {
    [self.xyp_manager xyf_enterOtherRoomByBroadcast:model];
}

/// 改变画中画
- (void)xyf_changePIPOpenState:(BOOL)isOpen {
    if (OWLMusicInsideManagerShared.xyp_hasPIPFunc) {
        [self.xyp_pipManager zoepip_swichOpen:isOpen];
    }
}

#pragma mark - Private
/// 移除视图
- (void)xyf_removeControlViewAndVideoView {
    [self.xyp_manager.xyp_controlView removeFromSuperview];
    [self.xyp_manager.xyp_videoContainerView removeFromSuperview];
}

/// 将控制视图添加到当前cell
- (void)xyf_addControlViewAndVideoViewToCurrentCell {
    /// 刷新打电话图片（fix bug）
    [self xyf_postNotification:xyl_module_refresh_private_image];
    /// 添加到当前视图
    OWLBGMModuleCell *cell = [self xyf_getCurrentCell:self.xyp_manager.xyp_currentIndex];
    [cell addSubview:self.xyp_manager.xyp_videoContainerView];
    [cell addSubview:self.xyp_manager.xyp_controlView];
    /// 如果有引导view的话 显示在最上层
    if (self.xyp_guideView) {
        [cell addSubview:self.xyp_guideView];
    }
}

/// 禁止手势
- (void)xyf_controlAndVideoViewEnable:(BOOL)enable {
    self.xyp_manager.xyp_controlView.userInteractionEnabled = enable;
    self.xyp_manager.xyp_videoContainerView.userInteractionEnabled = enable;
}

/// 刷新列表
- (void)xyf_reloadTableView {
    /// 移除视图
    [self xyf_removeControlViewAndVideoView];
    /// 刷新列表
    [self.xyp_tableView reloadData];
    /// 将控制视图添加到当前cell
    [self xyf_addControlViewAndVideoViewToCurrentCell];
}

/// 还原视图
- (void)xyf_resumeVideoView {
    /// 隐藏浮窗
    [OWLMusicFloatWindowShared xyf_hideFloatingView];
    /// 改变状态
    [self.xyp_manager.xyp_videoContainerView xyf_changeFloatState:NO];
    /// 重新添加到视图上
    [self xyf_reloadTableView];
}

/// 开启/关闭返回手势
- (void)xyf_controlPopGesture:(BOOL)enabled {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = enabled;
    }
}

/// 隐藏引导弹窗
- (void)xyf_hiddenGuideView {
    if (![OWLJConvertToolShared xyf_isShowScrollTip]) {
        [OWLJConvertToolShared xyf_hadShowScrollTip];
    }
    
    if (!self.xyp_guideView) { return; }
    /// 移除引导弹窗
    [self.xyp_guideView removeFromSuperview];
    self.xyp_guideView = nil;
    /// 开启侧滑返回
    [self xyf_controlPopGesture:YES];
    /// 开启控制层手势
    [self xyf_controlAndVideoViewEnable:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.xyp_manager.xyp_dataSourceRoomList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = indexPath.section == self.xyp_manager.xyp_currentIndex ? @"xyp_liveModule_playing_cell" : @"xyp_liveModule_noplaying_cell";
    
    OWLBGMModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OWLBGMModuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    OWLMusicRoomTotalModel *model = [self.xyp_manager.xyp_dataSourceRoomList xyf_objectAtIndexSafe:indexPath.section];
    cell.xyp_cover = model.xyp_tempModel.xyp_cover;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kXYLScreenHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xyf_hiddenGuideView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger nextIndex = scrollView.contentOffset.y / kXYLScreenHeight;
    [self.xyp_manager xyf_switchChangeRoom:nextIndex];
}

#pragma mark - OWLMusicTotalManagerDelegate 管理类代理
/// 刷新列表
- (void)xyf_totalManagerRefreshRoomList {
    [self xyf_reloadTableView];
}

/// 插入或删除cell
- (void)xyf_totalManagerOperateData:(NSInteger)index isDelete:(BOOL)isDelete {
    [XYCUtil xyf_doInMain:^{
        if (isDelete) {
            [self.xyp_tableView xyf_deleteSection:index withAnimation:UITableViewRowAnimationNone];
        } else {
            [self.xyp_tableView xyf_insertSection:index withAnimation:UITableViewRowAnimationNone];
        }
    }];
}

/// 进入对方直播间
- (void)xyf_totalManagerEnterOtherRoom:(BOOL)isAlreadyHasRoom fromWay:(XYLOutDataSourceEnterRoomType)fromWay {
    /// 移除视图
    [self xyf_removeControlViewAndVideoView];
    /// 刷新列表
    [self.xyp_tableView reloadData];
    /// 移动到对应的位置
    [self.xyp_tableView setContentOffset:CGPointMake(0, kXYLScreenHeight * self.xyp_manager.xyp_currentIndex) animated:NO];
    /// 添加到当前视图
    [self xyf_addControlViewAndVideoViewToCurrentCell];
    /// 进入房间
    [self.xyp_manager xyf_switchJoinRoomWithIndex:self.xyp_manager.xyp_currentIndex fromWay:fromWay];
}

/// 显示引导弹窗
- (void)xyf_totalManagerShowGuideView {
    /// 关闭返回手势
    [self xyf_controlPopGesture:NO];
    /// 添加引导弹窗
    self.xyp_guideView = [[OWLMusicGuideView alloc] init];
    /// 添加到当前视图
    OWLBGMModuleCell *cell = [self xyf_getCurrentCell:self.xyp_manager.xyp_currentIndex];
    [cell addSubview:self.xyp_guideView];
    /// 屏蔽手势
    [self xyf_controlAndVideoViewEnable:NO];
    /// 改变本地状态
    [OWLJConvertToolShared xyf_hadShowScrollTip];
}

/// 操控滑动手势
- (void)xyf_totalManagerChangePopGesture:(BOOL)isEnable {
    /// 操控返回手势
    [self xyf_controlPopGesture:isEnable];
}

/// 更新当前主播ID
- (void)xyf_totalManagerUpdateCurrentHostID:(NSInteger)hostID {
    self.xyp_compairCurrentHostID = hostID;
}

#pragma mark - XYCTapClickBaseTableViewDelegate 列表点击事件代理
- (void)xyf_tapClickBaseTabelViewClickTouchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.xyp_inputView xyf_dismiss];
    [self xyf_hiddenGuideView];
}

#pragma mark - ZOEPIPPictureInPictureManagerDelegate 画中画
- (NSInteger)zoepip_getPIPViewIndexWithUid:(NSUInteger)uid channelId:(NSString * _Nonnull)channelId {
    if (uid == [self xyp_currentTotalModel].xyp_detailModel.dsb_pkData.dsb_otherPlayer.dsb_accountID) {
        return 1;
    } else {
        return 0;
    }
}

/// 直播间语聊房实现，小窗模式时画中画结束需回到大窗模式
- (void)zoepip_finishPIPGoBigSizeView {
    if (OWLMusicFloatWindowShared.xyp_isShowing && !OWLMusicInsideManagerShared.xyp_isTakingAnchor) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (OWLMusicFloatWindowShared.xyp_isShowing && !OWLMusicInsideManagerShared.xyp_isTakingAnchor) {
                [OWLMusicFloatWindowShared xyf_backToVC];
            }
        });
    }
}

/// 在后台关闭画中画 你需要关闭声音
- (void)zoepip_closePIPWindowInBackMode {
    [OWLJConvertToolShared.xyf_rtcKit adjustPlaybackSignalVolume:0];
}

#pragma mark - Notification
- (void)xyf_appEnterForeground {
    [OWLJConvertToolShared.xyf_rtcKit adjustPlaybackSignalVolume:200];
}

#pragma mark - Getter
/// 根据下标获取cell
- (OWLBGMModuleCell *)xyf_getCurrentCell:(NSInteger)index {
    OWLBGMModuleCell *cell = (OWLBGMModuleCell *)[self.xyp_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    return cell;
}

/// 当前主播ID
- (NSInteger)xyp_currentAnchorID {
    return [[self.xyp_manager xyp_currentTotalModel] xyf_getOwnerID];
}

/// 当前房间是否是UGC房间
- (BOOL)xyp_isUGC {
    return [[self.xyp_manager xyp_currentTotalModel] xyp_isUGCRoom];
}

/// 当前房间模型
- (OWLMusicRoomTotalModel *)xyp_currentTotalModel {
    return [self.xyp_manager xyp_currentTotalModel];
}

#pragma mark - Lazy
- (OWLMusicTableviewBaseView *)xyp_tableView {
    if (!_xyp_tableView) {
        _xyp_tableView = [[OWLMusicTableviewBaseView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _xyp_tableView.backgroundColor = [UIColor clearColor];
        _xyp_tableView.delegate = self;
        _xyp_tableView.dataSource = self;
        _xyp_tableView.xyp_tapDelegate = self;
        _xyp_tableView.showsVerticalScrollIndicator = NO;
        _xyp_tableView.showsHorizontalScrollIndicator = NO;
        _xyp_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _xyp_tableView.estimatedSectionFooterHeight = 0;
        _xyp_tableView.estimatedSectionHeaderHeight = 0;
        _xyp_tableView.estimatedRowHeight = 0;
        _xyp_tableView.pagingEnabled = YES;
        _xyp_tableView.scrollsToTop = NO;
        _xyp_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_xyp_tableView registerClass:[OWLBGMModuleCell class] forCellReuseIdentifier:NSStringFromClass([OWLBGMModuleCell class])];
        if (@available(iOS 11.0, *)) {
            _xyp_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _xyp_tableView;
}

- (OWLMusicBottomInputView *)xyp_inputView {
    if (!_xyp_inputView) {
        _xyp_inputView = [[OWLMusicBottomInputView alloc] initWithFrame:CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, [OWLMusicBottomInputView xyf_getHeight])];
    }
    return _xyp_inputView;
}

- (OWLMusicTotalManager *)xyp_manager {
    if (!_xyp_manager) {
        _xyp_manager = [[OWLMusicTotalManager alloc] init];
        _xyp_manager.delegate = self;
    }
    return _xyp_manager;
}

@end
