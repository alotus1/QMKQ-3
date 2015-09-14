//
//  UIImage+Extension.h
//  UI-QQ聊天
//
//  Created by Lotus on 15-4-23.
//  Copyright (c) 2015年 zhaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  图片拉伸功能
 *
 *  @param imageName <#imageName description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)resizableImage:(NSString *)imageName;
@end
