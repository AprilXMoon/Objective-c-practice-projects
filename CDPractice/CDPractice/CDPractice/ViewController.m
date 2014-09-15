//
//  ViewController.m
//  CDPractice
//
//  Created by AprilXMoon on 2014/9/2.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic) NSMutableArray *searchResults;

@end

@implementation ViewController

@synthesize UserDataArr = _UserDataArr;
@synthesize UserInfoTableView;
@synthesize TitleLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUserTableView];
    [self setTitleLabel];
    [self setAutolayout];
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[_UserDataArr count]];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self getUserData];
    
    [UserInfoTableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
    
}

//iOS7 Hidden Status Bar has to overright the perferStatusBarHidden methods
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Setting Method
-(void)setUserTableView
{
    UserInfoTableView = [[UITableView alloc]init];
    [UserInfoTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UserInfoTableView.delegate = self;
    UserInfoTableView.dataSource = self;
    
    [self.view addSubview:UserInfoTableView];
}

-(void)setTitleLabel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDate *Date = [NSDate date];
    
    [formatter setDateFormat:@"YYYY-MM-dd EEEE"];
    
    TitleLabel.text = [formatter stringFromDate:Date];
}

-(void)setAutolayout
{
    NSMutableArray *TableViewConstraints = [NSMutableArray array];
    
    [TableViewConstraints addObjectsFromArray:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:[UserInfoTableView(>=320)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:
         NSDictionaryOfVariableBindings(UserInfoTableView)]];
    
    [TableViewConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-85-[UserInfoTableView(>=360)]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(UserInfoTableView)]];
    
    
    [self.view addConstraints:TableViewConstraints];
    
}

#pragma mark - Button Action
-(IBAction)InsertButtonPressed:(id)sender
{
    AddDataViewController *AddDataView = [[AddDataViewController alloc]initWithNibName:@"AddDataViewController" bundle:nil];
    [self presentViewController:AddDataView animated:YES completion:NULL];
    
}

#pragma mark - GetData Method

-(void)getUserData
{
    _UserDataArr = [[ModelController shareModelController]GetAllUserDataFromModel:@"Phone"];
}

-(void)showUserData:(NSArray*)UserDataArray
{
    if ([_UserDataArr count] == 0) {
        return;
    }

   for (Phone *phoneinfo in _UserDataArr) {
        NSLog(@"name = %@",phoneinfo.name);
        NSLog(@"number = %@",phoneinfo.number);
    }
}

#pragma mark - Tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults.count;
    }else{
        return _UserDataArr.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"CellUserName";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    
    Phone *phoneInfo;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        phoneInfo = [self.searchResults objectAtIndex:indexPath.row];
    }else{
        phoneInfo = [_UserDataArr objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = phoneInfo.name;
    [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self ShowPhoneDetailView:tableView TableViewRowIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Phone *DelPhone = [_UserDataArr objectAtIndex:indexPath.row];
        BOOL isSucceed = [[ModelController shareModelController]DeleteObject:DelPhone];
        
        if (isSucceed) {
            [_UserDataArr removeObject:DelPhone];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }

}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self ShowPhoneDetailView:tableView TableViewRowIndexPath:indexPath];
}

#pragma mark - SearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self updateFilteredContentForSearchString:searchString];
    return YES;
}

-(void)updateFilteredContentForSearchString:(NSString*)searchString
{
    if (searchString == nil) {
        
        self.searchResults = [_UserDataArr mutableCopy];
    }else{
        
        [self.searchResults removeAllObjects];

        for (Phone *phoneInfo in _UserDataArr) {
            
            NSUInteger searchOption = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, phoneInfo.name.length);
            NSRange foundRange =[phoneInfo.name rangeOfString:searchString options:searchOption range:productNameRange];
            
            if (foundRange.length > 0) {
                [self.searchResults addObject:phoneInfo];
            }
        }
        
    }
}

#pragma mark - Detail Data Method
-(void)ShowPhoneDetailView:(UITableView*)tableView TableViewRowIndexPath:(NSIndexPath*)indexPath
{
    Phone *phoneInfo;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        phoneInfo = [self.searchResults objectAtIndex:indexPath.row];
    }else{
        phoneInfo = [_UserDataArr objectAtIndex:indexPath.row];
    }
    
    PhoneInfoViewController *PhoneInfoView = [[PhoneInfoViewController alloc]initWithNibName:@"PhoneInfoViewController" bundle:nil];
    [PhoneInfoView setUserDataFromPhoneObjdect:phoneInfo];
    
    [self presentViewController:PhoneInfoView animated:YES completion:NULL];
}


@end
