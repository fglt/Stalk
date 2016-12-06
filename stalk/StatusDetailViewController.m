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
@property (nonatomic, strong) UIView *headerSectionView;

@end

@implementation StatusDetailViewController

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _statusCell.frame = CGRectMake(0, 0, CellWidth, _statusCell.frame.size.height);
        _headerSectionView.subviews[0].left = (self.view.width - CellWidth)/2;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureHeadreSectionView];
    
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
    //[self.tableView addSubview:headerView];
    
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


- (void)configureHeadreSectionView{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake((self.view.width-CellWidth)/2, 0, CellWidth, font.lineHeight+10);
    
    UIButton *repostButton = [UIButton buttonWithType:UIButtonTypeSystem];
    repostButton.titleLabel.font =font;
    NSString *repostTitle = [NSString stringWithFormat:@"转发:%d", _layout.status.repostsCount];
    CGSize textSize = [repostTitle boundingRectWithSize:view.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    [repostButton setTitle:repostTitle forState:UIControlStateNormal];
    repostButton.frame = CGRectMake(0, 0, textSize.width, view.height);
    repostButton.tag = 10;
    repostButton.exclusiveTouch = YES;
    
    NSString *commentTitle =[NSString stringWithFormat:@"评论:%d", _layout.status.commentsCount];
    textSize = [commentTitle boundingRectWithSize:view.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    commentButton.titleLabel.font =font;
    [commentButton setTitle:commentTitle forState:UIControlStateNormal];
    commentButton.frame = CGRectMake(CGRectGetMaxX(repostButton.frame)+10, 0, textSize.width, view.height);
    commentButton.tag = 11;
    commentButton.exclusiveTouch = YES;
    
    [view addSubview:repostButton];
    [view addSubview:commentButton];
    [repostButton addTarget:self action:@selector(touchHeaderView:) forControlEvents:UIControlEventTouchUpInside];
    [commentButton addTarget:self action:@selector(touchHeaderView:) forControlEvents:UIControlEventTouchUpInside];
   
    _headerSectionView = UIView.new;
    _headerSectionView.frame = CGRectMake(0, 0, self.view.width, font.lineHeight+10);
    [_headerSectionView addSubview:view];
}

- (void)touchHeaderView:(UIButton *)sender{
    
    MessageDataSource *dataSource = (MessageDataSource *)self.tableView.dataSource;
    if(sender.tag == 10){
        if(dataSource.type == MESSAGETYPECOMMENT){
            self.tableView.dataSource = _repostDataSrource;

            [self.tableView reloadData];
            //self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.frame.size.height-64);
        }
    }else{
        if(dataSource.type == MESSAGETYPEREPOST){
            self.tableView.dataSource = _commentDataSource;
            [self.tableView reloadData];
            //self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.frame.size.height-64);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [((MessageDataSource *) tableView.dataSource) cellHeightAtIndex:indexPath.row];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headerSectionView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    UIFont *font = [UIFont systemFontOfSize:17];
    return font.lineHeight+10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"title";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
