//
//  OWLMusicEntryEffectPAGView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/29.
//

#import "OWLMusicEntryEffectPAGView.h"
#import <libpag/PAGView.h>
#import <libpag/PAGTextLayer.h>
#import <libpag/PAGImageLayer.h>
#import <libpag/PAGImageView.h>
#import "OWLBGMModuleVC.h"
#import <AVFoundation/AVFoundation.h>

@interface OWLMusicEntryEffectPAGView() <PAGImageViewListener>

@property (nonatomic, strong) PAGImageView * pagView;

@property (nonatomic, strong) NSMutableArray <OWLMusicEntryEffectPushMsg *> * modelArray;

@property (nonatomic, strong) PAGFile * file;

@property (nonatomic, strong) OWLMusicEntryEffectPushMsg * currentModel;

@property (nonatomic, strong) AVAudioPlayer * audioPlayer;

@end

@implementation OWLMusicEntryEffectPAGView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self setupViews];
        [self addAction];
    }
    return self;
}


#pragma mark public
- (void)xyf_loadModel:(OWLMusicEntryEffectPushMsg *)xyp_model{
    if(xyp_model.dsb_userId == OWLJConvertToolShared.xyf_userAccountID){
        [self.modelArray insertObject:xyp_model atIndex:0];
    }else{
        [self.modelArray addObject:xyp_model];
    }
    [self.pagView addListener:self];
    [self playModel];
}

- (void)xyf_clear{
    [self.pagView removeListener:self];
    [self.modelArray removeAllObjects];
    [self.pagView pause];
    self.currentModel = nil;
    self.file = nil;
    self.pagView.hidden = YES;
    if(self.audioPlayer){
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}

- (void)xyf_clearCurrentModel{
    if([self.modelArray containsObject:self.currentModel]){
        [self.modelArray removeObject:self.currentModel];
    }
    [self.pagView pause];
    self.currentModel = nil;
    self.file = nil;
    self.pagView.hidden = YES;
    if(self.audioPlayer){
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}

#pragma mark private

- (void)setupViews{
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.pagView];
    [self.pagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}


- (void)addAction{
    
}

- (void)playModel{
    if(self.modelArray.count == 0){
        return;
    }
    if(self.file){
        return;
    }
    self.currentModel = self.modelArray.firstObject;
    kXYLWeakSelf
    [self.currentModel xyf_getFilePath:^(NSString * _Nullable path) {
        kXYLStrongSelf
        if(path.length > 0 && self.currentModel){
            strongSelf.file = [PAGFile Load:path];
            if(strongSelf.file){
                PAGTextLayer * nameLayer = (PAGTextLayer *)[strongSelf.file getLayersByName:@"UsernameLayer"].firstObject;
                PAGLayer * joinedLayer =  [strongSelf.file getLayersByName:@"JoinedLayer"].firstObject;
                PAGImageLayer * imageLayer = (PAGImageLayer *)[strongSelf.file getLayersByName:@"AvatarLayer"].firstObject;
                NSData * audioData = strongSelf.file.audioBytes;
                if(audioData){
                    self.audioPlayer = [[AVAudioPlayer alloc]initWithData:audioData error:nil];
                    [self.audioPlayer prepareToPlay];
                }
                if(nameLayer){
                    UIFont * font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-%@",nameLayer.font.fontFamily,nameLayer.font.fontStyle] size:nameLayer.fontSize / 2];
                    NSString * content = [strongSelf xyf_getContentStringWithString:strongSelf.currentModel.dsb_userName andFont:font andWidth:120];
                    [nameLayer setText:content] ;
                    if(joinedLayer){
                        CGFloat contentWidth = [content xyf_getSizeWithFont:font maxSize:CGSizeMake(120, CGFLOAT_MAX)].width;
                        [joinedLayer setMatrix:CGAffineTransformMakeTranslation(contentWidth * 2, 0)];
                    }
                }
                if(imageLayer){
                    if(!strongSelf.currentModel.dsb_avater || strongSelf.currentModel.dsb_avater.length == 0){
                        UIImage * image = OWLJConvertToolShared.xyf_userPlaceHolder;
                        image = [image xyf_getCornerImageWithRadius: 32 imageSize:CGSizeMake(64, 64)];
                      
                        PAGImage * pagImage = [PAGImage FromCGImage:image.CGImage];
                        [imageLayer setImage:pagImage];
                        [strongSelf pagViewLoadFile];
                    }else{
                        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:strongSelf.currentModel.dsb_avater] options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                            if(image && !error){
                                image = [[[image xyf_fixOrientation]  xyf_cutResizedImage:CGSizeMake(64, 64)] xyf_getCornerImageWithRadius: 32 imageSize:CGSizeMake(64, 64)];
                                PAGImage * pagImage = [PAGImage FromCGImage:image.CGImage];
                                [imageLayer setImage:pagImage];
                                [strongSelf pagViewLoadFile];
                            }else{
                                UIImage * image = OWLJConvertToolShared.xyf_userPlaceHolder;
                                image = [image xyf_getCornerImageWithRadius: 32 imageSize:CGSizeMake(64, 64)];
                                PAGImage * pagImage = [PAGImage FromCGImage:image.CGImage];
                                [imageLayer setImage:pagImage];
                                [strongSelf pagViewLoadFile];
                            }
                        }];
                    }
                }else{
                    [strongSelf pagViewLoadFile];
                }
            }else{
                if([strongSelf.modelArray containsObject:strongSelf.currentModel]){
                    [strongSelf.modelArray removeObject:strongSelf.currentModel];
                }
                strongSelf.currentModel = nil;
                strongSelf.file = nil;
                if(strongSelf.audioPlayer){
                    [strongSelf.audioPlayer stop];
                    strongSelf.audioPlayer = nil;
                }
                [strongSelf playModel];
            }
        }else{
            if([strongSelf.modelArray containsObject:strongSelf.currentModel]){
                [strongSelf.modelArray removeObject:strongSelf.currentModel];
            }
            strongSelf.currentModel = nil;
            strongSelf.file = nil;
            if(strongSelf.audioPlayer){
                [strongSelf.audioPlayer stop];
                strongSelf.audioPlayer = nil;
            }
            [strongSelf playModel];
        }
    }];
   
}
- (void)pagViewLoadFile{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.currentModel.dsb_hostId == OWLMusicInsideManagerShared.xyp_hostID){
            /// 延迟0.1秒显示 是为了解决 偶尔会播放上一个pag视图的最后一帧
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.pagView.hidden = NO;
            });
            [self.pagView setComposition:self.file];
            [self.pagView play];
            if(self.audioPlayer){
                [self.audioPlayer play];
            }
        }else{
            if([self.modelArray containsObject:self.currentModel]){
                [self.modelArray removeObject:self.currentModel];
            }
            self.file = nil;
            self.currentModel = nil;
            self.pagView.hidden = YES;
            if(self.audioPlayer){
                [self.audioPlayer stop];
                self.audioPlayer = nil;
            }
            [self playModel];
        }
    });
}

- (void)onAnimationEnd:(PAGView *)pagView{
    if([self.modelArray containsObject:self.currentModel]){
        [self.modelArray removeObject:self.currentModel];
    }
    self.file = nil;
    self.currentModel = nil;
    if(self.audioPlayer){
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    self.pagView.hidden = YES;
    [self playModel];
    
}

- (NSString *)xyf_getContentStringWithString:(NSString *)xyp_string andFont:(UIFont *)xyp_font andWidth:(CGFloat)xyp_width{
   NSArray <NSString *>* array = [xyp_string xyf_linesWithMaxWidth:xyp_width font:xyp_font];
    if(array.count <= 1){
        return xyp_string;
    }else{
        return [self xyf_changeText:array.firstObject font:xyp_font width:xyp_width];
    }
}

- (NSString *)xyf_changeText:(NSString *)xyp_text font:(UIFont*)xyp_font width:(CGFloat)xyp_width{
    NSString * str = [xyp_text xyf_substringToIndex:(xyp_text.length - 1)];
    NSString * str1 = [str stringByAppendingString:@"..."];
    CGFloat wid = [str1 xyf_getSizeWithFont:xyp_font maxSize:CGSizeMake(xyp_width, CGFLOAT_MAX)].width;
    if(wid <= xyp_width){
        return str1;
    }else{
        return [self xyf_changeText:str font:xyp_font width:xyp_width];
    }
}

- (PAGImageView *)pagView {
    if(!_pagView){
        _pagView = [[PAGImageView alloc]init];
        _pagView.userInteractionEnabled = NO;
        [_pagView setRepeatCount:1];
        _pagView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _pagView;
}

- (NSMutableArray<OWLMusicEntryEffectPushMsg *> *)modelArray{
    if(!_modelArray){
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
