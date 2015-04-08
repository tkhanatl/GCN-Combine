//
//  FavouritesViewController.h
//  GCN Combine
//
//  Created by DP Samantrai on 29/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerTransactionDelegate.h"

@interface FavouritesViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,ServerTransactionDelegate>
{
    UISearchController *m_cObjFavouriteSearchDisplayControllerPtr;
    UISearchBar               *m_cObjFavouriteSearchBarPtr;
    UITableView               *m_cObjFavouriteTablePtr;
    NSString                 *savedFavouriteSearchTerm;
    NSInteger                 savedScopeButtonIndex;
    BOOL                        searchWasActive;
    NSMutableArray             *m_cObjFavouriteFilteredListContent;
}

@property (nonatomic, copy) NSString *savedFavouriteSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic,retain) NSMutableArray    *m_cObjFavouriteFilteredListContent;

-(id)initWithTabBar;
-(void)createSearchDisplayController;
-(void)createElements;


@end
