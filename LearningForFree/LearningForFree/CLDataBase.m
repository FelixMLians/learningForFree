//
//  CLDataBase.m
//  LearningForFree
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLDataBase.h"
#import "FMDatabase.h"

@implementation CLDataBase
static CLDataBase *dataBase = nil;

+ (CLDataBase *)sharedDataBase
{
    if (dataBase == nil)
    {
        dataBase = [[self alloc] init];
    }
    
    return dataBase;
}
- (id)init
{
    self = [super init];
    
    if (self)
    {
        //获取数据库路径
        NSString *path = [self getDatabasePath];
        
        myDatabase = [[FMDatabase alloc] initWithPath:path];
        
        //数据库打开
        if (![myDatabase open])
        {
            return nil;
        }
        
        //创建表
        [self createTable];
    }
    
    return self;
}
- (NSString *)getDatabasePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    /*
     方法自动加入"/"
     [NSHomeDirectory() stringByAppendingPathComponent:@"test.db"];
     [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"test.db"]
     */
    
    return [path stringByAppendingPathComponent:@"details.db"];
}

- (void)createTable
{
    BOOL isCreateTableOK = [myDatabase executeUpdate:@"create table if not exists Details (id integer primary key autoincrement,imgpath text,name text,tags text,playcount text,titlenumber text,title text,mp4size text,plid text,updateplaycount text,repovideourl text)"];
    
    if (isCreateTableOK)
    {
        NSLog(@"表创建成功");
    }
    else
    {
        NSLog(@"表创建失败");
    }
}

- (BOOL)insertDataOfFavWithItem:(CLDetailsModel *)item aItem:(CLRecommendModel *)aItem
{
    //判断是否已经收藏
    FMResultSet *result=[myDatabase executeQuery:@"select * from Details"];
    while (result.next) {
        NSString *str=[[NSString alloc]init];
        NSString *titleStr=[[NSString alloc]init];
        str=[result stringForColumn:@"imgpath"];
        titleStr=[result stringForColumn:@"title"];
        if ([str isEqualToString:aItem.imgPathString]||aItem.titleString==NULL) {
            return  NO;
            NSLog(@"%@",str);
        }
        
    }

    BOOL isInsertDataOK = [myDatabase executeUpdate:@"insert into Details(imgpath,name,tags,playcount,titlenumber,title,mp4size,plid,updateplaycount,repovideourl) values (?,?,?,?,?,?,?,?,?,?)",aItem.imgPathString,aItem.titleString,aItem.tagsString,aItem.playcountString,item.pnumberString,item.titleString,item.mp4sizeString,aItem.plidString,aItem.updatedString,item.repovideourlString];
    
    if (isInsertDataOK)
    {
        return YES;
        NSLog(@"数据插入成功");
    }
    else
    {
        return NO;
        NSLog(@"数据插入失败");
    }
    
}
- (BOOL)insertDataOfDowWithItem:(CLDetailsModel *)item aItem:(CLRecommendModel *)aItem
{
    //判断是否已经下载
    FMResultSet *result=[myDatabase executeQuery:@"select * from Details"];
    while (result.next) {
        NSString *str=[[NSString alloc]init];
        NSString *titleStr=[[NSString alloc]init];
        str=[result stringForColumn:@"name"];
        titleStr=[result stringForColumn:@"title"];
        if ([titleStr isEqualToString:item.titleString]||item.titleString==NULL) {
            return  NO;
            NSLog(@"%@",str);
        }
        
    }
    
    BOOL isInsertDataOK = [myDatabase executeUpdate:@"insert into Details(imgpath,name,tags,playcount,titlenumber,title,mp4size,plid,updateplaycount,repovideourl) values (?,?,?,?,?,?,?,?,?,?)",aItem.imgPathString,aItem.titleString,aItem.tagsString,aItem.playcountString,item.pnumberString,item.titleString,item.mp4sizeString,aItem.plidString,aItem.updatedString,item.repovideourlString];
    
    if (isInsertDataOK)
    {
        return YES;
        NSLog(@"数据插入成功");
    }
    else
    {
        return NO;
        NSLog(@"数据插入失败");
    }
    
}
-(void)deleteDataFromUserTable:(CLDetailsModel *)item aItem:(CLRecommendModel *)aItem
{
        BOOL isDeleteDataOK=[myDatabase executeUpdate:@"delete from Details where imgpath = ?",aItem.imgPathString];
    if (isDeleteDataOK) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败");
    }
}
-(void)deleteDownloadDataFromUserTabel:(CLDetailsModel *)item
{
    BOOL isDeleteDataOK=[myDatabase executeUpdate:@"delete from Details where repovideourl = ?",item.repovideourlString];
    if (isDeleteDataOK) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败");
    }

}
- (NSMutableArray *)getItemsFromDatabase
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    FMResultSet *results = [myDatabase executeQuery:@"select * from Details"];
    
    //遍历
    while (results.next)
    {
        CLRecommendModel *recModel=[[CLRecommendModel alloc]init];
        CLDetailsModel *detailModel=[[CLDetailsModel alloc]init];
        recModel.titleString=[results stringForColumn:@"name"];
        recModel.playcountString=[results stringForColumn:@"playcount"];
        recModel.imgPathString=[results stringForColumn:@"imgpath"];
        recModel.tagsString=[results stringForColumn:@"tags"];
        recModel.plidString=[results stringForColumn:@"plid"];
        recModel.updatedString=[results stringForColumn:@"updateplaycount"];
        detailModel.titleString=[results stringForColumn:@"title"];
        detailModel.pnumberString=[results stringForColumn:@"titlenumber"];
        detailModel.mp4sizeString=[results stringForColumn:@"mp4size"];
        detailModel.repovideourlString=[results stringForColumn:@"repovideourl"];
        
        NSMutableArray *arr=[NSMutableArray arrayWithObjects:recModel,detailModel, nil];
        [items addObject:arr];
    }
    
    return items;
}
@end
