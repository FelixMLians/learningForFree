//
//  CLDownloadedCell.m
//  LearningForFree
//
//  Created by apple on 14-6-5.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLDownloadedCell.h"

@implementation CLDownloadedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 20)];
        _titleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        _sizeLabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 5, 70, 20)];
        _sizeLabel.textAlignment=NSTextAlignmentRight;
        _sizeLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_sizeLabel];
        
        _desLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 30, 240, 20)];
        _desLabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:_desLabel];
        
        _playButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame=CGRectMake(260, 25, 50, 50);
        [_playButton setImage:[UIImage imageNamed:@"download_loaded_play"] forState:UIControlStateNormal];
        [self.contentView addSubview:_playButton];
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
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

@end
