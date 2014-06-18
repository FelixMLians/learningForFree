//
//  CLCommentModel.h
//  LearningForFree
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLCommentModel : NSObject

@property (nonatomic,strong) NSString *bCommentString;
@property (nonatomic,strong) NSString *fIDString;
@property (nonatomic,strong) NSString *tTimeString;

@property (nonatomic,assign,readonly) CGSize commentSize;
@end
