//
//  ViewController.m
//  ZZPageViewController
//
//  Created by Aaron on 16/8/22.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "ViewController.h"
#import "MyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Actions

- (IBAction)buttonClick:(id)sender {
    MyViewController *vc = [[MyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
