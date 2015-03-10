//
//  ViewController.h
//  CDPractice
//
//  Created by AprilXMoon on 2014/9/2.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelController.h"
#import "Phone.h"
#import "PhoneInfoViewController.h"
#import "AddDataViewController.h"


@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>

@property (copy,nonatomic)NSMutableArray *UserDataArr;
@property (nonatomic,retain,setter = setTitleLabel:)IBOutlet UILabel *TitleLabel;
@property (nonatomic,retain)UITableView *UserInfoTableView;



-(void)getUserData;
-(void)showUserData:(NSArray*)UserDataArray;



@end
