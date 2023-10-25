//
//  OWLMusicVideoManager.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/30.
//

#import "OWLMusicVideoManager.h"
#import "OWLMusicVideoContentView.h"
@interface OWLMusicVideoManager ()

/// 小窗
@property (nonatomic, strong) OWLMusicVideoContentView *xyp_smallView;
/// 全屏
@property (nonatomic, strong) OWLMusicVideoContentView *xyp_bigView;

@end

@implementation OWLMusicVideoManager




#pragma mark - Lazy
- (OWLMusicVideoContentView *)xyp_smallView {
    if (!_xyp_smallView) {
        _xyp_smallView = [[OWLMusicVideoContentView alloc] initWithIsSmall:YES];
    }
    return _xyp_smallView;
}

- (OWLMusicVideoContentView *)xyp_bigView {
    if (!_xyp_bigView) {
        _xyp_bigView = [[OWLMusicVideoContentView alloc] initWithIsSmall:NO];
    }
    return _xyp_bigView;
}

@end
