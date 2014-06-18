//
//  CLVideoDownloadController.h
//  LearningForFree
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRecommendModel.h"
#import "CLDetailsModel.h"
#import "CLDownloadViewController.h"
#import "CLDataBase.h"

@interface CLVideoDownloadController : UIViewController

@property (nonatomic,strong) CLRecommendModel *recModel;
@property (nonatomic,strong) NSMutableArray *allListArray;

@end
