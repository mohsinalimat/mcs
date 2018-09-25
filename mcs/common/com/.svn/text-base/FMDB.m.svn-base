//
//  FMDB.m
//  Toolbox
//
//  Created by gener on 17/8/28.
//  Copyright © 2017年 Light. All rights reserved.
//

#import "FMDB.h"

@implementation FMDB
{
    FMDatabase * _db;
}

+(instancetype)default{
    static FMDB * _singleton =  nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _singleton = [[[self class] alloc ]init];
    });
    
    return _singleton;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/Database"];
        NSString *filePath = [path stringByAppendingPathComponent:@"ToolBox.db"];

        _db = [FMDatabase databaseWithPath:filePath];
        
       NSArray * sql = @[
                         @"CREATE TABLE IF NOT EXISTS 'AMM' ('rowid' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'taskCode' VARCHAR(100),'taskName' VARCHAR(255),'doc' VARCHAR(10))",
                         
                         @"CREATE TABLE IF NOT EXISTS 'MEL' ('rowid' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'code' VARCHAR(100),'title' VARCHAR(255),'_description' VARCHAR(255))",
                         
                         @"CREATE TABLE IF NOT EXISTS 'TSM' ('rowid' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'code' VARCHAR(100),'message' VARCHAR(255))"
                         ];
        
        
        if ([_db open]) {
            // 初始化数据表
            for (int i = 0 ; i < sql.count; i++) {
                NSString *s = sql[i];
                
                BOOL b = [_db executeUpdate:s];
                if (b) {
                    NSLog(@"create table success!");
                }else{
                    NSLog(@"create table error!:%@",_db.lastError.localizedDescription);
                }

            }
 
        }else{
            NSLog(@"open database fail!");
        }

        [_db close];

    }
    
    return self;
}

- (void)insertWithDic:(NSDictionary *)dic{
    /*[_db open];

    [_db executeUpdate:@"INSERT INTO SEGMENT(primary_id,parent_id,toc_id,book_id,content_location,has_content,is_leaf,is_visible,mime_type,original_tag,revision_type,toc_code,title,effrg,tocdisplayeff,nodeLevel)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",dic[@"primary_id"],dic[@"parent_id"],dic[@"toc_id"],dic[@"book_id"],dic[@"content_location"],dic[@"has_content"],dic[@"is_leaf"],dic[@"is_visible"],dic[@"mime_type"],dic[@"original_tag"],dic[@"revision_type"],dic[@"toc_code"],dic[@"title"],dic[@"effrg"],dic[@"tocdisplayeff"],dic[@"nodeLevel"]];
    [_db close];*/
}

-(void)insertWithArray:(NSArray*)arr toc: (NSString*)toc {

    NSDate * start = [NSDate date];
    
    [_db open];
    [_db beginTransaction];
    
    @try {
        for (NSDictionary * dic in arr) {
            if ([toc isEqualToString:@"amm"]) {
               [_db executeUpdate:@"INSERT INTO AMM(taskCode,taskName,doc)VALUES(?,?,?)",dic[@"taskCode"],dic[@"taskName"],toc];
            }else if ([toc isEqualToString:@"mel"]) {
                [_db executeUpdate:@"INSERT INTO MEL(code,title,_description)VALUES(?,?,?)",dic[@"code"],dic[@"title"],dic[@"description"]];
            }else if ([toc isEqualToString:@"tsm"]) {
                [_db executeUpdate:@"INSERT INTO TSM(code,message)VALUES(?,?)",dic[@"code"],dic[@"message"]];
            }
            
        }
       
        NSDate *endTime = [NSDate date];
        NSTimeInterval a = [endTime timeIntervalSince1970] - [start timeIntervalSince1970];
        NSLog(@"插入%ld条数据用时%.3f秒",arr.count,a);
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        [_db rollback];
    } @finally {
        [_db commit];
    }
    
    [_db close];
}



@end
