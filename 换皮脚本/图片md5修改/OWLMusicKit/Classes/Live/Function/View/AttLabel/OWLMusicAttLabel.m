//
//  OWLMusicAttLabel.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/5.
//

#import "OWLMusicAttLabel.h"
#import "OWLMusicTextAttachment.h"
@implementation OWLMusicAttLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [super setAttributedText:attributedText];
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(OWLMusicTextAttachment* value, NSRange range, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[OWLMusicTextAttachment class]]) {
            UIView *contentView = value.xyp_contentViewBlock ? value.xyp_contentViewBlock() : nil;
            value.xyp_contentView = contentView;
            [self addSubview:value.xyp_contentView];
        }
    }];
    [self setNeedsDisplay];
}

@end
