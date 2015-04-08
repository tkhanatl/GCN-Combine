//
//  FavouritesViewController.m
//  GCN Combine
//
//  Created by DP Samantrai on 29/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "FavouritesViewController.h"
#import "Macros.h"
#import "AthleteDetailTableViewCell.h"
#import "AppDelegate.h"
#import "AthleteLoggerViewController.h"
#import "Athlete.h"
#import "AppDelegate.h"

@implementation FavouritesViewController

@synthesize savedFavouriteSearchTerm,savedScopeButtonIndex,searchWasActive,m_cObjFavouriteFilteredListContent;

-(id)initWithTabBar
{
    if (self = [super init]) 
    {
        UITabBarItem *lObjTabbarItem = (UITabBarItem *)nil;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"LoginBackGround", @"")]];
        self.tabBarController.navigationController.navigationBar.hidden = YES;
        lObjTabbarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Favourites", @"") image:[UIImage imageNamed:NSLocalizedString(@"FavouritesLogo", @"")] tag:0];
        self.tabBarItem = lObjTabbarItem;
        self.title = NSLocalizedString(@"Favourites", @"");
        SAFE_RELEASE(lObjTabbarItem)
        
        m_cObjFavouriteSearchDisplayControllerPtr = (UISearchController *)nil;
        m_cObjFavouriteSearchBarPtr = (UISearchBar *)nil;
        
        self.hidesBottomBarWhenPushed = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    m_cObjFavouriteFilteredListContent = [[NSMutableArray alloc] init];
    [self createSearchDisplayController];
    [self createElements];
    if (self.savedFavouriteSearchTerm)
    {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedFavouriteSearchTerm];
        
        self.savedFavouriteSearchTerm = nil;
        
        [m_cObjFavouriteTablePtr reloadData];
        m_cObjFavouriteTablePtr.scrollEnabled = YES;
    }
    [m_cObjFavouriteTablePtr reloadData];

}

-(void)loadView
{
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    gObjAppDelegatePtr.isAlertViewShown = NO;
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
    NSMutableArray *lObjArrayPtr = (NSMutableArray *)nil;
    lObjArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAllFavouriteAthletes]retain];
    gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr = lObjArrayPtr;
    
       
    
    //Narasimhaiah sorting the athlete array 12-3-13 - start
    NSString * FIRSTNAME = @"m_cObjFirstNamePtr";
    NSSortDescriptor *firstDescriptor =
    [[[NSSortDescriptor alloc]
      initWithKey:FIRSTNAME
      ascending:YES
      selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    
    NSArray * descriptors =
    [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray * sortedArray =
    [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr sortedArrayUsingDescriptors:descriptors];
    [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr removeAllObjects];
    gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr = [NSMutableArray arrayWithArray:sortedArray];
    //Narasimhaiah sorting the athlete array 12-3-13 - end
    
    
    
    SAFE_RELEASE(lObjArrayPtr)
    gObjAppDelegatePtr.m_cObjImageDatePtr = (NSData *)nil;
    [m_cObjFavouriteTablePtr reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.searchController setActive:NO animated:NO];
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = nil;
}
-(void)serverTransactionSucceeded
{
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    [gObjAppDelegatePtr stopProgressHandler];
    
    
    //Narasimhaiah sorting the athlete array 12-3-13 - start
    NSString * FIRSTNAME = @"m_cObjFirstNamePtr";
    NSSortDescriptor *firstDescriptor =
    [[[NSSortDescriptor alloc]
      initWithKey:FIRSTNAME
      ascending:YES
      selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    
    NSArray * descriptors =
    [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray * sortedArray =
    [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr sortedArrayUsingDescriptors:descriptors];
    [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr removeAllObjects];
    gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr = [NSMutableArray arrayWithArray:sortedArray];
    //Narasimhaiah sorting the athlete array 12-3-13 - end

}
-(void)serverTransactionFailed
{
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    [gObjAppDelegatePtr stopProgressHandler];
}
-(void)photoDownloadSucceed
{
    
}
-(void)photoDownloadFailed
{
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    [super viewDidDisappear:YES];
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedFavouriteSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
}

-(void)createSearchDisplayController
{
    m_cObjFavouriteSearchBarPtr = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0 ,self.navigationController.navigationBar.frame.size.height , self.view.bounds.size.width, 44)];
	m_cObjFavouriteSearchBarPtr.showsCancelButton = NO;
	m_cObjFavouriteSearchBarPtr.placeholder = @"Search";
	m_cObjFavouriteSearchBarPtr.delegate = self;
    m_cObjFavouriteSearchBarPtr.barStyle = UIBarStyleBlackOpaque;
	
    
    m_cObjFavouriteSearchDisplayControllerPtr =[[UISearchDisplayController alloc]initWithSearchBar:m_cObjFavouriteSearchBarPtr contentsController:self];
    
    
    m_cObjFavouriteSearchDisplayControllerPtr.delegate =self;
    m_cObjFavouriteSearchDisplayControllerPtr.searchResultsDelegate = self;
    m_cObjFavouriteSearchDisplayControllerPtr.searchResultsDataSource =self;
    [self.view addSubview:m_cObjFavouriteSearchBarPtr];
    
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    /*
     Update the filtered array based on the search text and scope.
     */
    
    [self.m_cObjFavouriteFilteredListContent removeAllObjects]; // First clear the filtered array.
    
    /*
     Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    for (Athlete *athlete in gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr)
    {
        NSString *lObjAthletePhoneNumberPtr = (NSString *)nil;
        NSString *lObjAthletePhoneNumber = (NSString *)nil;
        NSString *lObjAthleteFirstName = (NSString *)nil;
        NSComparisonResult result1 = -1L;
        NSComparisonResult result2 = -1L;
        
        if ((NSString *)nil !=athlete.m_cObjPhoneNumberPtr && ![athlete.m_cObjPhoneNumberPtr isEqualToString:@""] && ![athlete.m_cObjPhoneNumberPtr isEqualToString:@" "]) {
            lObjAthletePhoneNumberPtr = athlete.m_cObjPhoneNumberPtr;
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"()-"];
            NSArray *phoneArray = (NSArray *)nil;
            phoneArray = [lObjAthletePhoneNumberPtr componentsSeparatedByCharactersInSet:set];
            lObjAthletePhoneNumber =[phoneArray componentsJoinedByString:@""];
            if ((NSString *)nil != lObjAthletePhoneNumber && ![lObjAthletePhoneNumber isEqualToString:@""] && ![lObjAthletePhoneNumber isEqualToString:@" "]) {
                result2 = [lObjAthletePhoneNumber compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            }
            
        }
        if ((NSString *)nil !=athlete.m_cObjFirstNamePtr && ![athlete.m_cObjFirstNamePtr isEqualToString:@""] && ![athlete.m_cObjFirstNamePtr isEqualToString:@" "]) {
            
            lObjAthleteFirstName = athlete.m_cObjFirstNamePtr;
            if ((NSString *)nil != lObjAthleteFirstName) {
                result1 = [lObjAthleteFirstName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            }
        }
        
        if (result1 == NSOrderedSame || result2 == NSOrderedSame)
        {
            [self.m_cObjFavouriteFilteredListContent addObject:athlete];
        }
        
    }

}
-(void)createElements
{
    
	CGRect				lObjRect = CGRectZero;
    CGFloat              lHeight = {0.0};
        
	lHeight = self.navigationController.navigationBar.frame.size.height + m_cObjFavouriteSearchBarPtr.frame.size.height;
    lObjRect = CGRectMake(CGRectGetMinX(self.view.bounds),
                          lHeight,
                          CGRectGetWidth(self.view.frame),330.0);
    
	m_cObjFavouriteTablePtr = [[UITableView alloc] initWithFrame:lObjRect style:UITableViewStylePlain];	
	m_cObjFavouriteTablePtr.backgroundColor = [UIColor whiteColor];
    m_cObjFavouriteTablePtr.delegate = self;
	m_cObjFavouriteTablePtr.dataSource = self;
	m_cObjFavouriteTablePtr.autoresizesSubviews = YES;
	m_cObjFavouriteTablePtr.scrollEnabled = YES;
	m_cObjFavouriteTablePtr.allowsSelectionDuringEditing = YES;
    m_cObjFavouriteTablePtr.alpha = 1.0;
    [self.view addSubview:m_cObjFavouriteTablePtr];
}


#pragma mark tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.m_cObjFavouriteFilteredListContent count];
    }
    else
    {
        return [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr count];
    }
    
    return 0;
    
}

#pragma mark tableview delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        static NSString      *lObjCellIdentifierPtr = @"AthleteDetailCell";
        NSString    *lObjStrPtr = (NSString *)nil;
        Athlete *lObjFavAthletePtr = (Athlete *)nil;
        
        AthleteDetailTableViewCell   *lObjCellPtr = (AthleteDetailTableViewCell *)nil;
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr]; 
        if((AthleteDetailTableViewCell *)nil == lObjCellPtr)
        {
            lObjCellPtr = [[[AthleteDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjCellIdentifierPtr] autorelease];
        }
        
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            lObjFavAthletePtr = [self.m_cObjFavouriteFilteredListContent objectAtIndex:indexPath.row];
            NSString *lObjStrPtr = [NSString stringWithFormat:@"%@%@%@", GET_STR(lObjFavAthletePtr.m_cObjFirstNamePtr),GET_SPACE(lObjFavAthletePtr.m_cObjFirstNamePtr), GET_STR(lObjFavAthletePtr.m_cObjLastNamePtr)];
            
            
            
            //Narasimhaiah adding to set photo to athlete record 25-2-13 - start
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL isIDexists = NO;
            NSString *lObjImageNamePathPtr = (NSString *)nil;
            
            NSArray *athleteIdsPtr =gObjAppDelegatePtr.m_cObjDictionaryPtr.allKeys;
            
            if (athleteIdsPtr.count > 0) {
                for (int i=0; i<athleteIdsPtr.count; i++) {
                    if ([lObjFavAthletePtr.m_cAthleteId isEqualToString:[athleteIdsPtr objectAtIndex:i]]) {
                        isIDexists = YES;
                        lObjImageNamePathPtr = [gObjAppDelegatePtr.m_cObjDictionaryPtr objectForKey:[athleteIdsPtr objectAtIndex:i]];
                    }
                }
            }
            
            NSString *lObjImageNamePtr = (NSString *)nil;
            BOOL fileExists = NO;
            
            if (YES == isIDexists) {
                lObjImageNamePtr = lObjImageNamePathPtr;
                fileExists = [fileManager fileExistsAtPath:lObjImageNamePtr];
                
                if (NO == fileExists && (NSString *)nil != lObjFavAthletePtr.m_cPhotoNamePtr && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                    lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:lObjFavAthletePtr.m_cPhotoNamePtr];
                    //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                    fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                }

            }
            else{
                if ((NSString *)nil != lObjFavAthletePtr.m_cPhotoNamePtr && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]){
                    lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:lObjFavAthletePtr.m_cAthleteId AthImageName:lObjFavAthletePtr.m_cPhotoNamePtr];
                    //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                    fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                    
                }
            }
            
            if (NO == fileExists && (NSString *)nil != lObjFavAthletePtr.m_cPhotoNamePtr && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:lObjFavAthletePtr.m_cPhotoNamePtr];
                //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
            }
            
            if (YES == fileExists) {
                NSData *lObjImageDataPtr = [NSData dataWithContentsOfFile:lObjImageNamePathPtr];
                lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageWithData:lObjImageDataPtr];
                //[lObjCellPtr.m_cAthleteImageViewPtr.image setImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
            }
            else
            {
                //[lObjCellPtr.m_cAthleteImageViewPtr.image setImage:[UIImage imageNamed:@"AthleteImage.png"] forState:UIControlStateNormal];
                lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageNamed:@"AthleteImage.png"];
            }
            //Narasimhaiah adding to set photo to athlete record 25-2-13 - end
            
            
            
//            lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageNamed:@"AthleteImage.png"];
            lObjCellPtr.m_cAthleteNamePtr.text = lObjStrPtr;
        }
        else
        {
            lObjFavAthletePtr = [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr objectAtIndex:indexPath.row];
            lObjStrPtr = [NSString stringWithFormat:@"%@%@%@", GET_STR(lObjFavAthletePtr.m_cObjFirstNamePtr),GET_SPACE(lObjFavAthletePtr.m_cObjFirstNamePtr), GET_STR(lObjFavAthletePtr.m_cObjLastNamePtr)];
            
            //Narasimhaiah adding to set photo to athlete record 25-2-13 - start
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL isIDexists = NO;
            NSString *lObjImageNamePathPtr = (NSString *)nil;
            
            NSArray *athleteIdsPtr =gObjAppDelegatePtr.m_cObjDictionaryPtr.allKeys;
            
            if (athleteIdsPtr.count > 0) {
                for (int i=0; i<athleteIdsPtr.count; i++) {
                    if ([lObjFavAthletePtr.m_cAthleteId isEqualToString:[athleteIdsPtr objectAtIndex:i]]) {
                        isIDexists = YES;
                        lObjImageNamePathPtr = [gObjAppDelegatePtr.m_cObjDictionaryPtr objectForKey:[athleteIdsPtr objectAtIndex:i]];
                    }
                }
            }
            
            NSString *lObjImageNamePtr = (NSString *)nil;
            BOOL fileExists = NO;
            
            if (YES == isIDexists) {
                lObjImageNamePtr = lObjImageNamePathPtr;
                fileExists = [fileManager fileExistsAtPath:lObjImageNamePtr];

                if (NO == fileExists && (NSString *)nil != lObjFavAthletePtr.m_cPhotoNamePtr && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                    lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:lObjFavAthletePtr.m_cPhotoNamePtr];
                    //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                    fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                }
            }
            else{
                if ((NSString *)nil != lObjFavAthletePtr.m_cPhotoNamePtr && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]){
                    lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:lObjFavAthletePtr.m_cAthleteId AthImageName:lObjFavAthletePtr.m_cPhotoNamePtr];
                    //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                    fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                    
                   
                }
            }
            
            if (NO == fileExists && (NSString *)nil != lObjFavAthletePtr.m_cPhotoNamePtr && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![lObjFavAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:lObjFavAthletePtr.m_cPhotoNamePtr];
                //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
            }
                        
            if (YES == fileExists) {
                NSData *lObjImageDataPtr = [NSData dataWithContentsOfFile:lObjImageNamePathPtr];
                lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageWithData:lObjImageDataPtr];
                //[lObjCellPtr.m_cAthleteImageViewPtr.image setImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
            }
            else
            {
                //[lObjCellPtr.m_cAthleteImageViewPtr.image setImage:[UIImage imageNamed:@"AthleteImage.png"] forState:UIControlStateNormal];
                lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageNamed:@"AthleteImage.png"];
            }
            //Narasimhaiah adding to set photo to athlete record 25-2-13 - end
        
            //lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageNamed:@"AthleteImage.png"];
            lObjCellPtr.m_cAthleteNamePtr.text = lObjStrPtr;
        } 
        
        
        lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        return lObjCellPtr;
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        //set add to Favourites button to nil or dont create add to favourite 7-12-12
        gObjAppDelegatePtr.IsinFavourites = YES;
        AthleteLoggerViewController *lObjAthleteLoggerViewControllerPtr = (AthleteLoggerViewController *)nil;
        lObjAthleteLoggerViewControllerPtr = [[AthleteLoggerViewController alloc]init];
        lObjAthleteLoggerViewControllerPtr.m_cObjAthleteDetailStructurePtr = [self.m_cObjFavouriteFilteredListContent objectAtIndex:indexPath.row];
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        
        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadAthleteInformation:lObjAthleteLoggerViewControllerPtr.m_cObjAthleteDetailStructurePtr];
        
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading Athlete Detail from server"];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
        

        [self.navigationController pushViewController:lObjAthleteLoggerViewControllerPtr animated:YES];
        SAFE_RELEASE(lObjAthleteLoggerViewControllerPtr)
    }
    else{
        //set add to Favourites button to nil or dont create add to favourite 7-12-12
        gObjAppDelegatePtr.IsinFavourites = YES;
        AthleteLoggerViewController *lObjAthleteLoggerViewControllerPtr = (AthleteLoggerViewController *)nil;
        lObjAthleteLoggerViewControllerPtr = [[AthleteLoggerViewController alloc]init];
        lObjAthleteLoggerViewControllerPtr.m_cObjAthleteDetailStructurePtr = [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr objectAtIndex:indexPath.row];
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadAthleteInformation:lObjAthleteLoggerViewControllerPtr.m_cObjAthleteDetailStructurePtr];
        
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading Athlete Detail from server"];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
        

        [self.navigationController pushViewController:lObjAthleteLoggerViewControllerPtr animated:YES];
        SAFE_RELEASE(lObjAthleteLoggerViewControllerPtr)
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchController.searchResultsTableView) {
        //set add to Favourites button to nil or dont create add to favourite 7-12-12
        gObjAppDelegatePtr.IsinFavourites = YES;
        AthleteLoggerViewController *lObjAthleteLoggerViewControllerPtr = (AthleteLoggerViewController *)nil;
        lObjAthleteLoggerViewControllerPtr = [[AthleteLoggerViewController alloc]init];
        lObjAthleteLoggerViewControllerPtr.m_cObjAthleteDetailStructurePtr = [self.m_cObjFavouriteFilteredListContent objectAtIndex:indexPath.row];
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        
        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadAthleteInformation:lObjAthleteLoggerViewControllerPtr.m_cObjAthleteDetailStructurePtr];
        
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading Athlete Detail from server"];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;

        [self.navigationController pushViewController:lObjAthleteLoggerViewControllerPtr animated:YES];
        SAFE_RELEASE(lObjAthleteLoggerViewControllerPtr)
    }
    else{
        //set add to Favourites button to nil or dont create add to favourite 7-12-12
        gObjAppDelegatePtr.IsinFavourites = YES;
        AthleteLoggerViewController *lObjAthleteLoggerViewControllerPtr = (AthleteLoggerViewController *)nil;
        lObjAthleteLoggerViewControllerPtr = [[AthleteLoggerViewController alloc]init];
        lObjAthleteLoggerViewControllerPtr.m_cObjAthleteDetailStructurePtr = [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr objectAtIndex:indexPath.row];
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadAthleteInformation:lObjAthleteLoggerViewControllerPtr.m_cObjAthleteDetailStructurePtr];
        
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading Athlete Detail from server"];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
        

        [self.navigationController pushViewController:lObjAthleteLoggerViewControllerPtr animated:YES];
        SAFE_RELEASE(lObjAthleteLoggerViewControllerPtr)
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    SAFE_RELEASE(m_cObjFavouriteSearchDisplayControllerPtr)
    SAFE_RELEASE(m_cObjFavouriteSearchBarPtr)
    SAFE_RELEASE(m_cObjFavouriteTablePtr)
    SAFE_RELEASE(m_cObjFavouriteFilteredListContent)
    [super dealloc];
}

@end
