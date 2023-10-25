//
//  NSString+XYLExtention.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XYLExtention)

- (NSString *)xyf_md5;

- (NSString *)xyf_localString;

- (NSString *)xyf_stringByURLEncode;

/** 获取资源图片 */
- (UIImage *)xyf_getOwnImageFromName;

- (NSString *)xyf_stringByTrim;

+ (NSString *)xyf_urlEncodeString:(NSString *)str;

+ (NSString *)xyf_decimalString:(CGFloat)value maxFloat:(int)maxFloat;

- (NSArray <NSString *>*)xyf_linesWithMaxWidth:(CGFloat)xyp_width font:(UIFont *)xyp_font;

- (CGSize)xyf_getSizeWithFont:(UIFont *)xyp_font maxSize:(CGSize)xyp_size;

- (NSString *)xyf_substringToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
