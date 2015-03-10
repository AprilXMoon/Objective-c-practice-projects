//
//  DBManeger.m
//  FMDBSQLite
//
//  Created by April Lee on 2015/3/9.
//  Copyright (c) 2015年 april. All rights reserved.
//

#import "DBManeger.h"

static DBManeger *shareDBManager = nil;

@implementation DBManeger

+ (id)shareDBManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDBManager = [[DBManeger alloc] init];
    });
    
    return shareDBManager;
}


- (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MESSAGEDB.db"];
    
    return dbPath;

}


- (NSArray *)selectAllDataFromDB
{
    
    NSString *dbPath = [self getDBPath];
   
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];

    __block NSArray *Items = [[NSArray alloc] init];
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        [db setShouldCacheStatements:YES];
            
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM Message"];
        Items = [self readDataFromDBResult:rs];
        [rs close];
       
    }];
    
    [dbQueue close];
    
    return Items;
}

- (NSArray *)selectDataFromDBwithWhereCondition:(NSString *)Condition
{
    NSArray *items = [[NSArray alloc] init];
    
    NSString *dbPath = [self getDBPath];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        
        NSLog(@"SelectWithCondition:Could not open DB");
    } else {
        
        [db setShouldCacheStatements:YES];
        
        FMResultSet *QueryRs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM Message WHERE %@",Condition]];
        items = [self readDataFromDBResult:QueryRs];
                            
    }

    return items;
}


- (NSArray *)readDataFromDBResult:(FMResultSet *)result
{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    while ([result next]) {
        
        NSNumber *messageID = @([result intForColumn:@"_id"]);
        NSString *title = [result stringForColumn:@"title"];
        NSString *message = [result stringForColumn:@"message"];
        NSString *date = [result stringForColumn:@"time"];
        NSString *read_status = [result stringForColumn:@"read_status"];
        
       
        [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          messageID,@"messageID",
                          title, @"title",
                          message, @"message",
                          date , @"date",
                          read_status , @"read_status",nil]];
        
        /*[items addObject:@{@"title" : title,
                           @"message" : message,
                           @"date" : date,
                           @"read_status" : read_status}];*/
        
    }
    
    return items;
}

#pragma mark Insert,delete
- (void)insertDataToDB:(NSString *)title DetailMessage:(NSString *)message
{
    NSString *dbPath = [self getDBPath];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    //open
    if (![db open]) {
        NSLog(@"Insert:Could not open db.");
    } else {
        [db executeUpdate:@"INSERT INTO Message(title, message, time, read_status) VALUES (?,?,datetime(),?)",title,message,@"0"];
    }
    
    //close
    [db close];
}

- (BOOL)deleteDataWithCondition:(NSString *)condition
{
    BOOL result = NO;
    NSString *dbPath = [self getDBPath];
    NSString *deleteStr = [NSString stringWithFormat:@"DELETE FROM message WHERE %@",condition];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        
        NSLog(@"Delete:Could not open db");
    } else {
        result = [db executeUpdate:deleteStr];
    }
    
    [db close];
    
    return result;
}

- (BOOL)updateDataWithParameter:(NSDictionary *)parameter MessageID:(NSString *)messageID
{
    BOOL result = NO;
    NSString *dbPath = [self getDBPath];

    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        
        NSLog(@"Update:Could not open db");
    } else {
        result = [db executeUpdate:@"UPDATE message SET time = datetime(), title = ?, message = ? WHERE _id = ?",
                                    [parameter objectForKey:@"title"],[parameter objectForKey:@"message"],messageID];
    }
    
    
    return result;
}


@end
