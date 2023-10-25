//
//  OWLPPBannerDetailAlert.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLPPBannerDetailAlert : UIView

/** 设置url */
- (void)xyf_setupUrl:(NSString *)url;

/** 显示弹窗 */
- (void) xyf_showAlert;

@end

NS_ASSUME_NONNULL_END
