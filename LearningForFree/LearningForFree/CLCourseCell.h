//
//  CLCourseCell.h
//  LearningForFree
//
//  Created by apple on 14-5-26.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Colours.h"

@interface CLCourseCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *tagsLabel;
@property (nonatomic,strong) UILabel *playcountLabel;
@end
