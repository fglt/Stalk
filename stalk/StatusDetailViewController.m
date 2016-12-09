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
#import "BFPaperButton.h"
#import "UIColor+BFPaperColors.h"
#import "WBMessageCellDelegateIMP.h"

@interface StatusDetailViewController ()
@property (nonatomic, strong) WBStatusCell *statusCell;
@property (nonatomic, strong) UITableView *commentView;
@property (nonatomic, strong) MessageDataSource *commentDataSource;
@property (nonatomic, strong) MessageDataSource *repostDataSrource;
@property (nonatomic, strong) WBMessageCellDelegateIMP *cellDelegate;
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

    _statusCell  = [WBStatusCell new];
    _statusCell.layout = _layout;
    UIView *headerView = [UIView new];
    
    _cellDelegate = [WBMessageCellDelegateIMP new];
    _cellDelegate.controller = self;
   
    _commentDataSource = [[MessageDataSource alloc]initWithMessageType:MESSAGETYPECOMMENT cellIdentifer:@"CommentIdentifer" block:^(id cell, id messageLayout) {
        [(WBMessageCell *)cell configWithLayout:messageLayout delegate:_cellDelegate];
    }];
    _repostDataSrource = [[MessageDataSource alloc]initWithMessageType:MESSAGETYPEREPOST cellIdentifer:@"RepostIdentifer" block:^(id cell, id messageLayout) {
        [(WBMessageCell *)cell configWithLayout:messageLayout delegate:_cellDelegate];
    }];
   
    CGPoint origin = CGPointMake(0, 0);
    CGSize size = CGSizeMake(CellWidth, _layout.height);
    _statusCell.frame =(CGRect){origin, size};
    [headerView addSubview:_statusCell];
    headerView.frame = CGRectMake(0, 0, self.tableView.width, size.height);
    self.tableView.tableHeaderView = headerView;
    //[self.tableView addSubview:headerView];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
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
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.f];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake((self.view.width-CellWidth)/2, 0, CellWidth, font.lineHeight+10);
    
    NSString *repostTitle = [NSString stringWithFormat:@"转发:%d", _layout.status.repostsCount];
    CGSize textSize = [repostTitle boundingRectWithSize:view.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    BFPaperButton *repostButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0, 0, textSize.width, view.height) raised:NO];
    [repostButton setTitle:repostTitle forState:UIControlStateNormal];
    [repostButton setTitleFont:font];
    [repostButton setTitleColor:[UIColor paperColorBlue] forState:UIControlStateNormal];

    repostButton.tag = 10;
    repostButton.exclusiveTouch = YES;
    
    NSString *commentTitle =[NSString stringWithFormat:@"评论:%d", _layout.status.commentsCount];
    textSize = [commentTitle boundingRectWithSize:view.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    BFPaperButton *commentButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(repostButton.frame)+10, 0, textSize.width, view.height) raised:NO];
   
    [commentButton setTitle:commentTitle forState:UIControlStateNormal];
    [commentButton setTitleFont:font];
    [commentButton setTitleColor:[UIColor paperColorBlue] forState:UIControlStateNormal];

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
    
    [self screenshot];
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

- (void)screenshot
{
    
    UIView *view = UIApplication.sharedApplication.keyWindow;
    UIView *tabbar = self.tabBarController.tabBar;
    
    UIGraphicsBeginImageContextWithOptions(tabbar.size, 1,0);
    
    [tabbar.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tabbarImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    UIGraphicsBeginImageContextWithOptions(view.size, 1,0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    [tabbarImage drawAtPoint:CGPointMake(0, view.height-tabbarImage.size.height)];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",dir);
}
@end
