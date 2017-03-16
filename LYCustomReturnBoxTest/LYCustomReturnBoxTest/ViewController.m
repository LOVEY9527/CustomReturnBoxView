//
//  ViewController.m
//  LYCustomReturnBoxTest
//
//  Created by 李勇 on 17/3/16.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "ViewController.h"
#import "LYCustomReturnBoxView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LYCustomReturnBoxView *customReturnBoxView = [[LYCustomReturnBoxView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 60)
                                                                                        style:AutoCycleReturnBoxStyle
                                                                                   DataSource:@[@"轮播", @"轮播轮播轮播", @"轮播轮播轮播轮播轮播轮播"]];
//    customReturnBoxView.textAlignment = NSTextAlignmentLeft;
//    customReturnBoxView.textFont = [UIFont systemFontOfSize:10];
    customReturnBoxView.textColor = [UIColor grayColor];
    [self.view addSubview:customReturnBoxView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
