//
//  CLSetViewController.m
//  LearningForFree
//
//  Created by apple on 14-5-23.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define TEMPDOWNLOADVIDEOPATH [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Temp"]

#import "CLSetViewController.h"

@interface CLSetViewController ()
{
    UITableView *_settingTableView;
}
@end

@implementation CLSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *setItem=[[UITabBarItem alloc]initWithTitle:@"设置" image:[UIImage imageNamed:@"tab_set"] tag:104];
        self.tabBarItem = setItem;
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        self.title=@"设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _settingTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64-49) style:UITableViewStyleGrouped];
    _settingTableView.delegate=self;
    _settingTableView.dataSource=self;
    _settingTableView.bounces=NO;
    [self.view addSubview:_settingTableView];
    UIImageView *bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2"]];
    [_settingTableView addSubview:bgView];
    [_settingTableView sendSubviewToBack:bgView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else{
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    switch (section) {
        case 0:
            switch (row) {
                case 0:{
                    cell.textLabel.text = @"消息推送";
                    UISwitch *sw = [[UISwitch alloc] init];
                    [sw addTarget: self action: @selector(newsPushValueChanged:) forControlEvents: UIControlEventValueChanged];
                    sw.frame = CGRectMake(cell.frame.size.width - sw.frame.size.width - 25, (cell.frame.size.height - sw.frame.size.height) / 2, cell.frame.size.width, cell.frame.size.height);
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.contentView addSubview: sw];}
                    break;
                case 1:{
                    cell.textLabel.text = @"清除缓存";
                    UILabel *cacheSizeLabel = [[UILabel alloc] init];
                    /*
                     NSUInteger cacheSize = [[XDDataCenter sharedCenter] cacheSize];
                     if (cacheSize < 1024)
                     {
                     cacheSizeLabel.text = [NSString stringWithFormat: @"%u B", cacheSize];
                     }
                     else if (cacheSize < 1024 * 1024)
                     {
                     cacheSizeLabel.text = [NSString stringWithFormat: @"%.2f KB", (cacheSize * 1.0f) / 1024];
                     }
                     else if (cacheSize < 1024 * 1024 * 1024)
                     {
                     cacheSizeLabel.text = [NSString stringWithFormat: @"%.2f MB", (cacheSize * 1.0f) / (1024 * 1024)];
                     }
                     else
                     {
                     cacheSizeLabel.text = [NSString stringWithFormat: @"%.2f GB", (cacheSize * 1.0f) / (1024 * 1024 * 1024)];
                     }
                     */
                    cacheSizeLabel.frame = CGRectMake(230, 0, 50, 40);
                    cacheSizeLabel.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview: cacheSizeLabel];
                }
                    break;
                }
            break;
        case 1:{
            switch (row) {
//                case 0:
//                    cell.textLabel.text=@"推荐软件";
//                    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
//                    break;
                case 0:
                    cell.textLabel.text=@"检查更新";
                    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                    break;
                case 1:
                    cell.textLabel.text=@"关于我们";
                    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                    break;
                default:
                    break;
            }
            break;
          
        default:
            break;
    }
    }
    cell.backgroundColor=[UIColor lightTextColor];

    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"系统设置";
            break;
        case 1:
            return @"产品信息";
            break;
        default:
            break;
    }
    return @"demo";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==1) {
        NSLog(@"清除缓存");
        NSFileManager *manager=[NSFileManager defaultManager];
        if ([manager fileExistsAtPath:TEMPDOWNLOADVIDEOPATH]) {
            [manager removeItemAtPath:TEMPDOWNLOADVIDEOPATH error:nil];
        }
    }
    if (indexPath.section==1&&indexPath.row==0) {
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
        NSLog(@"%@",currentVersion);
        /*  获取软件最新的版本
        NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=***"];
        NSString * file =  [NSString stringWithContentsOfURL:url];
        NSLog(file);
        //"version":"1.0"
        NSRange substr = [file rangeOfString:@"\"version\":\""];
        NSRange substr2 =[file rangeOfString:@"\"" options:NULL range:NSMakeRange(substr.location+substr.length,10)];
        NSRange range = {substr.location+substr.length,substr2.location-substr.location-substr.length};
        NSString *newVersion =[file substringWithRange:range];
         */
        if([currentVersion intValue]==1)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"已经是最新版本:%@",currentVersion] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
    }
}
-(void)newsPushValueChanged:(id)sender
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
