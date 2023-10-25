//
//  OWLPPPageControl.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLPPPageControl : UIView

@property (nonatomic, assign) NSInteger numberPages;

@property (nonatomic, assign) NSInteger currentPage;

- (instancetype)initWithFrame:(CGRect)frame andAllPoint:(NSInteger) count;
 
@end

NS_ASSUME_NONNULL_END
