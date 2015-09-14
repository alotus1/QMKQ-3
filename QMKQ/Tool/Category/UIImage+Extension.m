
//
//  UIImage+Extension.m
//  UI-QQ聊天
//
//  Created by Lotus on 15-4-23.
//  Copyright (c) 2015年 zhaowei. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 *  图片拉伸功能
 *
 *  @param imageName <#imageName description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)resizableImage:(NSString *)imageName
{
    UIImage *nomal = [UIImage imageNamed:imageName];
    CGFloat top = nomal.size.height * 0.8;
    CGFloat left = nomal.size.width * 0.8;
    //重新生成一个图片对象(使用平铺方式),图片被拉伸是不会变形
    return [nomal resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top - 1, left - 1)];
}
@end
