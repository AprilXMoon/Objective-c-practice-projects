//
//  ViewController.m
//  BlurView
//
//  Created by April Lee on 2014/12/9.
//  Copyright (c) 2014年 april. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBlurView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createBlurView
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    visualView.frame = [[UIScreen mainScreen]applicationFrame];
    
    [blurView addSubview:visualView];
}

@end
