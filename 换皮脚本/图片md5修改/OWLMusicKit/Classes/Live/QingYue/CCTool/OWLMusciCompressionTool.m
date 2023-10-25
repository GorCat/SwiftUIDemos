//
//  OWLMusciCompressionTool.m
//  qianDuoDuo
//
//  Created by wdys on 2023/3/7.
//

#import "OWLMusciCompressionTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CTFontManager.h>
@import SSZipArchive;

@implementation OWLMusciCompressionTool : NSObject

#pragma mark - 解压
+ (void)xyf_compressionResources {
    NSString * resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:kXYLResourceName]];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:resourcePath isDirectory:&isDir];
    if (!(isDir == YES && existed == YES)) {
        // 在 Document 目录下创建一个 资源 文件夹
        [fileManager createDirectoryAtPath:resourcePath withIntermediateDirectories:YES attributes:nil error:nil];
        [self xyf_compressionToSpecifiedPath:resourcePath];
    } else {//如果已经存在资源 判断是否需要更新
//        NSString * tempPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:kXYLResourceName]];
//        BOOL isDir = NO;
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        BOOL existed = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
//        if (!(isDir == YES && existed == YES)) {
//            [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        NSString * snapPath = [tempPath stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/%@",kXYLZipName]];
//        [self xyf_compressionToSpecifiedPath:tempPath];
//        NSString * oldMd5 = [self xyf_getFileMD5StrFromPath:[resourcePath stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/%@",kXYLZipName]]];
//        NSString * xyp_newMd5 = [self xyf_getFileMD5StrFromPath:snapPath];
//        if (![oldMd5 isEqualToString:xyp_newMd5]) {
            [self xyf_compressionToSpecifiedPath:resourcePath];
//        }
    }
}

#pragma mark - 解压到指定资源文件夹
+ (void)xyf_compressionToSpecifiedPath:(NSString *)filePath {
    //解压到资源文件夹
    [SSZipArchive unzipFileAtPath:[self xyf_getZipPath]
                    toDestination:filePath
                        overwrite:YES
                         password:kXYLRecourcePW
                  progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) { }
                completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"解压成功");
        }
    }];
}

#pragma mark - 获取zip资源路径
+ (NSString *) xyf_getZipPath {
    //获取当前类文件所在的bundle qytodo
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString * zipPath = [currentBundle pathForResource:kXYLZipName ofType:@"zip"];
    return zipPath;
}

#pragma mark - 获取svg路径
+ (NSString *)xyf_getPreparedSvgPathFrom:(NSString *)name {
    NSString * resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:kXYLResourceName]];
    NSString * resultPath = [resourcePath stringByAppendingFormat:@"/%@/%@.svga",kXYLZipName,name];
    return resultPath;
}

#pragma mark - 获取gif路径
+ (NSString *)xyf_getPreparedGifPathFrom:(NSString *)name {
    NSString * resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:kXYLResourceName]];
    NSString * resultPath = [resourcePath stringByAppendingFormat:@"/%@/%@.gif",kXYLZipName,name];
    return resultPath;
}

#pragma mark - 获取lproj路径
+ (NSString *)xyf_getLprojPathFrom:(NSString *)name {
    NSString *resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:kXYLResourceName]];
    NSString *resultPath = [resourcePath stringByAppendingFormat:@"/%@/localString/%@.lproj",kXYLZipName,name];
    return resultPath;
}

#pragma mark - 获取字体
+ (UIFont *)xyf_getCorrespondFontWith:(NSString *)name andSize:(NSInteger)size {
    UIFont * resutFont = [UIFont fontWithName:name size:size];
    if (!resutFont) {
        [self xyf_dynamicallyLoadFontNamed:name];
        resutFont = [UIFont fontWithName:name size:size];
        if (!resutFont) resutFont = [UIFont systemFontOfSize:size];
    }
    return resutFont;
}

+ (void)xyf_dynamicallyLoadFontNamed:(NSString *)name {
    NSString * resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:kXYLResourceName]];
    NSString * resultPath = [resourcePath stringByAppendingFormat:@"/%@/%@.otf",kXYLZipName,name];
    NSURL *url = [NSURL fileURLWithPath:resultPath];
    NSData *fontData = [NSData dataWithContentsOfURL:url];
    if (fontData) {
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);
    }
}

#pragma mark - 获取文件的MD5
+ (NSString *)xyf_getFileMD5StrFromPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path isDirectory:nil]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        unsigned char digest[OWLPP_MD5_DIGEST_LENGTH];
        OWLPP_MD5( data.bytes, (OWLPP_LONG)data.length, digest );
        NSMutableString *output = [NSMutableString stringWithCapacity:OWLPP_MD5_DIGEST_LENGTH * 2];
        for( int i = 0; i < OWLPP_MD5_DIGEST_LENGTH; i++ ) {
            [output appendFormat:@"%02x", digest[i]];
        }
        return output;
    } else {
        return @"";
    }
}

#pragma mark - 拼接地址
+ (NSString *)xyf_appendUrl:(NSString *)address dic:(NSDictionary *)dic {
    NSString *appendUrl = address;
    if (dic.count > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict addEntriesFromDictionary:dic];
        
        NSMutableArray *array = [NSMutableArray array];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [array addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        
        if (array.count > 0) {
            NSString *queryString = [array componentsJoinedByString:@"&"];
            appendUrl = [appendUrl stringByAppendingFormat:@"?%@",[NSString xyf_urlEncodeString:queryString]];
        }
    }
    return appendUrl;
}

@end
