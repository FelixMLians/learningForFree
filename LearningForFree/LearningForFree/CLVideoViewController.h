//
//  CLVideoViewController.h
//  LearningForFree
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLVideoViewController : UIViewController

@property (nonatomic,strong) NSString *weburlString;
@property (nonatomic,strong) NSString *localVideoString;

-(void)watchOnLine;
-(void)watchOffLine;
@end
