//
//  CLRecommendModel.m
//  LearningForFree
//
//  Created by apple on 14-5-23.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLRecommendModel.h"

@implementation CLRecommendModel
// 解档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.imgPathString forKey:@"imgpath"];
    [aCoder encodeObject:self.titleString forKey:@"title"];
    [aCoder encodeObject:self.tagsString forKey:@"tags"];
    [aCoder encodeObject:self.schoolString forKey:@"school"];
    [aCoder encodeObject:self.playcountString forKey:@"playcount"];
    [aCoder encodeObject:self.updatedString forKey:@"updated_playcount"];
    [aCoder encodeObject:self.sourceString forKey:@"source"];
    [aCoder encodeObject:self.plidString forKey:@"plid"];
}

// 归档
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
       self.imgPathString=[aDecoder decodeObjectForKey:@"imgpath"];
        self.titleString=[aDecoder decodeObjectForKey:@"title"];
        self.tagsString=[aDecoder decodeObjectForKey:@"tags"];
        self.schoolString=[aDecoder decodeObjectForKey:@"school"];
        self.playcountString=[aDecoder decodeObjectForKey:@"playcount"];
        self.updatedString=[aDecoder decodeObjectForKey:@"updated_playcount"];
        self.sourceString=[aDecoder decodeObjectForKey:@"source"];
        self.plidString=[aDecoder decodeObjectForKey:@"plid"];

    }
    return self;
}
@end
