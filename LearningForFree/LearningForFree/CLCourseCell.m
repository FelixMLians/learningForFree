//
//  CLCourseCell.m
//  LearningForFree
//
//  Created by apple on 14-5-26.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLCourseCell.h"

@implementation CLCourseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 65)];
        [self.contentView addSubview:_imgView];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 5, 242, 20)];
        _titleLabel.textColor=[UIColor robinEggColor];
        [self.contentView addSubview:_titleLabel];
        
        _tagsLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 40, 230, 20)];
        _tagsLabel.font=[UIFont systemFontOfSize:15];
        _tagsLabel.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_tagsLabel];
        
        _playcountLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 60, 230, 20)];
        _playcountLabel.font=[UIFont systemFontOfSize:15];
        _playcountLabel.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_playcountLabel];
        [self setBackgroundView];
    }
    return self;
}
-(void)setBackgroundView
{
    UIImageView *bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"platform_mid_cell"]];
    self.backgroundView=bgView;
    UIImageView *bgView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg"]];
    self.selectedBackgroundView=bgView2;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
