//
//  CLRecommendViewController.m
//  LearningForFree
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define RECPAGE 6
#define MAINURL @"http://mobile.open.163.com/movie/2/getPlaysForAndroid.htm"
#import "CLRecommendViewController.h"

@interface CLRecommendViewController ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    NSMutableData *_allData;
    NSMutableArray *_recDataArray;
}
@end

@implementation CLRecommendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"今天推荐";
        
        UITabBarItem *recItem=[[UITabBarItem alloc]initWithTitle:@"推荐" image:[UIImage imageNamed:@"tab_recommend"] tag:100];
        self.tabBarItem = recItem;
        
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    _recDataArray=[[NSMutableArray alloc]init];
    _allData=[[NSMutableData alloc]init];
    [self sendRequest];
    [self createScrollView];
}
-(void)createScrollView
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64-49)];
    _scrollView.contentSize=CGSizeMake(320*RECPAGE, _scrollView.frame.size.height);
    _scrollView.bounces=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.delegate=self;
    _scrollView.contentInset=UIEdgeInsetsMake(0, 0, -49, 0);
    [self.view addSubview:_scrollView];
}
-(void)createItems
{
    for (int i=0; i<RECPAGE; i++) {
        CLRecommendModel *recModel=[[CLRecommendModel alloc]init];
        int item=_recDataArray.count-i-1;
        recModel=_recDataArray[item];
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0+320*i, 0, 320, 150)];
        [imgView setImageWithURL:[NSURL URLWithString:recModel.imgPathString] placeholderImage:[UIImage imageNamed:@"1"]];
        [_scrollView addSubview:imgView];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20+320*i,imgView.frame.origin.y+imgView.frame.size.height+5 , 300, 60)];
        titleLabel.font=[UIFont systemFontOfSize:22];
        titleLabel.numberOfLines=0;
        titleLabel.textColor=[UIColor midnightBlueColor];
        titleLabel.text=recModel.titleString;
        [_scrollView addSubview:titleLabel];
        UILabel *tagsLabel=[[UILabel alloc]initWithFrame:CGRectMake(20+320*i, titleLabel.frame.origin.y+titleLabel.frame.size.height, 320, 20)];
        tagsLabel.text=[NSString stringWithFormat:@"分类：%@",recModel.tagsString];
        tagsLabel.font=[UIFont systemFontOfSize:15];
        [_scrollView addSubview:tagsLabel];
        UILabel *schoolLabel=[[UILabel alloc]initWithFrame:CGRectMake(20+320*i, tagsLabel.frame.origin.y+tagsLabel.frame.size.height, 320, 20)];
        schoolLabel.text=[NSString stringWithFormat:@"学校：%@",recModel.schoolString];
        schoolLabel.font=[UIFont systemFontOfSize:15];
        [_scrollView addSubview:schoolLabel];
        UILabel *playcountLabel=[[UILabel alloc]initWithFrame:CGRectMake(20+320*i, schoolLabel.frame.origin.y+schoolLabel.frame.size.height, 100, 20)];
        playcountLabel.text=[NSString stringWithFormat:@"课时：%@",recModel.playcountString];
        playcountLabel.font=[UIFont systemFontOfSize:15];
        [_scrollView addSubview:playcountLabel];
        UILabel *updatedLabel=[[UILabel alloc]initWithFrame:CGRectMake(20+320*i, playcountLabel.frame.origin.y+playcountLabel.frame.size.height, 200, 20)];
        updatedLabel.text=[NSString stringWithFormat:@"已翻译：%@",recModel.updatedString];
        updatedLabel.font=[UIFont systemFontOfSize:15];
        [_scrollView addSubview:updatedLabel];
        UIButton *checkBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        checkBtn.frame=CGRectMake(120+320*i, _scrollView.frame.size.height-60, 80, 40);
        [checkBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        checkBtn.font=[UIFont systemFontOfSize:20];
        checkBtn.tag=200+i;
        [checkBtn setTitleColor:[UIColor seafoamColor] forState:UIControlStateNormal];
        [checkBtn addTarget:self action:@selector(checkDetails:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:checkBtn];
        
        _pageControl=[[UIPageControl alloc]init];
        _pageControl.frame=CGRectMake(0,_scrollView.frame.origin.y+_scrollView.frame.size.height-20,_scrollView.frame.size.width, 20);
        _pageControl.numberOfPages=RECPAGE;
        _pageControl.currentPageIndicatorTintColor=[UIColor blackColor];
        _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_pageControl];
    }
    [_scrollView reloadInputViews];
}
-(void)pageChanged:(UIPageControl *)sender
{
    NSInteger page=sender.currentPage;
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width*page, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}
#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage=scrollView.contentOffset.x/self.view.frame.size.width;
    
}

-(void)sendRequest
{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:MAINURL]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
#pragma mark - NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _allData.length=0;
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_allData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_recDataArray removeAllObjects];
    NSString *requestStr=[[NSString alloc]initWithData:_allData encoding:NSUTF8StringEncoding];
    NSArray *requestArr=[requestStr JSONValue];
    for (NSDictionary *dict in requestArr) {
        CLRecommendModel *model=[[CLRecommendModel alloc]init];
        model.imgPathString=dict[@"imgpath"];
        model.titleString=dict[@"title"];
        model.schoolString=dict[@"school"];
        model.tagsString=dict[@"tags"];
        model.playcountString=dict[@"playcount"];
        model.updatedString=dict[@"updated_playcount"];
        model.sourceString=dict[@"source"];
        model.plidString=dict[@"plid"];
        [_recDataArray addObject:model];
    }
    //缓存
//    CLRecommendModel *model=[[CLRecommendModel alloc]init];
//    model=[_recDataArray lastObject];
//    [NSKeyedArchiver archiveRootObject:model toFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/model.dat"]];
    [self createItems];
    [_scrollView reloadInputViews];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection failure");
}
-(void)checkDetails:(UIButton *)button
{
    int num=_recDataArray.count-(button.tag-200)-1;
    CLDetailViewController *play=[[CLDetailViewController  alloc]init];
    play.detailArray=_recDataArray;
    play.detailModel=_recDataArray[num];
    [self.navigationController pushViewController:play animated:YES];

}

-(void)viewWillDisappear:(BOOL)animated
{
    CLCourseViewController *couCtl=[[CLCourseViewController alloc]init];
    [couCtl registerNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wholeItem" object:_recDataArray];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
