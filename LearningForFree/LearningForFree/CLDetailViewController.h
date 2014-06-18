//
//  CLDetailViewController.h
//  LearningForFree
//
//  Created by apple on 14-5-23.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRecommendModel.h"
#import "NSString+SBJSON.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Colours.h"
#import "CLDetailsModel.h"
#import "CLVideoCell.h"
#import "CLVideoViewController.h"
#import "CLDownloadViewController.h"
#import "CLDataBase.h"
#import "CLVideoDownloadController.h"
#import "WeiboSDK.h"
#import "CLCommentViewController.h"

@interface CLDetailViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,WBHttpRequestDelegate>

@property (nonatomic,strong) NSMutableArray *detailArray;
@property (nonatomic,strong) CLRecommendModel *detailModel;
@property (nonatomic,strong) CLDetailsModel *desModel;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;

@property (nonatomic,assign) BOOL isFavBtnClicked;
@end
