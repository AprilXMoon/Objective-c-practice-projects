//
//  DBManeger.h
//  FMDBSQLite
//
//  Created by April Lee on 2015/3/9.
//  Copyright (c) 2015年 april. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

@interface DBManeger : NSObject

+ (id)shareDBManager;

- (NSArray *)selectAllDataFromDB;
- (NSArray *)selectDataFromDBwithWhereCondition:(NSString *)Condition;

- (void)insertDataToDB:(NSString *)title DetailMessage:(NSString *)message;
- (BOOL)deleteDataWithCondition:(NSString *)condition;
- (BOOL)updateDataWithParameter:(NSDictionary *)parameter MessageID:(NSString *)messageID;

@end
