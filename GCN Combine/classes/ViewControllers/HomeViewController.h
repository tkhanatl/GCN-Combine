//
//  HomeViewController.h
//  GCN Combine
//
//  Created by DP Samantrai on 28/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"
#import "HttpHandler.h"
#import "ImageHandlerDelegate.h"

@interface HomeViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,ServerTransactionDelegate,UIScrollViewDelegate,ImageHandlerDelegate,UIAlertViewDelegate>
{
    
    NSMutableArray              *m_cObjHomeCombineIdArrayPtr;
    NSMutableArray              *m_cObjfilteredListContent;
    NSMutableArray               *m_cObjsearchResults;
    NSMutableArray              *m_cObjCombineListPtr;
    NSMutableArray              *m_cObjAthleteLogArrayPtr;
    NSMutableArray              *m_cObjCombineIDsPtr;

    UITableView                 *m_cObjTablePtr;

    UIPickerView                *m_cObjPickerViewPtr;

    NSInteger                    savedScopeButtonIndex;
//    NSInteger                    m_cTestCount;
    NSInteger                    m_cObjHomeCombineIdPtr;

    NSString                    *m_cObjCombineNamePtr;
    NSString                    *savedSearchTerm;

    UIToolbar                   *m_cObjToolBarPtr;
    UIToolbar                   *m_cObjPickerToolBarPtr;
    UIToolbar                   *keyboardDoneButtonView;

    BOOL                        searchWasActive;
    BOOL                        m_cDownloadisForCombineIds;
    BOOL                        m_cDownloadisForCombineTests;
     BOOL                                 m_cIsSearch;
    
//    UISearchDisplayController   *m_cObjSearchDisplayControllerPtr;
    UISearchBar                 *m_cObjSearchBarPtr;
    
    UILabel                     *m_cObjAtheleteCountLabelPtr;
    UILabel                     *m_CobjCombineTitleLabelptr;
     UILabel                    *m_cObjNoDataLablePtr;
    
    Athlete                     *m_cObjAthleteDetailStructurePtr;
    NSMutableArray              *m_cObjHomeCombineListPtr;
    
}

@property (nonatomic,retain)NSMutableArray   *m_cObjHomeCombineListPtr;
@property (nonatomic,retain)NSMutableArray   *m_cObjHomeCombineIdArrayPtr;
@property (nonatomic,retain)NSMutableArray   *m_cObjfilteredListContent;
@property (nonatomic,retain)NSMutableArray   *m_cObjCombineListPtr;
@property (nonatomic,retain)NSMutableArray   *m_cObjCombineIDsPtr;
@property(nonatomic,retain)UILabel           *m_CobjCombineTitleLabelptr;


@property (nonatomic,retain)UITableView       *m_cObjTablePtr;

@property (nonatomic,retain)UIPickerView      *m_cObjPickerViewPtr;

@property (nonatomic,assign)NSInteger         m_cObjHomeCombineIdPtr;
//@property (nonatomic,assign)NSInteger         m_cTestCount;
@property (nonatomic)NSInteger                savedScopeButtonIndex;

@property (nonatomic,retain)UIToolbar         *m_cObjPickerToolBarPtr;
@property (nonatomic,retain)UIToolbar         *keyboardDoneButtonView;
@property (nonatomic,retain)UIToolbar         *m_cObjToolBarPtr;

@property (nonatomic,copy)NSString            *savedSearchTerm;
@property (nonatomic,copy)NSString            *m_cObjCombineNamePtr;

@property (nonatomic)BOOL                     m_cDownloadisForCombineIds;
@property (nonatomic)BOOL                     m_cDownloadisForCombineTests;
@property (nonatomic)BOOL                     searchWasActive;

@property (nonatomic,retain)UILabel           *m_cObjAtheleteCountLabelPtr;

@property (nonatomic,retain)Athlete           *m_cObjAthleteDetailStructurePtr;



-(void)createlablesForCount;
-(id)initWithTabBar;
-(void)createSearchDisplayController;
-(void)createElements;
//-(void)createRefreshButton;
+(void)refreshHomeScreen;
-(void)downloadCombineTests;

//- (void)showElemTypePicker;
//-(void)pickerDoneClicked:(id)sender;
-(void)choosecombine;
-(void)homeServerTransactionSucceeded;
//-(void)DismisAlertView:(UIAlertView *)alertView;

@end