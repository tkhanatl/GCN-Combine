//
//  SettingsScreenViewController.h
//  GCN Combine
//
//  Created by DP Samant on 18/07/13.
//  Copyright (c) 2013 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageHandlerDelegate.h"
#import "ServerTransactionDelegate.h"
#import "Athlete.h"
#import "AthleteLog.h"



@interface SettingsScreenViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ServerTransactionDelegate,ImageHandlerDelegate>

{
    UIActionSheet      *m_cObjActionSheetPtr;
    BOOL               isUploadtoServer;
    NSMutableArray     *m_cObjLogArrayPtr;
    NSMutableArray     *m_cObjAthleteImagesListPtr;
    NSMutableArray     *m_cObjAtthleteListPtr;
    Athlete            *m_cObjAthletePtr;
    NSInteger          requestisFor;
    AthleteLog         *m_cObjAthleteLogPtr;
    NSMutableArray     *m_cObjSupportingServersPtr;
    UIPickerView       *m_cObjPickerViewPtr;
    UIPickerView       *m_cObjCombinePickerViewPtr;
    UIToolbar          *m_cObjkeyboardDoneButtonViewPtr;
    UIToolbar          *m_cObjToolBarPtr;
    BOOL               IsPickerDispaly;
    UILabel            *m_cObjPickerSelectionLablePtr;
    NSMutableArray     *m_cObjCombineIdArrayPtr;
    NSMutableArray     *m_cObjCombineListPtr;
    NSMutableArray     *m_cObjCombineIDsPtr;
    NSMutableArray     *m_cObjAthleteLogArrayPtr;
    NSInteger          m_cObjCombineIdPtr;
    NSString           *m_cObjCombineNamePtr;
    NSInteger          m_cTestCount;
    NSInteger          m_cObjPickerSelectionRowOtr;
    
    int                m_cRowValue;

    BOOL                 m_cIsAthletDataUpload;
    BOOL                 m_cIsLogDataUpload;
     NSString             *m_cObjServerSelectiontextptr;
    NSString              *m_CobjCombineSelectionTextPtr;//sougata added on 7/8/13
    int                 m_cUploadCount;
    int                 m_cUploadLogCount;
    BOOL                m_cIsForDeleteLocalInformation;//sougata added this on 14 aug.
     BOOL               isCombineDownloadFailedServer;
    NSString           *m_cObjAnotherCombineNameString;
    int                 m_cPreviusCombineId;
    int                 m_cObjUpdateRowValue;
}
@property (nonatomic,copy)NSString         *m_cObjServerSelectiontextptr;
@property (nonatomic,copy)NSString              *m_CobjCombineSelectionTextPtr;//sougata added on 7/8/13
@property(nonatomic,retain)UITableView      *m_cObjSettingsTableViewPtr;
@property (nonatomic)BOOL                   isUploadtoServer;
@property (nonatomic,retain)UIActionSheet   *m_cObjActionSheetPtr;
@property (nonatomic,copy)NSMutableArray    *m_cObjLogArrayPtr;
@property (nonatomic,retain)NSMutableArray  *m_cObjAthleteImagesListPtr;
@property (nonatomic,copy)NSMutableArray    *m_cObjAtthleteListPtr;
@property (nonatomic,copy)Athlete           *m_cObjAthletePtr;
@property (nonatomic,assign)NSInteger       requestisFor;
@property (nonatomic,copy)AthleteLog        *m_cObjAthleteLogPtr;
@property (nonatomic,retain)UIToolbar       *m_cObjToolBarPtr;
@property (nonatomic)  BOOL                 IsPickerDispaly;
@property (nonatomic,retain)UILabel         *m_cObjPickerSelectionLablePtr;
@property (nonatomic,retain) NSMutableArray  *m_cObjCombineIdArrayPtr;
@property (nonatomic,retain)NSMutableArray   *m_cObjCombineListPtr;
@property (nonatomic,retain)NSMutableArray   *m_cObjCombineIDsPtr;
@property (nonatomic,assign)NSInteger         m_cObjCombineIdPtr;
@property (nonatomic,copy)  NSString         *m_cObjCombineNamePtr;
@property (nonatomic,assign)NSInteger         m_cTestCount;
@property (nonatomic,retain)UIToolbar        *keyboardDoneButtonView;
@property (nonatomic)  BOOL                m_cIsForDeleteLocalInformation;
@property (nonatomic)  BOOL                isCombineDownloadFailedServer;
@property(nonatomic,copy) NSString           *m_cObjAnotherCombineNameString;

-(id)initWithTabBar;
-(void)CreateControl;
-(void)uploadScandata;
-(void)uploadAthleteData;
-(void)uploadLogData;
- (void)createServerSelectionPicker;
- (NSString *)languageDisplayNameForCode:(NSString*)pLangCode;
- (NSString *)ServerCodeForDisplayName:(NSString*)pLangDisName;
- (BOOL)showElemTypePicker;
-(void)downloadCombineTests;
-(void)onCancelButtonClicked;
-(void)combinenameChange;

@end
