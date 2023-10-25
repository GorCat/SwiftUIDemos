//
//  OWLMusicInsideManager.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/10.
//

#import "OWLMusicInsideManager.h"
#import "OWLBGMModuleVC.h"
#import "OWLMusicComboView.h"

@implementation OWLMusicInsideManager

#pragma mark - 单例
+ (instancetype)shareInstance {
    static OWLMusicInsideManager *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[super allocWithZone:NULL] init];
        _sharedSingleton.xyp_shouldShowAutoDiscountView = YES;
    });
    return _sharedSingleton;
}

#pragma mark - Public
#pragma mark - 处理外部推送
/// 处理外部推送
- (void)xyf_insideHandleOpcode3Data:(XYCModulePushMessageModel *)model {
    [self.xyp_vc xyf_handleOpcode3Data:model];
}

#pragma mark - 关闭房间
/// 关闭或最小化
- (void)xyf_insideCloseOrFloatWindow {
    [self.xyp_vc xyf_closeSelfOrChangeFloatState];
}

/// 关闭房间
- (void)xyf_insideCloseLivePage:(BOOL)isPopVC {
    [self.xyp_vc xyf_closeSelf:isPopVC];
}

/// 仅返回页面
- (void)xyf_insideOnlyPopLiveVC {
    [self.xyp_vc xyf_onlyPopSelf];
}

#pragma mark - 其他方法
/// 控制列表是否能滑动
- (void)xyf_tableViewCanScroll:(BOOL)scrollEnabled {
    [self.xyp_vc xyf_tableViewIsEnable:scrollEnabled];
}

/// 移除连击视图
- (void)xyf_removeComboView {
    self.comboing = -1;
    [OWLMusicComboViewManager.shared xyf_removeCurrentComboViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

#pragma mark - Getter
/// 是否充值过
- (BOOL)xyf_hasRecharge {
    return self.xyp_hasRechargeInThisLife || OWLJConvertToolShared.xyf_userTotalRecharge >= 0.1;
}

- (NSInteger)xyp_currentRoomID {
    return self.xyp_vc.xyp_currentTotalModel.xyf_getRoomID;
}

- (NSInteger)xyp_hostID {
    return self.xyp_vc.xyp_currentTotalModel.xyf_getOwnerID;
}

- (OWLMusicRoomTotalModel *)xyp_currentModel {
    return self.xyp_vc.xyp_currentTotalModel;
}

@end
