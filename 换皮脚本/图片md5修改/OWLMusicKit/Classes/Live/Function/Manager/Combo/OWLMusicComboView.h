//
//  OWLMusicComboView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/27.
//

#import <UIKit/UIKit.h>
@class OWLMusicComboView;
NS_ASSUME_NONNULL_BEGIN

@protocol OWLMusicComboViewDelegate <NSObject>

- (void)xyf_comboViewDidFinish:(OWLMusicComboView *)xyp_comboView;

@end

@interface OWLMusicComboView : UIView

@property (nonatomic, assign) NSInteger xyp_roomId;

@property (nonatomic, assign) NSInteger xyp_giftId;

@property (nonatomic, weak) id<OWLMusicComboViewDelegate> delegate;

- (instancetype)initWithIsQuickGift:(BOOL)isQuick numberFont:(UIFont*)font;

- (void)xyf_finishCountDown;

- (void)xyf_raise;

@end

@interface OWLMusicComboViewManager : NSObject

+ (instancetype)shared;

- (void)xyf_ClickedGift:(NSInteger)xyp_giftId roomId:(NSInteger)xyp_roomId container:(UIView *)xyp_container frame:(CGRect)xyp_frame isQuick:(BOOL)xyp_isQuick numberFont:(nullable UIFont*)xyp_font;

- (void)xyf_removeCurrentComboViewFromSuperView;

@end

NS_ASSUME_NONNULL_END
