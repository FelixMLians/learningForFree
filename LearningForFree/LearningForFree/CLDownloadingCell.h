//
//  CLDownloadingCell.h
//  LearningForFree
//
//  Created by apple on 14-5-29.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDownloadViewController.h"

@interface CLDownloadingCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *sizeLabel;
@property (nonatomic,strong) UIProgressView *progressBar;
@property (nonatomic,strong) UIButton *startButton;
@end
