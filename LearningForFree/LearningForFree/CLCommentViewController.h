//
//  CLCommentViewController.h
//  LearningForFree
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDetailsModel.h"
#import "CLCommentModel.h"
#import "CLCommentCell.h"
#import "MJRefresh.h"

@interface CLCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,MJRefreshBaseViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) CLDetailsModel *detailModel;

@end
