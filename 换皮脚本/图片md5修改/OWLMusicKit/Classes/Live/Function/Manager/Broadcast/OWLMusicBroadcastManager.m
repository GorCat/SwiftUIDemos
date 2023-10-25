//
//  OWLMusicBroadcastManager.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/5.
//

#import "OWLMusicBroadcastManager.h"
#import "OWLBGMModuleVC.h"

@interface OWLMusicBroadcastManager ()

@property (nonatomic, strong) NSMutableArray <OWLMusicBroadcastModel *>* bannerArray;

@property (nonatomic, strong) OWLMusicBroadcastCell * firstCell;

@property (nonatomic, strong) OWLMusicBroadcastCell * secondCell;

@property (nonatomic, weak) UIView *xyp_View;

@property (nonatomic, assign) BOOL runing;

@property (nonatomic, strong) dispatch_queue_t bannerQueue;

@property (nonatomic, strong) NSLock * lock;

@end

@implementation OWLMusicBroadcastManager
static OWLMusicBroadcastManager * _manager;
+ (instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[OWLMusicBroadcastManager alloc]init];
    });
    return _manager;
}

- (instancetype)init{
    self= [super init];
    if(self){
        [self.bannerArray removeAllObjects];
        [self xyf_setupViews];
        [self xyf_addActions];
    }
    return self;
}

#pragma mark public
- (void)xyf_addChannalBanner:(OWLMusicBroadcastModel *)xyp_model{
    if (OWLJConvertToolShared.xyf_isCloseBroadcast) {
        return;
    }
    if (!OWLBGMModuleManagerShared.xyp_isInLiveModule) {
        return;
    }
    
    kXYLWeakSelf
    [self xyf_addHandleOnBannerQueue:^{
        if(xyp_model.xyp_showType == XYLBroadcastShowTypeTake){
            OWLMusicBroadcastModel * first = weakSelf.bannerArray.firstObject;
            if(first){
                if(first.xyp_state == XYLBroadcastCellStateWait){
                    [weakSelf.bannerArray insertObject:xyp_model atIndex:0];
                }else{
                    if(weakSelf.bannerArray.count > 1){
                        OWLMusicBroadcastModel * second = weakSelf.bannerArray[1];
                        if(second.xyp_state == XYLBroadcastCellStateWait){
                            [weakSelf.bannerArray insertObject:xyp_model atIndex:1];
                        }else{
                            [weakSelf.bannerArray insertObject:xyp_model atIndex:2];
                        }
                    }else{
                        [weakSelf.bannerArray addObject:xyp_model];
                    }
                }
            }else{
                [weakSelf.bannerArray addObject:xyp_model];
            }
        }else{
            [weakSelf.bannerArray addObject:xyp_model];
        }
        
        [weakSelf xyf_addHandleOnMainQueue:^{
            [weakSelf xyf_start];
        }];
    }];

}


- (void)xyf_setupBannerOnView:(UIView *)view {
    if(!view){
        return;
    }
    self.xyp_View = view;
    [self.firstCell removeFromSuperview];
    [self.secondCell removeFromSuperview];
    
    [view addSubview:self.firstCell];
    [view addSubview:self.secondCell];
    kXYLWeakSelf
    [self xyf_addHandleOnBannerQueue:^{
        NSArray <OWLMusicBroadcastModel *>* array  = [[NSArray alloc]initWithArray:weakSelf.bannerArray];
        for (OWLMusicBroadcastModel * model in array) {
            if(model.xyp_showType == XYLBroadcastShowTypeTake){
                [weakSelf.bannerArray removeObject:model];
            }else{
                if(model.xyp_state != XYLBroadcastCellStateWait){
                    [weakSelf.bannerArray removeObject:model];
                }
            }
        }
       
        if(weakSelf.bannerArray.count > 0){
            [weakSelf xyf_addHandleOnMainQueue:^{
                [weakSelf xyf_start];
            }];
        }
    }];
}

- (void)xyf_leaveRoom{

    self.runing = NO;
    [self xyf_addHandleOnBannerQueue:^{
        [self.bannerArray enumerateObjectsUsingBlock:^(OWLMusicBroadcastModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(obj.xyp_showType == XYLBroadcastShowTypeTake){
                [self.bannerArray removeObject:obj];
            }else{
                if(obj.xyp_state != XYLBroadcastCellStateWait){
                    [self.bannerArray removeObject:obj];
                }
            }
        }];
    }];
    [self.firstCell xyf_loadModel:nil];
    [self.firstCell removeFromSuperview];
    [self.secondCell xyf_loadModel:nil];
    [self.secondCell removeFromSuperview];

}

- (void)xyf_clearBannerData{
    [self.bannerArray removeAllObjects];
}

- (void)xyf_destoryManager{
    self.runing = NO;
    [self xyf_clearBannerData];
    [self.firstCell removeFromSuperview];
    [self.secondCell removeFromSuperview];

}

#pragma mark private
- (void)xyf_start{
    if(OWLJConvertToolShared.xyf_isCloseBroadcast){
        return;
    }
    if(self.runing){
        return;
    }
    if (!self.firstCell.superview) {
        [self.xyp_View addSubview:self.firstCell];
    }
    if (!self.secondCell.superview) {
        [self.xyp_View addSubview:self.secondCell];
    }
    
    
    kXYLWeakSelf
    [self xyf_addHandleOnBannerQueue:^{
        OWLMusicBroadcastModel * firstModel = weakSelf.bannerArray.firstObject;
        if(!firstModel){
            return;
        }
        firstModel.xyp_state = XYLBroadcastCellStateWait;
        [weakSelf xyf_addHandleOnMainQueue:^{
            if(!weakSelf.firstCell.xyp_model){
                [weakSelf.firstCell xyf_loadModel:firstModel];
                [weakSelf.firstCell xyf_cellEnter];
                self.runing = YES;
                [weakSelf.firstCell.superview bringSubviewToFront:weakSelf.firstCell];
            }
        }];
    }];
    
  
}

- (void)xyf_setupViews{
    
}

- (void)xyf_addActions{
    kXYLWeakSelf
    self.firstCell.stateChangeBlock = ^(XYLBroadcastCellState state) {
        kXYLStrongSelf
        if(state == XYLBroadcastCellStateExit){
            [strongSelf xyf_addHandleOnBannerQueue:^{
                if(strongSelf.bannerArray.count > 1){
                    OWLMusicBroadcastModel * secondModel = strongSelf.bannerArray[1];
                    [strongSelf xyf_addHandleOnMainQueue:^{
                        if(secondModel.xyp_state == XYLBroadcastCellStateWait){
                            if(OWLJConvertToolShared.xyf_isCloseBroadcast){
                                return;
                            }
                            if(!strongSelf.secondCell.xyp_model){
                                [strongSelf.secondCell xyf_loadModel:secondModel];
                                [strongSelf.secondCell xyf_cellEnter];
                                [strongSelf.secondCell.superview bringSubviewToFront:strongSelf.secondCell];
                            }
                        }
                    }];
                }
            }];
        }else if (state == XYLBroadcastCellStateEnd){
            [strongSelf xyf_addHandleOnBannerQueue:^{
                [strongSelf.bannerArray removeObject:strongSelf.firstCell.xyp_model];
                if(strongSelf.bannerArray.count == 0){
                    strongSelf.runing = NO;
                }
                [strongSelf xyf_addHandleOnMainQueue:^{
                    [strongSelf.firstCell xyf_loadModel:nil];
                }];
            }];
          
        }
    };
    
    self.secondCell.stateChangeBlock = ^(XYLBroadcastCellState state) {
        kXYLStrongSelf
        if(state == XYLBroadcastCellStateExit){
            [strongSelf xyf_addHandleOnBannerQueue:^{
                if(strongSelf.bannerArray.count > 1){
                    OWLMusicBroadcastModel * secondModel = strongSelf.bannerArray[1];
                    [strongSelf xyf_addHandleOnMainQueue:^{
                        if(secondModel.xyp_state == XYLBroadcastCellStateWait){
                            if(OWLJConvertToolShared.xyf_isCloseBroadcast){
                                return;
                            }
                            if(!strongSelf.firstCell.xyp_model){
                                [strongSelf.firstCell xyf_loadModel:secondModel];
                                [strongSelf.firstCell xyf_cellEnter];
                                [strongSelf.firstCell.superview bringSubviewToFront:strongSelf.firstCell];
                            }
                        }
                    }];
                }
            }];
        }else if (state == XYLBroadcastCellStateEnd){
            [strongSelf xyf_addHandleOnBannerQueue:^{
                [strongSelf.bannerArray removeObject:weakSelf.secondCell.xyp_model];
                if(strongSelf.bannerArray.count == 0){
                    strongSelf.runing = NO;
                }
                [strongSelf xyf_addHandleOnMainQueue:^{
                    [strongSelf.secondCell xyf_loadModel:nil];
                }];
            }];
        }
    };
    
    
    self.firstCell.cellWillStayBlock = ^(OWLMusicBroadcastModel * _Nonnull xyp_bannerModel) {
        kXYLStrongSelf
        [strongSelf xyf_addHandleOnBannerQueue:^{
            NSInteger index = [strongSelf.bannerArray indexOfObject:xyp_bannerModel];
            if(strongSelf.bannerArray.count - 1 > index){
                xyp_bannerModel.fastStayDuration = 1;
            }
        }];
    };
    
    self.secondCell.cellWillStayBlock = ^(OWLMusicBroadcastModel * _Nonnull xyp_bannerModel) {
        kXYLStrongSelf
        [strongSelf xyf_addHandleOnBannerQueue:^{
            NSInteger index = [strongSelf.bannerArray indexOfObject:xyp_bannerModel];
            if(strongSelf.bannerArray.count - 1 > index){
                xyp_bannerModel.fastStayDuration = 1;
            }
        }];
    };
    
    self.firstCell.tapChannalBannerBlock = ^(OWLMusicBroadcastModel * _Nonnull xyp_bannerModel) {
        kXYLStrongSelf
        [strongSelf xyf_jumpToOther:xyp_bannerModel];
    };
    self.secondCell.tapChannalBannerBlock = ^(OWLMusicBroadcastModel * _Nonnull xyp_bannerModel) {
        kXYLStrongSelf
        [strongSelf xyf_jumpToOther:xyp_bannerModel];
    };

}

- (void)xyf_jumpToOther:(OWLMusicBroadcastModel *)xyp_bannerModel{
    
    if (xyp_bannerModel.xyp_fromType == XYLBroadcastFromTypeLive || xyp_bannerModel.xyp_fromType == XYLBroadcastFromTypeUGC) {
        /// 无网
        if (OWLJConvertToolShared.xyf_judgeNoNetworkAndShowNoNetTip) { return; }
        /// 同一个主播就不跳转
        if (xyp_bannerModel.xyp_recieverUserId == OWLMusicInsideManagerShared.xyp_vc.xyp_currentTotalModel.xyf_getOwnerID) { return; }
        /// 横幅类型是UGC 但不是UGC进入的
        if (xyp_bannerModel.xyp_fromType == XYLBroadcastFromTypeUGC && !OWLMusicInsideManagerShared.xyp_vc.xyp_configModel.xyp_isUGCRoom) { return; }
        /// 横幅类型不是UGC 但是UGC进入的
        if (xyp_bannerModel.xyp_fromType != XYLBroadcastFromTypeUGC && OWLMusicInsideManagerShared.xyp_vc.xyp_configModel.xyp_isUGCRoom) { return; }
        [OWLMusicInsideManagerShared.xyp_vc xyf_enterOtherRoomByBroadcast:xyp_bannerModel];
        
    } else if (xyp_bannerModel.xyp_fromType == XYLBroadcastFromTypeChatRoom) {
        if (OWLJConvertToolShared.xyf_judgeNoNetworkAndShowNoNetTip) { return; }
        [OWLJConvertToolShared xyf_enterChatRoom:xyp_bannerModel.xyp_roomId];
    }
}


- (void)xyf_addHandleOnBannerQueue:(void(^)(void))handleBlock{
    dispatch_async(self.bannerQueue, ^{
        [self.lock lock];
        handleBlock();
        [self.lock unlock];
    });
}

- (void)xyf_addHandleOnMainQueue:(void(^)(void))handleBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        handleBlock();
    });
}

#pragma mark getter
- (NSMutableArray<OWLMusicBroadcastModel *> *)bannerArray{
    if(!_bannerArray){
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (OWLMusicBroadcastCell *)firstCell{
    if(!_firstCell){
        _firstCell = [[OWLMusicBroadcastCell alloc]init];
    }
    return _firstCell;
}

- (OWLMusicBroadcastCell *)secondCell{
    if(!_secondCell){
        _secondCell = [[OWLMusicBroadcastCell alloc]init];
    }
    return _secondCell;
}

- (dispatch_queue_t)bannerQueue{
    if(!_bannerQueue){
        _bannerQueue = dispatch_queue_create("BroadcastQueue", NULL);
    }
    return _bannerQueue;
}
- (NSLock *)lock{
    if(!_lock){
        _lock = [[NSLock alloc]init];
    }
    return _lock;
}
@end
