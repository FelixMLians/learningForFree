//
//  CLDownloadViewController.m
//  LearningForFree
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define DOWNLOADVIDEOPATH [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Videos"]
#define TEMPDOWNLOADVIDEOPATH [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Temp"]

#import "CLDownloadViewController.h"

@interface CLDownloadViewController ()
{
    NSMutableArray *_loadedURLArray;
    NSMutableArray *_downloadCourseArray;
    CLRecommendModel *_recModel;
    
    UITableView *_downloadTableView;
    ASINetworkQueue *_myQueue;
}
@end

@implementation CLDownloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *dowItem=[[UITabBarItem alloc]initWithTitle:@"下载" image:[UIImage imageNamed:@"tab_download"] tag:103];
        self.tabBarItem = dowItem;
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        self.title=@"下载列表";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _loadedURLArray=[[NSMutableArray alloc]init];
    _downloadCourseArray=[[NSMutableArray alloc]init];
    
    [self createDownloadTableView];
    [self createDownloadVideoFolder];
    _downloadTableView.delegate=self;
    _downloadTableView.dataSource=self;
    [self getDataFromDatabase];
    
    //queue
    if (!_myQueue) {
        _myQueue=[[ASINetworkQueue alloc]init];
        _myQueue.maxConcurrentOperationCount = 5;
        [_myQueue setShowAccurateProgress:YES];
        _myQueue.shouldCancelAllRequestsOnFailure=NO;
    }
    _myQueue.delegate=self;
    [_myQueue go];
}
-(void)getDataFromDatabase
{
    [_downloadCourseArray removeAllObjects];
    [_loadedURLArray removeAllObjects];
    NSMutableArray *databaseArray=[[NSMutableArray alloc]init];
    databaseArray =[[CLDataBase sharedDataBase] getItemsFromDatabase];
    for (NSMutableArray *arr in databaseArray) {
        CLRecommendModel *recModel=[[CLRecommendModel alloc]init];
        CLDetailsModel *detailModel=[[CLDetailsModel alloc]init];
        recModel=[arr objectAtIndex:0];
        detailModel=[arr objectAtIndex:1];
        if (detailModel.titleString!=NULL) {
            [_downloadCourseArray addObject:detailModel];
            [_loadedURLArray addObject:detailModel.repovideourlString];
        }
    }
}
-(void)createDownloadVideoFolder
{
    //创建下载文件夹
    NSFileManager *manager=[NSFileManager defaultManager];
    NSError *error=nil;
    if (![manager fileExistsAtPath:DOWNLOADVIDEOPATH]) {
        BOOL isSuccess=[manager createDirectoryAtPath:DOWNLOADVIDEOPATH withIntermediateDirectories:YES attributes:nil error:&error];
        if(isSuccess)
        {
            NSLog(@"creat succesful");
        }
    }
    if (![manager fileExistsAtPath:TEMPDOWNLOADVIDEOPATH]) {
        BOOL isSuccess=[manager createDirectoryAtPath:TEMPDOWNLOADVIDEOPATH withIntermediateDirectories:YES attributes:nil error:&error];
        if(isSuccess)
        {
            NSLog(@"creat succesful");
        }
    }


}
-(void)createDownloadTableView
{
    //table view
    _downloadTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64-49) style:UITableViewStylePlain];
    _downloadTableView.bounces=NO;
    _downloadTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_downloadTableView];
    
    //background image
    UIImageView *bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg"]];
    bgView.frame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64-49);
    [_downloadTableView addSubview:bgView];
    [_downloadTableView sendSubviewToBack:bgView];
    
//    //segment
//    NSArray *segArr=[[NSArray alloc]initWithObjects:@"下载中",@"已下载", nil];
//    _segment=[[UISegmentedControl alloc]initWithItems:segArr];
//    _segment.frame=CGRectMake(0, 0, 160, 22);
//    _segment.selectedSegmentIndex=0;
//    [_segment addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.titleView=_segment;
    
    //edit button
    UIBarButtonItem *editBtn=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editDownloadList:)];
    self.navigationItem.rightBarButtonItem=editBtn;
}
-(void)editDownloadList:(UIBarButtonItem *)sender
{
    [_downloadTableView setEditing:!_downloadTableView.editing animated:YES];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _downloadCourseArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellid";
    CLDownloadingCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[CLDownloadingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CLDetailsModel *detailModel=[[CLDetailsModel alloc]init];
    detailModel=_downloadCourseArray[indexPath.row];
    cell.titleLabel.text=[NSString stringWithFormat:@"第%d课  %@",[detailModel.pnumberString intValue],detailModel.titleString];
    int size=(int)[detailModel.mp4sizeString longLongValue]/1024/1024;
    cell.progressBar.tag=indexPath.row+300;
    cell.sizeLabel.text=[NSString stringWithFormat:@"%dMB",size];
    cell.startButton.tag=indexPath.row+200;
    [cell.startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell reloadInputViews];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [[CLDataBase sharedDataBase] deleteDownloadDataFromUserTabel:_downloadCourseArray[indexPath.row]];
        [_downloadCourseArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLVideoViewController *videoView=[[CLVideoViewController alloc]init];
    
    CLDetailsModel *detailModel=[[CLDetailsModel alloc]init];
    detailModel=_downloadCourseArray[indexPath.row];
    NSArray *arr=[detailModel.repovideourlString componentsSeparatedByString:@"/"];
    NSString *str=[arr lastObject];
    NSString *videoPath=[NSString stringWithFormat:@"%@/%@.mp4",DOWNLOADVIDEOPATH,str];
    videoView.localVideoString=videoPath;
    [videoView watchOffLine];
    [self.navigationController pushViewController:videoView animated:YES];
}
-(void)startButtonClick:(UIButton *)sender
{
    if (!sender.selected) {
                [self startDownloadOneItem:sender.tag-200];
            }else{
                [self stopDownloadOneItem:sender.tag-200];
            }
            sender.selected=!sender.selected;
}
-(void)startDownloadOneItem:(int)itemNumber
{
    CLDownloadingCell *actionCell = (CLDownloadingCell *)[_downloadTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:itemNumber inSection:0]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_loadedURLArray[itemNumber]]];
    request.tag = itemNumber+100;
    request.delegate=self;
    request.downloadProgressDelegate= actionCell.progressBar;
    NSArray *arr=[_loadedURLArray[itemNumber] componentsSeparatedByString:@"/"];
    NSString *str=[arr lastObject];
    
    [request setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@/%@_temp.mp4",TEMPDOWNLOADVIDEOPATH,str]];
    [request setDownloadDestinationPath:[NSString stringWithFormat:@"%@/%@.mp4",DOWNLOADVIDEOPATH,str]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@_temp.mp4",TEMPDOWNLOADVIDEOPATH,str]);
    
    [request setAllowResumeForFileDownloads:YES];
    
    [_myQueue addOperation:request];
    
    /*
    //添加缓存数据
    NSMutableData *_downloadData=[[NSMutableData alloc]init];
    _downloadData.length=0;
    NSData *cache=[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@_temp.mp4",TEMPDOWNLOADVIDEOPATH,str]];
    [_downloadData appendData:cache];
    
    //同步数据
    [request setDataReceivedBlock:^(NSData *data) {
        //total size
        CLDetailsModel *detailModel=[[CLDetailsModel alloc]init];
        detailModel=_downloadCourseArray[itemNumber];
        int totalSize=(int)[detailModel.mp4sizeString longLongValue]/1024/1024;
        //temp size
        [_downloadData appendData:data];
        int tempSize=(int)_downloadData.length/1024/1024;
        actionCell.sizeLabel.text=[NSString stringWithFormat:@"%d/%dMB",tempSize,totalSize];
    }];
     */
}
-(void)stopDownloadOneItem:(int)itemNumber
{
    //operations方法返回队列里的所有请求
    NSArray *requestArray=[_myQueue operations];
    for (ASIHTTPRequest *request in requestArray) {
    //取消请求
        if (request.tag==100+itemNumber) {
        [request clearDelegatesAndCancel];
        }
    }
        NSLog(@"download pause");
}

#pragma mark - ASIHTTPRequestDelegate
//请求开始
- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}
//请求收到响应的头部，主要包括文件大小信息，下面会用到
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"%@",responseHeaders);
}
//请求将被重定向
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    
}
//请求完成
- (void)requestFinished:(ASIHTTPRequest *)request
{
    int number=request.tag;
    CLDownloadingCell *actionCell = (CLDownloadingCell *)[_downloadTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:number inSection:0]];
    [actionCell.startButton setHidden:YES];
    
}
//请求失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败，请查看网络");
}
//请求已被重定向
- (void)requestRedirected:(ASIHTTPRequest *)request
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getDataFromDatabase];
    [_downloadTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
