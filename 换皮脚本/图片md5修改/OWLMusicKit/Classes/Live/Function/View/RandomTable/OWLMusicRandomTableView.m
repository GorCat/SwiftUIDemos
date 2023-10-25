//
//  OWLMusicRandomTableView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/25.
//

#import "OWLMusicRandomTableView.h"
@import CoreGraphics;

@implementation OWLMusicRandomTableColorModel

@end

@implementation OWLMusicRandomTableViewModel

@end

@interface OWLMusicRandomTableView () <CAAnimationDelegate> {
    UIColor *_dotColor;
    UIColor *_dotShinningColor;
    NSInteger _numberOfDot;
    CGFloat _dotSize; // default is 10.0
}

@property (nonatomic, strong) NSMutableArray *xyp_dotLayers;

@property (nonatomic, strong) NSMutableArray *xyp_imageLayers;

@property (nonatomic, strong) NSOperationQueue *xyp_imageRenderQueue;

@property (nonatomic, assign) CGFloat xyp_startValue;//default = 0

@property (nonatomic, assign) NSInteger xyp_displayIndex;

@property (nonatomic, assign) CGFloat xyp_textFontSize;

@property (nonatomic, strong) UIColor *xyp_circleBgColor;

@end

static CGPoint pointAroundCircumference(CGPoint center, CGFloat radius, CGFloat theta);

@implementation OWLMusicRandomTableView

- (void)dealloc {
    [_xyp_imageRenderQueue cancelAllOperations];
    _xyp_imageRenderQueue = nil;
    
    [_xyp_imageLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_xyp_imageLayers removeAllObjects];
    
    [_xyp_dotLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_xyp_dotLayers removeAllObjects];
}

#pragma mark - Init
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self xyf_setupDefaultConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupDefaultConfig];
    }
    return self;
}

- (void)xyf_setupDefaultConfig {
    self.backgroundColor = [UIColor clearColor];
    
    _xyp_dotLayers = [NSMutableArray arrayWithCapacity:18];
    self.xyp_textFontSize = 12.0;
    self.xyp_textPadding = 5.0;
    self.xyp_attributes = @{
        NSForegroundColorAttributeName: [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0],
                              NSFontAttributeName:[UIFont boldSystemFontOfSize:12]
                    };

    self.xyp_imageSize = CGSizeMake(35, 35);
    self.xyp_circleWidth = 30.f;
    _numberOfDot = 18;
    _dotSize = 8.0;
    self.xyp_panBgColors = @[[UIColor colorWithRed:249 / 255.0 green:105 / 255.0 blue:108 / 255.0 alpha:1.0],[UIColor colorWithRed:247 / 255.0 green:131 / 255.0 blue:131 / 255.0 alpha:1.0]
    ];
    self.xyp_circleBgColor = [UIColor colorWithRed:251 / 255.0 green:94 / 255.0 blue:97 / 255.0 alpha:1.0];
    _dotShinningColor = [UIColor colorWithRed:42 / 255.0 green:253 / 255.0 blue:47 / 255.0 alpha:1.0];
    _dotColor = [UIColor whiteColor];
}

#pragma mark - Public
- (void)xyf_ramdomTabelToDisplayIndex:(NSInteger)displayIndex {
    self.xyp_displayIndex = displayIndex;
    CGFloat count = self.xyp_luckyItemArray.count;
    CGFloat angel = (360 / count);
    CGFloat angle4Rotate = angel * (displayIndex+1);// 以 π*3/2 为终点, 加多一圈以防反转, 默认顺时针
    angle4Rotate = angle4Rotate+90-angel*0.5; //自定义文字和奖品模式
    angle4Rotate = 360-angle4Rotate;
    CGFloat radians = XYLDegress2Radians(angle4Rotate) + M_PI * 20;
    [self xyf_startRotationWithEndValue:radians round:20];
}

- (void)xyf_startRotationWithEndValue:(CGFloat)endValue round:(NSInteger)round{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @(_xyp_startValue);
    animation.toValue = @(endValue);// default is 6 * M_PI
    animation.duration = 5.0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    [self.layer addAnimation:animation forKey:@"rotation"];
    _xyp_startValue = round ? (endValue - 2*M_PI*round) : 0;//记录上次的结果位置当作下次的开始位置
}

#pragma mark - Setter
- (void)setXyp_luckyItemArray:(NSArray<OWLMusicRandomTableViewModel *> *)xyp_luckyItemArray {
    _xyp_luckyItemArray = xyp_luckyItemArray;
    
    _numberOfDot = _xyp_luckyItemArray.count * 2;
    
    [self setNeedsDisplay];
}

#pragma mark - Draw Method
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_xyp_luckyItemArray && _xyp_luckyItemArray.count) {
     
        [_xyp_imageLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [_xyp_imageLayers removeAllObjects];
        
        NSInteger count = _xyp_luckyItemArray.count;
        CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
        CGFloat degree = 360.0 / count;
        for (int i = 0; i < count; i++) {
        
            OWLMusicRandomTableViewModel *obj = [_xyp_luckyItemArray objectAtIndex:i];
            
            UIBezierPath *fanPath = [UIBezierPath bezierPath];//reference path
            [fanPath moveToPoint:center];
            
            [fanPath addArcWithCenter:center
                            radius:center.x - self.xyp_circleWidth
                        startAngle:XYLDegress2Radians(i * degree)
                          endAngle:XYLDegress2Radians((i + 1) * degree)
                         clockwise:YES];
            [fanPath closePath];
            if (self.xyp_panBgGradientColors) {
                [fanPath fill];
                int colorIndex = i%self.xyp_panBgGradientColors.count;
                OWLMusicRandomTableColorModel *gradientColorModel = self.xyp_panBgGradientColors[colorIndex];
                CGContextRef gc = UIGraphicsGetCurrentContext();
                [self xyf_drawLinearGradient:gc path:fanPath.CGPath startColor:gradientColorModel.xyp_startColor.CGColor endColor:gradientColorModel.xyp_endColor.CGColor];
                
            }else{
                //偶数
                if (count%2 == 0) {
                    int colorIndex = i%self.xyp_panBgColors.count;
                    UIColor * color = self.xyp_panBgColors[colorIndex];
                    [color setFill];
                }else{
                    //奇数
                    UIColor * color = self.xyp_panBgColors[i];
                    [color setFill];
                }
                [fanPath fill];
            }
            
            NSString *string = obj.xyp_remark;
            
            // 自定义显示...
            NSInteger max = floor(kXYLWidthScale(15));
            if (string.length > max) string = [NSString stringWithFormat:@"%@...",[string substringToIndex:max-1]];
            
            //text 文字
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];

            [attributedStr addAttribute:NSFontAttributeName
                                  value:kXYLGilroyRegularFont(13)
                                  range:NSMakeRange(0, string.length)];

            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0]
                                  range:NSMakeRange(0, string.length)];
            
            [self xyf_drawStringOnLayer:self.layer withAttributedText:attributedStr.copy atAngle:XYLDegress2Radians((i + 0.5) * degree) withRadius:center.x - self.xyp_circleWidth - self.xyp_textFontSize - self.xyp_textPadding];
            
            //image 图片
            CALayer *imageLayer = [CALayer layer];
            NSBlockOperation *operaton = [NSBlockOperation blockOperationWithBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageNamed:obj.xyp_imageName];
                    CGImageRef imageRef = image.CGImage;//[image fb_newCGImageRenderedInBitmapContext];
                    imageLayer.contents = (__bridge id)imageRef;
                });
            }];
            [self.xyp_imageRenderQueue addOperation:operaton];
            // DIMOOY
            CGPoint imageLayerPos = pointAroundCircumference(center, (center.x - self.xyp_circleWidth) / 2.0+10, XYLDegress2Radians((i + 0.5) * degree));
            imageLayer.frame = CGRectMake(0, 0, self.xyp_imageSize.width, self.xyp_imageSize.height);
            imageLayer.position = imageLayerPos;
            imageLayer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, XYLDegress2Radians((i + 0.5) * degree) + M_PI_2);
//            imageLayer.cornerRadius = 3.0;
//            imageLayer.masksToBounds = YES;
            
            [self.layer addSublayer:imageLayer];
            [self.xyp_imageLayers addObject:imageLayer];
        }
    }
}

- (void)xyf_drawLinearGradient:(CGContextRef)context path:(CGPathRef)path startColor:(CGColorRef)startColor endColor:(CGColorRef)endColor{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGFloat locations[] = {0.0,1.0};
    NSArray *colors = @[(__bridge id)startColor,(__bridge id)endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors,NULL);
    CGRect pathRect = CGPathGetBoundingBox(path);

    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    CGContextSaveGState(context);
    CGContextAddPath(context,path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context,gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)xyf_drawStringOnLayer:(CALayer *)layer
           withAttributedText:(NSAttributedString *)text
                      atAngle:(float)angle
                   withRadius:(float)radius {
    
//    CGSize textSize = CGRectIntegral([text boundingRectWithSize:CGSizeMake(radius - 25, 50)
//                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                        context:nil]).size;
    CGSize textSize = CGSizeMake(radius - 25, 20);
    
//    CGFloat perimeter = 2 * M_PI * radius;
//    textSize.height += 1;//高度刚好显示不出第二行，要加1
    CGFloat textRotation = 0;
    CGFloat textDirection = 0;
    textRotation = 1 * M_PI;
    textDirection = 2 * M_PI;
    
    CGFloat flagValue = kXYLWidthScale(38.5);
    CGFloat x = (radius - flagValue) * cos(angle);
    CGFloat y = (radius - flagValue) * sin(angle);
    
    CATextLayer * textLayer = [self xyf_drawTextOnLayer:layer
                                           withText:text
                                              frame:CGRectMake(layer.frame.size.width/2 - textSize.width/2 + x,
                                                               layer.frame.size.height/2 - textSize.height/2 + y,
                                                               textSize.width, textSize.height)
                                            bgColor:nil
                                            opacity:1];
    textLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(angle - textDirection));
}


- (CATextLayer *)xyf_drawTextOnLayer:(CALayer *)layer
                            withText:(NSAttributedString *)text
                               frame:(CGRect)frame
                             bgColor:(UIColor *)bgColor
                             opacity:(CGFloat)opacity {
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    [textLayer setFrame:frame];
    [textLayer setString:text];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setBackgroundColor:bgColor.CGColor];
    [textLayer setContentsScale:[UIScreen mainScreen].scale];
    [textLayer setOpacity:opacity];
    [textLayer setWrapped:NO];
    [layer addSublayer:textLayer];
    return textLayer;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.lunckyAnimationDidStopBlock) {
        if (self.xyp_displayIndex <= self.xyp_luckyItemArray.count) {
            self.lunckyAnimationDidStopBlock(flag,self.xyp_luckyItemArray[self.xyp_displayIndex]);
        }
    }
}

#pragma mark - Lazy
- (NSOperationQueue *)xyp_imageRenderQueue {
    if (!_xyp_imageRenderQueue) {
        _xyp_imageRenderQueue = [[NSOperationQueue alloc] init];
        _xyp_imageRenderQueue.name = @"DwyaneWadeImageRenderQ";
    }
    return _xyp_imageRenderQueue;
}

@end

// center point on circle 在圆上的点
static CGPoint pointAroundCircumference(CGPoint center, CGFloat radius, CGFloat theta){
    CGPoint point = CGPointZero;
    point.x = center.x + radius * cos(theta);
    point.y = center.y + radius * sin(theta);
    return point;
}
