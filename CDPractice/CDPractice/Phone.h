//
//  Phone.h
//  CDPractice
//
//  Created by AprilXMoon on 2014/9/11.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Phone : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * birthday;

@end
