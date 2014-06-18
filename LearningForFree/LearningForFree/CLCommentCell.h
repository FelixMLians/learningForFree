//
//  CLCommentCell.h
//  LearningForFree
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCommentModel.h"

@interface CLCommentCell : UITableViewCell

@property (nonatomic,strong) UILabel *idLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *commentLabel;

- (void)refreshModel:(CLCommentModel *)model;
@end
