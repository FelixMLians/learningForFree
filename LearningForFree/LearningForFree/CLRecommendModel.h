//
//  CLRecommendModel.h
//  LearningForFree
//
//  Created by apple on 14-5-23.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLRecommendModel : NSObject<NSCoding>
@property (nonatomic,strong) NSString *imgPathString;
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSString *tagsString;
@property (nonatomic,strong) NSString *schoolString;
@property (nonatomic,strong) NSString *playcountString;
@property (nonatomic,strong) NSString *updatedString;
@property (nonatomic,strong) NSString *sourceString;
@property (nonatomic,strong) NSString *plidString;
@end
