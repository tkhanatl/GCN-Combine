//
//  AthleteLoggerViewController.h
//  GCN Combine
//
//  Created by Debi Samantrai on 03/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberKeypadDecimalPoint.h"
#import "Athlete.h"
#import "ServerTransactionDelegate.h"
#import "AthleteLog.h"
#import "ImageHandlerDelegate.h"

@interface AthleteLoggerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate,NumberKeyPadDelegate,UIAlertViewDelegate,ServerTransactionDelegate,ImageHandlerDelegate,UIPickerViewDelegate/*,UIPickerViewDataSource*/>
{
    UITableView               *m_cObjUpperEditTablePtr;
    UITableView               *m_cObjLowerEditTablePtr;
    UIToolbar                 *m_cObjToolBarPtr;
    UIScrollView              *m_cObjScrollViewPtr;
    UIImage                   *m_cObjImagePtr;
    UIButton                  *m_cObjImageBtnPtr;
    NumberKeypadDecimalPoint  *m_cObjNumberKeypadDecimalPointPtr;
    CGRect                     m_cApplicationSize;
    BOOL                        IsFirstNameValidationSuccess;
    BOOL                        IsLastNameValidationSuccess;
    UITextField                  *m_cObjActiveTextFieldPtr;
    Athlete                    *m_cObjAthleteDetailStructurePtr;
    NSString                    *m_cObjFolderPathPtr;
    BOOL                       IsPhotoDeleted;
    BOOL                       IsEmailValidationSuccess;
    AthleteLog              *m_cObjAthleteLogPtr;
    BOOL                     isIDexists;
    BOOL                        isForLog;
    NSOperationQueue        *m_cObjOperationQueuePtr;
    NSString                *m_cObjImageNamePathPtr;
    
    
    UIPickerView                *m_cObjPickerViewPtr;
    UIToolbar                   *m_cObjPickerToolBarPtr;
    NSMutableArray              *m_cObjCombineListPtr;
    
    
    UITextField             *m_cObjCombineIdTextFieldPtr;
    NSInteger               m_cTestCount;
    
    NSMutableArray          *m_cObjCombineIDsPtr;
    NSMutableArray          *m_cObjAthleteLogArrayPtr;
//    NSString                *m_cObjCombineIdPtr;
    NSInteger               m_cObjCombineIdPtr;
    UIToolbar               * keyboardDoneButtonView;
    NSString                *m_cObjCombineNamePtr;
    UIBarButtonItem         *lObjAddFavButton;
    BOOL                    isIdexists;
    BOOL                    isOfflineData;
    int                     m_cTotalNoOfRows;
   

}
@property (nonatomic)    BOOL                    isIdexists;
@property (nonatomic)    BOOL                    isOfflineData;
@property (nonatomic,copy)    NSString                *m_cObjCombineNamePtr;
//@property (nonatomic,copy)      NSString                *m_cObjCombineIdPtr;
@property (nonatomic,assign)      NSInteger               m_cObjCombineIdPtr;
@property (nonatomic,retain)    NSMutableArray          *m_cObjAthleteLogArrayPtr;
@property (nonatomic,retain)    NSMutableArray          *m_cObjCombineIDsPtr;
@property (nonatomic,assign)    NSInteger               m_cTestCount;
@property (nonatomic,retain)    UITextField         *m_cObjCombineIdTextFieldPtr;
@property (nonatomic,retain)    UIBarButtonItem     *lObjAddFavButton;


@property (nonatomic,retain)    UIPickerView                *m_cObjPickerViewPtr;
@property (nonatomic,retain)    UIToolbar                   *m_cObjPickerToolBarPtr;
@property (nonatomic,retain)    NSMutableArray              *m_cObjCombineListPtr;

@property (nonatomic,copy)    NSString                *m_cObjImageNamePathPtr;
@property (nonatomic)    BOOL                     isIDexists;
@property (nonatomic,retain) Athlete      *m_cObjAthleteDetailStructurePtr;
@property (nonatomic,retain)NSString       *m_cObjFolderPathPtr;
@property (nonatomic,retain)UIImage        *m_cObjImagePtr;
@property (nonatomic,retain)AthleteLog       *m_cObjAthleteLogPtr;
@property (nonatomic)    BOOL                        isForLog;
@property (nonatomic,retain)UIButton                  *m_cObjImageBtnPtr;
@property (nonatomic,retain)    UIToolbar               * keyboardDoneButtonView;

-(void)createElements;
-(void)createImageControls;
//-(void)createTopToolBar;
-(void)onBackButtonPressed : (id)sender;

-(void)setAthletePhototo;
-(void)setAthletePhoto;
-(NSArray *)getAnimatedPlaceHolderImages;
#if 0
-(void)callImageDownload;
#endif
-(void)doPhotoAnimation;

-(void)callImageDownload;


-(void)onAddOrRemoveFromFacButtonPressed :(id)sender;
-(void)getImageDatatoUpload;
-(void)adjustScrollView;

@end
