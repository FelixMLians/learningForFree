//
//  CLVideoViewController.m
//  LearningForFree
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CLVideoViewController ()
{
    MPMoviePlayerViewController *_playerCtl;
}
@end

@implementation CLVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)watchOnLine
{
    _playerCtl=[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:_weburlString]];
    [self.view addSubview:_playerCtl.view];
    [_playerCtl.moviePlayer prepareToPlay];
    [_playerCtl.moviePlayer shouldAutoplay];
    [self presentMoviePlayerViewControllerAnimated:_playerCtl];
    [_playerCtl.moviePlayer setControlStyle:MPMovieControlStyleDefault];
    [_playerCtl.view setBackgroundColor:[UIColor clearColor]];
    [_playerCtl.view setFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:_playerCtl];
}
-(void)watchOffLine
{
    _playerCtl=[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:_localVideoString]];
    [self.view addSubview:_playerCtl.view];
    [_playerCtl.moviePlayer prepareToPlay];
    [_playerCtl.moviePlayer shouldAutoplay];
    [self presentMoviePlayerViewControllerAnimated:_playerCtl];
    [_playerCtl.moviePlayer setControlStyle:MPMovieControlStyleDefault];
    [_playerCtl.view setBackgroundColor:[UIColor clearColor]];
    [_playerCtl.view setFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:_playerCtl.moviePlayer];
}

-(void)movieFinishedCallback:(NSNotification*)notify
{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
     
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
     
                                                  object:theMovie];
    
    [self dismissMoviePlayerViewControllerAnimated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
