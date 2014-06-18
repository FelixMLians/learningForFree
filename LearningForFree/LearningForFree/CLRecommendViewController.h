//
//  CLRecommendViewController.h
//  LearningForFree
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRecommendModel.h"
#import "NSString+SBJSON.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Colours.h"
#import "CLCourseViewController.h"
#import "CLDetailViewController.h"

@interface CLRecommendViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate,UIScrollViewDelegate>

@end
