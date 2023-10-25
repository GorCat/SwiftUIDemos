//
//  OWLBGMHeader.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/12.
//

#ifndef OWLBGMHeader_h
#define OWLBGMHeader_h

#pragma mark - 定义类
#import "XYCEnum.h"
#import "XYCMacroDef.h"
#import "XYCNotificationDef.h"

#pragma mark - 三方库
#import <AgoraRtmKit/AgoraRtmKit.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <SDWebImage/SDWebImage.h>
#import <SVGAPlayer/SVGA.h>

#pragma mark --- 外部 ---
#import "OWLMusicEventLabelModel.h"
#import "OWLMusicRequestApiModel.h"
#import "OWLMusicPayModel.h"
#import "OWLMusicFanInfoModel.h"
#import "OWLBGMModuleDataSource.h"
#import "OWLBGMModuleDelegate.h"
#import "OWLBGMModuleManager.h"

#pragma mark --- 内部 ---
#pragma mark 定义
#import "OWLJayoutDef.h"

#pragma mark 分类
#import "NSArray+XYLExtention.h"
#import "NSObject+XYLExtention.h"
#import "NSString+XYLExtention.h"
#import "UIImage+XYLExtention.h"
#import "NSDictionary+XYLExtention.h"
#import "UITableView+XYLExtention.h"
#import "UIView+XYLExtention.h"
#import "NSMutableArray+XYLExtention.h"
#import "UIScrollView+XYLExtention.h"
#import "UILabel+XYLExtention.h"

#pragma mark 模型
#import "OWLBGMModuleBaseModel.h"
#import "OWLBGMModuleUserModel.h"
#import "OWLBGMModuleAnchorModel.h"
#import "OWLMusicRoomTotalModel.h"
#import "OWLMusicEnterConfigModel.h"
#import "OWLMusicMessageModel.h"
#import "OWLMusicAccountDetailInfoModel.h"

#pragma mark 工具类
#import "XYCStringTool.h"
#import "XYCUtil.h"
#import "XYCUtil+LoadSource.h"
#import "OWLMusicInsideManager.h"
#import "OWLBGMModuleManagerConvertTool.h"
#import "OWLMusicRequestApiManager.h"
#import "OWLMusicTongJiTool.h"

#pragma mark 协议
#import "OWLBGMModuleBaseViewDelegate.h"
#import "OWLMusicSubManagerDataSource.h"

#endif /* OWLBGMHeader_h */
