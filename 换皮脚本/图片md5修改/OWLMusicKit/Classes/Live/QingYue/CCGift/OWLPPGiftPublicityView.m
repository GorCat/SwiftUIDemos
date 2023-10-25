//
//  OWLPPGiftPublicityView.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/27.
//

#import "OWLPPGiftPublicityView.h"
#import "OWLPPReceiveGiftCell.h"
#import "OWLPPReceiveGiftModel.h"

@interface OWLPPGiftPublicityView()

@property (nonatomic, strong) NSMutableArray <OWLPPReceiveGiftModel *> * xyp_ingArray;//正常显示的队列

@property (nonatomic, strong) NSMutableArray <OWLPPReceiveGiftModel *>  * xyp_waitArray;//等待显示的队列

@property (nonatomic, strong) NSArray <OWLPPReceiveGiftCell *> * xyp_cellArray;//两个礼物显示cell

@property (nonatomic, strong) NSMutableArray * xyp_timeArray;//倒计时数组

@end

@implementation OWLPPGiftPublicityView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupUI];
    }
    return self;
}

- (NSMutableArray *)xyp_ingArray {
    if (!_xyp_ingArray) {
        _xyp_ingArray = [NSMutableArray array];
    }
    return _xyp_ingArray;
}

- (NSMutableArray *)xyp_waitArray {
    if (!_xyp_waitArray) {
        _xyp_waitArray = [NSMutableArray array];
    }
    return _xyp_waitArray;
}

#pragma mark - UI
- (void) xyf_setupUI {
    OWLPPReceiveGiftCell * oneCell = [[OWLPPReceiveGiftCell alloc] initWithFrame:CGRectMake([self xyf_getCellInitX], 0, [self xyf_getCellWidth], 38)];
    [self addSubview:oneCell];
    OWLPPReceiveGiftCell * twoCell = [[OWLPPReceiveGiftCell alloc] initWithFrame:CGRectMake([self xyf_getCellInitX], 47, [self xyf_getCellWidth], 38)];
    [self addSubview:twoCell];
    self.xyp_cellArray = @[oneCell, twoCell];
    self.xyp_timeArray = [@[@(3), @(3)] mutableCopy];
    self.xyp_ingArray = [@[[[OWLMusicMessageModel alloc] init], [[OWLMusicMessageModel alloc] init]] mutableCopy];
}

#pragma mark - 新增礼物消息显示
- (void) xyf_appendOneGiftMessage:(OWLMusicMessageModel *) msg {
    //判断当前显示队列是否有同个用户送的同一个礼物
    for (int i = 0; i < 2; i ++) {
        OWLPPReceiveGiftModel * xyp_giftModel = self.xyp_ingArray[i];
        OWLMusicMessageModel * xyp_mm = xyp_giftModel.xyp_giftModel;
        if ([self xyf_judgeIsTheSameOne:msg andOther:xyp_mm]) {
            xyp_giftModel.xyp_comboNumber += 1;
            OWLPPReceiveGiftCell * cell = self.xyp_cellArray[i];
            [cell xyf_configGiftData:xyp_giftModel];
            [self.xyp_timeArray replaceObjectAtIndex:i withObject:@(3)];
            return;
        }
    }
    OWLPPReceiveGiftModel * xyp_waitData = [[OWLPPReceiveGiftModel alloc] init];
    xyp_waitData.xyp_giftModel = msg;
    xyp_waitData.xyp_comboNumber = 1;
    //判断是否有空余显示位置
    for (int i = 0; i < 2; i ++) {
        OWLPPReceiveGiftModel * xyp_oneData = self.xyp_ingArray[i];
        OWLMusicMessageModel * xyp_gModel = xyp_oneData.xyp_giftModel;
        if (xyp_gModel.dsb_avatar == nil) {
            [self.xyp_ingArray replaceObjectAtIndex:i withObject:xyp_waitData];
            [self.xyp_timeArray replaceObjectAtIndex:i withObject:@(3)];
            OWLPPReceiveGiftCell * cell = self.xyp_cellArray[i];
            if (OWLJConvertToolShared.xyf_isRTL) {
                if (cell.xyp_x < cell.xyp_w) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [cell xyf_configGiftData:xyp_waitData];
                        [cell xyf_moveToDisplayGift];
                    });
                } else {
                    [cell xyf_configGiftData:xyp_waitData];
                    [cell xyf_moveToDisplayGift];
                }
            } else {
                if (cell.xyp_x > -cell.xyp_w) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [cell xyf_configGiftData:xyp_waitData];
                        [cell xyf_moveToDisplayGift];
                    });
                } else {
                    [cell xyf_configGiftData:xyp_waitData];
                    [cell xyf_moveToDisplayGift];
                }
            }
            return;
        }
    }
    
    for (int i = 0; i < self.xyp_waitArray.count; i ++) {
        OWLPPReceiveGiftModel * xyp_mm = self.xyp_waitArray[i];
        if ([self xyf_judgeIsTheSameOne:xyp_mm.xyp_giftModel andOther:msg]) {
            xyp_mm.xyp_comboNumber += 1;
            return;
        }
    }
    //加入等待队列
    [self.xyp_waitArray addObject:xyp_waitData];
}

#pragma mark - 定时器
- (void)xyf_nextSecond {
    for (int i = 0; i < 2; i ++) {
        NSInteger xyp_second = [self.xyp_timeArray[i] integerValue];
        if (xyp_second > 0) {
            [self.xyp_timeArray replaceObjectAtIndex:i withObject:@(xyp_second - 1)];
        } else {
            OWLPPReceiveGiftModel * xyp_oneData = self.xyp_ingArray[i];
            if (xyp_oneData.xyp_giftModel != nil) {
                OWLPPReceiveGiftCell * cell = self.xyp_cellArray[i];
                [cell xyf_moveToHideGift];
                [self.xyp_ingArray replaceObjectAtIndex:i withObject:[[OWLPPReceiveGiftModel alloc] init]];
                kXYLWeakSelf;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.xyp_waitArray.count > 0) {
                        [weakSelf.xyp_ingArray replaceObjectAtIndex:i withObject:weakSelf.xyp_waitArray[0]];
                        [weakSelf.xyp_waitArray removeObjectAtIndex:0];
                        [weakSelf.xyp_timeArray replaceObjectAtIndex:i withObject:@(3)];
                        [cell xyf_configGiftData:weakSelf.xyp_ingArray[i]];
                        [cell xyf_moveToDisplayGift];
                    }
                });
            }
        }
    }
}

#pragma mark - 判断是否是同一个人送的同一个礼物
- (BOOL) xyf_judgeIsTheSameOne:(OWLMusicMessageModel *) xyp_one andOther:(OWLMusicMessageModel *) xyp_two {
    return ((xyp_one.dsb_accountID == xyp_two.dsb_accountID) && (xyp_one.dsb_giftID == xyp_two.dsb_giftID));
}

#pragma mark - 进入新的直播间清理数据
- (void) xyf_cleanData {
    [self.xyp_waitArray removeAllObjects];
    for (int i = 0; i < 2; i ++) {
        [self.xyp_ingArray replaceObjectAtIndex:i withObject:[[OWLPPReceiveGiftModel alloc] init]];
        [self.xyp_timeArray replaceObjectAtIndex:i withObject:@(3)];
        OWLPPReceiveGiftCell * cell = self.xyp_cellArray[i];
        CGRect rect = cell.frame;
        rect.origin.x = [self xyf_getCellInitX];
        cell.frame = rect;
    }
}

#pragma mark - Getter
- (CGFloat) xyf_getCellWidth {
    return 262;
}

- (CGFloat) xyf_getCellInitX {
    return OWLJConvertToolShared.xyf_isRTL ? [self xyf_getCellWidth] : -[self xyf_getCellWidth];
}

@end
