//
//  ZOEPIP_CVPBufferTool.m
//  ZBNChatRoom
//
//  Created by zzzzzzzzzz on 2023/6/26.
//

#import "ZOEPIP_CVPBufferTool.h"

@implementation ZOEPIP_CVPBufferTool

+ (UIImage *)zoepip_getUIImageFromCVPixelBuffer:(CVPixelBufferRef)cvPixelBuffer
{
    return [self getUIImageFromCVPixelBuffer:cvPixelBuffer uiOrientation:UIImageOrientationUp];
}


+ (UIImage *)getUIImageFromCVPixelBuffer:(CVPixelBufferRef)cvPixelBuffer uiOrientation:(UIImageOrientation)uiOrientation
{
    UIImage *image;
    @autoreleasepool{
        CGImageRef quartzImage = [self zoepip_getCGImageFromCVPixelBuffer:cvPixelBuffer];
        image = [UIImage imageWithCGImage:quartzImage scale:1.0 orientation:uiOrientation];
        CGImageRelease(quartzImage);
    }
    return (image);
}



+ (CGImageRef)zoepip_getCGImageFromCVPixelBuffer:(CVPixelBufferRef)cvPixelBuffer {
    CGImageRef quartzImage;
    @autoreleasepool {
        
        
        
        OSType pixeltype = CVPixelBufferGetPixelFormatType(cvPixelBuffer);

        if (pixeltype == kCVPixelFormatType_32BGRA){
            CVImageBufferRef imageBuffer = cvPixelBuffer;
                    CVPixelBufferLockBaseAddress(imageBuffer, 0);
            
                    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
                    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
                    size_t width = CVPixelBufferGetWidth(cvPixelBuffer);
                    size_t height = CVPixelBufferGetHeight(cvPixelBuffer);
            //
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);//kCGBitmapByteOrderDefault | kCGImageAlphaNoneSkipLast
                    quartzImage = CGBitmapContextCreateImage(context);
                    CGContextRelease(context);
                    CGColorSpaceRelease(colorSpace);
                    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        }else{
            
            //        CVImageBufferRef imageBuffer = cvPixelBuffer;
            //        CVPixelBufferLockBaseAddress(imageBuffer, 0);
            //
            //        void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
            //        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
                    size_t width = CVPixelBufferGetWidth(cvPixelBuffer);
                    size_t height = CVPixelBufferGetHeight(cvPixelBuffer);
            //
            //        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            //        CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
            //                                                     bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);//kCGBitmapByteOrderDefault | kCGImageAlphaNoneSkipLast
            //        quartzImage = CGBitmapContextCreateImage(context);
            //        CGContextRelease(context);
            //        CGColorSpaceRelease(colorSpace);
            //        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
                    
                    
                    CIImage *coreImage = [CIImage imageWithCVPixelBuffer:cvPixelBuffer];
                    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
                    quartzImage = [temporaryContext createCGImage:coreImage
                                                                       fromRect:CGRectMake(0, 0, width, height)];
            
        }
        

    }
    return quartzImage;
}

+ (CVPixelBufferRef)zoepip_creatPixelBufferSameStyleWithOtherPixelBuffer:(CVPixelBufferRef)inputPixelBuffer withSize:(CGSize)size
{
    CVPixelBufferRef outputPixelBuffer = NULL;
    size_t pixelWidth   = size.width;
    size_t pixelHeight  = size.height;
    OSType formatType  = CVPixelBufferGetPixelFormatType(inputPixelBuffer);
    
    NSDictionary *outputPixelBufferAttributes = [self createPixelBufferAttributes:inputPixelBuffer];
    
    CVPixelBufferCreate(kCFAllocatorDefault, pixelWidth, pixelHeight,formatType, (__bridge CFDictionaryRef)outputPixelBufferAttributes, &outputPixelBuffer);
    
    return outputPixelBuffer;
}

+ (NSDictionary *)createPixelBufferAttributes:(CVPixelBufferRef)pixelBuffer
{
    NSArray *properties = [self getPixelBufferProperties:pixelBuffer];
    
    NSMutableDictionary *outputPixelBufferAttributes = [NSMutableDictionary dictionary];
    [outputPixelBufferAttributes setObject:properties[ZOEPIP_PixelPropertyFormat] forKey:(__bridge NSString *) kCVPixelBufferPixelFormatTypeKey];
    [outputPixelBufferAttributes setObject:properties[ZOEPIP_PixelPropertyWidth] forKey:(__bridge NSString *) kCVPixelBufferWidthKey];
    [outputPixelBufferAttributes setObject:properties[ZOEPIP_PixelPropertyHeight] forKey:(__bridge NSString *) kCVPixelBufferHeightKey];
    [outputPixelBufferAttributes setObject:@{} forKey:(__bridge NSString *) kCVPixelBufferIOSurfacePropertiesKey];
    
    return outputPixelBufferAttributes;
}


+ (NSArray *)getPixelBufferProperties:(CVPixelBufferRef)pixelBuffer
{
    NSMutableArray *arr = [NSMutableArray array];
    size_t pixelWidth  = CVPixelBufferGetWidth(pixelBuffer);
    size_t pixelHeight = CVPixelBufferGetHeight(pixelBuffer);
    OSType formatType  = CVPixelBufferGetPixelFormatType(pixelBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
    
    arr[ZOEPIP_PixelPropertyWidth] = @(pixelWidth);
    arr[ZOEPIP_PixelPropertyHeight] = @(pixelHeight);
    arr[ZOEPIP_PixelPropertyFormat] = @(formatType);
    arr[ZOEPIP_PixelPropertyBytesPerRow] = @(bytesPerRow);
    
    return arr;
}

+ (CVPixelBufferRef)zoepip_getPixelBufferFromUIImage:(UIImage *)image {
    return [self getPixelBufferFromCGImage:image.CGImage];
}



/**
 把CGImage转化为CVPixelBuffer
 
 @param image CGImageRef
 @return CVPixelBufferRef
 */
+ (CVPixelBufferRef)getPixelBufferFromCGImage:(CGImageRef)image {
    CVPixelBufferRef pixelBuffer;
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    size_t bytePerRow = CGImageGetBytesPerRow(image);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(image);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
    
    OSType pixelFormatType = kCVPixelFormatType_32BGRA;
    
    NSDictionary *pixelAttributes =
    @{(__bridge NSString *)kCVPixelBufferCGImageCompatibilityKey : @(YES),
      (__bridge NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey : @(YES),
      (__bridge NSString *)kCVPixelBufferWidthKey : @(width),
      (__bridge NSString *)kCVPixelBufferHeightKey : @(height)};
    
    CVReturn ret = CVPixelBufferCreate(kCFAllocatorDefault, width, height, pixelFormatType, (__bridge CFDictionaryRef)pixelAttributes, &pixelBuffer);
    if (ret != kCVReturnSuccess) {
        
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *baseData = CVPixelBufferGetBaseAddress(pixelBuffer);
    CGContextRef context = CGBitmapContextCreate(baseData, width, height, bitsPerComponent, bytePerRow, colorSpace,  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return pixelBuffer;
}

+ (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
{
    CVPixelBufferRef pxbuffer = NULL;
    NSCParameterAssert(NULL != image);
    size_t originalWidth = CGImageGetWidth(image);
    size_t originalHeight = CGImageGetHeight(image);
    
    NSMutableData *imageData = [NSMutableData dataWithLength:originalWidth*originalHeight*4];
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes], originalWidth, originalHeight, 8, 4*originalWidth, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(cgContext, CGRectMake(0, 0, originalWidth, originalHeight), image);
    CGContextRelease(cgContext);
//    CGImageRelease(image);
    unsigned char *pImageData = (unsigned char *)[imageData bytes];
    
    
    CFDictionaryRef empty;
    empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL,
                               0,
                               &kCFTypeDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks);
    
    CFMutableDictionaryRef m_pPixelBufferAttribs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                                      3,
                                                      &kCFTypeDictionaryKeyCallBacks,
                                                      &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(m_pPixelBufferAttribs, kCVPixelBufferIOSurfacePropertiesKey, empty);
    CFDictionarySetValue(m_pPixelBufferAttribs, kCVPixelBufferOpenGLCompatibilityKey, empty);
    CFDictionarySetValue(m_pPixelBufferAttribs, kCVPixelBufferCGBitmapContextCompatibilityKey, empty);
    
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault, originalWidth, originalHeight, kCVPixelFormatType_32BGRA, pImageData, originalWidth * 4, NULL, NULL, m_pPixelBufferAttribs, &pxbuffer);
    CFRelease(empty);
    CFRelease(m_pPixelBufferAttribs);
    
    
    return pxbuffer;
}


@end
