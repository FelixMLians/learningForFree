//
//  CLIntroView.h
//  LearningForFree
//
//  Created by apple on 14-5-23.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLIntroView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_introScrollView;
}
@property (nonatomic,strong) UIScrollView *introScrollView;
-(void)btnClick;
-(void)firstOpened;
-(BOOL)isFirstOpen;

@end
