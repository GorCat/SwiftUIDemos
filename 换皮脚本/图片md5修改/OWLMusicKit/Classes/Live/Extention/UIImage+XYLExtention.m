//
//  UIImage+XYLExtention.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

#import "UIImage+XYLExtention.h"

const UICornerInset UICornerInsetZero = {0.0f, 0.0f, 0.0f, 0.0f};

NSString* NSStringFromUICornerInset(UICornerInset cornerInset)
{
    return [NSString stringWithFormat:@"UICornerInset <topLeft:%f> <topRight:%f> <bottomLeft:%f> <bottomRight:%f>",cornerInset.topLeft, cornerInset.topRight, cornerInset.bottomLeft, cornerInset.bottomRight];
}

static NSCache * _imageCache = nil;

static NSString * kUIImageName = @"kUIImageName";
static NSString * kUIImageResizableImage = @"kUIImageResizableImage";
static NSString * kUIImageColors = @"kUIImageColors";
static NSString * kUIImageTintColor = @"kUIImageTintColor";
static NSString * kUIImageTintStyle = @"kUIImageTintStyle";
static NSString * kUIImageCornerInset = @"kUIImageCornerInset";
static NSString * kUIImageGradientDirection = @"kUIImageGradientDirection";
static NSString * kUIImageSize = @"kUIImageSize";

@implementation UIImage (XYLExtention)

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    return [self imageWithColor:color size:size cornerInset:UICornerInsetZero];
}

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
    return [self imageWithColor:color size:size cornerInset:UICornerInsetMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size cornerInset:(UICornerInset)cornerInset
{
    return [self _imageWithColor:color size:size cornerInset:cornerInset saveInCache:YES];
}

+ (UIImage*)resizableImageWithColor:(UIColor*)color
{
    return [self resizableImageWithColor:color cornerInset:UICornerInsetZero];
}

+ (UIImage*)resizableImageWithColor:(UIColor*)color cornerRadius:(CGFloat)cornerRadius
{
    return [self resizableImageWithColor:color cornerInset:UICornerInsetMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIImage*)resizableImageWithColor:(UIColor*)color cornerInset:(UICornerInset)cornerInset
{
    if (!color)
        return nil;
    
    NSDictionary *descriptors =  @{kUIImageColors : @[color],
                                   kUIImageResizableImage : @YES,
                                   kUIImageCornerInset : [NSValue valueWithUICornerInset:cornerInset]};
    
    UIImage *image = [self _cachedImageWithDescriptors:descriptors];
    
    if (image)
        return image;
    
    CGSize size = CGSizeMake(MAX(cornerInset.topLeft, cornerInset.bottomLeft) + MAX(cornerInset.topRight, cornerInset.bottomRight) + 1,
                             MAX(cornerInset.topLeft, cornerInset.topRight) + MAX(cornerInset.bottomLeft, cornerInset.bottomRight) + 1);
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(MAX(cornerInset.topLeft, cornerInset.topRight),
                                              MAX(cornerInset.topLeft, cornerInset.bottomLeft),
                                              MAX(cornerInset.bottomLeft, cornerInset.bottomRight),
                                              MAX(cornerInset.topRight, cornerInset.bottomRight));
    
    image = [[self imageWithColor:color size:size cornerInset:cornerInset] resizableImageWithCapInsets:capInsets];
    
    [self _cacheImage:image withDescriptors:descriptors];
    
    return image;
}

+ (UIImage*)imageNamed:(NSString *)name tintColor:(UIColor*)color style:(UIImageTintedStyle)tintStyle
{
    if (!name)
        return nil;

    UIImage *image = [UIImage imageNamed:name];
    
    if (!image)
        return nil;
    
    if (!color)
        return image;
    
    NSDictionary *descriptors =  @{kUIImageName : name,
                                   kUIImageTintColor : color,
                                   kUIImageTintStyle : @(tintStyle)};
    
    UIImage *tintedImage = [self _cachedImageWithDescriptors:descriptors];
    
    if (!tintedImage)
    {
        tintedImage = [image tintedImageWithColor:color style:tintStyle];
        [self _cacheImage:tintedImage withDescriptors:descriptors];
    }
    
    return tintedImage;
}

- (UIImage*)tintedImageWithColor:(UIColor*)color style:(UIImageTintedStyle)tintStyle
{
    if (!color)
        return self;
    
    CGFloat scale = self.scale;
    CGSize size = CGSizeMake(scale * self.size.width, scale * self.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // ---

    if (tintStyle == UIImageTintedStyleOverAlpha)
    {
        [color setFill];
        CGContextFillRect(context, rect);
    }
    
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);

    if (tintStyle == UIImageTintedStyleKeepingAlpha)
    {
        CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        [color setFill];
        CGContextFillRect(context, rect);
    }
    
    // ---
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    
    UIImage *coloredImage = [UIImage imageWithCGImage:bitmapContext scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapContext);
    
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

- (UIImage*)imageWithRoundedBounds
{
    CGSize size = self.size;
    CGFloat radius = MIN(size.width, size.height) / 2.0;
    return [self imageWithCornerRadius:radius];
}

- (UIImage*)imageWithCornerRadius:(CGFloat)cornerRadius
{
    return [self imageWithCornerInset:UICornerInsetMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

- (UIImage *)imageWithCornerInset:(UICornerInset)cornerInset
{
    if (![self isValidCornerInset:cornerInset])
        return nil;
    
    CGFloat scale = self.scale;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, scale*self.size.width, scale*self.size.height);
        
    cornerInset.topRight *= scale;
    cornerInset.topLeft *= scale;
    cornerInset.bottomLeft *= scale;
    cornerInset.bottomRight *= scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
        return nil;
    
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerInset.bottomLeft);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerInset.bottomRight);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, cornerInset.topRight);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerInset.topLeft);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGImageRef bitmapImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *newImage = [UIImage imageWithCGImage:bitmapImageRef scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapImageRef);

    return newImage;
}

- (BOOL)isValidCornerInset:(UICornerInset)cornerInset
{
    CGSize size = self.size;
    
    BOOL isValid = YES;
    
    if (cornerInset.topLeft + cornerInset.topRight > size.width)
        isValid = NO;
    
    else if (cornerInset.topRight + cornerInset.bottomRight > size.height)
        isValid = NO;
    
    else if (cornerInset.bottomRight + cornerInset.bottomLeft > size.width)
        isValid = NO;
    
    else if (cornerInset.bottomLeft + cornerInset.topLeft > size.height)
        isValid = NO;
    
    return isValid;
}

- (UIImage*)imageAddingImage:(UIImage*)image
{
    CGSize size1 = self.size;
    CGSize size2 = image.size;
    
    CGPoint offset = CGPointMake(floorf((size1.width - size2.width)/2.0),
                                 floorf((size1.height - size2.height)/2.0));
    return [self imageAddingImage:image offset:offset];
}

- (UIImage*)imageAddingImage:(UIImage*)image offset:(CGPoint)offset
{
    CGSize size = self.size;
    CGFloat scale = self.scale;
    
    size.width *= scale;
    size.height *= scale;
    
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:CGRectMake( 0, 0, size.width, size.height)];
    
    [image drawInRect:CGRectMake(scale * offset.x, scale * offset.y, image.size.width * scale, image.size.height * scale)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    UIImage *destImage = [UIImage imageWithCGImage:bitmapContext scale:image.scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    CGImageRelease(bitmapContext);
    
    return destImage;
}

#pragma mark Private Methods

+ (NSCache*)_cache
{
    if (!_imageCache)
        _imageCache = [[NSCache alloc] init];
    
    return _imageCache;
}

+ (UIImage*)_cachedImageWithDescriptors:(NSDictionary*)descriptors
{
    return [[self _cache] objectForKey:[self _keyForImageWithDescriptors:descriptors]];
}

+ (void)_cacheImage:(UIImage*)image withDescriptors:(NSDictionary*)descriptors
{
    NSString *key = [self _keyForImageWithDescriptors:descriptors];
    [[self _cache] setObject:image forKey:key];
}

+ (NSString*)_keyForImageWithDescriptors:(NSDictionary*)descriptors
{
    NSMutableString *string = [NSMutableString string];
    
    NSString *imageName = [descriptors valueForKey:kUIImageName];
    [string appendFormat:@"<%@:%@>",kUIImageName,(imageName == nil)?@"":imageName];
    [string appendFormat:@"<%@:%@>",kUIImageSize, NSStringFromCGSize([[descriptors valueForKey:kUIImageSize] CGSizeValue])];
    [string appendFormat:@"<%@:%d>",kUIImageResizableImage,[[descriptors valueForKey:kUIImageResizableImage] boolValue]];
    
    [string appendFormat:@"<%@:",kUIImageColors];
    NSArray *colors = [descriptors valueForKey:kUIImageColors];
    for (UIColor *color in colors)
        [string appendFormat:@"%ld",(long)color.hash];
    [string appendFormat:@">"];
    
    [string appendFormat:@"<%@:%ld>",kUIImageTintColor,(long)[[descriptors valueForKey:kUIImageTintColor] hash]];
    [string appendFormat:@"<%@:%ld>",kUIImageTintStyle,(long)[[descriptors valueForKey:kUIImageTintStyle] integerValue]];
    [string appendFormat:@"<%@:%@>",kUIImageCornerInset,NSStringFromUICornerInset([[descriptors valueForKey:kUIImageCornerInset] UICornerInsetValue])];
    [string appendFormat:@"<%@:%ld>",kUIImageGradientDirection,(long)[[descriptors valueForKey:kUIImageGradientDirection] integerValue]];
    
    return [string xyf_md5];
}

+ (UIImage*)_imageWithColor:(UIColor*)color size:(CGSize)size cornerInset:(UICornerInset)cornerInset saveInCache:(BOOL)save
{
    NSDictionary *descriptors =  @{kUIImageColors : @[color],
                                   kUIImageSize : [NSValue valueWithCGSize:size],
                                   kUIImageCornerInset : [NSValue valueWithUICornerInset:cornerInset]};

    UIImage *image = [self _cachedImageWithDescriptors:descriptors];
    
    if (image)
        return image;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect rect = CGRectMake(0.0f, 0.0f, scale*size.width, scale*size.height);
    
    cornerInset.topRight *= scale;
    cornerInset.topLeft *= scale;
    cornerInset.bottomLeft *= scale;
    cornerInset.bottomRight *= scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
        return nil;
    
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    
    CGContextBeginPath(context);
    CGContextSetGrayFillColor(context, 1.0, 0.0); // <-- Alpha color in background
    CGContextAddRect(context, rect);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSetFillColorWithColor(context, [color CGColor]); // <-- Color to fill
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerInset.bottomLeft);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerInset.bottomRight);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, cornerInset.topRight);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerInset.topLeft);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *theImage = [UIImage imageWithCGImage:bitmapContext scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapContext);
    
    if (save)
        [self _cacheImage:theImage withDescriptors:descriptors];
    
    return theImage;
}

+ (UIImage*)imageWithGradient:(NSArray*)colors size:(CGSize)size direction:(UIImageGradientDirection)direction
{
    
    NSDictionary *descriptors = @{kUIImageColors: colors,
                                  kUIImageSize: [NSValue valueWithCGSize:size],
                                  kUIImageGradientDirection: @(direction)};
    
    UIImage *image = [self _cachedImageWithDescriptors:descriptors];
    if (image)
        return image;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create Gradient
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors)
        [cgColors addObject:(id)color.CGColor];
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)cgColors, NULL);
    
    // Apply gradient
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    if (direction == UIImageGradientDirectionVertical)
        endPoint = CGPointMake(0, rect.size.height);
    
    else if (direction == UIImageGradientDirectionHorizontal)
        endPoint = CGPointMake(rect.size.width, 0);

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean memory & End context
    UIGraphicsEndImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
    
    [self _cacheImage:image withDescriptors:descriptors];
    
    return image;
}

+ (UIImage*)resizableImageWithGradient:(NSArray*)colors size:(CGSize)size direction:(UIImageGradientDirection)direction
{
    if ((size.width == 0.0f && direction == UIImageGradientDirectionHorizontal) ||
        (size.height == 0.0f && direction == UIImageGradientDirectionVertical) ||
        (size.height == 0.0f && size.width == 0.0f))
        return nil;
    
    NSDictionary *descriptors = @{kUIImageColors: colors,
                                  kUIImageSize: [NSValue valueWithCGSize:size],
                                  kUIImageGradientDirection: @(direction),
                                  kUIImageResizableImage: @YES};
    
    UIImage *image = [self _cachedImageWithDescriptors:descriptors];
    if (image)
        return image;
    
    CGSize imageSize = CGSizeMake(1.0f, 1.0f);
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if (direction == UIImageGradientDirectionVertical)
    {
        imageSize.height = size.height;
        insets = UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f);
    }
    else if (direction == UIImageGradientDirectionHorizontal)
    {
        imageSize.width = size.width;
        insets = UIEdgeInsetsMake(1.0f, 0.0f, 1.0f, 0.0f);
    }
    
    return [[self imageWithGradient:colors size:imageSize direction:direction] resizableImageWithCapInsets:insets];
}


- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    if (!tintColor) {
        return self;
    }
    
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn)
    {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (void)xyf_drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clips {
    CGRect drawRect = XYLCGRectFitWithContentMode(rect, self.size, contentMode);
    if (drawRect.size.width == 0 || drawRect.size.height == 0) return;
    if (clips) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context) {
            CGContextSaveGState(context);
            CGContextAddRect(context, rect);
            CGContextClip(context);
            [self drawInRect:drawRect];
            CGContextRestoreGState(context);
        }
    } else {
        [self drawInRect:drawRect];
    }
}

CGRect XYLCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode) {
    rect = CGRectStandardize(rect);
    size.width = size.width < 0 ? -size.width : size.width;
    size.height = size.height < 0 ? -size.height : size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    switch (mode) {
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill: {
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center;
                rect.size = CGSizeZero;
            } else {
                CGFloat scale;
                if (mode == UIViewContentModeScaleAspectFit) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height;
                    } else {
                        scale = rect.size.width / size.width;
                    }
                } else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width;
                    } else {
                        scale = rect.size.height / size.height;
                    }
                }
                size.width *= scale;
                size.height *= scale;
                rect.size = size;
                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
            }
        } break;
        case UIViewContentModeCenter: {
            rect.size = size;
            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
        } break;
        case UIViewContentModeTop: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeBottom: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeLeft: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeRight: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeTopLeft: {
            rect.size = size;
        } break;
        case UIViewContentModeTopRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeBottomLeft: {
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeBottomRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
        default: {
            rect = rect;
        }
    }
    return rect;
}

- (UIImage *)xyf_getMirroredImage {
    if (OWLJConvertToolShared.xyf_isRTL) {
        return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUpMirrored];
    }
    return self;
}

- (UIImage *)xyf_getCornerImageWithRadius:(CGFloat)cornerRadius imageSize:(CGSize)size {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *image = nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    [self drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)xyf_cutResizedImage:(CGSize)newSize {
    if(newSize.width <= 0 || newSize.height <= 0){
        return self;
    }
    CGSize originalsize = self.size;
    //原图长宽均小于标准长宽的，不作处理返回原图
    if(originalsize.width <= newSize.width && originalsize.height <= newSize.height){
        return self;
    }else if(originalsize.width > newSize.width && originalsize.height > newSize.height){
        //原图长宽均大于标准长宽的，按比例缩小至最大适应值
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width / newSize.width;
        CGFloat heightRate = originalsize.height / newSize.height;
        rate = MIN(widthRate, heightRate);
        CGImageRef imageRef = nil;
        if(heightRate>widthRate){
            imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(0, originalsize.height/2-newSize.height*rate/2, originalsize.width, newSize.height*rate));//获取图片整体部分
        }else{
           imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(originalsize.width/2-newSize.width*rate/2, 0, newSize.width*rate, originalsize.height));//获取图片整体部分
        }

        UIGraphicsBeginImageContext(newSize);//指定要绘画图片的大小

        CGContextRef con = UIGraphicsGetCurrentContext();

        CGContextTranslateCTM(con, 0.0, newSize.height);

        CGContextScaleCTM(con, 1.0, -1.0);

        CGContextDrawImage(con, CGRectMake(0, 0, newSize.width, newSize.height), imageRef);

        UIImage * standardImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        return standardImage;

    }else if(originalsize.height > newSize.height|| originalsize.width > newSize.width){
        //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
        CGImageRef imageRef = nil;
        if(originalsize.height > newSize.height){
            imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(0, originalsize.height/2-newSize.height/2, originalsize.width, newSize.height));//获取图片整体部分
        }else if(originalsize.width>newSize.width){
            imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(originalsize.width/2-newSize.width/2, 0, newSize.width, originalsize.height));//获取图片整体部分
        }

        UIGraphicsBeginImageContext(newSize);//指定要绘画图片的大小

        CGContextRef con = UIGraphicsGetCurrentContext();

        CGContextTranslateCTM(con, 0.0, newSize.height);

        CGContextScaleCTM(con, 1.0, -1.0);

        CGContextDrawImage(con, CGRectMake(0, 0, newSize.width, newSize.height), imageRef);

        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        CGImageRelease(imageRef);

        return standardImage;

    }else{
        //原图为标准长宽的，不做处理
        return self;
    }
}

- (UIImage *)xyf_fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform,M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width,0);
            transform = CGAffineTransformRotate(transform,M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform,0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }

    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width,0);
            transform = CGAffineTransformScale(transform, -1,1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height,0);
            transform = CGAffineTransformScale(transform, -1,1);
            break;
        default:
            break;
    }

    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage),0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;

        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }

    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

#pragma mark - Categories

@implementation NSValue (UICornerInset)

+ (NSValue*)valueWithUICornerInset:(UICornerInset)cornerInset
{
    CGRect rect = CGRectMake(cornerInset.topLeft, cornerInset.topRight, cornerInset.bottomLeft, cornerInset.bottomRight);
    return [NSValue valueWithCGRect:rect];
    
    //    UICornerInset inset = cornerInset;
    //    return [[NSValue alloc] initWithBytes:&inset objCType:@encode(struct __UICornerInset)];
}

- (UICornerInset)UICornerInsetValue
{
    CGRect rect = [self CGRectValue];
    return UICornerInsetMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    //    UICornerInset cornerInset;
    //    [self getValue:&cornerInset];
    //    return cornerInset;
}

@end
