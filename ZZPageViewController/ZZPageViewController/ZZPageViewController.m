//
//  ZZPageViewController.m
//  ZZPageViewController
//
//  Created by Aaron on 16/8/22.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "ZZPageViewController.h"

@interface ZZPageViewController () <UIScrollViewDelegate>

@property (copy, nonatomic) Completion completion;

@property (copy, nonatomic) SrollProgress srollProgress;

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

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    parent.automaticallyAdjustsScrollViewInsets = NO;
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
    _contentScrollView.delegate = self;
    [self.view addSubview:_contentScrollView];
}

#pragma mark - property

-(void)setDataSource:(id<ZZPageViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    NSAssert([_dataSource respondsToSelector:@selector(numbersOfSubViewControllers:)], @"必须实现numbersOfSubViewControllers:方法");
    NSAssert([_dataSource respondsToSelector:@selector(pageViewController:memberAtIndex:)], @"必须实现numbersOfSubViewControllers:方法");
    
    NSInteger count = [_dataSource numbersOfSubViewControllers:self];
    
    _totalPage = count;
    
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

-(NSInteger)currentPage {
    return _contentScrollView.contentOffset.x * _totalPage / _contentScrollView.contentSize.width;
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

-(void)setCurrentPageToIndex:(NSInteger)index animated:(BOOL)animated completion:(void (^)())completion {
    if (index < 0) return;
    if (_totalPage == 0 || index > _totalPage || index == self.currentPage) return;
    if (animated && completion) _completion = completion;
    CGFloat width = _contentScrollView.bounds.size.width / _totalPage;
    [_contentScrollView setContentOffset:CGPointMake(index * width, 0) animated:animated];
}

-(void)monitorScrollProgress:(SrollProgress)progress {
    if (progress) {
        _srollProgress = progress;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_srollProgress) {
        NSInteger currentPage = self.currentPage;
        CGFloat width = scrollView.contentSize.width / _totalPage;
        CGFloat currentWidtnInPage = scrollView.contentOffset.x - currentPage * width;
        CGFloat currentProgress = currentWidtnInPage / width;
        CGFloat totalProgress = scrollView.contentOffset.x / scrollView.contentSize.width;
        _srollProgress(currentPage, currentProgress, totalProgress);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (_completion) {
        _completion();
    }
}

@end

@implementation ZZScrollView

@end
