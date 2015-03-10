//
//  ViewController.m
//  FMDBSQLite
//
//  Created by April Lee on 2015/3/9.
//  Copyright (c) 2015年 april. All rights reserved.
//

#import "ViewController.h"
#import "DBManeger.h"

NSString* const TableViewCellIdentifier = @"DataCell";

@interface ViewController ()

@property (nonatomic,strong)NSArray *DataArray;
@property (nonatomic)int selectedIndex;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *ShowDataTableView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *InsertButton;
@property (weak, nonatomic) IBOutlet UIButton *UpdateButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.DataArray = [[DBManeger shareDBManager] selectAllDataFromDB];
    
    self.ShowDataTableView.dataSource = self;
    self.ShowDataTableView.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didInsertButton:(id)sender
{
    [self insertMessageToDB:self.titleTextField.text detailMessage:self.messageTextField.text];
    
    [self clearData];
    [self loadTableData];
}

- (IBAction)deleteButtondidSelected:(id)sender
{
    NSString *resultMsg = @"";
    
    NSString *delMessageID = [[self.DataArray objectAtIndex:self.selectedIndex] objectForKey:@"messageID"];
    NSString *delCondition = [NSString stringWithFormat:@"_id = %@",delMessageID];
    
    BOOL delResult = [[DBManeger shareDBManager] deleteDataWithCondition:delCondition];
    
    if (!delResult) {
        resultMsg = @"Error. Does not to delete the item";
        [self showAlertMessage:resultMsg];
    }
  
    [self loadTableData];
}

- (IBAction)updateButtonDidSelected:(id)sender
{
    NSString *ButtonTitle = self.UpdateButton.titleLabel.text;
    NSDictionary *updateDic = [self.DataArray objectAtIndex:self.selectedIndex];
    
    if ([ButtonTitle isEqualToString:@"Update"]) {
        
        self.deleteButton.enabled = NO;
        
        [self.UpdateButton setTitle:@"Done" forState:UIControlStateNormal];
        
        self.titleTextField.text = [updateDic objectForKey:@"title"];
        self.messageTextField.text = [updateDic objectForKey:@"message"];
    } else {
        
        NSDictionary *updateData = @{@"title" : self.titleTextField.text,
                                     @"message" : self.messageTextField.text};
        
        NSString *updateMessageID = [[self.DataArray objectAtIndex:self.selectedIndex] objectForKey:@"messageID"];
        
        BOOL result = [[DBManeger shareDBManager] updateDataWithParameter:updateData MessageID:updateMessageID];
        
        if (!result) {
            [self showAlertMessage:@"Update error"];
        }
        
        [self clearData];
        [self loadTableData];
    }
}

- (void)insertMessageToDB:(NSString *)title detailMessage:(NSString *)message
{
    [[DBManeger shareDBManager] insertDataToDB:title DetailMessage:message];
}

- (void)clearData
{
    self.titleTextField.text = @"";
    self.messageTextField.text = @"";
}

- (void)loadTableData
{
    if ([self.UpdateButton.titleLabel.text isEqualToString:@"Done"]) {
        
        [self.UpdateButton setTitle:@"Update" forState:UIControlStateNormal];
    }
    
    self.UpdateButton.enabled = NO;
    self.deleteButton.enabled = NO;
    
    self.DataArray = [[DBManeger shareDBManager] selectAllDataFromDB];
    [self.ShowDataTableView reloadData];
}

- (void)showAlertMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.DataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell){
        
        NSString *title = [[self.DataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        NSString *date = [[self.DataArray objectAtIndex:indexPath.row] objectForKey:@"date"];
        NSString *message = [[self.DataArray objectAtIndex:indexPath.row] objectForKey:@"message"];
        
        cell.textLabel.text = title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    Date:%@",message,date];
    }
    
    return cell;
    
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = (int)indexPath.row;
    self.deleteButton.enabled = YES;
    self.UpdateButton.enabled = YES;
}

#pragma mark - touch event

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.titleTextField resignFirstResponder];
    [self.messageTextField resignFirstResponder];
}

@end
