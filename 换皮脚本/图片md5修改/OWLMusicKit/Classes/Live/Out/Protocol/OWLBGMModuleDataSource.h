//
//  OWLBGMModuleDataSource.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间数据源
 * @创建时间：2023.2.9
 * @创建人：许琰
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OWLBGMModuleDataSource <NSObject>

/**
 1.为了减少 "各包模型 => 字典 => SDK模型" 的性能消耗
 2.避免外部更新信息时，需要在外部各个更新的地方 去调方法更新SDK内部模型信息
 ==> 所以此处采用get具体属性的方式实时获取外面的数据，辛苦大家接一下惹【鞠躬】
 3.以下三个方法 获取文本、数字、字典信息的时候 都用switch 然后别写default 方便以后更新。
 */

/// 获取文本类型信息
- (NSString *)xyf_getOutTextTypeInfo:(XYLOutDataSourceTextInfoType)textType;

/// 获取数字类型信息
- (NSInteger)xyf_getOutNumTypeInfo:(XYLOutDataSourceNumInfoType)numType;

/// 获取字典类型信息
- (NSDictionary *)xyf_getOutDicTypeInfo:(XYLOutDataSourceDicInfoType)dicType;

/// 获取布尔类型信息
- (BOOL)xyf_getOutBoolTypeInfo:(XYLOutDataSourceBoolInfoType)boolType;

/// 获取小数类型信息
- (float)xyf_getOutFloatTypeInfo:(XYLOutDataSourceFloatInfoType)floatType;

/// 获取数组类型信息
- (NSMutableArray *)xyf_getOutArrayTypeInfo:(XYLOutDataSourceArrayInfoType)arrayType;

/// 获取RTC实例【注：每个主包应该都有自己的RTC单例】
- (AgoraRtcEngineKit *)xyf_getRTCKit;

/// 获取RTM实例【注：每个主包应该都有自己的RTM单例】
- (AgoraRtmKit *)xyf_getRTMKit;

/// 用户头像占位图
- (UIImage *)xyf_userAvatarPlaceHolderImage;

/// 获取当前网络状态
- (XYLOutDataSourceNetworkStateType)xyf_getOutNetworkState;

/// SSE状态（xy本人也不知道干嘛的 反正先传个1 →_→）
- (NSInteger)xyf_sseStatus;

/// 获取当前窗口
- (UIWindow *)xyf_getOutKeyWindow;

/// 获取当前VC
- (UIViewController *)xyf_outsideModuleGetCurrentVC;

/// 根据性别字符串返回性别类型（和主包的判断逻辑保持一致）
- (XYLOutDataSourceGenderType)xyf_outsideModuleGetGenderType:(NSString *)genderStr;

@optional
/// 当外部没有🐴+的时候二次拒绝文案
- (NSString *)xyf_outsideModuleGetRefuseAuthErrorTip:(XYLSystemAuthType)type;

/// 获取主包svg文件路径
- (NSString *)xyf_getSVGPathWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
