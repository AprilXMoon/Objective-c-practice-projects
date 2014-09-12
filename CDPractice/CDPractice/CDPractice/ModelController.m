//
//  ModelController.m
//  CDPractice
//
//  Created by AprilXMoon on 2014/9/4.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "ModelController.h"


static ModelController *shared =nil;

@implementation ModelController

+(ModelController*)shareModelController
{
    if (!shared) {
        shared = [[ModelController alloc]init];
    }
    
    return shared;
}

#pragma mark - Context Action
-(BOOL)UpdateContext
{
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        NSLog(@"CoreData save error : %@, %@",error,([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknow Error");
        return NO;
    }else{
        return YES;
    }
}


#pragma mark - Database Action
-(NSMutableArray*)GetAllUserDataFromModel:(NSString*)ModelName;
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ModelName inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *DataArray = [[NSMutableArray alloc]initWithArray:[context executeFetchRequest:request error:&error]];
    
    return DataArray;
}

-(BOOL)UpdateObject
{
    NSError *error = nil;
    
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        return NO;
        NSLog(@"CoreData save fault:%@,%@",error, ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
    }else{
        return YES;
    }
    
}

-(BOOL)SaveNewContext:(NSDictionary*)DataDic
{
    BOOL isSucceed = YES;
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSString *PhoneNumber = [DataDic objectForKey:@"Number"];
    NSString *UserName = [DataDic objectForKey:@"Name"];
    NSString *Email = [DataDic objectForKey:@"Email"];
    NSDate *Birthday = [self ChangeBirthdayStringToDate:[DataDic objectForKey:@"Birthday"]];
    
    Phone *detail = [NSEntityDescription insertNewObjectForEntityForName:@"Phone" inManagedObjectContext:context];
    detail.name = UserName;
    detail.number = PhoneNumber;
    detail.email = Email;
    detail.birthday = Birthday;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"error");
        isSucceed = NO;
    }
    
    return isSucceed;
}


-(BOOL)DeleteObject:(NSManagedObject*)DelObject
{
    if (DelObject) {
        [self.managedObjectContext deleteObject:DelObject];
        [self UpdateContext];
        return YES;
    }else{
        return NO;
    }
}

#pragma mark Date processed method

-(NSDate *)ChangeBirthdayStringToDate:(NSString *)BirthdayString
{
    NSDateFormatter *Dateformatter = [[NSDateFormatter alloc]init];
    [Dateformatter setDateFormat:@"YYYY-MM-dd"];
    return [Dateformatter dateFromString:BirthdayString];
}

-(NSString *)ChangeBirthdayDateToString:(NSDate *)BirthdayDate
{
    NSDateFormatter *Dateformatter = [[NSDateFormatter alloc]init];
    [Dateformatter setDateFormat:@"YYYY-MM-dd"];
    return [Dateformatter stringFromDate:BirthdayDate];
}
@end
