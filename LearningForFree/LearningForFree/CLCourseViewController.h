//
//  CLCourseViewController.h
//  LearningForFree
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCourseCell.h"
#import "CLRecommendModel.h"
#import "UIImageView+WebCache.h"
#import "CLDetailViewController.h"

@interface CLCourseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

-(void)registerNotification;
@end
