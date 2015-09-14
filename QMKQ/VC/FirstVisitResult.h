//
//  FirstVisitResult.h
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "BaseVC.h"
#import "Patient.h"

@interface FirstVisitResult : BaseVC

@property (nonatomic, strong) NSDictionary * caseResult;
@property (nonatomic, retain) Patient *patient;

@end
