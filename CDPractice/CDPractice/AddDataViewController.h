//
//  AddDataViewController.h
//  CDPractice
//
//  Created by AprilXMoon on 2014/9/5.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelController.h"

@interface AddDataViewController : UIViewController <UITextFieldDelegate>

@property (retain,nonatomic)IBOutlet UITextField *FirstNameField;
@property (retain,nonatomic)IBOutlet UITextField *LastNameField;
@property (retain,nonatomic)IBOutlet UITextField *NumberFiled;
@property (retain,nonatomic)IBOutlet UITextField *EmailFiled;
@property (retain,nonatomic)IBOutlet UITextField *BirthdayFiled;

@property (retain,nonatomic)IBOutlet UILabel *FaultMessage;

@property (retain,nonatomic)UIDatePicker *DatePicker;

@end
