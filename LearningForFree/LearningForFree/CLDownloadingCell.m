//
//  CLDownloadingCell.m
//  LearningForFree
//
//  Created by apple on 14-5-29.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLDownloadingCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CLDownloadingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 230, 20)];
        _titleLabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:_titleLabel];
        _sizeLabel=[[UILabel alloc]initWithFrame:CGRectMake(240, 5, 70, 20)];
        _sizeLabel.textAlignment=NSTextAlignmentRight;
        _sizeLabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:_sizeLabel];
        _progressBar=[[UIProgressView alloc]initWithFrame:CGRectMake(10, 30, 230, 20)];
        _progressBar.progressImage=[UIImage imageNamed:@"download_progressbar"];
        _progressBar.progressViewStyle=UIProgressViewStyleBar;
        [self.contentView addSubview:_progressBar];
        _startButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame=CGRectMake(260, 25, 20, 20);
        [_startButton setImage:[UIImage imageNamed:@"downloadcell_start"] forState:UIControlStateNormal];
        [_startButton setImage:[UIImage imageNamed:@"downloadcell_wait"] forState:UIControlStateSelected];
        _startButton.selected=NO;
        [self.contentView addSubview:_startButton];
    }
    [self setBackgroundView];
    return self;
}

-(void)setBackgroundView
{
    UIImageView *bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg"]];
    self.backgroundView=bgView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO  animated:NO];

    // Configure the view for the selected state
}

@end
