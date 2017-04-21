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

@property (nonatomic, strong) UIView *testView;

@property (nonatomic, strong) LYCustomReturnBoxView *customReturnBoxView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.customReturnBoxView = [[LYCustomReturnBoxView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 30)
                                                             ReturnBoxStyle:ReturnBoxStyleCubeBottomToTop
                                                                 DataSource:@[@"Lovey购买了小秘书得到了价值￥5000股票",
                                                                              @"Hxx购买了小秘书得到了价值￥5000股票",
                                                                              @"Ly购买了小秘书得到了价值￥5000股票"]];
//    self.customReturnBoxView.textAlignment = NSTextAlignmentLeft;
//    self.customReturnBoxView.textFont = [UIFont systemFontOfSize:10];
    self.customReturnBoxView.textColor = [UIColor grayColor];
//    self.customReturnBoxView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.customReturnBoxView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.center = self.view.layer.position;
    btn.bounds = CGRectMake(0, 0, 100, 50);
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(btnClick:)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

/**
 *  @author liyong
 *
 *  按钮点击
 *
 *  @param sender
 */
- (void)btnClick:(UIButton *)sender
{
    if (sender.isSelected)
    {
        [self.customReturnBoxView refreshWithDataSource:@[@"123"]];
    }else
    {
        [self.customReturnBoxView refreshWithDataSource:@[@"谁最帅", @"我最帅", @"没人比我帅"]];
    }
    
    [sender setSelected:!sender.isSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
