//
//  OWLMusicGiftSVGAView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/14.
//

#import "OWLMusicGiftSVGAView.h"

@interface OWLMusicGiftSVGAView () <SVGAPlayerDelegate>

@property (nonatomic, strong) SVGAPlayer *xyp_player;

@property (nonatomic, strong) SVGAParser *xyp_parser;

@property (nonatomic, strong) NSMutableArray *xyp_list;

@property (nonatomic, assign) BOOL xyp_isPlaying;

@property (nonatomic, strong) OWLMusicGiftInfoModel *xyp_currentPlayGift;

@end

@implementation OWLMusicGiftSVGAView

- (void)dealloc {
    [self.xyp_player clear];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 初始化
/// 页面初始化
- (void)xyf_setupView {
    self.userInteractionEnabled = NO;
    [self addSubview:self.xyp_player];
}

#pragma mark - Public
- (void)xyf_dealGiftMessage:(OWLMusicGiftInfoModel *)message {
    if (message && message.dsb_gifUrl.length > 0) {
        if (self.xyp_list.count > 0 || self.xyp_isPlaying) {
            [self.xyp_list addObject:message];
        } else {
            [self xyf_playGift:message];
        }
    }
}

- (void)xyf_removeGift {
    [self.xyp_list removeAllObjects];
    [self.xyp_player stopAnimation];
    self.xyp_isPlaying = NO;
    self.xyp_currentPlayGift = nil;
}

#pragma mark - Private
- (void)xyf_playGift:(OWLMusicGiftInfoModel *)gift {
    self.xyp_isPlaying = YES;
    NSString *giftUrl = gift.dsb_gifUrl;
    NSURL *playUrl;
    if (OWLJConvertToolShared.xyf_isUseMainSVGPath) {
        NSString *svgPath = [OWLJConvertToolShared xyf_getSVGPath:giftUrl];
        if (svgPath.length > 0) {
            playUrl = [NSURL fileURLWithPath:svgPath];
        } else {
            playUrl = [NSURL URLWithString:giftUrl];
        }
    } else {
        playUrl = [NSURL URLWithString:giftUrl];
    }
    
    SVGAVideoEntity *cacheItem = [SVGAVideoEntity readCache:[gift.dsb_gifUrl xyf_md5].uppercaseString];
    self.xyp_currentPlayGift = gift;
    if (cacheItem) {
        self.xyp_player.videoItem = cacheItem;
        [self.xyp_player startAnimation];
    } else {
        kXYLWeakSelf;
        [self.xyp_parser parseWithURL:playUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            if (videoItem != nil && self.xyp_currentPlayGift == gift) {
                self.xyp_player.videoItem = videoItem;
                [self.xyp_player startAnimation];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            weakSelf.xyp_isPlaying = NO;
            if (weakSelf.xyp_list.count > 0) {
                OWLMusicGiftInfoModel *model = weakSelf.xyp_list.firstObject;
                [weakSelf.xyp_list xyf_removeFirstObject];
                [weakSelf xyf_playGift:model];
            }
        }];
    }
}


#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    [player clear];
    [player clearDynamicObjects];
    if (player != self.xyp_player) { return; }
    if (self.xyp_list.count > 0) {
        OWLMusicGiftInfoModel *model = self.xyp_list.firstObject;
        [self.xyp_list xyf_removeFirstObject];
        [self xyf_playGift:model];
    } else {
        self.xyp_isPlaying = NO;
    }
}

#pragma mark - Lazy
- (SVGAPlayer *)xyp_player {
    if (!_xyp_player) {
        _xyp_player = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_player.delegate = self;
        _xyp_player.loops = 1;
        _xyp_player.clearsAfterStop = YES;
        _xyp_player.contentMode = UIViewContentModeBottom;
        _xyp_player.userInteractionEnabled = NO;
    }
    return _xyp_player;
}

- (SVGAParser *)xyp_parser {
    if (!_xyp_parser) {
        _xyp_parser = [[SVGAParser alloc] init];
        _xyp_parser.enabledMemoryCache = NO;
    }
    return _xyp_parser;
}

- (NSMutableArray *)xyp_list {
    if (!_xyp_list) {
        _xyp_list = [[NSMutableArray alloc] init];
    }
    return _xyp_list;
}

@end
