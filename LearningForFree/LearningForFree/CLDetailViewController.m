//
//  CLDetailViewController.m
//  LearningForFree
//
//  Created by apple on 14-5-23.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

#define DETAILURL @"http://mobile.open.163.com/movie/%@/getMoviesForAndroid.htm"
#import "CLDetailViewController.h"
#import "CLAppDelegate.h"

@interface CLDetailViewController ()
{
    NSMutableData *_downloadData;
    NSMutableArray *_videoListArray;
}
@end

@implementation CLDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"课程详情";
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _videoListArray=[[NSMutableArray alloc]init];
    _downloadData=[[NSMutableData alloc]init];
    _videoTableView.delegate=self;
    _videoTableView.dataSource=self;
    _videoTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _videoTableView.bounces=NO;
    [self addToolBar];
    [self setBackgoundImage];
    [self sendRequest];
    [self presentTopViewData];
    
}
-(void)setBackgoundImage
{
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, -2, 320, 125)];
    bgView.image=[UIImage imageNamed:@"board"];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
    UIImageView *bgView2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 449)];
    bgView2.image=[UIImage imageNamed:@"background"];
    [_contentView addSubview:bgView2];
    [_contentView sendSubviewToBack:bgView2];
    UIImageView *bgView3=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 449)];
    bgView3.image=[UIImage imageNamed:@"cell_bg"];
    [_videoTableView addSubview:bgView3];
    [_videoTableView sendSubviewToBack:bgView3];
    
}
#pragma mark - toobar
-(void)addToolBar
{
    UIImageView *bottomImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-100, 320, 40)];
    bottomImg.image=[UIImage imageNamed:@"topbar_set"];
    [self.view addSubview:bottomImg];
    UIButton *favorite=[UIButton buttonWithType:UIButtonTypeSystem];
    favorite.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-100, 80, 35);
    [favorite setTitle:@"收藏" forState:UIControlStateNormal];
    [favorite addTarget:self action:@selector(favor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:favorite];
    UIButton *share=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    share.frame=CGRectMake(80, [UIScreen mainScreen].bounds.size.height-100, 80, 35);
    [share setTitle:@"分享" forState:UIControlStateNormal];
    [share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:share];
    UIButton *download=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    download.frame=CGRectMake(160, [UIScreen mainScreen].bounds.size.height-100, 80, 35);
    [download setTitle:@"下载" forState:UIControlStateNormal];
    [download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:download];
    UIButton *comment=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    comment.frame=CGRectMake(240, [UIScreen mainScreen].bounds.size.height-100, 80, 35);
    [comment setTitle:@"评论" forState:UIControlStateNormal];
    [comment addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comment];
}
-(void)favor:(UIButton *)sender
{
    if (!_isFavBtnClicked) {
        BOOL isCollected=[[CLDataBase sharedDataBase] insertDataOfFavWithItem:nil aItem:_detailModel];
            if (!isCollected) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"该课程已经被收藏" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
        [sender setTitle:@"取消收藏" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"收藏" forState:UIControlStateNormal];
        [[CLDataBase sharedDataBase] deleteDataFromUserTable:nil aItem:_detailModel];
    }
    _isFavBtnClicked=!_isFavBtnClicked;
}
-(void)share:(UIButton *)sender
{
    UIActionSheet *shareActionSheet=[[UIActionSheet alloc]initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博", nil];
    shareActionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [shareActionSheet showInView:sender];
}
-(void)download:(UIButton *)sender
{
    CLVideoDownloadController *downloadView=[[CLVideoDownloadController alloc]init];
    downloadView.recModel=_detailModel;
    downloadView.allListArray=_videoListArray;
    [self.navigationController pushViewController:downloadView animated:YES];
}
-(void)comment:(UIButton *)sender
{
    CLDetailsModel *model=[[CLDetailsModel alloc]init];
    model=_videoListArray[1];
    
    CLCommentViewController *comment=[[CLCommentViewController alloc]init];
    comment.detailModel=model;
    [self.navigationController pushViewController:comment animated:YES];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
        NSString *wbtoken=[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
        if (wbtoken!=NULL) {
        //分享
//        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
//        request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                             @"Other_Info_1": [NSNumber numberWithInt:123],
//                             @"Other_Info_2": @[@"obj1", @"obj2"],
//                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//            request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
//        
//        [WeiboSDK sendRequest:request];
            CLDetailsModel *model=[[CLDetailsModel alloc]init];
            model=[_videoListArray objectAtIndex:1];
            NSString *postInfo=[NSString stringWithFormat:@"我发现了一门非常好的课程，小伙伴们都来看看吧：%@:%@",_detailModel.titleString,model.weburlString];
            [WBHttpRequest requestWithAccessToken:wbtoken url:@"https://api.weibo.com/2/statuses/update.json" httpMethod:@"POST" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"For Test ->>>>>",@"status",postInfo,@"status",nil] delegate:self withTag:nil];
//                [WBHttpRequest requestWithURL:@"statuses/update.json" httpMethod:@"POST" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TestTestTestTestTest",@"status",postInfo,@"status",nil] delegate:self withTag:nil];
        }
        else{
            //授权注册
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = kAppRedirectURI;
            request.scope = @"all";
            request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            request.shouldOpenWeiboAppInstallPageIfNotInstalled=NO;
            [WeiboSDK sendRequest:request];
        }
    }
}
-(WBMessageObject *)messageToShare
{
   //post message
    CLDetailsModel *model=[[CLDetailsModel alloc]init];
    model=[_videoListArray objectAtIndex:1];
    NSString *postInfo=[NSString stringWithFormat:@"我发现了一门非常好的课程，小伙伴们都来看看吧：%@,%@",_detailModel.titleString,model.weburlString];
//    [WBHttpRequest requestWithURL:@"statuses/update.json" httpMethod:@"POST" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TestTestTestTestTest",@"status",postInfo,@"status",nil] delegate:self withTag:nil];
    WBMessageObject *message = [WBMessageObject message];
    //分享文字
    message.text = postInfo;
    //分享图片
//    WBImageObject *image = [WBImageObject object];
//        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
//        message.imageObject = image;
    //分享网页媒体
//    WBWebpageObject *webpage = [WBWebpageObject object];
//        webpage.objectID = @"identifier1";
//    webpage.title = _detailModel.titleString;
//        webpage.description = [NSString stringWithFormat:@"分享网页内容简介-%.0f", [[NSDate date] timeIntervalSince1970]];
//        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
//        webpage.webpageUrl = [NSString stringWithFormat:@"%@",model.weburlString];
//        message.mediaObject = webpage;
    
    return message;
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    }
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"收到网络回调";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}

#pragma mark - load data
-(void)presentTopViewData
{
    //topview
    [_imgView setImageWithURL:[NSURL URLWithString:_detailModel.imgPathString] placeholderImage:[UIImage imageNamed:@"1"]];
    _titleLabel.text=_detailModel.titleString;
    _titleLabel.textColor=[UIColor darkTextColor];
    _titleLabel.font=[UIFont systemFontOfSize:18];
    _titleLabel.numberOfLines=0;
    _playcountLabel.text=[NSString stringWithFormat:@"本课程共%@集 翻译%@集 欢迎学习",_detailModel.playcountString,_detailModel.updatedString];
    _playcountLabel.font=[UIFont systemFontOfSize:15];
    
}
-(void)presentBottomViewData
{
    //bottomview
        _desModel=[[CLDetailsModel alloc]init];
        _desModel=[_videoListArray objectAtIndex:0];
        _typeLabel.text=[NSString stringWithFormat:@"分类：%@",_desModel.typeString];
        _directorLabel.text=[NSString stringWithFormat:@"讲师：%@",_desModel.directorString];
       _descriptionLabel.text=[NSString stringWithFormat:@"简介：%@",_desModel.descriptionString];
    _descriptionLabel.numberOfLines=0;
    _descriptionLabel.textAlignment=NSTextAlignmentLeft;
    _descriptionLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    _descriptionLabel.font=[UIFont systemFontOfSize:15];
}
-(void)sendRequest
{
    NSString *requestString=[NSString stringWithFormat:DETAILURL,_detailModel.plidString];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
#pragma mark - NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _downloadData.length=0;
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_videoListArray removeAllObjects];
    NSString *requestString=[[NSString alloc]initWithData:_downloadData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict=[requestString JSONValue];
    CLDetailsModel *desModel=[[CLDetailsModel alloc]init];
    desModel.typeString=jsonDict[@"type"];
    desModel.descriptionString=jsonDict[@"description"];
    desModel.directorString=jsonDict[@"director"];
    [_videoListArray addObject:desModel];
    NSArray *videoList=jsonDict[@"videoList"];
    for (NSDictionary *videoDict in videoList) {
        CLDetailsModel *videoModel=[[CLDetailsModel alloc]init];
        videoModel.commentidString=videoDict[@"commentid"];
        videoModel.imgpathString=videoDict[@"imgpath"];
        videoModel.mlengthString=videoDict[@"mlength"];
        videoModel.mp4sizeString=videoDict[@"mp4size"];
        videoModel.repovideourlString=videoDict[@"repovideourl"];
        videoModel.pnumberString=videoDict[@"pnumber"];
        videoModel.titleString=videoDict[@"title"];
        videoModel.weburlString=videoDict[@"weburl"];
        [_videoListArray addObject:videoModel];
    }
    [self presentBottomViewData];
    [_videoTableView reloadData];
}
- (IBAction)segmentChanged:(id)sender {
    int selectedSegment = _segment.selectedSegmentIndex;
    if (selectedSegment==1) {
        [_contentView setFrame:CGRectMake(-320, 119, 640, 449)];
    }else{
        _playcountLabel.text=[NSString stringWithFormat:@"本课程共%@集 翻译%@集 欢迎学习",_detailModel.playcountString,_detailModel.updatedString];
//        CGAffineTransform old=_contentView.transform;
//        _contentView.transform=CGAffineTransformTranslate(old, 640, 0);
        [_contentView setFrame:CGRectMake(0, 119, 640, 449)];
        [_videoTableView deselectRowAtIndexPath:[_videoTableView indexPathForSelectedRow] animated:NO];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _videoListArray.count-1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cellIdentifier";
    CLVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[CLVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    CLDetailsModel *model=[[CLDetailsModel alloc]init];
    model=_videoListArray[indexPath.row+1];
    cell.numberLabel.text=[NSString stringWithFormat:@"第%@课",model.pnumberString];
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",model.titleString];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //提示视屏的时间和视屏的大小
    CLDetailsModel *model=[[CLDetailsModel alloc]init];
    model=_videoListArray[indexPath.row+1];
    int min=[model.mlengthString intValue]/60;
    int sec=[model.mlengthString intValue]%60;
    long length=[model.mp4sizeString integerValue]/(1024*1024);
    NSString *str=[NSString stringWithFormat:@"第%d课  时长:%d:%d  大小:%ld M",indexPath.row+1,min,sec,length];
    [_playcountLabel setText:str];
    
    CLVideoViewController *videoCtl=[[CLVideoViewController alloc]init];
    videoCtl.weburlString=model.repovideourlString;
    [videoCtl watchOnLine];
    [self.navigationController pushViewController:videoCtl animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_contentView setFrame:CGRectMake(0, 119, 640, 449)];
//    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
