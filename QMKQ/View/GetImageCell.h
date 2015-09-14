//
//  GetImageCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *firstImgView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImgView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImgView;
@property (weak, nonatomic) IBOutlet UIImageView *lastImgView;


@end

@interface UIImageView (ADDTARGETANDACTION)

- (void)addImageGestureTarget:(id)target andAction:(SEL)action;

@end

