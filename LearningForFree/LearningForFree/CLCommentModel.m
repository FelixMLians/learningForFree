//
//  CLCommentModel.m
//  LearningForFree
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLCommentModel.h"

@implementation CLCommentModel
-(void)setBCommentString:(NSString *)bCommentString
{
    if (_bCommentString != bCommentString) {
        
        _bCommentString = bCommentString;
        _commentSize = [_bCommentString boundingRectWithSize:CGSizeMake(310, 480) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName] context:nil].size;
//                   [_bCommentString sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(310, 2000)];
    }

}
@end
