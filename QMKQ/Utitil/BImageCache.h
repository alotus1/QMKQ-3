

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CacheConfig.h"
//如果没有自定义，则需要重新定义，即希望在配置文件定义常量
#ifndef BCacheDirectory
#define BCacheDirectory @"BCache"
#endif
#ifndef BImageCacheDirectory
#define BImageCacheDirectory @"BImageCache"
#endif

extern NSString *const BImageCacheClearDiskNotificationName;

static NSInteger cacheMaxCacheAge = 60*60*24*7; //文件最大缓存时间：7天

typedef void (^BStoreImageBlock) (BOOL success);

typedef void (^BFindImageBlock) (BOOL success,UIImage*image);

/**
 *  图片缓存类，使用block
 */
@interface BImageCache : NSObject

+(void)BImageCacheCheckTimeOutFile;//找出过期文件

+(BOOL)clearDisk;//清空磁盘

+(NSInteger)getSize;//获取磁盘存储的所有图片的大小

+(void)BImageCacheCheckImageObserver;//添加监听，使得在程序结束和退到后台的时候自动清理过期文件

+(void)storeImage:(UIImage*)image forKey:(NSString*)urlString completion:(BStoreImageBlock)block;//在磁盘中存储一个图片

+(void)findImageForKey:(NSString*)urlString completion:(BFindImageBlock)block;//在磁盘中找到一个图片



@end
