//
//  CLFavoriteViewController.m
//  LearningForFree
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLFavoriteViewController.h"

@interface CLFavoriteViewController ()
{
    NSMutableArray *_favoriteList;
    UITableView *_favTableView;
}
@end

@implementation CLFavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *favItem=[[UITabBarItem alloc]initWithTitle:@"收藏夹" image:[UIImage imageNamed:@"tab_favorite"] tag:102];
        self.tabBarItem = favItem;
        self.title=@"我的收藏";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _favoriteList=[[NSMutableArray alloc]init];
    _favTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-113) style:UITableViewStylePlain];
    _favTableView.bounces=NO;
    _favTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _favTableView.delegate=self;
    _favTableView.dataSource=self;
    UIImageView *bgView3=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-113)];
    bgView3.image=[UIImage imageNamed:@"cell_bg"];
    [_favTableView addSubview:bgView3];
    [_favTableView sendSubviewToBack:bgView3];
    [self.view addSubview:_favTableView];
    [self getDataFromDatabase];
}
-(void)getDataFromDatabase
{
    [_favoriteList removeAllObjects];
    NSMutableArray *databaseArr=[[NSMutableArray alloc]init];
    databaseArr=[[CLDataBase sharedDataBase] getItemsFromDatabase];
    for (NSMutableArray *arr in databaseArr) {
        CLRecommendModel *recModel=[[CLRecommendModel alloc]init];
        CLDetailsModel *detailModel=[[CLDetailsModel alloc]init];
        recModel=[arr objectAtIndex:0];
        detailModel=[arr objectAtIndex:1];
        if (recModel.titleString!=NULL) {
            [_favoriteList addObject:arr];
        }
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _favoriteList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cellId";
    CLCourseCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[CLCourseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    CLRecommendModel *recModel=[[CLRecommendModel alloc]init];
    recModel=[_favoriteList[indexPath.row] objectAtIndex:0];
    [cell.imgView setImageWithURL:[NSURL URLWithString:recModel.imgPathString] placeholderImage:[UIImage imageNamed:@"1"]];
    cell.titleLabel.text=recModel.titleString;
    cell.tagsLabel.text=[NSString stringWithFormat:@"分类：%@",recModel.tagsString];
    cell.playcountLabel.text=[NSString stringWithFormat:@"课时：%@ 已译：%@",recModel.playcountString,recModel.updatedString];
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
    detail.detailModel=_favoriteList[indexPath.row][0];
    detail.isFavBtnClicked=YES;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getDataFromDatabase];
    [_favTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
