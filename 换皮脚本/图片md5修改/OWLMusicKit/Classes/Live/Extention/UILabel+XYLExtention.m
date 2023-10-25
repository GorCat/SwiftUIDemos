//
//  UILabel+XYLExtention.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/12.
//

#import "UILabel+XYLExtention.h"
#import "OWLBGMModuleManagerConvertTool.h"

@implementation UILabel (XYLExtention)

- (void)xyf_atl {
    if (OWLJConvertToolShared.xyf_isRTL) {
        if (self.textAlignment == NSTextAlignmentRight) {
            self.textAlignment = NSTextAlignmentLeft;
        } else if(self.textAlignment == NSTextAlignmentLeft) {
            self.textAlignment = NSTextAlignmentRight;
        }
    }
}

@end
