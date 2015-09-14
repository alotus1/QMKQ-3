
#import "BImageCache.h"
#import "Tools.h"

NSString *const BImageCacheClearDiskNotificationName=@"BImageCacheClearDisk";

@implementation BImageCache


+(void)BImageCacheCheckTimeOutFile
{
    //在这里把超时文件去掉
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-cacheMaxCacheAge];
    NSString*imagePath=[BImageCache pathForImageCache];
    NSFileManager*manager=[[NSFileManager alloc]init];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:imagePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [imagePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [manager attributesOfItemAtPath:filePath error:nil];
        if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
        {
            [manager removeItemAtPath:filePath error:nil];
        }
    }
}

+(BOOL)clearDisk
{
    NSFileManager*manager=[[NSFileManager alloc]init];
    NSString*path=[BImageCache pathForImageCache];
    [manager removeItemAtPath:path error:nil];
    if (![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
        if (![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
            return NO;
        }
    }
    return YES;
}

+(NSInteger)getSize
{
    NSUInteger size = 0;
    NSFileManager*manager=[[NSFileManager alloc]init];
    NSString*path=[BImageCache pathForImageCache];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:path];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

+(void)BImageCacheCheckImageObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:BImageCacheClearDiskNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [BImageCache clearDisk];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [BImageCache BImageCacheCheckTimeOutFile];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [BImageCache BImageCacheCheckTimeOutFile];
    }];
}

+(NSString*)pathForImageCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString*diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:BCacheDirectory];
    NSFileManager*manager=[[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:diskCachePath])
    {
        if (![manager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            if (![manager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:nil]) {
                return nil;
            }
        }
    }
    //图片文件夹
    NSString*imageCachePath=[diskCachePath stringByAppendingPathComponent:BImageCacheDirectory];
    if (![manager fileExistsAtPath:imageCachePath])
    {
        if (![manager createDirectoryAtPath:imageCachePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            if (![manager createDirectoryAtPath:imageCachePath withIntermediateDirectories:YES attributes:nil error:nil]) {
                return nil;
            }
        }
    }
    return imageCachePath;
}

+(void)storeImage:(UIImage *)image forKey:(NSString *)urlString completion:(BStoreImageBlock)block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager*manager=[[NSFileManager alloc]init];
        NSString*path=[BImageCache pathForImageCache];
        if (!path) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO);
            });
        }
        NSString *filePath = [path stringByAppendingPathComponent:[Tools md5HexDigest:urlString]];
        if (![manager createFileAtPath:filePath contents:[NSKeyedArchiver archivedDataWithRootObject:image] attributes:nil]) {
            if (![manager createFileAtPath:filePath contents:[NSKeyedArchiver archivedDataWithRootObject:image] attributes:nil]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO);
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES);
            });
        }
    });
}

+(void)findImageForKey:(NSString *)urlString completion:(BFindImageBlock)block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager*manager=[[NSFileManager alloc]init];
        NSString*path=[BImageCache pathForImageCache];
        if (!path)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(NO,nil);
            });
        }
        NSString *filePath = [path stringByAppendingPathComponent:[Tools md5HexDigest:urlString]];
        if ([manager fileExistsAtPath:filePath]) {
            NSData*imageData=[manager contentsAtPath:filePath];
            UIImage*image=[NSKeyedUnarchiver unarchiveObjectWithData:imageData];
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(YES,image);
            });
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(NO,nil);
            });
        }
    });
}

@end
