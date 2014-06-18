//
//  CLVideoDownloadController.m
//  LearningForFree
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLVideoDownloadController.h"

@interface CLVideoDownloadController ()
{
    UIScrollView *_downloadScrollView;
    NSMutableArray *_downloadListArray;
    int totalSize;
}
@end

@implementation CLVideoDownloadController

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
    _downloadListArray=[[NSMutableArray alloc]init];
    [self createItemButtons];
    
}
-(void)createItemButtons
{
    //create scrollView
    _downloadScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64)];
    _downloadScrollView.contentSize=CGSizeMake(320, _downloadScrollView.frame.size.height*(self.allListArray.count/7+1));
    _downloadScrollView.bounces=NO;
    [self.view addSubview:_downloadScrollView];
    
    //create background image
    UIImageView *bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg"]];
    bgView.frame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height*(self.allListArray.count/7+1));
    [_downloadScrollView addSubview:bgView];
    
    //create right download button
    UIImage* rightBtnImg = [UIImage imageNamed:@"download"];
    CGRect rightframe = CGRectMake(0,0,44,44);
    UIButton* rightBtn= [[UIButton alloc] initWithFrame:rightframe];
    [rightBtn setBackgroundImage:rightBtnImg forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(downloadItems:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *downloadBtn=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=downloadBtn;
    
    //create item title and buttons
    for (int i=0; i<self.allListArray.count-1; i++) {
        UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 6+60*i, 320, 60)];
        bgView.image=[UIImage imageNamed:@"topbar_set"];
        [_downloadScrollView addSubview:bgView];
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 6+60*i, 260, 60)];
        title.layer.cornerRadius=10;
        CLDetailsModel *model=[[CLDetailsModel alloc]init];
        model=self.allListArray[i+1];
        title.text=[NSString stringWithFormat:@"第%@课  %@",model.pnumberString,model.titleString];
        [_downloadScrollView addSubview:title];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"editNormal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"editSelected"] forState:UIControlStateSelected];
        btn.selected=NO;
        btn.frame=CGRectMake(276, 10+60*i, 44, 44);
        btn.tag=200+i;
        [btn addTarget:self action:@selector(chooseItems:) forControlEvents:UIControlEventTouchUpInside];
        [_downloadScrollView addSubview:btn];
    }
}
-(void)chooseItems:(UIButton *)sender
{
    totalSize=0;
    if (sender.selected==NO) {
        [_downloadListArray addObject:[_allListArray objectAtIndex:sender.tag-200+1]];
    }else{
        [_downloadListArray removeObject:[_allListArray objectAtIndex:sender.tag-200+1]];
    }
    for (CLDetailsModel *model in _downloadListArray) {
        int size=[model.mp4sizeString intValue]/1024;
        totalSize +=size/1024;
    }
    [self setTitle:[NSString stringWithFormat:@"已选 %d MB",totalSize]];
    sender.selected=!sender.selected;
}
-(void)downloadItems:(UIBarButtonItem *)sender
{
    //下载目录存入本地数据库
    for (CLDetailsModel *detailModel in _downloadListArray) {
    BOOL isDownloaded=[[CLDataBase sharedDataBase] insertDataOfDowWithItem:detailModel aItem:nil];
    if (!isDownloaded) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"第%@集已经下载过了",detailModel.pnumberString]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
