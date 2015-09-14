

#import "BOffLineCache.h"
#import "Tools.h"

NSString *const BOffLineCacheClearCacheNotificationName=@"BOffLineCacheClearDisk";

@implementation BOffLineCache


+(BOOL)clearDisk
{
    NSFileManager*manager=[[NSFileManager alloc]init];
    NSString*path=[BOffLineCache pathForOffLineCache];
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
    NSString*path=[BOffLineCache pathForOffLineCache];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:path];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

+(void)BOffLineCacheObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:BOffLineCacheClearCacheNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [BOffLineCache clearDisk];
    }];
}


+(NSString*)pathForOffLineCache
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
    //离线缓存文件夹
    NSString*offLineCachePath=[diskCachePath stringByAppendingPathComponent:BOffLineCacheDirectory];
    if (![manager fileExistsAtPath:offLineCachePath])
    {
        if (![manager createDirectoryAtPath:offLineCachePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            if (![manager createDirectoryAtPath:offLineCachePath withIntermediateDirectories:YES attributes:nil error:nil]) {
                return nil;
            }
        }
    }
    return offLineCachePath;
}


+(void)storeOffLineData:(id)object withKey:(id)key
{
    if (key&&object) {
        NSFileManager*manager=[[NSFileManager alloc]init];
        NSString*path=[BOffLineCache pathForOffLineCache];
        if (path) {
            NSString*filePath=[path stringByAppendingPathComponent:[Tools md5HexDigest:[NSString stringWithFormat:@"%@",key]]];
            NSData*data=[NSKeyedArchiver archivedDataWithRootObject:object];
            if (![manager createFileAtPath:filePath contents:data attributes:nil]) {
                if (![manager createFileAtPath:filePath contents:data attributes:nil]) {
                    [manager createFileAtPath:filePath contents:data attributes:nil];
                }
            }
        }
    }
}

+(id)offLineDataForKey:(id)key
{
    if (key) {
        NSFileManager*manager=[[NSFileManager alloc]init];
        NSString*path=[BOffLineCache pathForOffLineCache];
        if (path) {
            NSString*filePath=[path stringByAppendingPathComponent:[Tools md5HexDigest:[NSString stringWithFormat:@"%@",key]]];
            if ([manager fileExistsAtPath:filePath]) {
                NSData*data=[manager contentsAtPath:filePath];
                id objc=[NSKeyedUnarchiver unarchiveObjectWithData:data];
                return objc;
            }
        }
    }
    return nil;
}

@end
