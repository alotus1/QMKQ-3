//
//  Tools.m
//  QMKQ
//
//  Created by shangjin on 15/8/1.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Tools

+(NSString *)md5HexDigest:(NSString*)password{
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    // 警告（CC_LONG）
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (NSInteger i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    
    // DLog(@"Encryption Result = %@",mdfiveString);
    return mdfiveString;
}

+ (void)button:(UIButton *)button removeAllActionsFromTarget:(id)target
{
    [[self class] button:button removeAllActionsFromTarget:target controlEvents:UIControlEventTouchUpInside];
}
+ (void)button:(UIButton *)button removeAllActionsFromTarget:(id)target controlEvents:(UIControlEvents)events
{
    for (NSString*sel in [button actionsForTarget:target forControlEvent:UIControlEventTouchUpInside]) {
        SEL send = NSSelectorFromString(sel);
        [button removeTarget:target action:send forControlEvents:UIControlEventTouchUpInside];
    }
}


+ (void)button:(DLRadioButton *)button andOthersButtonAddTarget:(id)target action:(SEL)action
{
    [[self class] button:button andOthersButtonAddTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
+ (void)button:(DLRadioButton *)button andOthersButtonAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)events
{
    [button addTarget:target action:action forControlEvents:events];
    for (DLRadioButton*bt in button.otherButtons) {
        if (![bt isKindOfClass:[DLRadioButton class]]) {
            continue;
        }
        [bt addTarget:target action:action forControlEvents:events];
    }
}


+ (BOOL) validateMobile:(NSString *)number
{
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:number];
}


+ (NSString*)imageFromString:(NSString*)str withSuffix:(NSString*)suffix
{
    if (str.length>0) {
        NSString * suf = @".png";
        NSArray*image = [str componentsSeparatedByString:suf];
        NSString * url = @"";
        if (image.count>0) { }else {
            suf = @".jpg";
            image = [str componentsSeparatedByString:suf];
            if (image.count>0) { }else {
                suf = @".jpeg";
                image = [str componentsSeparatedByString:suf];
            }
        }
        for (NSInteger i = 0; i < image.count; i++) {
            url = [url stringByAppendingString:[image objectAtIndex:i]];
        }
        url = [url stringByAppendingString:suffix];
        url = [url stringByAppendingString:suf];
        return url;
    }
    return nil;
}

@end
