//
//  CLAppDelegate.h
//  LearningForFree
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

@class CLIntroViewController;

@interface CLAppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>
{
    NSString* wbtoken;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLIntroViewController *introCtl;
@property (strong, nonatomic) NSString *wbtoken;

@end
