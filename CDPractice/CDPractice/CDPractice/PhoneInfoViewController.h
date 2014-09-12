//
//  PhoneInfoViewController.h
//  CDPractice
//
//  Created by AprilXMoon on 2014/9/5.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"
#import "ModelController.h"

@interface PhoneInfoViewController : UIViewController <UITextFieldDelegate>
{
    NSArray* PhoneDataArray;
}

@property (retain,nonatomic)Phone *UserPhoneInfo;

@property (retain,nonatomic)IBOutlet UITextField *NameField;
@property (retain,nonatomic)IBOutlet UITextField *NumberFiled;
@property (retain,nonatomic)IBOutlet UITextField *EmailFiled;
@property (retain,nonatomic)IBOutlet UITextField *BirthdayFiled;
@property (retain,nonatomic)IBOutlet UILabel *FaultMessage;

@property (retain,nonatomic)IBOutlet UIButton *EditButton;
@property (retain,nonatomic)IBOutlet UIButton *BackButton;

@property (retain,nonatomic)UIDatePicker *DatePicker;


-(void)setTextValue;
-(void)setUserDataFromDataIndex:(int)DataIndex;
-(void)setUserDataFromPhoneObjdect:(Phone*)PhoneData;


@end
