//
//  AddDataViewController.m
//  CDPractice
//
//  Created by AprilXMoon on 2014/9/5.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "AddDataViewController.h"

@interface AddDataViewController ()

@end

@implementation AddDataViewController

@synthesize FirstNameField = _FirstNameField;
@synthesize LastNameField = _LastNameField;
@synthesize NumberFiled = _NumberFiled;
@synthesize EmailFiled = _EmailFiled;
@synthesize BirthdayFiled = _BirthdayFiled;
@synthesize FaultMessage = _FaultMessage;
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
    [self setSubTextFieldDelegate];
    [self InitDataPicker];
    
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Setting Method
-(void)setSubTextFieldDelegate
{
    _FirstNameField.delegate = self;
    _LastNameField.delegate = self;
    _NumberFiled.delegate = self;
    _EmailFiled.delegate = self;
    _BirthdayFiled.delegate = self;
}

#pragma mark - Button Action
-(IBAction)BackButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)SaveButtonPressed:(id)sender
{
    NSString *UserName = [NSString stringWithFormat:@"%@ %@",_FirstNameField.text,_LastNameField.text];
    
    NSDictionary *DataDic = @{@"Name":UserName,@"Number":_NumberFiled.text,@"Email":_EmailFiled.text,@"Birthday":_BirthdayFiled.text};
    
    BOOL isSucceed = [[ModelController shareModelController]SaveNewContext:DataDic];
    
    if (isSucceed) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        _FaultMessage.text = @"CoreData Insert Data Error";
    }
}

#pragma mark - TextField Delegate
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

#pragma mark -Touch Event
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

#pragma mark - DatePicker method

-(void)InitDataPicker
{
    _DatePicker = [[UIDatePicker alloc]init];
    NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    _DatePicker.locale = datelocale;
    _DatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    _DatePicker.datePickerMode = UIDatePickerModeDate;
    [_DatePicker addTarget:self action:@selector(ChangeDateToTextField) forControlEvents:UIControlEventValueChanged];
    
    NSDate *Todate = [NSDate date];
    _DatePicker.maximumDate = Todate;
    
    //Keyborad change DatePicker
    _BirthdayFiled.inputView = _DatePicker;
}

-(void)ChangeDateToTextField
{
    NSString *SelectDateStr = [[ModelController shareModelController] ChangeBirthdayDateToString:_DatePicker.date];
    
    _BirthdayFiled.text = SelectDateStr;
}

#pragma mark - AnimationMoveMainView
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
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 30,
                                 self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}


@end
