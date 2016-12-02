//
//  StatusDetailViewController.m
//  stalk
//
//  Created by Coding on 18/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "StatusDetailViewController.h"
#import "WBStatusCell.h"
#import "CommentsDataSource.h"
#import "WBStatusCellDelegateIMP.h"

@interface StatusDetailViewController ()
@property (nonatomic, strong) WBStatusCell *statusCell;
@property (nonatomic, strong) UITableView *commentView;
@property (nonatomic, strong) CommentsDataSource *dataSource;
@property (nonatomic, strong) WBStatusCellDelegateIMP *cellDelegate;
@end

@implementation StatusDetailViewController

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
//    
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        CGPoint origin = CGPointMake((size.width - CELL_WIDTH)/2, 0);
//        _statusCell.origin =origin;
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//    }];
//}

//- (void)loadView{
//    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
//    
//    tableView.
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellDelegate = [[WBStatusCellDelegateIMP alloc] initWithController:self];

    _statusCell  = [WBStatusCell new];
    _statusCell.layout = _layout;
    _statusCell.delegate = _cellDelegate;
    UIView *headerView = [UIView new];
   
    _dataSource = [[CommentsDataSource alloc]initWithCellIdentifer:@"CommentIdentifer"];
   
    CGPoint origin = CGPointMake(([UIScreen mainScreen].bounds.size.width - CELL_WIDTH)/2 - PADDING, 0);
    CGSize size = CGSizeMake(CELL_WIDTH, _layout.height);
    _statusCell.frame =(CGRect){origin, size};
    [headerView addSubview:_statusCell];
    headerView.height = size.height+5;
    self.tableView.tableHeaderView = headerView;

    self.tableView.delegate = _dataSource;
    self.tableView.dataSource = _dataSource;
    [_dataSource loadCommentsForStatus:_layout.status.lid withCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_dataSource cellHeightAtIndex:indexPath.row];
}


@end
