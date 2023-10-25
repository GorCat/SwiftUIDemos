//
//  OWLMusicProgressView.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/24.
//

#import "OWLMusicProgressView.h"

@interface OWLMusicProgressView()

@property (nonatomic, strong) UIView * xyp_progressView;

@end

@implementation OWLMusicProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)xyf_setupUI {
    self.backgroundColor = UIColor.whiteColor;
    self.xyp_progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2)];
    self.xyp_progressView.backgroundColor = kXYLColorFromRGB(0xFFC73C);
    [self addSubview:self.xyp_progressView];
}

- (void)setXyp_progress:(CGFloat)xyp_progress {
    self.xyp_progressView.xyp_w = xyp_progress * self.bounds.size.width;
}


@end
