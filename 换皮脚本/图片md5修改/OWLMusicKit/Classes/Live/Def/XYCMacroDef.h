//
//  XYCMacroDef.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#ifndef XYCMacroDef_h
#define XYCMacroDef_h

#import "XYCUtil.h"
#import "OWLMusciCompressionTool.h"

#define kXYLGilroyRegularFont(s) [OWLMusciCompressionTool xyf_getCorrespondFontWith:@"gilroy-regular" andSize:s]
#define kXYLGilroyMediumFont(s) [OWLMusciCompressionTool xyf_getCorrespondFontWith:@"gilroy-Medium" andSize:s]
#define kXYLGilroyBoldFont(s) [OWLMusciCompressionTool xyf_getCorrespondFontWith:@"gilroy-bold" andSize:s]
#define kXYLGilroyExtraBoldItalicFont(s) [OWLMusciCompressionTool xyf_getCorrespondFontWith:@"gilroy-ExtraBoldItalic" andSize:s]

/// 宽高
#define kXYLScreenWidth [UIScreen mainScreen].bounds.size.width
#define kXYLScreenHeight [UIScreen mainScreen].bounds.size.height
#define kXYLStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kXYLIPhoneBottomHeight ([XYCUtil xyf_isIPhoneX] ? 34 : 0)
#define kXYLScreenBounds     [UIScreen mainScreen].bounds

/// 屏幕适配
#define kXYLWidthScale(float) (float * kXYLScreenWidth/375)
#define kXYLHeightScale(float) (float * kXYLScreenHeight/667)

/// 颜色
#define kXYLColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kXYLColorFromRGBA(rgbValue, aValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:aValue]

#define kXYLLocalString(_key) [_key xyf_localString]

#define kXYLLocalBundle [NSBundle mainBundle]

/// 弱引用
#define kXYLWeakSelf __weak typeof(self) weakSelf = self;

#define kXYLStrongSelf     __strong __typeof(weakSelf) strongSelf = weakSelf;

/** 资源zip包名 */
#define kXYLZipName @"cc_resources"

/** 解压密码 */
#define kXYLRecourcePW @"asasas"

/** 解压后的资源文件夹名 */
#define kXYLResourceName @"cc_downloadResource"

/** 多语言文件夹（在zip包里面）*/
#define kXYLStringFileInZip @"localString"

#define kXYLDownloadPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kXYLDownloadPathPag      [kXYLDownloadPath stringByAppendingString:@"/xyl_localPag"]

#endif /* XYCMacroDef_h */
