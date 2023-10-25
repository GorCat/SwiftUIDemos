//
//  ZOEPIP_CVPBufferTool.h
//  ZBNChatRoom
//
//  Created by zzzzzzzzzz on 2023/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZOEPIP_PixelProperty) {
    ZOEPIP_PixelPropertyWidth,
    ZOEPIP_PixelPropertyHeight,
    ZOEPIP_PixelPropertyFormat,
    ZOEPIP_PixelPropertyBytesPerRow,
    
};
@interface ZOEPIP_CVPBufferTool : NSObject
+ (CGImageRef)zoepip_getCGImageFromCVPixelBuffer:(CVPixelBufferRef)cvPixelBuffer ;
+ (CVPixelBufferRef)zoepip_creatPixelBufferSameStyleWithOtherPixelBuffer:(CVPixelBufferRef)inputPixelBuffer withSize:(CGSize)size;
+ (CVPixelBufferRef)zoepip_getPixelBufferFromUIImage:(UIImage *)image;
+ (UIImage *)zoepip_getUIImageFromCVPixelBuffer:(CVPixelBufferRef)cvPixelBuffer;
+ (CVPixelBufferRef)getPixelBufferFromCGImage:(CGImageRef)image ;
+ (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image;

@end

NS_ASSUME_NONNULL_END
