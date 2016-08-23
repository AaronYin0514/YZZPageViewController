//
//  MyViewController.m
//  ZZPageViewController
//
//  Created by Aaron on 16/8/22.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "MyViewController.h"
#import "ZZPageViewController.h"

#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThireViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"

@interface MyViewController () <ZZPageViewControllerDelegate, ZZPageViewControllerDataSource>

@property (nonatomic, strong) NSMutableArray *mutableArray;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mutableArray = [NSMutableArray arrayWithCapacity:5];
    
    OneViewController *one = [[OneViewController alloc] init];
    TwoViewController *two = [[TwoViewController alloc] init];
    ThireViewController *thire = [[ThireViewController alloc] init];
    FourViewController *four = [[FourViewController alloc] init];
    FiveViewController *five = [[FiveViewController alloc] init];
    
    [_mutableArray addObject:one];
    [_mutableArray addObject:two];
    [_mutableArray addObject:thire];
    [_mutableArray addObject:four];
    [_mutableArray addObject:five];
    
    ZZPageViewController *controller = [[ZZPageViewController alloc] init];
    
    controller.delegate = self;
    controller.dataSource = self;

    
    controller.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    
    [self addChildViewController:controller];
    
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

#pragma mark - ZZPageViewControllerDataSource
-(NSInteger)numbersOfSubViewControllers:(ZZPageViewController *)pageViewController {
    return _mutableArray.count;
}

-(UIViewController *)pageViewController:(ZZPageViewController *)pageViewController memberAtIndex:(NSInteger)index {
    return _mutableArray[index];
}
#pragma mark - ZZPageViewControllerDelegate
-(UIEdgeInsets)edgeInsetsForMemberInPageViewController:(ZZPageViewController *)pageViewController {
    return UIEdgeInsetsMake(20.0, 0.0, 20.0, 10.0);
}

-(CGFloat)paddingForItemInPageViewController:(ZZPageViewController *)pageViewController {
    return 0.0;
}

@end
