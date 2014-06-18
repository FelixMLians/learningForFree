//
//  CLCommentCell.m
//  LearningForFree
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLCommentCell.h"

@implementation CLCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _idLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
        _idLabel.font=[UIFont systemFontOfSize:12];
        _idLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:_idLabel];
        
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 210, 20)];
        _timeLabel.font=[UIFont systemFontOfSize:12];
        _timeLabel.textAlignment=NSTextAlignmentRight;
        _timeLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:_timeLabel];
        
        _commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 30, 310, 100)];
        _commentLabel.font=[UIFont systemFontOfSize:17];
        _commentLabel.lineBreakMode=NSLineBreakByCharWrapping;
        _commentLabel.numberOfLines=0;
        [self.contentView addSubview:_commentLabel];
    }
    [self setBackgroundView];
    return self;
}
- (void)refreshModel:(CLCommentModel *)model
{
    self.idLabel.text=model.fIDString;
    
    self.timeLabel.text=[NSString stringWithFormat:@"%@ 发表",model.tTimeString];
    
    self.commentLabel.text = model.bCommentString;
    CGPoint point1 = _commentLabel.frame.origin;
    _commentLabel.frame = CGRectMake(point1.x, point1.y, model.commentSize.width, model.commentSize.height);
}
-(void)setBackgroundView
{
    UIImageView *bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2"]];
    self.backgroundView=bgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

@end
