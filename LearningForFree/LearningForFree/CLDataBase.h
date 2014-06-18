//
//  CLDataBase.h
//  LearningForFree
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLDetailsModel.h"
#import "CLRecommendModel.h"

@class FMDatabase;
@interface CLDataBase : NSObject
{
    FMDatabase *myDatabase;
}
//生成数据库单例对象
+ (CLDataBase *)sharedDataBase;

//数据库路径
- (NSString *)getDatabasePath;

//创建表
- (void)createTable;

//插入数据
- (BOOL)insertDataOfFavWithItem:(CLDetailsModel *)item aItem:(CLRecommendModel *)aItem;
//插入数据
- (BOOL)insertDataOfDowWithItem:(CLDetailsModel *)item aItem:(CLRecommendModel *)aItem;
//删除数据
-(void)deleteDataFromUserTable:(CLDetailsModel *)item aItem:(CLRecommendModel *)aItem;
//删除数据
-(void)deleteDownloadDataFromUserTabel:(CLDetailsModel *)item;
//返回数据库中所有数据
- (NSMutableArray *)getItemsFromDatabase;
@end
