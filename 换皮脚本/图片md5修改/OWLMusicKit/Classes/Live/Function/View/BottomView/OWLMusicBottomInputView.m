//
//  OWLMusicBottomInputView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/1.
//

#import "OWLMusicBottomInputView.h"

@interface OWLMusicBottomInputView () <UITextViewDelegate>

// MARK: - Views
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 背景容器
@property (nonatomic, strong) UIView *xyp_bgView;
/// 背景容器
@property (nonatomic, strong) UIView *xyp_inputBG;
/// 发送按钮
@property (nonatomic, strong) UIButton *xyp_sendButton;
/// 输入框
@property (nonatomic, strong) UITextView *textView;
/// placeHolder
@property (nonatomic, strong) UILabel *xyp_placeHolderLabel;

// MARK: - Datas
/// 输入框背景上下间距
@property (nonatomic, assign) CGFloat xyp_inputBgUpDownMargin;
/// 输入框背景最大宽度
@property (nonatomic, assign) CGFloat xyp_inputBGWidth;
/// textView的最大高度
@property (nonatomic, assign) CGFloat xyp_inputMaxHeight;
/// textView显示的宽度
@property (nonatomic, assign) CGFloat xyp_inputWidth;
/// 当前textView的高度
@property (nonatomic, assign) CGFloat currentTextViewHeight;
/// textView四周边距
@property (nonatomic, assign) UIEdgeInsets textViewInsets;
/// 当前总的高度
@property (nonatomic, assign) CGFloat currentTotalHeight;
/// 当前输入内容
@property (nonatomic, strong) NSString *currentInputText;

@end

@implementation OWLMusicBottomInputView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupData];
        [self xyf_setupView];
        [self xyf_addNotification];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupData {
    /// 输入框背景上下间距
    self.xyp_inputBgUpDownMargin = [OWLMusicBottomInputView xyf_textBgUpDownMargin];
    /// 输入框背景最大宽度
    self.xyp_inputBGWidth = kXYLScreenWidth - 12 - 52;
    /// textView的最大高度
    self.xyp_inputMaxHeight = 94;
    /// textView周围间距
    self.textViewInsets = UIEdgeInsetsMake(12, 25, 11, 20);
    /// textView显示的宽度
    self.xyp_inputWidth = self.xyp_inputBGWidth - self.textViewInsets.left - self.textViewInsets.right;
    self.currentTextViewHeight = 20;
    self.currentTotalHeight = [OWLMusicBottomInputView xyf_getHeight];
}

- (void)xyf_setupView {
    [self addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_sendButton];
    [self.xyp_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(30);
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-11);
    }];
    
    [self addSubview:self.xyp_inputBG];
    [self.xyp_inputBG addSubview:self.xyp_placeHolderLabel];
    [self.xyp_inputBG addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xyp_inputBG).offset(-self.textViewInsets.bottom);
        make.leading.equalTo(self.xyp_inputBG).offset(self.textViewInsets.left);
        make.trailing.equalTo(self.xyp_inputBG).offset(-self.textViewInsets.right);
        make.height.mas_equalTo(self.currentTextViewHeight);
    }];
    
    [self.xyp_inputBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-self.xyp_inputBgUpDownMargin);
        make.leading.equalTo(self).offset(12);
        make.trailing.equalTo(self).offset(-52);
        make.top.equalTo(self.textView).offset(-self.textViewInsets.top);
    }];
    
}

- (void)xyf_addNotification {
    [self xyf_observeNotification:UIKeyboardWillShowNotification];
    [self xyf_observeNotification:UIKeyboardWillHideNotification];
    [self xyf_observeNotification:UITextViewTextDidChangeNotification];
}

- (BOOL)becomeFirstResponder {
    [self.textView becomeFirstResponder];
    return [super becomeFirstResponder];
}

#pragma mark - Private
#pragma mark 输入框逻辑
/// 输入框内容改变
- (void)textViewContentDidChanged:(UITextView *)textView {
    CGSize countSize = CGSizeMake(self.xyp_inputWidth, MAXFLOAT);
    CGSize size = [textView sizeThatFits:countSize];
    textView.scrollEnabled = size.height >= self.xyp_inputMaxHeight;
    size.height = size.height > self.xyp_inputMaxHeight ? self.xyp_inputMaxHeight : size.height;
    if (size.height != self.currentTextViewHeight) {
        [textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
        /// 输入框改变的高度
        CGFloat textViewChangeHeight = size.height - self.currentTextViewHeight;
        /// 原来的frame
        CGRect beforeFrame = self.frame;
        self.frame = CGRectMake(0, beforeFrame.origin.y - textViewChangeHeight, kXYLScreenWidth, beforeFrame.size.height + textViewChangeHeight);
        [self changeInputHeight:size.height];
        [textView xyf_scrollToBottom];
        [self xyf_callBackToolBarDidChangeInputHeight:XYLModuleChangeInputViewHeightType_Input];
    }
    BOOL isCanSend = [textView.text xyf_stringByTrim].length > 0;
    self.xyp_sendButton.selected = [textView.text xyf_stringByTrim].length > 0;
    self.xyp_sendButton.userInteractionEnabled = isCanSend;
    self.xyp_placeHolderLabel.hidden = textView.text.length > 0;
}

/// 改变输入框高度
- (void)changeInputHeight:(CGFloat)height {
    self.currentTextViewHeight = height;
    self.currentTotalHeight = self.currentTextViewHeight + self.textViewInsets.top + self.textViewInsets.bottom + self.xyp_inputBgUpDownMargin * 2;
}

/// 发消息
- (void)xyf_sendMsg:(NSString *)text {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewSendText:)]) {
        [self.delegate xyf_lModuleBaseViewSendText:text];
    }
}

/// 点击回车或者点击发送
- (void)xyf_sendMsgAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickSendMsg];
    NSString *string = [self.textView.text xyf_stringByTrim];
    if (string.length > 0) {
        [self xyf_sendMsg:self.textView.text];
        self.textView.text = @"";
        [self textViewContentDidChanged:self.textView];
        [self xyf_dismiss];
    } else {
        [OWLJConvertToolShared xyf_showNotiTip:kXYLLocalString(@"Content cannot be empty.")];
        self.textView.text = @"";
        [self textViewContentDidChanged:self.textView];
    }
}

#pragma mark 高度改变逻辑
- (void)xyf_callBackToolBarDidChangeInputHeight:(XYLModuleChangeInputViewHeightType)changeType {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewUpdateKeyboardHeight:changeType:)]) {
        [self.delegate xyf_lModuleBaseViewUpdateKeyboardHeight:self.frame.origin.y changeType:changeType];
    }
}

#pragma mark - Public
+ (CGFloat)xyf_getHeight {
    return 44 + [OWLMusicBottomInputView xyf_textBgUpDownMargin] * 2;
}

- (void)xyf_showInView:(UIView *)view {
    [view addSubview:self.xyp_overyView];
    [view insertSubview:self.xyp_overyView belowSubview:self];
    [self.textView becomeFirstResponder];
}

+ (CGFloat)xyf_textBgUpDownMargin {
    return 6;
}

- (void)xyf_dismiss {
    [self.xyp_overyView removeFromSuperview];
    [self.textView resignFirstResponder];
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        // 过滤textView 拿到当前响应的textView
        if (![self.textView isFirstResponder]) return;

        CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGFloat y = keyboardRect.origin.y;
        
        CGFloat margin = kXYLScreenHeight - y;
        NSLog(@"xytest 键盘高度:%f", margin);
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(0, kXYLScreenHeight - self.currentTotalHeight - margin, kXYLScreenWidth, self.currentTotalHeight);
            [self xyf_callBackToolBarDidChangeInputHeight:XYLModuleChangeInputViewHeightType_Show];
        } completion:^(BOOL finished) {
            
        }];
        
    } else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        // 过滤textView 拿到当前响应的textView
        if (![self.textView isFirstResponder]) return;
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.currentTotalHeight);
            [self xyf_callBackToolBarDidChangeInputHeight:XYLModuleChangeInputViewHeightType_Dismiss];
        }];
        
    } else if ([notification.name isEqualToString:UITextViewTextDidChangeNotification]) {
        
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self textViewContentDidChanged:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length < 1) {
        return YES;
    }
    NSString *content = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([text isEqualToString:@"\n"]) {
        [self xyf_sendMsgAction];
        return NO;
    }
    
//    if ([content isEqualToString:@"\n"]) {  // 回车
//        return NO;
//    }
    
    if (content.length > 80) {
        return NO;
    }
    return YES;
}

#pragma mark - Actions
- (void)xyf_sendButtonAction {
    [self xyf_sendMsgAction];
}

- (void)xyf_overyViewAction {
    [self xyf_dismiss];
}

#pragma mark - Lazy
- (UIControl *)xyp_overyView {
    if (!_xyp_overyView) {
        _xyp_overyView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_overyView.backgroundColor = UIColor.clearColor;
        [_xyp_overyView addTarget:self action:@selector(xyf_overyViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_overyView;
}

- (UIView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIView alloc] init];
        _xyp_bgView.backgroundColor = UIColor.whiteColor;
    }
    return _xyp_bgView;
}

- (UIView *)xyp_inputBG {
    if (!_xyp_inputBG) {
        _xyp_inputBG = [[UIView alloc] init];
        _xyp_inputBG.layer.cornerRadius = 20.5;
        _xyp_inputBG.backgroundColor = kXYLColorFromRGB(0xF5F6F9);
        _xyp_inputBG.clipsToBounds = YES;
    }
    return _xyp_inputBG;
}

- (UIButton *)xyp_sendButton {
    if (!_xyp_sendButton) {
        _xyp_sendButton = [[UIButton alloc] init];
        [_xyp_sendButton setImage:[XYCUtil xyf_getIconWithName:@"xyr_bottom_chat_input_unsend_icon"].xyf_getMirroredImage forState:UIControlStateNormal];
        [_xyp_sendButton setImage:[XYCUtil xyf_getIconWithName:@"xyr_bottom_chat_input_send_icon"].xyf_getMirroredImage forState:UIControlStateSelected];
        [_xyp_sendButton addTarget:self action:@selector(xyf_sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_sendButton;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.textColor = kXYLColorFromRGB(0x000000);
        _textView.font = kXYLGilroyBoldFont(14);
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.backgroundColor = UIColor.clearColor;
        _textView.scrollEnabled = YES;
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.textContainer.lineFragmentPadding = 0;
    }
    return _textView;
}

- (UILabel *)xyp_placeHolderLabel {
    if (!_xyp_placeHolderLabel) {
        _xyp_placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 11, self.xyp_inputBGWidth - 50, 20)];
        _xyp_placeHolderLabel.text = kXYLLocalString(@"Chat with everyone");
        _xyp_placeHolderLabel.textColor = kXYLColorFromRGB(0x999999);
        _xyp_placeHolderLabel.font = kXYLGilroyBoldFont(14);
        _xyp_placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        [_xyp_placeHolderLabel xyf_atl];
    }
    return _xyp_placeHolderLabel;
}

@end
