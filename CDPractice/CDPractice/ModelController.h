//
//  ModelController.h
//  CDPractice
//
//  Created by AprilXMoon on 2014/9/4.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Phone.h"

@interface ModelController : NSObject


@property (retain,nonatomic)NSManagedObjectContext *managedObjectContext;


+(ModelController*)shareModelController;

-(NSMutableArray*)GetAllUserDataFromModel:(NSString*)ModelName;

-(BOOL)UpdateObject;
-(BOOL)SaveNewContext:(NSDictionary*)DataDic;
-(BOOL)DeleteObject:(NSManagedObject*)DelObject;

-(BOOL)UpdateContext;

#pragma mark Date processed method
-(NSDate *)ChangeBirthdayStringToDate:(NSString *)BirthdayString;
-(NSString *)ChangeBirthdayDateToString:(NSDate *)BirthdayDate;


@end
