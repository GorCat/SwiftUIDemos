//
//  OWLBGMReportAlertView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

/**
 * @功能描述：直播间举报弹窗
 * @创建时间：2023.2.10
 * @创建人：许琰
 */

#import "OWLBGMReportAlertView.h"
#import "OWLBGMReportUploadImageCell.h"
#import "OWLMusicSystemAuthManager.h"

@interface OWLBGMReportAlertView () <
UITextViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

#pragma mark - Views
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 举报标题
@property (nonatomic, strong) UILabel *xyp_reportLabel;
/// 输入框背景
@property (nonatomic, strong) UITextView *xyp_textView;
/// placeHolder
@property (nonatomic, strong) UILabel *xyp_placeHolderLabel;
/// 图片标题
@property (nonatomic, strong) UILabel *xyp_picLabel;
/// 图片列表
@property (nonatomic, strong) UICollectionView *xyp_collectionView;
/// 提交按钮
@property (nonatomic, strong) UIButton *xyp_submitButton;

#pragma mark - Data
/// 图片链接数据
@property (nonatomic, strong) NSMutableArray *xyp_picUrlList;
/// 图片列表数据
@property (nonatomic, strong) NSMutableArray *xyp_picDataList;
/// 相关ID
@property (nonatomic, assign) NSInteger xyp_relationID;

#pragma mark - Layout
/// 总高度
@property (nonatomic, assign) CGFloat xyp_totalHeight;
/// 列表上下左右距离视图的边距
@property (nonatomic, assign) UIEdgeInsets xyp_listMarginInsets;
/// cell之间的距离
@property (nonatomic, assign) CGFloat xyp_cellMargin;
/// cell宽高
@property (nonatomic, assign) CGFloat xyp_cellWH;

#pragma mark - BOOL
/// 是否显示键盘
@property (nonatomic, assign) BOOL xyp_isShowKeyboard;
/// 是否是UGC房间房主
@property (nonatomic, assign) BOOL xyp_isUGCRoomOwner;
/// 相册是否已经消失
@property (nonatomic, assign) BOOL xyp_photoVCIsDismiss;

#pragma mark - Block
/// 弹窗消失的回调
@property (nonatomic, copy, nullable) XYLVoidBlock xyp_dismissBlock;

@end

@implementation OWLBGMReportAlertView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

+ (instancetype)xyf_showReportUserAlertView:(id<OWLBGMModuleBaseViewDelegate>)delegate
                                 targetView:(UIView *)targetView
                                 relationID:(NSInteger)relationID
                             isUGCRoomOwner:(BOOL)isUGCRoomOwner
                               dismissBlock:(XYLVoidBlock)dismissBlock {
    OWLBGMReportAlertView *view = [[OWLBGMReportAlertView alloc] initWithDismissBlock:dismissBlock];
    view.xyp_relationID = relationID;
    view.xyp_isUGCRoomOwner = isUGCRoomOwner;
    [view xyf_showInView:targetView];
    
    return view;
}

- (instancetype)initWithDismissBlock:(XYLVoidBlock)dismissBlock {
    self = [super init];
    if (self) {
        self.xyp_dismissBlock = dismissBlock;
        [self xyp_setupNotification];
        [self xyf_setupLayout];
        [XYCUtil xyf_clickRadius:20 alertView:self];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
/// 初始化layout
- (void)xyf_setupLayout {
    /// 提交按钮底部间距
    CGFloat submitBottomMargin = [XYCUtil xyf_isIPhoneX] ? 34 : 24;
    /// 列表底部间距
    CGFloat listBottomMargin = 26 + 55 + submitBottomMargin;
    self.xyp_listMarginInsets = UIEdgeInsetsMake(211.5, 16, listBottomMargin, 16 - 4);
    /// cell之间间距 = 图片间隔距离8 - 删除按钮突出去的4
    self.xyp_cellMargin = 4;
    /// cell宽高
    self.xyp_cellWH = floor((kXYLScreenWidth - (self.xyp_listMarginInsets.left + self.xyp_listMarginInsets.right) - (3.0 * self.xyp_cellMargin)) / 4.0);
    /// 视图实际高度 = 图片列表顶部 + 图片列表高度 + 图片列表底部
    self.xyp_totalHeight = self.xyp_listMarginInsets.top + self.xyp_cellWH + self.xyp_listMarginInsets.bottom;
    self.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.xyp_totalHeight);
}

/// 初始化视图
- (void)xyf_setupView {
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.xyp_reportLabel];
    [self.xyp_reportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(16);
        make.trailing.equalTo(self).offset(-16);
    }];
    
    [self addSubview:self.xyp_textView];
    [self.xyp_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(16);
        make.trailing.equalTo(self).offset(-16);
        make.height.mas_equalTo(126);
        make.top.equalTo(self.xyp_reportLabel.mas_bottom);
    }];
    
    [self.xyp_textView addSubview:self.xyp_placeHolderLabel];
    
    [self addSubview:self.xyp_picLabel];
    [self.xyp_picLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.equalTo(self.xyp_textView.mas_bottom).offset(4);
        make.leading.equalTo(self).offset(16);
        make.trailing.equalTo(self).offset(-16);
    }];
    
    [self addSubview:self.xyp_collectionView];
    [self.xyp_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(self.xyp_listMarginInsets.left);
        make.trailing.equalTo(self).offset(-self.xyp_listMarginInsets.right);
        make.height.mas_equalTo(self.xyp_cellWH);
        make.top.equalTo(self).offset(self.xyp_listMarginInsets.top);
    }];
    
    [self addSubview:self.xyp_submitButton];
    [self.xyp_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_collectionView.mas_bottom).offset(26);
        make.leading.equalTo(self).offset(16);
        make.trailing.equalTo(self).offset(-16);
        make.height.mas_equalTo(55);
    }];
}

/// 初始化通知
- (void)xyp_setupNotification {
    [self xyf_observeNotification:UIKeyboardWillShowNotification];
    [self xyf_observeNotification:UIKeyboardWillHideNotification];
}

#pragma mark - 动画
/// 展示
- (void)xyf_showInView:(UIView *)superView {
    CGRect rect = self.frame;
    rect.origin.y = kXYLScreenHeight - self.xyp_totalHeight;
    [superView addSubview:self.xyp_overyView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    }];
}

/// 消失
- (void)xyf_dismiss {
    CGRect rect = self.frame;
    rect.origin.y = kXYLScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.xyp_overyView removeFromSuperview];
        !self.xyp_dismissBlock?:self.xyp_dismissBlock();
    }];
}

#pragma mark - 更新图片数据
- (void)xyf_refreshPictureView {
    [self.xyp_collectionView reloadData];
}

#pragma mark - Delegate
#pragma mark UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.xyp_picDataList.count > 3 ? 4: self.xyp_picDataList.count + 1;
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OWLBGMReportUploadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OWLBGMReportUploadImageCell class]) forIndexPath:indexPath];
    if (self.xyp_picDataList.count > indexPath.row) {
        kXYLWeakSelf;
        [cell xyf_setupPicture:self.xyp_picDataList[indexPath.row]];
        cell.xyp_deleltePicture = ^{
            [weakSelf.xyp_picDataList removeObjectAtIndex:indexPath.row];
            [weakSelf.xyp_picUrlList removeObjectAtIndex:indexPath.row];
            [weakSelf xyf_refreshPictureView];
        };
    } else {
        [cell xyf_setupPicture:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.xyp_picDataList.count > indexPath.row) {
        return;
    }
    [[OWLMusicSystemAuthManager sharedInstance] xyf_openAlbum:self];
}

#pragma mark UIImagePickerControllerDelegate 相册回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.xyp_photoVCIsDismiss) {
        return;
    }
    self.xyp_photoVCIsDismiss = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    kXYLWeakSelf;
    [OWLJConvertToolShared xyf_showLoading];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [[OWLBGMModuleManagerConvertTool shareInstance] xyf_updateImage:image isNeedJH:NO completion:^(BOOL success, NSString * _Nonnull photoUrl) {
        [OWLJConvertToolShared xyf_hideLoading];
        if (!success) {
            return;
        }
        [weakSelf.xyp_picDataList addObject:image];
        [weakSelf.xyp_picUrlList addObject:photoUrl];
        [weakSelf xyf_refreshPictureView];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.xyp_photoVCIsDismiss = NO;
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - uitextView delegate
- (void)textViewDidChange:(UITextView *)textView {
    self.xyp_placeHolderLabel.hidden = textView.text.length > 0;
    UITextRange *selectedRange = [textView markedTextRange];
    // 获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    // 如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        return;
    }
    
    self.xyp_reportLabel.text = [NSString stringWithFormat:kXYLLocalString(@"Please describe the report detail(%ld/300)"), textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self endEditing:YES];
        return YES;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    // 如果是高亮部分在变化，就直接返回
    if (selectedRange && pos) {
        return YES;
    }
    // 如果是删除，就返回
    if ([text isEqual: @""]) {
        return YES;
    }
    // 截取字符串
    NSString *string = textView.text;
    if (string.length >= 300) {
        string = [XYCUtil xyf_subToString:string maxLength:300];
        self.xyp_textView.text = string;
        return false;
    }
    return YES;
}

#pragma mark - Actions
- (void)xyf_overyViewAction {
    if (self.xyp_isShowKeyboard) {
        [self.xyp_textView resignFirstResponder];
    } else {
        [self xyf_dismiss];
    }
}

#pragma mark - 提交
- (void)xyf_submitButtonClicked {
    NSString *string = [self.xyp_textView.text xyf_stringByTrim];
    if (string.length < 1) {
        [OWLJConvertToolShared xyf_showNotiTip:kXYLLocalString(@"Content cannot be empty.")];
        return;
    }
    [OWLJConvertToolShared xyf_showLoading];
    kXYLWeakSelf;
    [OWLMusicRequestApiManager xyf_requestReport:self.xyp_relationID content:self.xyp_textView.text images:self.xyp_picUrlList isUGCRoomOwner:self.xyp_isUGCRoomOwner completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        [OWLJConvertToolShared xyf_hideLoading];
        if (aResponse.xyf_success) {
            [OWLJConvertToolShared xyf_showSuccessTip:kXYLLocalString(@"We have received your report and will solve it ASAP.")];
            [weakSelf xyf_dismiss];
            if (weakSelf.xyp_isUGCRoomOwner) {
                OWLMusicInsideManagerShared.xyp_isNeedRefreshHomeList = YES;
                [OWLMusicInsideManagerShared xyf_insideCloseLivePage:YES];
            }
        } else {
            [OWLJConvertToolShared xyf_showErrorTip:kXYLLocalString(@"Report error, please try again.")];
        }
    }];
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        // 过滤textView 拿到当前响应的textView
        if (![self.xyp_textView isFirstResponder]) return;
        self.xyp_isShowKeyboard = YES;
        
        CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGFloat y = keyboardRect.origin.y;
        
        CGFloat margin = kXYLScreenHeight - y;
        NSLog(@"xytest 键盘高度:%f", margin);
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(0, kXYLScreenHeight - self.xyp_listMarginInsets.top - margin, kXYLScreenWidth, self.xyp_totalHeight);
        } completion:^(BOOL finished) {
            
        }];
        
    } else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        // 过滤textView 拿到当前响应的textView
        if (![self.xyp_textView isFirstResponder]) return;
        self.xyp_isShowKeyboard = NO;
        
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(0, kXYLScreenHeight - self.xyp_totalHeight, kXYLScreenWidth, self.xyp_totalHeight);
        }];
    }
}

#pragma mark - Lazy
- (NSMutableArray *)xyp_picUrlList {
    if (!_xyp_picUrlList) {
        _xyp_picUrlList = [NSMutableArray array];
    }
    return _xyp_picUrlList;
}

- (NSMutableArray *)xyp_picDataList {
    if (!_xyp_picDataList) {
        _xyp_picDataList = [NSMutableArray array];
    }
    return _xyp_picDataList;
}

- (UIControl *)xyp_overyView {
    if (!_xyp_overyView) {
        _xyp_overyView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_overyView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.3);
        [_xyp_overyView addTarget:self action:@selector(xyf_overyViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_overyView;
}

- (UILabel *)xyp_reportLabel {
    if (!_xyp_reportLabel) {
        _xyp_reportLabel = [[UILabel alloc] init];
        _xyp_reportLabel.font = kXYLGilroyBoldFont(14);
        _xyp_reportLabel.text = [NSString stringWithFormat:kXYLLocalString(@"Please describe the report detail(%ld/300)"), 0];
        _xyp_reportLabel.textColor = kXYLColorFromRGB(0x333333);
    }
    return _xyp_reportLabel;
}

- (UITextView *)xyp_textView {
    if (!_xyp_textView) {
        _xyp_textView = [[UITextView alloc] init];
        _xyp_textView.delegate = self;
        _xyp_textView.textColor = kXYLColorFromRGB(0x333333);
        _xyp_textView.font = kXYLGilroyBoldFont(14);
        _xyp_textView.enablesReturnKeyAutomatically = YES;
        _xyp_textView.keyboardType = UIKeyboardTypeDefault;
        _xyp_textView.backgroundColor = UIColor.clearColor;
        _xyp_textView.scrollEnabled = YES;
        _xyp_textView.textContainerInset = UIEdgeInsetsMake(12, 8, 12, 8);
        _xyp_textView.textContainer.lineFragmentPadding = 0;
        _xyp_textView.showsVerticalScrollIndicator = NO;
        _xyp_textView.layer.cornerRadius = 10;
        _xyp_textView.returnKeyType = UIReturnKeyDone;
        _xyp_textView.backgroundColor = kXYLColorFromRGB(0xF4F4F4);
    }
    return _xyp_textView;
}

- (UILabel *)xyp_placeHolderLabel {
    if (!_xyp_placeHolderLabel) {
        _xyp_placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 12, kXYLScreenWidth - (24 * 2), 17)];
        _xyp_placeHolderLabel.text = kXYLLocalString(@"Please describe the report detail");
        _xyp_placeHolderLabel.textColor = kXYLColorFromRGB(0x7F7F7F);
        _xyp_placeHolderLabel.font = kXYLGilroyMediumFont(14);
        _xyp_placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        [_xyp_placeHolderLabel xyf_atl];
    }
    return _xyp_placeHolderLabel;
}

- (UILabel *)xyp_picLabel {
    if (!_xyp_picLabel) {
        _xyp_picLabel = [[UILabel alloc] init];
        _xyp_picLabel.font = kXYLGilroyBoldFont(14);
        _xyp_picLabel.text = kXYLLocalString(@"Upload image(Maximum of 4)");
        _xyp_picLabel.textColor = kXYLColorFromRGB(0x333333);
    }
    return _xyp_picLabel;
}

- (UICollectionView *)xyp_collectionView {
    if (!_xyp_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.xyp_cellWH, self.xyp_cellWH);
        layout.minimumLineSpacing = self.xyp_cellMargin;
        layout.minimumInteritemSpacing = self.xyp_cellMargin;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _xyp_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _xyp_collectionView.backgroundColor = [UIColor clearColor];
        _xyp_collectionView.showsVerticalScrollIndicator = NO;
        _xyp_collectionView.showsHorizontalScrollIndicator = NO;
        _xyp_collectionView.delegate = self;
        _xyp_collectionView.dataSource = self;
        [_xyp_collectionView registerClass:[OWLBGMReportUploadImageCell class] forCellWithReuseIdentifier:NSStringFromClass([OWLBGMReportUploadImageCell class])];
        if (@available(iOS 11.0, *)) {
            _xyp_collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _xyp_collectionView;
}

- (UIButton *)xyp_submitButton {
    if (!_xyp_submitButton) {
        _xyp_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _xyp_submitButton.backgroundColor = kXYLColorFromRGB(0xEA417F);
        [_xyp_submitButton setTitle:kXYLLocalString(@"Submit") forState:UIControlStateNormal];
        [_xyp_submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _xyp_submitButton.titleLabel.font = kXYLGilroyBoldFont(16);
        _xyp_submitButton.layer.cornerRadius = 27.5;
        _xyp_submitButton.clipsToBounds = YES;
        [_xyp_submitButton addTarget:self action:@selector(xyf_submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_submitButton;
}

@end
