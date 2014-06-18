//
//  CLIntroView.m
//  LearningForFree
//
//  Created by apple on 14-5-23.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define INTROPAGE 3
#import "CLIntroView.h"

@implementation CLIntroView
{
    UIImage *bgImg;
    UILabel *desLabel;
//    UIButton *skipButton;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _introScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        _introScrollView.contentSize=CGSizeMake(_introScrollView.frame.size.width*INTROPAGE, _introScrollView.frame.size.height);
        _introScrollView.pagingEnabled=YES;
        _introScrollView.showsHorizontalScrollIndicator=NO;
        _introScrollView.bounces=NO;
        [self addSubview:_introScrollView];
        
        NSArray *titleArray=@[@"海量名校课程",@"视频下载观看",@"收藏与同步"];
        NSArray *desArray=@[@"  课程最全，中文翻译速度最快！两千余集精品课程，涵盖人文、哲学、数理、心理、经济等领域。",@"  视频下载到本地，无网络时也能看，省流量。可手动暂停或启动下载中的视频，支持断点续传。",@"  将喜爱的课程放入收藏夹，随身携带。收藏列表与云端保持同步，满足您在不同设备的收看需求。"];
        for (int i=0; i<INTROPAGE; i++) {
            UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0+320*i,0 , 320, [UIScreen mainScreen].bounds.size.height)];
            bgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
            [_introScrollView addSubview:bgView];
//            [_introScrollView sendSubviewToBack:bgView];
            
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(160-76+320*i, 100, 152, 152)];
            
            imgView.image=[UIImage imageNamed:@"icon-76"];
            [_introScrollView addSubview:imgView];
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(64 +320*i,imgView.frame.origin.y+imgView.frame.size.height+20, 152+40, 40)];
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.font=[UIFont systemFontOfSize:22];
            titleLabel.text=titleArray[i];
            [_introScrollView addSubview:titleLabel];
            
            CGSize desLabelSize=[desArray[i] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:(CGSize){titleLabel.frame.size.width+80,CGFLOAT_MAX} lineBreakMode:NSLineBreakByCharWrapping];
            desLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x-40, titleLabel.frame.origin.y+titleLabel.frame.size.height +15 , titleLabel.frame.size.width+80, desLabelSize.height)];
            desLabel.font=[UIFont systemFontOfSize:15];
            desLabel.numberOfLines=0;
            desLabel.text=desArray[i];
            [_introScrollView addSubview:desLabel];
        }
        
        UIButton * skipButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [skipButton setTitle:@"开始体验->" forState:UIControlStateNormal];
        skipButton.titleLabel.font=[UIFont systemFontOfSize:15];
        skipButton.frame=CGRectMake(240+320*2, desLabel.frame.origin.y+desLabel.frame.size.height, 80, 40);
        [skipButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_introScrollView addSubview:skipButton];
    }
    return self;
}
-(void)btnClick
{
    [self removeFromSuperview];
}
-(void)firstOpened
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *DocumentDirectory = [paths objectAtIndex:0];
    
    [fileManager changeCurrentDirectoryPath:[DocumentDirectory stringByExpandingTildeInPath]];
    
    [fileManager removeItemAtPath:@"firstOpenFile"error:nil];
    
    NSString *path = [DocumentDirectory stringByAppendingPathComponent:@"firstOpenFile"];
    
    NSMutableData  *writer = [[NSMutableData alloc] init];
    
    [writer appendData:nil];
    
    [writer writeToFile:path atomically:YES];
}
-(BOOL)isFirstOpen
{
    //判断文件是否存在
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,  YES) ;
    
    NSString *documentsDirectory =  [paths objectAtIndex:0] ;
    
    NSString *file = [documentsDirectory stringByAppendingPathComponent:@"firstOpenFile"] ;
    
    if ([[NSFileManager defaultManager]  fileExistsAtPath:file]) {
        
        return NO ;
        
    }
    
    return YES ;
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
