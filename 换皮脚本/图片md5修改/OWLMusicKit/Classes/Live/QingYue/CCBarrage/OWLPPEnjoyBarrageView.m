//
//  OWLPPEnjoyBarrageView.m
//  qianDuoDuo
//
//  Created by wdys on 2023/3/1.
//

#import "OWLPPEnjoyBarrageView.h"
#import "OWLPPEnjoyBarrageCell.h"
#import "OWLMusicEnjoyPromptBtn.h"
#import "OWLPPAddAlertTool.h"
#import "OWLPPBarrageModel.h"

@interface OWLPPEnjoyBarrageView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView * xyp_maskView;

@property (nonatomic, strong) UITableView * xyp_tableView;

@property (nonatomic, strong) NSMutableArray * xyp_dataArray;//弹幕数组

@property (nonatomic, strong) NSMutableArray * xyp_poolArray;//等待显示的弹幕数组

@property (nonatomic, strong) OWLMusicEnjoyPromptBtn * xyp_promptBtn;//提示按钮

@property (nonatomic, assign) bool xyp_hasSayHi;//是否已经弹出sayHi

@property (nonatomic, assign) bool xyp_hasSendGg;//是否已经弹出送礼物

@property (nonatomic, assign) bool xyp_hasFollow;//是否已经弹出关注

@property (nonatomic, assign) NSInteger xyp_tipSecond;

@property (nonatomic, strong) UIButton * xyp_scrolBtn;

@property (nonatomic, assign) BOOL xyp_showTip;

@end

@implementation OWLPPEnjoyBarrageView

- (instancetype)init {
    if (self = [super init]) {
        [self xyf_setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupUI];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"xytest 弹幕视图dealloc");
}

- (NSMutableArray *)xyp_dataArray {
    if (!_xyp_dataArray) {
        _xyp_dataArray = [NSMutableArray array];
    }
    return _xyp_dataArray;
}

- (NSMutableArray *)xyp_poolArray {
    if (!_xyp_poolArray) {
        _xyp_poolArray = [NSMutableArray array];
    }
    return _xyp_poolArray;
}

- (UIView *)xyp_maskView {
    if (!_xyp_maskView) {
        _xyp_maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.xyp_w, self.xyp_h)];
        _xyp_maskView.backgroundColor = UIColor.clearColor;
    }
    return _xyp_maskView;
}

- (UITableView *)xyp_tableView {
    if (!_xyp_tableView) {
        _xyp_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.xyp_w, self.xyp_h) style:UITableViewStyleGrouped];
        _xyp_tableView.backgroundColor = UIColor.clearColor;
        _xyp_tableView.delegate = self;
        _xyp_tableView.dataSource = self;
        _xyp_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _xyp_tableView.showsVerticalScrollIndicator = NO;
        _xyp_tableView.estimatedSectionFooterHeight = 0.01;
        if (@available(iOS 11.0, *)) {
            _xyp_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        _xyp_tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _xyp_tableView;
}

- (OWLMusicEnjoyPromptBtn *)xyp_promptBtn {
    if (!_xyp_promptBtn) {
        _xyp_promptBtn = [[OWLMusicEnjoyPromptBtn alloc] initWithFrame:CGRectMake(0, self.xyp_h, 256, 41)];
    }
    return _xyp_promptBtn;
}

- (UIButton *)xyp_scrolBtn {
    if (!_xyp_scrolBtn) {
        _xyp_scrolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xyp_scrolBtn.backgroundColor = UIColor.clearColor;
        [_xyp_scrolBtn setBackgroundImage:[XYCUtil xyf_getIconWithNameInMainLanguage:@"xyr_barrage_new_msg"] forState:UIControlStateNormal];
        [_xyp_scrolBtn addTarget:self action:@selector(xyf_scrollToBottom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_scrolBtn;
}

#pragma mark - UI
- (void) xyf_setupUI {
    self.xyp_tipSecond = 100;
    self.clipsToBounds = YES;
    [self addSubview:self.xyp_maskView];
    [self.xyp_maskView xyf_addDefaultGradientMaskView];
    [self.xyp_maskView addSubview:self.xyp_tableView];
    [self addSubview:self.xyp_promptBtn];
    self.xyp_scrolBtn.hidden = YES;
    [self addSubview:self.xyp_scrolBtn];
    [self.xyp_scrolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xyp_tableView);
        make.leading.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake(59, 25));
    }];
    kXYLWeakSelf;
    self.xyp_promptBtn.xyp_tapPromptThis = ^(XYLPromptType xyp_type) {
        switch (xyp_type) {
            case XYLPromptType_SayHi:
            {
                if ([weakSelf.xyp_delegate respondsToSelector:@selector(xyf_sayHi)]) {
                    [weakSelf.xyp_delegate xyf_sayHi];
                }
                [OWLMusicTongJiTool xyf_thinkingWithName:XYLThinkingEventClickMsgAutoSayHi];
            }
                break;
            case XYLPromptType_SendGift:
            {
                if ([weakSelf.xyp_delegate respondsToSelector:@selector(xyf_openSendGiftAlert)]) {
                    [weakSelf.xyp_delegate xyf_openSendGiftAlert];
                }
                [OWLMusicTongJiTool xyf_thinkingWithName:XYLThinkingEventClickMsgAutoSendGift];
            }
                break;
            case XYLPromptType_Follow:
            {
                if ([weakSelf.xyp_delegate respondsToSelector:@selector(xyf_followHer)]) {
                    [weakSelf.xyp_delegate xyf_followHer];
                }
                [OWLMusicTongJiTool xyf_thinkingWithName:XYLThinkingEventClickMsgAutoFollow];
            }
                break;
                
            default:
                break;
        }
        [weakSelf xyf_refreshFrameShowPrompt:NO];
    };
}

#pragma mark - 新房间RTM链接成功后开始计时操作
- (void) xyf_joinRoomSuccess {
    self.xyp_tipSecond = 0;
    self.xyp_hasSayHi = self.xyp_hasSendGg = self.xyp_hasFollow = NO;
}

#pragma mark - 定时器操作
- (void) xyf_nextSecondAction {
    [self refreshPoolBarrageData];
    self.xyp_tipSecond += 1;
    if (self.xyp_tipSecond % 12 != 0) {
        return;
    }
    NSInteger xyp_times = self.xyp_tipSecond / 12;
    if (xyp_times < 1 || xyp_times > 7) {
        return;
    }
    if (xyp_times % 2 == 1) {
        if (![OWLPPAddAlertTool shareInstance].xyf_hasSendBarrage) {
            if (!self.xyp_hasSayHi) {
                [self.xyp_promptBtn xyf_setupButtonType:XYLPromptType_SayHi];
                [self xyf_refreshFrameShowPrompt:YES];
                self.xyp_hasSayHi = YES;
                return;
            }
        }
        if (![OWLPPAddAlertTool shareInstance].xyf_hasSendGift) {
            if (!self.xyp_hasSendGg) {
                [self.xyp_promptBtn xyf_setupButtonType:XYLPromptType_SendGift];
                [self xyf_refreshFrameShowPrompt:YES];
                self.xyp_hasSendGg = YES;
                return;
            }
        }
        if (![OWLPPAddAlertTool shareInstance].xyf_hasFollowed) {
            if (!self.xyp_hasFollow) {
                [self.xyp_promptBtn xyf_setupButtonType:XYLPromptType_Follow];
                [self xyf_refreshFrameShowPrompt:YES];
                self.xyp_hasFollow = YES;
                return;
            }
        }
    } else {
        if (self.xyp_promptBtn.xyp_y < self.xyp_h) {
            [self xyf_refreshFrameShowPrompt:NO];
        }
    }
}

#pragma mark - 修改提示及frame
- (void) xyf_refreshFrameShowPrompt:(BOOL)show {
    self.xyp_showTip = show;
    [self xyf_updateFrame];
}

#pragma mark - 修改frame
- (void) xyf_updateFrame {
    CGRect xyp_tbRect = self.xyp_tableView.frame;
    CGRect xyp_btnRect = self.xyp_promptBtn.frame;
    kXYLWeakSelf;
    if (self.xyp_showTip) {
        xyp_tbRect.origin.y = -41;
        xyp_btnRect.origin.y = self.xyp_h - 41;
        self.xyp_tableView.frame = xyp_tbRect;
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1 initialSpringVelocity:12 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.xyp_promptBtn.frame = xyp_btnRect;
        } completion:nil];
    } else {
        xyp_tbRect.origin.y = 0;
        xyp_btnRect.origin.y = self.xyp_h;
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1 initialSpringVelocity:12 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.xyp_tableView.frame = xyp_tbRect;
            weakSelf.xyp_promptBtn.frame = xyp_btnRect;
        } completion:nil];
    }
}

#pragma mark - 外部修改tableview frame 方法
- (void) xyf_outsideChangeTableViewFrame {
    CGRect xyp_tbRect = self.xyp_tableView.frame;
    CGRect xyp_btnRect = self.xyp_promptBtn.frame;
    if (self.xyp_showTip) {
        xyp_tbRect.origin.y = -41;
        xyp_btnRect.origin.y = self.xyp_h - 41;
        xyp_tbRect.size.height = self.xyp_h;
        self.xyp_tableView.frame = xyp_tbRect;
        self.xyp_promptBtn.frame = xyp_btnRect;
    } else {
        xyp_tbRect.origin.y = 0;
        xyp_btnRect.origin.y = self.xyp_h;
        xyp_tbRect.size.height = self.xyp_h;
        self.xyp_tableView.frame = xyp_tbRect;
        self.xyp_promptBtn.frame = xyp_btnRect;
    }
    
    [self xyf_scrollToBottom];
}

#pragma mark - 添加立即显示的弹幕信息
- (void) xyf_addImmediatelyBarrageWith:(OWLMusicMessageModel *)model {
    /// 容错处理 fix 张老师瞎发消息的bug →_→
    if (model.dsb_msgType == OWLMusicMessageType_TextMessage && model.dsb_text.length == 0) {
        return;
    }
    OWLPPBarrageModel *message = [self xyf_configBarrageModel:model];
    [self.xyp_dataArray addObject:message];
    self.xyp_scrolBtn.hidden = YES;
    [self.xyp_tableView reloadData];
    [self xyf_scrollToBottom];
}

#pragma mark - 添加弹幕信息到等待显示池中
- (void)xyf_addOneBarrageToPoolWith:(OWLMusicMessageModel *)model {
    /// 容错处理 fix 张老师瞎发消息的bug →_→
    if (model.dsb_msgType == OWLMusicMessageType_TextMessage && model.dsb_text.length == 0) {
        return;
    }
    OWLPPBarrageModel *message = [self xyf_configBarrageModel:model];
    [self.xyp_poolArray addObject:message];
}

- (OWLPPBarrageModel *)xyf_configBarrageModel:(OWLMusicMessageModel *)model {
    OWLPPBarrageModel *message = [[OWLPPBarrageModel alloc] initWithModel:model];
    kXYLWeakSelf
    message.refreshUIBlock = ^{
        [weakSelf.xyp_tableView reloadData];
    };
    return message;
}

#pragma mark - 刷新弹幕显示
- (void) refreshPoolBarrageData {
    if (self.xyp_poolArray.count < 1) {
        return;
    }
    [self.xyp_dataArray addObjectsFromArray:self.xyp_poolArray];
    [self.xyp_poolArray removeAllObjects];
    if (self.xyp_dataArray.count > 120) {
        NSInteger count = self.xyp_dataArray.count - 120;
        for (int i = 0; i < count; i ++) {
            [self.xyp_dataArray xyf_removeFirstObject];
        }
    }
    if (self.xyp_tableView.contentSize.height < self.xyp_h + 50) {
        [self.xyp_tableView reloadData];
        [self xyf_scrollToBottom];
        return;
    }
    if (self.xyp_tableView.contentOffset.y < (self.xyp_tableView.contentSize.height - self.xyp_h - 50)) {
        self.xyp_scrolBtn.hidden = NO;
        [self.xyp_tableView reloadData];
    } else {
        self.xyp_scrolBtn.hidden = YES;
        [self.xyp_tableView reloadData];
        [self xyf_scrollToBottom];
    }
}

#pragma mark - 滑动到底部
- (void) xyf_scrollToBottom {
    self.xyp_scrolBtn.hidden = YES;
    if (self.xyp_dataArray.count < 1) {
        return;
    }
    [self.xyp_tableView xyf_scrollToRow:self.xyp_dataArray.count - 1 inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:true];
}

#pragma mark - 清空数据
- (void)xyf_cleanData {
    self.xyp_tipSecond = 0;
    [self xyf_refreshFrameShowPrompt:NO];
    [self.xyp_dataArray removeAllObjects];
    [self.xyp_poolArray removeAllObjects];
    [self.xyp_tableView reloadData];
}

#pragma mark - tableview delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xyp_dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.xyp_tableView.contentSize.height > self.xyp_tableView.xyp_h ? 55 : 150;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OWLPPBarrageModel *message = [self.xyp_dataArray xyf_objectAtIndexSafe:indexPath.row];
    NSString *cellID = [NSString stringWithFormat:@"barrageCellName%ld",message.xyp_msgModel.dsb_msgType];
    OWLPPEnjoyBarrageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OWLPPEnjoyBarrageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = message;
    kXYLWeakSelf
    cell.clickNickname = ^{
        if ([weakSelf.xyp_delegate respondsToSelector:@selector(xyf_clickNickname:andType:)]) {
            [weakSelf.xyp_delegate xyf_clickNickname:message.xyp_msgModel.dsb_accountID andType:message.xyp_msgModel.dsb_userType];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OWLPPBarrageModel *message = [self.xyp_dataArray xyf_objectAtIndexSafe:indexPath.row];
    return message.xyp_cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@", [NSString stringWithFormat:@"y:%.2f - height:%.2f",self.xyp_tableView.contentOffset.y, self.xyp_tableView.contentSize.height]);
    if (self.xyp_tableView.contentOffset.y > (self.xyp_tableView.contentSize.height - self.xyp_h - 10)) {
        self.xyp_scrolBtn.hidden = YES;
    }
}

@end
