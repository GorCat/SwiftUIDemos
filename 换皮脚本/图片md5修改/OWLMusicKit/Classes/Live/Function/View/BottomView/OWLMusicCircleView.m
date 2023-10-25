//
//  OWLMusicCircleView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/7/14.
//

#import "OWLMusicCircleView.h"

@interface OWLMusicCircleView ()

@property (nonatomic, strong) NSArray <UIImageView *> * viewArray;

@property (nonatomic, strong) UIImageView * currentIV;

@end

@implementation OWLMusicCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupViews];
    }
    return self;
}

- (void)xyf_setupViews {
    self.frame = CGRectMake(0, 0, 36, 36);
    self.backgroundColor = kXYLColorFromRGBA(0x000000, 0.3);
    self.layer.cornerRadius = 18;
    self.clipsToBounds = YES;
}

#pragma mark public
- (void)xyf_loadArray:(NSArray<UIImageView *> *)array {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentIV = nil;
    self.viewArray = array.copy;
    for (UIImageView * imgView in self.viewArray) {
        imgView.userInteractionEnabled = YES;
        [self addSubview:imgView];
    }
    [self loadImageView];
}

- (void)loadImageView{

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadImageView) object:nil];
    if(self.viewArray.count <= 1){
        return;
    }
    if(!self.currentIV){
        self.currentIV = self.viewArray.firstObject;
        self.currentIV.frame = CGRectMake(3, 3, 30, 30);
    }else{
        if([self.currentIV isEqual:self.viewArray.firstObject]){
            self.viewArray.firstObject.frame = CGRectMake(3, 3, 30, 30);
            self.viewArray.lastObject.frame = CGRectMake(39, 3, 30, 30);
            [UIView animateWithDuration:0.2 animations:^{
                self.viewArray.firstObject.frame = CGRectMake(-39, 3, 30, 30);
                self.viewArray.lastObject.frame = CGRectMake(3, 3, 30, 30);
            } completion:^(BOOL finished) {
                self.currentIV = self.viewArray.lastObject;
            }];
        }else{
            self.viewArray.lastObject.frame = CGRectMake(3, 3, 30, 30);
            self.viewArray.firstObject.frame = CGRectMake(39, 3, 30, 30);
            [UIView animateWithDuration:0.2 animations:^{
                self.viewArray.lastObject.frame = CGRectMake(-39, 3, 30, 30);
                self.viewArray.firstObject.frame = CGRectMake(3, 3, 30, 30);
            } completion:^(BOOL finished) {
                self.currentIV = self.viewArray.firstObject;
            }];
        }
    }
    [self performSelector:@selector(loadImageView) withObject:nil afterDelay:3];
}


@end
