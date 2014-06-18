//
//  CLVideoCell.m
//  LearningForFree
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLVideoCell.h"

@implementation CLVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 40)];
        _numberLabel.textColor=[UIColor robinEggColor];
        [self.contentView addSubview:_numberLabel];
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(_numberLabel.frame.size.width+20, 0, 320-_numberLabel.frame.size.width-40, 40)];
        _titleLabel.textColor=[UIColor eggshellColor];
        _titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];
    }
    [self setBackgroundView];
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
