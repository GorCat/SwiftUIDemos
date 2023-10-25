//
//  OWLMusciCompressionTool.h
//  qianDuoDuo
//
//  Created by wdys on 2023/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusciCompressionTool : NSObject

/**
 解压
*/
+ (void)xyf_compressionResources;

/**
 获取svg路径
 @param name svg名字
*/
+ (NSString *)xyf_getPreparedSvgPathFrom:(NSString *)name;

/**
 获取gif路径
 @param name gif名字
*/
+ (NSString *)xyf_getPreparedGifPathFrom:(NSString *)name;

/**
 获取lproj路径
 @param name lproj名字
*/
+ (NSString *)xyf_getLprojPathFrom:(NSString *)name;

/**
 获取字体
 @param name 字体名字
 @param size 字体大小
*/
+ (UIFont *)xyf_getCorrespondFontWith:(NSString *)name andSize:(NSInteger)size;

/** 拼接地址 */
+ (NSString *)xyf_appendUrl:(NSString *)address dic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
