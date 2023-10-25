//
//  OWLPPBarrageModel.m
//  AFNetworking
//
//  Created by wdys on 2023/3/16.
//

#import "OWLPPBarrageModel.h"
#import "OWLPPAddAlertTool.h"
#import "OWLBGMModuleVC.h"
#import "OWLMusicTextAttachment.h"

@interface OWLPPBarrageModel ()

/// 昵称大小
@property (nonatomic, assign) CGSize xyp_nicknameSize;
/// 身份标签宽度
@property (nonatomic, assign) CGFloat xyp_identityWidth;
/// 用户标签宽度
@property (nonatomic, assign) CGFloat xyp_userTagWidth;
/// label
@property (nonatomic, strong) UILabel *xyp_textLabel;
/// 礼物弹幕标签
@property (nonatomic, strong) NSTextAttachment *xyp_giftAttach;
/// 用户身份标签
@property (nonatomic, strong) OWLMusicTextAttachment *xyp_medalAttach;
/// 用户身份标签
@property (nonatomic, strong) NSTextAttachment *xyp_labelAttach;
/// 富文本到send有两行
@property (nonatomic, assign) BOOL xyp_twoLineToSend;

@end

@implementation OWLPPBarrageModel

- (void)dealloc {
    NSLog(@"xytest 消息模型dealloc");
}

- (instancetype)initWithModel:(OWLMusicMessageModel *)model {
    if (self = [super init]) {
        self.xyp_msgModel = model;
        [self xyf_configNicknameSize];
        [self xyf_setupAtr];
    }
    return self;
}

//- (void)xyf_refreshMedal:(UIImage *)medalImage {
//    if (self.xyp_medalHasLoad) {
//        return;
//    }
//
//    self.xyp_medalHasLoad = YES;
//    CGFloat width = medalImage.size.width * 14/medalImage.size.height;
//    self.xyp_labelAttach.bounds = CGRectMake(0, -1.5, width, 14);
//    self.xyp_medalFrame = CGRectMake(kXYLMessageTextEdge.left + self.xyp_identityWidth, kXYLMessageTextEdge.top + 2, width, 14);
//    [self xyf_configNicknameFrameWithX:kXYLMessageBubbleMinEdge.left + kXYLMessageTextEdge.left + self.xyp_identityWidth + self.xyp_userTagWidth];
//}

#pragma mark - 初始化富文本
/// 初始化富文本
- (void)xyf_setupAtr {
    self.xyp_atr = [[NSMutableAttributedString alloc] init];
    [self.xyp_atr appendAttributedString:[[NSAttributedString alloc] initWithString:[self xyf_getAtrChar]]];
    switch (self.xyp_msgModel.dsb_msgType) {
        case OWLMusicMessageType_SystemTip:
            [self xyf_setupSystemTipAtr];
            break;
        case OWLMusicMessageType_MuteUser:
            [self xyf_setupMuteUserAtr];
            break;
        case OWLMusicMessageType_JoinRoom:
            [self xyf_setupJoinRoomAtr];
            break;
        case OWLMusicMessageType_TextMessage:
            [self xyf_setupSendTextAtr];
            break;
        case OWLMusicMessageType_SendGift:
            [self xyf_setupSendGiftAtr];
            break;
        default:
            break;
    }
    /// 背景颜色
    [self xyf_configBubbleColor];
    /// 切换左右
    [self.xyp_atr addAttributes:@{NSParagraphStyleAttributeName:[self xyf_getParagraphStyle]} range:NSMakeRange(0, self.xyp_atr.length - 1)];
    /// 计算高度
    [self xyf_configCellSize];
}

/// 初始化系统消息：系统文案
- (void)xyf_setupSystemTipAtr {
    [self xyf_appendText:self.xyp_msgModel.dsb_text color:kXYLColorFromRGB(0xFFEF57)];
}

/// 初始化禁言消息：昵称 + 被禁言
- (void)xyf_setupMuteUserAtr {
    NSString *nickname = [NSString stringWithFormat:@"%@ %@", self.xyp_msgModel.dsb_nickname, [self xyf_getAtrChar]];
    [self xyf_appendText:nickname color:kXYLColorFromRGBA(0xFFFFFF, 0.74)];
    [self.xyp_atr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [self xyf_appendText:kXYLLocalString(@"has been muted!") color:kXYLColorFromRGB(0xFFEF57)];
    [self xyf_configNicknameFrameWithX:kXYLMessageTextEdge.left];
}

/// 初始化进房消息：(身份标签(svip/vip/host) + 标签 + 昵称) + 进房
- (void)xyf_setupJoinRoomAtr {
    [self xyf_setupUserMsgAtr];
    [self xyf_appendText:kXYLLocalString(@"joined the room") color:UIColor.whiteColor];
}

/// 初始化送礼消息：(身份标签(svip/vip/host) + 标签 + 昵称 )+ sent + 礼物图片 + x1
- (void)xyf_setupSendGiftAtr {
    [self xyf_setupUserMsgAtr];
    NSString *sent = [NSString stringWithFormat:@" %@ %@", kXYLLocalString(@"sent"), [self xyf_getAtrChar]];
    [self xyf_appendText:sent color:kXYLColorFromRGB(0xFFEF57)];
    self.xyp_textLabel.attributedText = self.xyp_atr;
    CGSize textSize = [self.xyp_textLabel sizeThatFits:CGSizeMake([self xyf_textMaxWidth], MAXFLOAT)];
    self.xyp_twoLineToSend = textSize.height > 25;
    
    [self xyf_addGiftImage];
    NSString *num = OWLJConvertToolShared.xyf_isRTL ? @" 1x " : @" x1 ";
    [self xyf_appendText:num color:kXYLColorFromRGB(0xFFEF57)];
    if (self.xyp_msgModel.dsb_isblindGift && !OWLMusicInsideManagerShared.xyp_vc.xyp_isUGC) {
        NSString *sent = [NSString stringWithFormat:@" %@ %@", kXYLLocalString(@"by Lucky Box"), [self xyf_getAtrChar]];
        [self xyf_appendText:sent color:kXYLColorFromRGB(0xFFEF57)];
    }
    
}

/// 初始化文本消息：(身份标签(svip/vip/host) + 标签 + 昵称) + 文本
- (void)xyf_setupSendTextAtr {
    [self xyf_setupUserMsgAtr];
    [self xyf_appendText:@":" color:kXYLColorFromRGBA(0xFFFFFF, 0.74)];
    NSString *str = [OWLJConvertToolShared xyf_wordFilter:self.xyp_msgModel.dsb_text];
    NSString *text = [NSString stringWithFormat:@" %@ %@", str, [self xyf_getAtrChar]];
    [self xyf_appendText:text color:UIColor.whiteColor];
}

#pragma mark 初始化富文本相关方法
/// 初始化用户消息：身份标签(svip/vip/host) + 标签 + 昵称
- (void)xyf_setupUserMsgAtr {
    [self xyf_addIdentityLabel];
    [self xyf_addUserTagNew];
    NSString *nickname = [NSString stringWithFormat:@"%@ %@", self.xyp_msgModel.dsb_nickname, [self xyf_getAtrChar]];
    [self xyf_appendText:nickname color:kXYLColorFromRGBA(0xFFFFFF, 0.74)];
    [self xyf_configNicknameFrameWithX:[self xyf_getUserTagLeftMargin] + self.xyp_userTagWidth];
}

/// 添加身份标签
- (void)xyf_addIdentityLabel {
    NSString *iconStr = @"";
    if (self.xyp_msgModel.dsb_userType != OWLMusicMessageUserType_User) {
        if (!OWLJConvertToolShared.xyf_isGreen) {
            iconStr = @"xyr_barrige_host";
        }
    } else {
        if (self.xyp_msgModel.dsb_isSVipUser) {
            iconStr = @"xyr_barrige_svip";
        } else if (self.xyp_msgModel.dsb_isVipUser) {
            iconStr = @"xyr_barrige_vip";
        }
    }
    if (iconStr.length == 0) { return; }
    
    UIImage *iconImage = [XYCUtil xyf_getIconWithName:iconStr];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = iconImage;
    attach.bounds = CGRectMake(0, -2, iconImage.size.width, iconImage.size.height);
    NSAttributedString *identityText = [NSAttributedString attributedStringWithAttachment:attach];
    [self.xyp_atr appendAttributedString:identityText];
    [self.xyp_atr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    self.xyp_identityWidth = iconImage.size.width + 3;
}

/// ============================  最原始方法 =================================
/// 添加用户标签
//- (void)xyf_1 {
//    NSString *tagUrl = self.xyp_msgModel.dsb_tagUrl;
//    if (tagUrl.length == 0) { return; }
//    UIImage *image = [SDImageCache.sharedImageCache imageFromDiskCacheForKey:[SDWebImageManager.sharedManager cacheKeyForURL:[NSURL URLWithString:self.xyp_msgModel.dsb_tagUrl]]];
//    if (image) {
//        [self xyf_appendAndloadUserTagImage:image isDefaultImage:NO];
//        return;
//    }
//
//    [self xyf_appendAndloadUserTagImage:nil isDefaultImage:YES];
//
//    kXYLWeakSelf
//    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.xyp_msgModel.dsb_tagUrl] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        if (error) { return; }
//        [weakSelf xyf_setupAtr];
//        if (weakSelf.refreshUIBlock) { weakSelf.refreshUIBlock(); }
//    }];
//}
//
///// 拼接并加载用户标签图片
//- (void)xyf_appendAndloadUserTagImage:(UIImage *)image isDefaultImage:(BOOL)isDefault {
//    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//
//    if (isDefault) {
//
//        attach.bounds = CGRectMake(0, -3, 36, 14);
//        attach.image = [XYCUtil xyf_scaleToSize:[XYCUtil xyf_getIconWithName:@"xyr_medal_default"] size:CGSizeMake(36, 14)];
//    } else {
//        CGFloat width = image.size.width * 14/image.size.height;
//        UIImage *getImg = [XYCUtil xyf_scaleToSize:image size:CGSizeMake(width, 14)];
//        attach.image = getImg;
//        attach.bounds = CGRectMake(0, -1.5, width, 14);
//    }
//
//    NSAttributedString *tagAtr = [NSAttributedString attributedStringWithAttachment:attach];
//    [self.xyp_atr appendAttributedString:tagAtr];
//    [self.xyp_atr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
//    self.xyp_userTagWidth = attach.bounds.size.width + 3;
//}


/// ============================  自己改的方法 =================================
- (void)xyf_addUserTagNew {
    NSString *tagUrl = self.xyp_msgModel.dsb_tagUrl;
    if (tagUrl.length == 0) { return; }
    UIImage *image = [SDImageCache.sharedImageCache imageFromCacheForKey:[SDWebImageManager.sharedManager cacheKeyForURL:[NSURL URLWithString:self.xyp_msgModel.dsb_tagUrl]]];
    if (image) {
        [self xyf_appendUserTagImage:image isDefaultImage:NO];
        return;
    }

    kXYLWeakSelf;
    [self xyf_appendUserTagImage:nil isDefaultImage:YES];
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.xyp_msgModel.dsb_tagUrl] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (error) { return; }
        [weakSelf xyf_setupAtr];
        if (weakSelf.refreshUIBlock) { weakSelf.refreshUIBlock(); }
    }];
}

- (void)xyf_appendUserTagImage:(UIImage *)image isDefaultImage:(BOOL)isDefault {
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];

    if (isDefault) {
        attach.bounds = CGRectMake(0, -3, 36, 14);
    } else {
        CGFloat width = image.size.width * 14/image.size.height;
        attach.bounds = CGRectMake(0, -1.5, width, 14);
    }
    attach.image = [UIImage new];
    self.xyp_labelAttach = attach;

    NSAttributedString *tagAtr = [NSAttributedString attributedStringWithAttachment:attach];
    [self.xyp_atr appendAttributedString:tagAtr];
    [self.xyp_atr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    self.xyp_userTagWidth = attach.bounds.size.width + 3;
    
    CGFloat margin = [self xyf_getUserTagLeftMargin];
    CGFloat medalX = [OWLJConvertToolShared xyf_isRTL] ? kXYLMessageViewWidth - self.xyp_userTagWidth - margin : margin;
    self.xyp_medalFrame = CGRectMake(medalX, [self xyf_getUserTagY:2], attach.bounds.size.width, attach.bounds.size.height);
}

/// ============================  第一版抄作业方法 =================================
/// 添加用户标签
//- (void)xyf_addUserTagLabel {
//    NSString *tagUrl = self.xyp_msgModel.dsb_tagUrl;
//    if (tagUrl.length == 0) { return; }
//    self.xyp_medalAttach = [[OWLMusicTextAttachment alloc] init];
//    
//    UIImage *image = [SDImageCache.sharedImageCache imageFromDiskCacheForKey:[SDWebImageManager.sharedManager cacheKeyForURL:[NSURL URLWithString:self.xyp_msgModel.dsb_tagUrl]]];
//    if (image.size.height > 0) {
//        CGFloat width = image.size.width * 14/image.size.height;
//        self.xyp_medalAttach.bounds = CGRectMake(0, -1.5, width, 14);
//    } else {
//        self.xyp_medalAttach.bounds = CGRectMake(0, -3, 36, 14);
//    }
//    
//    UIView *clearView = [[UIView alloc]initWithFrame:self.xyp_medalAttach.bounds];
//    clearView.backgroundColor = [UIColor clearColor];
//    self.xyp_medalAttach.image = [clearView xyf_getImageFromView];
//    
//    kXYLWeakSelf
//    self.xyp_medalAttach.xyp_contentViewBlock = ^UIView * _Nonnull{
//        kXYLStrongSelf
//        UIImageView *imageView = [[UIImageView alloc]init];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:strongSelf.xyp_msgModel.dsb_tagUrl] placeholderImage:[XYCUtil xyf_getIconWithName:@"xyr_medal_default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            if(image.size.height > 0){
//                CGFloat width = image.size.width * 14 / image.size.height;
//                strongSelf.xyp_medalAttach.bounds = CGRectMake(0, -2, width, 14);
//                strongSelf.xyp_userTagWidth = width + 4;
//                [strongSelf xyf_callBackRefreshLabel];
//                [strongSelf xyf_refreshNameButtonAfterLoadMedal];
//            }
//        }];
//        return imageView;
//    };
//    
//    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:self.xyp_medalAttach];
//    [self.xyp_atr appendAttributedString:imageString];
//    [self.xyp_atr appendAttributedString: [[NSAttributedString alloc]initWithString:@" "]];
//    self.xyp_userTagWidth = self.xyp_medalAttach.bounds.size.width + 3;
//}
//
///// 加载用户标签之后刷新昵称按钮
//- (void)xyf_refreshNameButtonAfterLoadMedal {
//    [self xyf_configNicknameFrameWithX:kXYLMessageBubbleMinEdge.left + kXYLMessageTextEdge.left + self.xyp_identityWidth + self.xyp_userTagWidth];
//    [self xyf_callBackRefreshNameFrame];
//}

/// 添加礼物
- (void)xyf_addGiftImage {
    OWLMusicGiftInfoModel *giftModel = [[OWLPPAddAlertTool shareInstance] xyf_inquireGiftModelWith:self.xyp_msgModel.dsb_giftID];
    UIImage *image = [SDImageCache.sharedImageCache imageFromDiskCacheForKey:[SDWebImageManager.sharedManager cacheKeyForURL:[NSURL URLWithString:giftModel.dsb_iconImageUrl]]];
    if (image) {
        [self xyf_appendAndloadGiftImage:image isDefaultImage:NO];
        return;
    }
    
    [self xyf_appendAndloadGiftImage:nil isDefaultImage:YES];
    
    kXYLWeakSelf
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:giftModel.dsb_iconImageUrl] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (error) { return; }
        weakSelf.xyp_giftAttach.image = image;
        [weakSelf xyf_callBackRefreshLabel];
    }];
}

/// 拼接并加载礼物图片
- (void)xyf_appendAndloadGiftImage:(UIImage *)image isDefaultImage:(BOOL)isDefault {
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    
    if (isDefault) {
        UIImage *defaultImage = [XYCUtil xyf_scaleToSize:[XYCUtil xyf_getIconWithName:@"xyr_barrage_gift_default"] size:CGSizeMake(30, 30)];
        attach.image = defaultImage;
    } else {
        attach.image = image;
    }
    attach.bounds = CGRectMake(0, -9, 30, 30);
    
    self.xyp_giftAttach = attach;
    NSAttributedString *giftAtr = [NSAttributedString attributedStringWithAttachment:self.xyp_giftAttach];
    [self.xyp_atr appendAttributedString:giftAtr];
    
    self.xyp_textLabel.attributedText = self.xyp_atr;
    CGSize textSize = [self.xyp_textLabel sizeThatFits:CGSizeMake([self xyf_textMaxWidth], MAXFLOAT)];
    /// 🙏🏻希望🈚️人看见这些垃圾代码
    /// 如果到send结尾就两行了 礼物肯定在第二行
    if (self.xyp_twoLineToSend) {
        [self xyf_refreshMedalFrameWithTopMargin:2];
    } else {
        /// 如果拼了礼物为两行，但到send就一行，说明礼物在第二行 标签往下两像素
        /// 如果拼了礼物为一行，说明礼物就在第一行 标签往下8像素
        CGFloat topMargin = textSize.height > 35 ? 2 : 8;
        [self xyf_refreshMedalFrameWithTopMargin:topMargin];
    }
}

- (void)xyf_refreshMedalFrameWithTopMargin:(CGFloat)y {
    CGRect frame = self.xyp_medalFrame;
    CGFloat margin = [self xyf_getUserTagLeftMargin];
    CGFloat medalX = [OWLJConvertToolShared xyf_isRTL] ? kXYLMessageViewWidth - self.xyp_medalFrame.size.width - margin : margin;
    self.xyp_medalFrame = CGRectMake(medalX, [self xyf_getUserTagY:y], frame.size.width, frame.size.height);
}

/// 气泡颜色
- (void)xyf_configBubbleColor {
    switch (self.xyp_msgModel.dsb_msgType) {
        case OWLMusicMessageType_JoinRoom:
        case OWLMusicMessageType_TextMessage:
        case OWLMusicMessageType_SendGift: {
            if (self.xyp_msgModel.dsb_isSVipUser) {
                self.xyp_bgColor = kXYLColorFromRGBA(0x5241E9, 0.7);
            } else if (self.xyp_msgModel.dsb_isVipUser) {
                self.xyp_bgColor = kXYLColorFromRGBA(0xCF0554, 0.4);
            } else {
                self.xyp_bgColor = kXYLColorFromRGBA(0x000000, 0.3);
            }
        }
            break;
        default:
            self.xyp_bgColor = kXYLColorFromRGBA(0x000000, 0.3);
            break;
    }
}

#pragma mark - 计算位置
#pragma mark 昵称按钮相关
- (void)xyf_configNicknameSize {
    NSString *nickname = self.xyp_msgModel.dsb_nickname;
    if (nickname.length <= 0) { return; }
    self.xyp_nicknameSize = [nickname boundingRectWithSize:CGSizeMake([self xyf_textMaxWidth], 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kXYLGilroyBoldFont(14)} context:nil].size;
}

- (void)xyf_configNicknameFrameWithX:(CGFloat)x {
    CGFloat buttonW = self.xyp_nicknameSize.width + 2;
    CGFloat buttonX = [OWLJConvertToolShared xyf_isRTL] ? kXYLMessageViewWidth - x - buttonW : x;
    self.xyp_userButtonFrame = CGRectMake(buttonX, 4 + kXYLMessageBubbleMinEdge.top, buttonW + 1, 18);
}

- (void)xyf_configCellSize {
    self.xyp_textLabel.attributedText = self.xyp_atr;
    CGSize textSize = [self.xyp_textLabel sizeThatFits:CGSizeMake([self xyf_textMaxWidth], MAXFLOAT)];
    CGFloat width = textSize.width + kXYLMessageTextEdge.left + kXYLMessageTextEdge.right + 2;
    CGFloat bubbleW = MIN(width, kXYLMessageViewWidth - kXYLMessageBubbleMinEdge.left - kXYLMessageBubbleMinEdge.right);
    CGFloat bubbleX = OWLJConvertToolShared.xyf_isRTL ? kXYLMessageViewWidth - kXYLMessageBubbleMinEdge.left - bubbleW : kXYLMessageBubbleMinEdge.left;
    CGFloat bubbleY = kXYLMessageBubbleMinEdge.top;
    CGFloat bubbleH = textSize.height + kXYLMessageTextEdge.top + kXYLMessageTextEdge.bottom + 1;
    self.xyp_bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
    self.xyp_cellHeight = kXYLMessageBubbleMinEdge.top + kXYLMessageBubbleMinEdge.bottom + bubbleH;
}

#pragma mark - Private
/// 添加文本
- (void)xyf_appendText:(NSString *)text color:(UIColor *)color {
    NSAttributedString *atr = [[NSAttributedString alloc] initWithString:text attributes:@{
        NSForegroundColorAttributeName: color,
        NSFontAttributeName: kXYLGilroyBoldFont(14)
    }];
    
    [self.xyp_atr appendAttributedString:atr];
}

#pragma mark - 给回调
- (void)xyf_callBackRefreshLabel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_refreshLabel:)]) {
        [self.delegate xyf_refreshLabel:self];
    }
}

- (void)xyf_callBackRefreshNameFrame {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_refreshNameFrame:model:)]) {
        [self.delegate xyf_refreshNameFrame:self.xyp_userButtonFrame model:self];
    }
}

#pragma mark - Getter
- (NSMutableParagraphStyle *)xyf_getParagraphStyle {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = [OWLJConvertToolShared xyf_isRTL] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.hyphenationFactor = 1;
    return style;
}

- (CGFloat)xyf_textMaxWidth {
    return kXYLMessageViewWidth - kXYLMessageBubbleMinEdge.left - kXYLMessageBubbleMinEdge.right - kXYLMessageTextEdge.left - kXYLMessageTextEdge.right;
}

- (NSString *)xyf_getAtrChar {
    return OWLJConvertToolShared.xyf_isRTL ? @"\u202B" : @"\u202A";
}

- (CGFloat)xyf_getUserTagY:(CGFloat)topMargin {
    return kXYLMessageBubbleMinEdge.top + kXYLMessageTextEdge.top + topMargin;
}

- (CGFloat)xyf_getUserTagLeftMargin {
    return kXYLMessageBubbleMinEdge.left + kXYLMessageTextEdge.left + self.xyp_identityWidth;
}

#pragma mark - Lazy
- (UILabel *)xyp_textLabel {
    if (!_xyp_textLabel) {
        _xyp_textLabel = [[UILabel alloc] init];
        _xyp_textLabel.textColor = UIColor.whiteColor;
        _xyp_textLabel.numberOfLines = 0;
        _xyp_textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _xyp_textLabel.font = kXYLGilroyBoldFont(14);
    }
    return _xyp_textLabel;
}

@end
