//
//  CLDownloadViewController.h
//  LearningForFree
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRecommendModel.h"
#import "CLVideoDownloadController.h"
#import "CLDownloadingCell.h"
#import "CLVideoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIProgressDelegate.h"

@interface CLDownloadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate>

-(void)startDownloadOneItem:(int)itemNumber;
-(void)stopDownloadOneItem:(int)itemNumber;
@end
