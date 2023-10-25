//
//  OWLMusicTableviewBaseView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/14.
//

#import "OWLMusicTableviewBaseView.h"

@implementation OWLMusicTableviewBaseView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.xyp_tapDelegate && [self.xyp_tapDelegate respondsToSelector:@selector(xyf_tapClickBaseTabelViewClickTouchesBegan:withEvent:)]) {
        [self.xyp_tapDelegate xyf_tapClickBaseTabelViewClickTouchesBegan:touches withEvent:event];
    }
}

@end
