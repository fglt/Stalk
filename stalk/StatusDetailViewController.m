//
//  StatusDetailViewController.m
//  stalk
//
//  Created by Coding on 18/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "StatusDetailViewController.h"
#import "WBStatusCell.h"
#import "MessageDataSource.h"
#import "WBStatusCellDelegateIMP.h"
#import "WBStatus.h"
#import "TableHeaderView.h"

@interface StatusDetailViewController ()
@property (nonatomic, strong) WBStatusCell *statusCell;
@property (nonatomic, strong) UITableView *commentView;
@property (nonatomic, strong) MessageDataSource *commentDataSource;
@property (nonatomic, strong) MessageDataSource *repostDataSrource;
@property (nonatomic, strong) WBStatusCellDelegateIMP *cellDelegate;

@end

@implementation StatusDetailViewController

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _statusCell.frame = CGRectMake(0, 0, CellWidth, _statusCell.frame.size.height);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

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
   
    _commentDataSource = [[MessageDataSource alloc]initWithMessageType:MESSAGETYPECOMMENT cellIdentifer:@"CommentIdentifer"];
    _repostDataSrource = [[MessageDataSource alloc]initWithMessageType:MESSAGETYPEREPOST cellIdentifer:@"RepostIdentifer"];
   
    CGPoint origin = CGPointMake(0, 0);
    CGSize size = CGSizeMake(CellWidth, _layout.height);
    _statusCell.frame =(CGRect){origin, size};
    [headerView addSubview:_statusCell];
    headerView.frame = CGRectMake(0, 0, self.tableView.width, size.height);
    self.tableView.tableHeaderView = headerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = _commentDataSource;
    self.tableView.tableFooterView= UIView.new;
    [_commentDataSource loadMessagesForStatus:_layout.status.lid withCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
    
    [_repostDataSrource loadMessagesForStatus:_layout.status.lid withCompletion:nil];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [((MessageDataSource *) tableView.dataSource) cellHeightAtIndex:indexPath.row];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIFont *font = [UIFont systemFontOfSize:17];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, CellWidth, font.lineHeight);
    UIButton *repost = [UIButton buttonWithType:UIButtonTypeSystem];
    repost.titleLabel.font =font;
    NSString *repostTitle = [NSString stringWithFormat:@"转发:%d", _layout.status.repostsCount];
    [repost setTitle:repostTitle forState:UIControlStateNormal];
    repost.frame = CGRectMake(100, 0, 80, view.height);
    NSString *commentTitle =[NSString stringWithFormat:@"评论:%d", _layout.status.commentsCount];
    UIButton *comment = [UIButton buttonWithType:UIButtonTypeSystem];
     comment.titleLabel.font =font;
    [comment setTitle:commentTitle forState:UIControlStateNormal];
    comment.frame = CGRectMake(200, 0, 80, view.height);
    [view addSubview:repost];
    [view addSubview:comment];
    view.autoresizingMask  = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    [repost addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        MessageDataSource *dataSource = (MessageDataSource *)self.tableView.dataSource;
        
        if(dataSource.type == MESSAGETYPECOMMENT){
            dataSource.type = MESSAGETYPEREPOST;
            self.tableView.dataSource = _repostDataSrource;
            [tableView reloadData];
        }
    }];
    
    [comment addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        MessageDataSource *dataSource = (MessageDataSource *)self.tableView.dataSource;
        
        if(dataSource.type == MESSAGETYPEREPOST){
            dataSource.type = MESSAGETYPECOMMENT;
            self.tableView.dataSource = _commentDataSource;
            [tableView reloadData];
        }
    }];
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    UIFont *font = [UIFont systemFontOfSize:17];
    return font.lineHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"title";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
