//
//  OWLMusicTextAttachment.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/5.
//

#import "OWLMusicTextAttachment.h"

@implementation OWLMusicTextAttachment

- (UIImage *)imageForBounds:(CGRect)imageBounds textContainer:(NSTextContainer *)textContainer characterIndex:(NSUInteger)charIndex {
    UIImage* image = [super imageForBounds:imageBounds textContainer:textContainer characterIndex:charIndex];
    CGRect frame = imageBounds;
    if (imageBounds.origin.y > 0){
        frame = CGRectMake(frame.origin.x, frame.origin.y - frame.size.height, frame.size.width, frame.size.height);
    }
    self.xyp_contentView.frame = frame;
    return image;
}

@end
