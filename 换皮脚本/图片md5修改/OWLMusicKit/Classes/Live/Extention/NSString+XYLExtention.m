//
//  NSString+XYLExtention.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

#import "NSString+XYLExtention.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>

@implementation NSString (XYLExtention)

- (NSString *)xyf_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    OWLPP_MD5(cStr, (OWLPP_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)xyf_localString {
    NSArray *supports = @[@"ar"];
    NSString *abbr = [OWLJConvertToolShared xyf_currentLanguage];
    if ([supports containsObject:abbr]) {
        NSString *path = [OWLMusciCompressionTool xyf_getLprojPathFrom:abbr];
        if (path) {
            NSString *text = [[NSBundle bundleWithPath:path] localizedStringForKey:self value:self table:@"OWLJocalizable"];
            if (text.length > 0) {
                return text;
            }
        }
    }
    
    return self;
}

- (NSString *)xyf_stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
            - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
            - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
            - parameter string: The string to be percent-escaped.
            - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

/** 获取资源图片 */
- (UIImage *) xyf_getOwnImageFromName {
    if (self.length < 1) {
        return nil;
    }
    NSString * resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:kXYLResourceName]];
    NSString * resultPath = [resourcePath stringByAppendingFormat:@"/%@/%@@3x.png",kXYLZipName,self];
    UIImage * icon = [UIImage imageWithContentsOfFile:resultPath];
    return icon;
}

- (NSString *)xyf_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

+ (NSString *)xyf_urlEncodeString:(NSString *)str {
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString *)xyf_decimalString:(CGFloat)value maxFloat:(int)maxFloat {
    NSString *valueStr = [NSString stringWithFormat:@"%f", value];
    NSArray *arr = [valueStr componentsSeparatedByString:@"."];
    NSString *pointBefore = arr.firstObject;
    if (pointBefore.length == 0) {
        return valueStr;
    }
    NSString *pointAfter = arr.lastObject;
    if (pointAfter.length == 0) {
        return valueStr;
    }
    return [NSString stringWithFormat:@"%@.%@", pointBefore, [pointAfter substringToIndex:maxFloat]];
}

- (NSArray <NSString *>*)xyf_linesWithMaxWidth:(CGFloat)xyp_width font:(UIFont *)xyp_font {
    if(self.length == 0){
        return nil;
    }
    NSAttributedString * attrStr = [[NSAttributedString alloc]initWithString:self attributes:@{NSFontAttributeName : xyp_font}];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
    CGRect frame = CGRectMake(0, 0, xyp_width, CGFLOAT_MAX);
    CGPathRef path = CGPathCreateWithRect(frame, nil);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil);
    NSArray * lines = (__bridge  NSArray *)CTFrameGetLines(ctFrame);
    NSMutableArray <NSString *>*linesArray = [NSMutableArray array];
    [lines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CTLineRef lineRef = (__bridge  CTLineRef)obj;
            CFRange lineRange = CTLineGetStringRange(lineRef);
            NSRange range = NSMakeRange(lineRange.location, lineRange.length);
            NSAttributedString * lineString = [attrStr attributedSubstringFromRange:range];
            [linesArray addObject:lineString.string];
    }];
    CFRelease(ctFrame);
    CGPathRelease(path);
    CFRelease(frameSetter);
    return linesArray.copy;
}

- (CGSize)xyf_getSizeWithFont:(UIFont *)xyp_font maxSize:(CGSize)xyp_size {
    NSAttributedString * att = [[NSAttributedString alloc]initWithString:self attributes:@{NSFontAttributeName : xyp_font}];
    return [att boundingRectWithSize:xyp_size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;

}

- (NSString *)xyf_substringToIndex:(NSInteger)index {
    if(self.length <= index){
        return  self;
    }
    NSRange  rangeIndex = [self rangeOfComposedCharacterSequenceAtIndex:index];
    if(rangeIndex.length == 1){
        NSRange rangeRange = [self rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, index)];
        return [self substringWithRange:rangeRange];
    }else{
        NSRange rangeRange = [self rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, index - 1)];
        return [self substringWithRange:rangeRange];
    }
}

@end
