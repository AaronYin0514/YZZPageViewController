//
//  ZZPageViewController.m
//  ZZPageViewController
//
//  Created by Aaron on 16/8/22.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "ZZPageViewController.h"

@interface ZZPageViewController ()

@end

@implementation ZZPageViewController

-(instancetype)init {
    if (self = [super init]) {
        _padding = 15.0;
        [self setupSubviews];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addObserver:self forKeyPath:@"view.frame" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"view.frame"];
}

#pragma mark - UI
-(void)setupSubviews {
    _contentScrollView = [[ZZScrollView alloc] initWithFrame:CGRectZero];
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.bouncesZoom = NO;
    _contentScrollView.clipsToBounds = NO;
    [self.view addSubview:_contentScrollView];
}

#pragma mark - property

-(void)setDataSource:(id<ZZPageViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    NSAssert([_dataSource respondsToSelector:@selector(numbersOfSubViewControllers:)], @"必须实现numbersOfSubViewControllers:方法");
    NSAssert([_dataSource respondsToSelector:@selector(pageViewController:memberAtIndex:)], @"必须实现numbersOfSubViewControllers:方法");
    
    NSInteger count = [_dataSource numbersOfSubViewControllers:self];
    
    if (count <= 0) return;
    
    if (_delegate && [_delegate respondsToSelector:@selector(paddingForItemInPageViewController:)]) {
        _padding = [_delegate paddingForItemInPageViewController:self];
    }
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    
    if (_delegate && [_delegate respondsToSelector:@selector(edgeInsetsForMemberInPageViewController:)]) {
        edgeInsets = [_delegate edgeInsetsForMemberInPageViewController:self];
    }
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    _contentScrollView.frame = CGRectMake(2 * _padding, 0.0, width - 3 * _padding, height);
    _contentScrollView.contentSize = CGSizeMake(count * (width - 3 * _padding), _contentScrollView.bounds.size.height);
    
    for (NSInteger i = 0; i < count; i++) {
        UIViewController *viewController = [_dataSource pageViewController:self memberAtIndex:i];
        [self addChildViewController:viewController];
        viewController.view.frame = CGRectMake(i * (width - 3 * _padding), edgeInsets.top, width - 4 *_padding, _contentScrollView.bounds.size.height - edgeInsets.top - edgeInsets.bottom);
        [_contentScrollView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (_dataSource) {
        NSInteger count = [_dataSource numbersOfSubViewControllers:self];
        NSString *rectString = [change[@"new"] description];
        CGRect rect = CGRectFromString([rectString substringFromIndex:8]);
        CGFloat width = rect.size.width;
        CGFloat heigth = rect.size.height;
        _contentScrollView.frame = CGRectMake(2 * _padding, 0.0, width - 3 * _padding, heigth);
        _contentScrollView.contentSize = CGSizeMake(count * (width - 3 * _padding), _contentScrollView.bounds.size.height);
        
        if (self.childViewControllers.count) {
            UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
            
            if (_delegate && [_delegate respondsToSelector:@selector(edgeInsetsForMemberInPageViewController:)]) {
                edgeInsets = [_delegate edgeInsetsForMemberInPageViewController:self];
            }
            
            [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.view.frame = CGRectMake(idx * (width - 3 * _padding), edgeInsets.top, width - 4 *_padding, _contentScrollView.bounds.size.height - edgeInsets.top - edgeInsets.bottom);
            }];
        }
    }
}

@end

@implementation ZZScrollView

@end
