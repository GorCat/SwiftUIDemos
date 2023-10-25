//
//  OWLPPPairShowView.m
//  qianDuoDuo
//
//  Created by wdys on 2023/3/3.
//

#import "OWLPPPairShowView.h"
#import "OWLMusciCompressionTool.h"

@interface OWLPPPairShowView()<SVGAPlayerDelegate>

@property (nonatomic, strong) SVGAPlayer * xyp_pairPlayer;

@property (nonatomic, assign) BOOL xyp_isMine;

@property (nonatomic, assign) BOOL xyp_needBlock;

@property (nonatomic, assign) NSInteger xyp_playStep;

@end

@implementation OWLPPPairShowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupUI];
    }
    return self;
}

- (SVGAPlayer *)xyp_pairPlayer {
    if (!_xyp_pairPlayer) {
        _xyp_pairPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_pairPlayer.loops = 1;
        _xyp_pairPlayer.delegate = self;
        _xyp_pairPlayer.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xyp_pairPlayer;
}

#pragma mark - UI
- (void) xyf_setupUI {
    self.xyp_playStep = 0;
    [self addSubview:self.xyp_pairPlayer];
    //接收移除svg播放通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xyf_removeSvgNotification:)
                                                 name:xyl_live_clear_room_info
                                               object:nil];
}

#pragma mark - 移除当前播放svg
- (void)xyf_removeSvgNotification:(NSNotification *)notification
{
    [self.xyp_pairPlayer stopAnimation];
    [self removeFromSuperview];
}

#pragma mark - 播放svg动画
- (void) xyf_playAppointSvgWithName:(NSString *) xyp_svgName {
    SVGAParser * xyp_parser = [[SVGAParser alloc] init];
    NSURL * xyp_url = [NSURL fileURLWithPath:[OWLMusciCompressionTool xyf_getPreparedSvgPathFrom:xyp_svgName]];
    if (!xyp_url) {
        return;
    }
    kXYLWeakSelf;
    [xyp_parser parseWithURL:xyp_url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem == nil) {
            [weakSelf xyf_dismiss];
            return;
        }
        self.xyp_pairPlayer.videoItem = videoItem;
        [self.xyp_pairPlayer startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        [weakSelf xyf_dismiss];
    }];
}

#pragma mark - 播放完消失
- (void) xyf_dismiss {
    kXYLWeakSelf;
    [UIView animateWithDuration:.2 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        if (weakSelf.xyp_playEndPair && weakSelf.xyp_needBlock) {
            weakSelf.xyp_playEndPair();
        }
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - 播放匹配成功动画
- (void) xyf_preparePlaySvgWithAncAvatar:(NSString *) xyp_ancAvatar andUAvatar:(NSString *) xyp_uAvatar andAncName:(NSString *) xyp_ancName andUName:(NSString *) xyp_uName andIsMine:(BOOL) xyp_mine {
    self.xyp_needBlock = YES;
    self.xyp_isMine = xyp_mine;
    kXYLWeakSelf;
    [self.xyp_pairPlayer setImage:OWLJConvertToolShared.xyf_userPlaceHolder forKey:@"Avatar_girl"];
    [self.xyp_pairPlayer setImage:OWLJConvertToolShared.xyf_userPlaceHolder forKey:@"Avatar_boy"];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:xyp_ancAvatar] options:SDWebImageAvoidDecodeImage progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (weakSelf.xyp_playStep < 1) {
            UIImage * xyp_aImg = [XYCUtil xyf_scaleToSize:OWLJConvertToolShared.xyf_userPlaceHolder size:CGSizeMake(124, 124)];
            if (image != nil) {
                xyp_aImg = [image xyf_fixOrientation];
            }
            UIImage * xyp_resultImg = [XYCUtil xyf_circleImageWith:[XYCUtil xyf_scaleToSize:xyp_aImg size:CGSizeMake(124, 124)]];
            [weakSelf.xyp_pairPlayer setImage:xyp_resultImg forKey:@"Avatar_girl"];
        }
    }];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:xyp_uAvatar] options:SDWebImageAvoidDecodeImage progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (weakSelf.xyp_playStep < 1) {
            UIImage * xyp_bImg = [XYCUtil xyf_scaleToSize:OWLJConvertToolShared.xyf_userPlaceHolder size:CGSizeMake(124, 124)];
            if (image != nil) {
                xyp_bImg = [image xyf_fixOrientation];
            }
            UIImage * xyp_resultImg = [XYCUtil xyf_circleImageWith:[XYCUtil xyf_scaleToSize:xyp_bImg size:CGSizeMake(124, 124)]];
            [weakSelf.xyp_pairPlayer setImage:xyp_resultImg forKey:@"Avatar_boy"];
        }
    }];
    [self xyf_svgaAddText:xyp_ancName forKey:@"id_girl" alignment:NSTextAlignmentRight];
    [self xyf_svgaAddText:xyp_uName forKey:@"id_boy" alignment:NSTextAlignmentLeft];
    [self xyf_playAppointSvgWithName:@"xyr_live_pair"];
}

#pragma mark - 播放完成目标svg动画
- (void) xyf_preparePlaySvgWithShowName:(NSString *) xyp_name {
    self.userInteractionEnabled = NO;
    self.xyp_pairPlayer.contentMode = UIViewContentModeScaleAspectFit;
    NSString * xyp_str = [NSString stringWithFormat:kXYLLocalString(@"%@ reached the quota!"), xyp_name];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *xyp_attText = [[NSMutableAttributedString alloc] initWithString:xyp_str attributes:@{
        NSFontAttributeName: kXYLGilroyBoldFont(26),
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSParagraphStyleAttributeName: style
    }];
    [self.xyp_pairPlayer setAttributedText:xyp_attText forKey:@"id_msg"];
    [self xyf_playAppointSvgWithName:@"xyr_live_goalDone"];
}

#pragma mark - 播放进入房间svg动画
- (void) xyf_preparePlayJoinRoomSvgWithAvatar:(NSString *) xyp_avatar andName:(NSString *) xyp_name {
    self.userInteractionEnabled = NO;
    self.xyp_pairPlayer.contentMode = UIViewContentModeScaleAspectFit;
    kXYLWeakSelf;
    [self.xyp_pairPlayer setImage:OWLJConvertToolShared.xyf_userPlaceHolder forKey:@"head"];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:xyp_avatar] options:SDWebImageAvoidDecodeImage progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        UIImage * xyp_aImg = [XYCUtil xyf_scaleToSize:OWLJConvertToolShared.xyf_userPlaceHolder size:CGSizeMake(124, 124)];
        if (image != nil) {
            xyp_aImg = [image xyf_fixOrientation];
        }
        UIImage * xyp_resultImg = [XYCUtil xyf_circleImageWith:[XYCUtil xyf_scaleToSize:xyp_aImg size:CGSizeMake(124, 124)]];
        [weakSelf.xyp_pairPlayer setImage:xyp_resultImg forKey:@"head"];
    }];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *xyp_attText = [[NSMutableAttributedString alloc] initWithString:xyp_name attributes:@{
        NSFontAttributeName: kXYLGilroyBoldFont(30),
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSParagraphStyleAttributeName: style
    }];
    [self.xyp_pairPlayer setAttributedText:xyp_attText forKey:@"id"];
    [self xyf_playAppointSvgWithName:@"xyr_live_inroom"];
}

- (void)xyf_svgaAddText:(NSString *)text forKey:(NSString *)key alignment:(NSTextAlignment)alignment
{
    if (self.xyp_playStep > 0) {
        return;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = alignment;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: kXYLGilroyBoldFont(40),
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSParagraphStyleAttributeName: style
    }];
    [self.xyp_pairPlayer setAttributedText:attText forKey:key];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SVGAPlayerDelegate

- (void) svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    if (self.xyp_isMine && self.xyp_playStep < 1) {
        self.xyp_playStep = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self xyf_playAppointSvgWithName:@"xyr_live_countdown"];
        });
    } else {
        [self.xyp_pairPlayer clear];
        [self xyf_dismiss];
    }
}

@end
