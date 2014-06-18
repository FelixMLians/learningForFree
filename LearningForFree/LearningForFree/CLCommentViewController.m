//
//  CLCommentViewController.m
//  LearningForFree
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define HOTCOMMENT @"http://comment.api.163.com/api/json/post/list/hot/video_bbs/%@/0/5/10/2/2"
#define LATESTCOMMENT @"http://comment.api.163.com/api/json/post/list/normal/video_bbs/%@/desc/0/10/10/2/2"

#import "CLCommentViewController.h"

@interface CLCommentViewController ()
{
    NSMutableArray *_hotCommentArray;
    NSMutableArray *_latestCommentArray;
    
    NSURLConnection *_hotCommentConnection;
    NSURLConnection *_latestCommentConnection;
    
    UITableView *_commentTableView;
    NSMutableData *_downloadData;
    
    MJRefreshHeaderView *_headerView;
    MJRefreshFooterView *_footerView;
    MJRefreshBaseView *_baseView;
    
    UIView *_writeView;
    UITextField *_writeTextField;
}
@end

@implementation CLCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _hotCommentArray=[[NSMutableArray alloc]init];
    _latestCommentArray=[[NSMutableArray alloc]init];
    _downloadData=[[NSMutableData alloc]init];
    [self createCommentTableView];
    [self initHeaderView];
//    [self initFooterView];
    [self createCommentWriteBoard];
    [self requestLatestCommentData];
    [self requestHotCommentData];
}

-(void)initHeaderView
{
    _headerView=[[MJRefreshHeaderView alloc]initWithScrollView:_commentTableView];
    _headerView.delegate=self;
}
//-(void)initFooterView
//{
//    _footerView=[[MJRefreshFooterView alloc]initWithScrollView:_commentTableView];
//    _footerView.delegate=self;
//}

-(void)createCommentTableView
{
    _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64-47) style:UITableViewStylePlain];
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
//    _commentTableView.bounces=NO;
    _commentTableView.scrollEnabled=YES;
    _commentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_commentTableView];
    
    UIImageView *bgView=[[UIImageView alloc]init];
    bgView.frame=_commentTableView.frame;
    bgView.image=[UIImage imageNamed:@"cell_bg"];
    [_commentTableView addSubview:bgView];
    [_commentTableView sendSubviewToBack:bgView];
}
-(void)createCommentWriteBoard
{
    _writeView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49-64-83, 320, 49)];
    [self.view addSubview:_writeView];
    
    UIImageView *writeViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0 , 320, 49)];
    writeViewBg.image=[UIImage imageNamed:@"topbar_set"];
    [_writeView addSubview:writeViewBg];
    
    UIImageView *writeFieldView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 255, 27)];
    writeFieldView.image=[UIImage imageNamed:@"write_normal"];
    [_writeView addSubview:writeFieldView];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(260, 9, 60, 27);
    [button addTarget:self action:@selector(publishComment:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"发表" forState:UIControlStateNormal];
    [_writeView addSubview:button];
    
    _writeTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 9, 255, 27)];
    _writeTextField.delegate=self;
    [_writeView addSubview:_writeTextField];
}
-(void)publishComment:(UIButton *)button
{
    NSLog(@"publish the data to the server ");
    [_writeTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _writeTextField.borderStyle=UITextBorderStyleRoundedRect;
    _writeTextField.backgroundColor=[UIColor whiteColor];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self adjustPanelsWithKeybordHeight:0];
    _writeTextField.text=nil;
    _writeTextField.backgroundColor=[UIColor clearColor];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    [self adjustPanelsWithKeybordHeight:keyboardBounds.size.height];
}

-(void)adjustPanelsWithKeybordHeight:(float)height
{
    CGRect rect=CGRectMake(0, 64, 320, 416);
        rect.origin.y -=height;
        self.view.frame=rect;
}

-(void)requestHotCommentData
{
    NSString *urlString=[NSString stringWithFormat:HOTCOMMENT,self.detailModel.commentidString];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    _hotCommentConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    [_hotCommentConnection start];
}
-(void)requestLatestCommentData
{
    NSString *urlString=[NSString stringWithFormat:LATESTCOMMENT,self.detailModel.commentidString];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    _latestCommentConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    [_latestCommentConnection start];
}
#pragma mark -NSURLConnectionDelegate
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
    
    if (connection==_latestCommentConnection) {
        [_latestCommentArray removeAllObjects];
        NSDictionary *responseDict=[NSJSONSerialization JSONObjectWithData:_downloadData options:NSJSONReadingMutableContainers error:nil];
        if (responseDict[@"newPosts"]!=[NSNull null]){
        NSArray *responseArray=responseDict[@"newPosts"];
            for (NSDictionary *dict1 in responseArray) {
            NSDictionary *dict2=dict1[@"1"];
            CLCommentModel *comModel=[[CLCommentModel alloc]init];
            comModel.bCommentString=dict2[@"b"];
            comModel.fIDString=dict2[@"f"];
            comModel.tTimeString=dict2[@"t"];
            [_latestCommentArray addObject:comModel];
                 NSLog(@"%@",comModel);
        }
        [_commentTableView reloadData];
        [self end];
        }
        
    }
    else{
        [_hotCommentArray removeAllObjects];
        NSDictionary *responseDict=[NSJSONSerialization JSONObjectWithData:_downloadData options:NSJSONReadingMutableContainers error:nil];
        if (responseDict[@"hotPosts"]!=[NSNull null]) {
        NSArray *responseArray=responseDict[@"hotPosts"];
            for (int i=0; i<responseArray.count; i++) {
                NSDictionary *dict1=responseArray[i];
            NSDictionary *dict2=dict1[@"1"];
            CLCommentModel *comModel=[[CLCommentModel alloc]init];
            comModel.bCommentString=dict2[@"b"];
            comModel.fIDString=dict2[@"f"];
            comModel.tTimeString=dict2[@"t"];
            [_hotCommentArray addObject:comModel];
    }
        [_commentTableView reloadData];
        [self end];
        }
  self.title=[NSString stringWithFormat:@"跟帖（%d）",_latestCommentArray.count+_hotCommentArray.count];
}
}
-(void)end
{
    if (_baseView==_headerView) {
        [_headerView endRefreshing];
    }
    else
    {
        [_footerView endRefreshing];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error");
}
#pragma mark MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    _baseView=refreshView;
    if (refreshView==_headerView) {
//        page=1;
        [self requestHotCommentData];
        [self requestLatestCommentData];
    }
    else
    {
//        page++;
//        [self requestHotCommentData];
//        [self requestLatestCommentData];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if (_hotCommentArray.count>0) {
        return _hotCommentArray.count;
        }
    }
    else
    {
        if (_latestCommentArray.count>0) {
            return _latestCommentArray.count;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellid";
    CLCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[CLCommentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (indexPath.section==0) {
        if (_hotCommentArray.count>0) {
        CLCommentModel *model=[[CLCommentModel alloc]init];
        model=_hotCommentArray[indexPath.row];
//        cell.textLabel.text=model.bCommentString;
//        cell.detailTextLabel.text=model.fIDString;
            [cell refreshModel:model];
        }
        return cell;
    }
    else{
        if (_latestCommentArray.count>0) {
        CLCommentModel *model=[[CLCommentModel alloc]init];
        model=_latestCommentArray[indexPath.row];
//        cell.textLabel.text=model.bCommentString;
//        cell.detailTextLabel.text=model.fIDString;
            [cell refreshModel:model];
        }
        return cell;
    }
    [cell reloadInputViews];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIImageView *bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
        bgView.frame=CGRectMake(0, 0, 320, 40);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 20)];
        label.text=@"最热跟帖";
        label.textColor=[UIColor whiteColor];
        [bgView addSubview:label];
        return bgView;
    }
    else
    {
        UIImageView *bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
        bgView.frame=CGRectMake(0, 0, 320, 40);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 20)];
        label.text=@"最新跟帖";
        label.textColor=[UIColor whiteColor];
        [bgView addSubview:label];
        bgView.frame=CGRectMake(0, 0, 320, 20);
        return bgView;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (_hotCommentArray.count>0) {
            CLCommentModel * model =_hotCommentArray[indexPath.row];
        return 45+model.commentSize.height;
        }
    }else
    {
        if (_latestCommentArray.count>0) {
        CLCommentModel *model=_latestCommentArray[indexPath.row];
        return 45 +model.commentSize.height;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)dealloc
{
    [_headerView free];
    [_footerView free];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
