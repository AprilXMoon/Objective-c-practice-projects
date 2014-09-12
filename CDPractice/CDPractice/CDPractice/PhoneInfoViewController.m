//
//  PhoneInfoViewController.m
//  CDPractice
//
//  Created by AprilXMoon on 2014/9/5.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "PhoneInfoViewController.h"

@interface PhoneInfoViewController ()

@end


@implementation PhoneInfoViewController

@synthesize FirstNameField = _FirstNameField;
@synthesize LastNameField = _LastNameField;
@synthesize NumberFiled = _NumberFiled;
@synthesize EmailFiled = _EmailFiled;
@synthesize BirthdayFiled = _BirthdayFiled;
@synthesize UserPhoneInfo = _UserPhoneInfo;
@synthesize EditButton = _EditButton;
@synthesize BackButton = _BackButton;
@synthesize DatePicker = _DatePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTextValue];
    [self setSubTextFieldDelegate];
    [self InitDataPicker];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Hidden status bar (iOS 7)
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - set Value
-(void)setUserDataFromDataIndex:(int)DataIndex
{
    PhoneDataArray = [[ModelController shareModelController] GetAllUserDataFromModel:@"Phone"];
    self.UserPhoneInfo = [PhoneDataArray objectAtIndex:DataIndex];
}

-(void)setUserDataFromPhoneObjdect:(Phone*)PhoneData
{
    self.UserPhoneInfo = PhoneData;
}

-(void)setTextValue
{
    NSArray *NameArr = [self.UserPhoneInfo.name componentsSeparatedByString:@" "];
    
    _FirstNameField.text = [NameArr objectAtIndex:0];
    _LastNameField.text = [NameArr objectAtIndex:1];
    _NumberFiled.text = self.UserPhoneInfo.number;
    _EmailFiled.text = self.UserPhoneInfo.email;
    _BirthdayFiled.text = [[ModelController shareModelController] ChangeBirthdayDateToString:self.UserPhoneInfo.birthday];
}

-(void)setSubTextFieldDelegate
{
    _FirstNameField.delegate = self;
    _LastNameField.delegate = self;
    _NumberFiled.delegate = self;
    _EmailFiled.delegate = self;
    _BirthdayFiled.delegate = self;
}

-(void)setSubTextFieldEnabled:(BOOL)isEnabled
{
    for (id subview in [self.view subviews]){
        
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *subTextField = (UITextField *)subview;
            subTextField.enabled = isEnabled;
        }
    }
}

#pragma mark - DatePicker method

-(void)InitDataPicker
{
    _DatePicker = [[UIDatePicker alloc]init];
    NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    _DatePicker.locale = datelocale;
    _DatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    _DatePicker.datePickerMode = UIDatePickerModeDate;
    [_DatePicker addTarget:self action:@selector(ChangeDateToTextField) forControlEvents:UIControlEventValueChanged];
    
    NSDate *Today = [NSDate date];
    _DatePicker.maximumDate = Today;
    
    //Keyborad change DatePicker
    _BirthdayFiled.inputView = _DatePicker;
}

-(void)ChangeDateToTextField
{
    NSString *SelectDateStr = [[ModelController shareModelController] ChangeBirthdayDateToString:_DatePicker.date];
    
    _BirthdayFiled.text = SelectDateStr;
}


#pragma mark - Button Action
-(IBAction)BackButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)EditButtonPressed:(id)sender
{
    if ([_EditButton.titleLabel.text isEqualToString:@"Edit"]) {
        
        [_EditButton setTitle:@"Done" forState:UIControlStateNormal];
        
        [self setSubTextFieldEnabled:YES];
        
        _BackButton.enabled = NO;
        
    }else{
        
        [self SaveDataToDB];
        
        [_EditButton setTitle:@"Edit" forState:UIControlStateNormal];
        
        [self setSubTextFieldEnabled:NO];
        
        _BackButton.enabled = YES;
        
    }
}

#pragma mark - DB Action Function
-(void)SaveDataToDB
{
    BOOL isSuccess = NO;
    
    NSString *UserName = [NSString stringWithFormat:@"%@ %@",_FirstNameField.text,_LastNameField.text];
    
    self.UserPhoneInfo.name = UserName;
    self.UserPhoneInfo.number = _NumberFiled.text;
    self.UserPhoneInfo.email = _EmailFiled.text;
    self.UserPhoneInfo.birthday = [[ModelController shareModelController] ChangeBirthdayStringToDate:_BirthdayFiled.text];
    
    isSuccess = [[ModelController shareModelController] UpdateObject];
    
    if (!isSuccess){
        self.FaultMessage.text = @"CoreData saves fault.";
    }
}

#pragma mark - TextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _EmailFiled) {
        BOOL isEmail = [self NSStringIsValidEmail:_EmailFiled.text];
        
        if (!isEmail) {
            UIAlertView *FormatErrorView = [[UIAlertView alloc]initWithTitle:@"Email Format" message:@"The e-mail format is wrong! \n Please check it again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [FormatErrorView show];
            
            _EmailFiled.textColor = [UIColor redColor];
        }else{
            _EmailFiled.textColor = [UIColor blackColor];
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _BirthdayFiled) {
        [self MoveUpTheView];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _BirthdayFiled) {
        [self MoveDownTheView];
    }
}

#pragma mark - touchEvent

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [_FirstNameField resignFirstResponder];
    [_LastNameField resignFirstResponder];
    [_NumberFiled resignFirstResponder];
    [_EmailFiled resignFirstResponder];
    [_BirthdayFiled resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Check Email

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    if ([checkString isEqualToString:@""]) {
        return YES;
    }
    
    NSString *stricterfilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *emailRegex = stricterfilterString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark AnimationMoveView

-(void)MoveUpTheView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 30,
                                 self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)MoveDownTheView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 30 ,
                                 self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}


@end
