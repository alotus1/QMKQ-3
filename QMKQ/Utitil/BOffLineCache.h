
#import <Foundation/Foundation.h>
#import "CacheConfig.h"
//如果没有自定义，则需要重新定义，即希望在配置文件定义常量
#ifndef BCacheDirectory
#define BCacheDirectory @"BCache"
#endif
#ifndef BOffLineCacheDirectory
#define BOffLineCacheDirectory @"BOffLineCache"
#endif

extern NSString *const BOffLineCacheClearCacheNotificationName;//warning：必须使用BOffLineCacheObserver:方法。使用并通知这个通知的名字，自动清除离线缓存所有数据

/**
 *  这是一个离线缓存的类
 */
@interface BOffLineCache : NSObject

+(BOOL)clearDisk;//清除磁盘

+(NSInteger)getSize;//获取磁盘所有离线文件的大小

+(void)BOffLineCacheObserver;//添加清除磁盘监听，监听名为BOffLineCacheClearCacheNotificationName

+(void)storeOffLineData:(id)object withKey:(id)key;//存储离线文件

+(id)offLineDataForKey:(id)key;//取出离线文件

@end
