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

@synthesize NameField = _NameField;
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
    [self setTextFieldDelegate];
    [self InitDataPicker];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _NameField.text = self.UserPhoneInfo.name;
    _NumberFiled.text = self.UserPhoneInfo.number;
    _EmailFiled.text = self.UserPhoneInfo.email;
    _BirthdayFiled.text = [[ModelController shareModelController] ChangeBirthdayDateToString:self.UserPhoneInfo.birthday];
}

-(void)setTextFieldDelegate
{
    _NameField.delegate = self;
    _NumberFiled.delegate = self;
    _EmailFiled.delegate = self;
    _BirthdayFiled.delegate = self;
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
        
        _NameField.enabled = YES;
        _NumberFiled.enabled = YES;
        _EmailFiled.enabled = YES;
        _BirthdayFiled.enabled = YES;
        
        _BackButton.enabled = NO;
        
    }else{
        
        [self SaveDataToDB];
        
        [_EditButton setTitle:@"Edit" forState:UIControlStateNormal];
        
        _NameField.enabled = NO;
        _NumberFiled.enabled = NO;
        _EmailFiled.enabled = NO;
        _BirthdayFiled.enabled = NO;
        
        _BackButton.enabled = YES;
        
    }
}

#pragma mark - DB Action Function
-(void)SaveDataToDB
{
    BOOL isSuccess = NO;
    
    self.UserPhoneInfo.name = _NameField.text;
    self.UserPhoneInfo.number = _NumberFiled.text;
    self.UserPhoneInfo.email = _EmailFiled.text;
    self.UserPhoneInfo.birthday = [[ModelController shareModelController] ChangeBirthdayStringToDate:_BirthdayFiled.text];
    
    isSuccess = [[ModelController shareModelController]UpdateObject];
    
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
        }
    }
    return YES;
}

#pragma mark - touchEvent

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_NumberFiled resignFirstResponder];
    [_NameField resignFirstResponder];
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
    
    BOOL stricterFilter = YES;
    NSString *stricterfilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterfilterString : laxString ;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}


@end
