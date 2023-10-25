//
//  OWLPPGiftPageControl.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/28.
//

#import "OWLPPGiftPageControl.h"

#define kXYLOnePageWid 12.5

@interface OWLPPGiftPageControl()

@property (nonatomic, strong) UIView * xyp_contentView;

@property (nonatomic, strong) UIView * xyp_pageView;

@property (nonatomic, assign) NSInteger xyp_lastPage;

@end

@implementation OWLPPGiftPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupUI];
    }
    return self;
}

- (void) xyf_setupUI {
    self.backgroundColor = UIColor.clearColor;
    self.clipsToBounds = YES;
    NSInteger xyp_wid = self.xyp_numberPages * kXYLOnePageWid;
    self.xyp_contentView = [[UIView alloc] initWithFrame:CGRectMake((kXYLScreenWidth - xyp_wid) / 2, self.xyp_h - 2, xyp_wid, 2)];
    self.xyp_contentView.backgroundColor = kXYLColorFromRGBA(0xFFFFFF, 0.2);
    [self addSubview:self.xyp_contentView];
    self.xyp_pageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kXYLOnePageWid, 2)];
    self.xyp_pageView.backgroundColor = UIColor.whiteColor;
    [self.xyp_contentView addSubview:self.xyp_pageView];
}


- (void)setXyp_numberPages:(NSInteger)xyp_numberPages {
    self.xyp_contentView.xyp_w = xyp_numberPages * kXYLOnePageWid;
    self.xyp_contentView.xyp_x = (kXYLScreenWidth - self.xyp_contentView.xyp_w) / 2;
}

- (void)setXyp_currentPage:(NSInteger)xyp_currentPage {
    if (xyp_currentPage == self.xyp_lastPage) {
        return;
    }
    self.xyp_lastPage = xyp_currentPage;
    kXYLWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.xyp_pageView.xyp_x = xyp_currentPage * kXYLOnePageWid;
    }];
}

@end
