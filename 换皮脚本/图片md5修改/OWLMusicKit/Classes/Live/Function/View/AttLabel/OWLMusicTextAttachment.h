//
//  OWLMusicTextAttachment.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIView *_Nonnull(^XYLContentViewBlock)(void);

@interface OWLMusicTextAttachment : NSTextAttachment

/// 内容view
@property (nonatomic, weak, nullable) UIView *xyp_contentView;
@property (nonatomic, copy) XYLContentViewBlock xyp_contentViewBlock;

@end

NS_ASSUME_NONNULL_END
