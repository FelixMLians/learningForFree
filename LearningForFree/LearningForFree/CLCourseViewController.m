//
//  CLCourseViewController.m
//  LearningForFree
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLCourseViewController.h"

@interface CLCourseViewController ()
{
    UITableView *_couTableView;
    UIButton *_tagsButton;
    UIButton *_sourceButton;
    
    NSMutableArray *_allDataArray;
    NSMutableArray *_filterArray;
    
    BOOL isTagsButtonClicked;
    BOOL isSourceButtonClicked;

    UIView *_tagsSearchView;
    UIView *_sourceSearchView;
    UIView *_searchBarView;
    
    UISearchBar *_searchBar;
}
@end

@implementation CLCourseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *couItem=[[UITabBarItem alloc]initWithTitle:@"课程" image:[UIImage imageNamed:@"tab_course"] tag:101];
        self.tabBarItem = couItem;
        self.title=@"全部课程";
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _filterArray=[[NSMutableArray alloc]init];
    _allDataArray=[[NSMutableArray alloc]init];
    
    //receive data
    [self registerNotification];
    [self createTable];
    [self createLayerView];
    [self createSearchBar];
    _couTableView.delegate=self;
    _couTableView.dataSource=self;
    
}
-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveData:) name:@"wholeItem" object:nil];
}
-(void)receiveData:(NSNotification *)note
{
    _allDataArray=[note object];
    for (CLRecommendModel *model in _allDataArray) {
        [_filterArray addObject:model];
    }
}
-(void)createTable
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 39)];
    topView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topbar_set"]];
    [self.view addSubview:topView];
    _tagsButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _tagsButton.frame=CGRectMake(40, 10, 80, 20);
    [_tagsButton addTarget:self action:@selector(tagsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tagsButton setTitle:@"全部类型" forState:UIControlStateNormal];
    [topView addSubview:_tagsButton];
    _sourceButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _sourceButton.frame=CGRectMake(200, 10, 80, 20);
    [_sourceButton setTitle:@"全部来源" forState:UIControlStateNormal];
    [_sourceButton addTarget:self action:@selector(sourceClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_sourceButton];
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchCourse)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    _couTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y +topView.frame.size.height, 320, 480) style:UITableViewStylePlain];
    _couTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _couTableView.bounces=NO;
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 449)];
    bgView.image=[UIImage imageNamed:@"cell_bg"];
    [_couTableView addSubview:bgView];
    [_couTableView sendSubviewToBack:bgView];
    [self.view addSubview:_couTableView];
    
}
-(void)createLayerView
{
    //tags search view
    _tagsSearchView=[[UIView alloc]initWithFrame:CGRectMake(0, 30, 318, 150)];
    UIImageView *tagsBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"layout_bg1"]];
    tagsBg.contentMode=UIViewContentModeScaleToFill;
    tagsBg.frame=CGRectMake(0, 0, 318, 150);
    [_tagsSearchView addSubview:tagsBg];
    NSArray *tagsList=@[@"全部类型",@"文学",@"艺术",@"哲学",@"历史",@"经济",@"社会",@"法律",@"媒体",@"伦理",@"心理",@"管理",@"技能",@"数学",@"物理",@"化学",@"生物",@"医学",@"环境",@"计算机"];
    for (int i=0; i<5; i++) {
        for (int j=0; j<4; j++) {
            UIButton *b=[UIButton buttonWithType:UIButtonTypeSystem];
            b.frame=CGRectMake(0+80*j, 30+20*i, 80, 20);
            [b addTarget:self action:@selector(tagsSearch:) forControlEvents:UIControlEventTouchUpInside];
            b.tag=100+j+i*4;
            [b setTitle:tagsList[i*4+j] forState:UIControlStateNormal];
            [_tagsSearchView addSubview:b];
        }
    }
    
    //source search view
    _sourceSearchView=[[UIView alloc]initWithFrame:CGRectMake(2, 32, 318, 40)];
    UIImageView *sourceBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"layout_bg_iphone"]];
    sourceBg.frame=CGRectMake(0, 0, 318, 40);
    [_sourceSearchView addSubview:sourceBg];
    NSArray *sourceList=@[@"全部来源",@"国内",@"国外",@"TED"];
    for (int i=0; i<4; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame=CGRectMake(80*i, 10, 80, 20);
        [btn addTarget:self action:@selector(sourceSearch:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=200+i;
        [btn setTitle:sourceList[i] forState:UIControlStateNormal];
        [_sourceSearchView addSubview:btn];
    }
}
-(void)createSearchBar
{
    _searchBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 39)];
    _searchBar=[[UISearchBar alloc]init];
    _searchBar.barStyle=UISearchBarStyleDefault;
    _searchBar.delegate=self;
    _searchBar.frame=CGRectMake(0, 0, 320, 39);
    [_searchBar setPlaceholder:@"请输入要搜索的课程名"];
    [_searchBarView addSubview:_searchBar];

//    //search display
//    _searchDisplay=[[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
//    _searchDisplay.searchResultsDataSource=self;
//    _searchDisplay.searchResultsDelegate=self;
    
}
-(void)tagsClick:(UIButton *)sender
{
    
    if (!isTagsButtonClicked) {
        [self.view addSubview:_tagsSearchView];
        [_sourceSearchView removeFromSuperview];
        isSourceButtonClicked=NO;
    }
    else{
        [_tagsSearchView removeFromSuperview];
    }
    isTagsButtonClicked=!isTagsButtonClicked;
}
-(void)sourceClick:(UIButton *)sender
{
    if (!isSourceButtonClicked) {
        [self.view addSubview:_sourceSearchView];
        [_tagsSearchView removeFromSuperview];
        isTagsButtonClicked=NO;
    }
    else{
        [_sourceSearchView removeFromSuperview];
    }
    isSourceButtonClicked=!isSourceButtonClicked;

}
#pragma mark - search
-(void)tagsSearch:(UIButton *)sender
{
    if (sender.tag==100) {
        [_filterArray removeAllObjects];
        for (CLRecommendModel *model in _allDataArray) {
            [_filterArray addObject:model];
        }

        [_couTableView reloadData];
    }
    else{
        NSString *str=[sender titleForState:UIControlStateNormal];
        [_filterArray removeAllObjects];
        for (int i=0; i<_allDataArray.count; i++) {
            CLRecommendModel *model=[[CLRecommendModel alloc]init];
            model=_allDataArray[i];
            NSRange subRange=[model.tagsString rangeOfString:str];
            if (subRange.location!=NSNotFound) {
                [_filterArray addObject:model];
            }
        }
        [_couTableView reloadData];
    }
    [_tagsSearchView removeFromSuperview];
    isTagsButtonClicked=NO;
}
-(void)sourceSearch:(UIButton *)sender
{
    if (sender.tag==200) {
        [_filterArray removeAllObjects];
        for (CLRecommendModel *model in _allDataArray) {
            [_filterArray addObject:model];
        }
        
        [_couTableView reloadData];
    }
    else{
        NSString *str=[sender titleForState:UIControlStateNormal];
        [_filterArray removeAllObjects];
        for (int i=0; i<_allDataArray.count; i++) {
            CLRecommendModel *model=[[CLRecommendModel alloc]init];
            model=_allDataArray[i];
            NSRange subRange=[model.sourceString rangeOfString:str];
            if (subRange.location!=NSNotFound) {
                [_filterArray addObject:model];
            }
        }
        [_couTableView reloadData];
    }
    [_sourceSearchView removeFromSuperview];
    isSourceButtonClicked=NO;
}
-(void)searchCourse
{
    [self.view addSubview:_searchBarView];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self resignFirstResponder];
    [_searchBarView removeFromSuperview];
    [_searchBar setShowsCancelButton:NO animated:NO];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self resignFirstResponder];
    [_searchBarView removeFromSuperview];
    [_searchBar setShowsCancelButton:NO animated:NO];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *str=searchText;
    [_filterArray removeAllObjects];
    for (int i=0; i<_allDataArray.count; i++) {
        CLRecommendModel *model=[[CLRecommendModel alloc]init];
        model=_allDataArray[i];
        NSRange subRange=[model.titleString rangeOfString:str];
        if (subRange.location!=NSNotFound) {
            [_filterArray addObject:model];
        }
    }
    [_couTableView reloadData];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filterArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cellIdentifier";
    CLCourseCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[CLCourseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    CLRecommendModel *model=[[CLRecommendModel alloc]init];
    model=_filterArray[indexPath.row];
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgPathString] placeholderImage:[UIImage imageNamed:@"1"]];
    cell.titleLabel.text=model.titleString;
    cell.tagsLabel.text=[NSString stringWithFormat:@"分类：%@",model.tagsString];
    cell.playcountLabel.text=[NSString stringWithFormat:@"课时：%@ 已译：%@",model.playcountString,model.updatedString];
    [cell reloadInputViews];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLDetailViewController *detail=[[CLDetailViewController alloc]init];
    detail.detailModel=_allDataArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_couTableView deselectRowAtIndexPath:[_couTableView indexPathForSelectedRow] animated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
