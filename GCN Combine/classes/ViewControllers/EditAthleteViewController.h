//
//  EditAthleteViewController.h
//  GCN Combine
//
//  Created by Debi Samantrai on 20/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberKeypadDecimalPoint.h"
#import "ServerTransactionDelegate.h"
#import "Athlete.h"
#import "ImageHandlerDelegate.h"

@interface EditAthleteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NumberKeyPadDelegate,ServerTransactionDelegate,UIAlertViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ImageHandlerDelegate>
{
    UITableView                 *m_cObjUpperTableViewPtr;
    UITableView                 *m_cObjLowerTableViewPtr;
    UIImagePickerController     *m_cImagePickerControllerPtr;
    UIButton                    *m_cTakeImageButtonPtr;
    UIScrollView                *m_cObjScrollViewPtr;
    UIImage                     *m_cObjImagePtr;
//    NumberKeypadDecimalPoint    *m_cObjNumberKeypadDecimalPointPtr;
    CGRect                      m_cApplicationSize;
    BOOL                        IsFirstNameValidationSuccess;
    BOOL                        IsLastNameValidationSuccess;
    BOOL                        IsEmailValidationSuccess;
    UITextField                  *m_cObjActiveTextFieldPtr;
    Athlete                     *m_cObjAthleteDetailsDataPtr;
    NSURL                      *m_cObjURlPtr;
    NSString                    *m_cObjFolderPathPtr;
    UIPickerView                *m_cObjPickerViewPtr;
    UIToolbar                   *m_cObjPickerToolBarPtr;
    NSArray                     *m_cObjSportsListPtr;
    BOOL                        IsTextView;
    BOOL                       IsPhotoDeleted;
    UIToolbar                 *m_cObjToolBarPtr;
    NSString                    *m_cObjSportNamePtr;
    BOOL                        isIDexists;
    UISegmentedControl          *m_cObjSegementCtrlPtr;
    UIPickerView                *m_cObjDOBPickerPtr;
    NSMutableArray              *m_cObjDateArrayPtr;
    NSMutableArray              *m_cObjMonthArrayPtr;
    NSMutableArray              *m_cObjYearArrayPtr;
    NSString                    *m_cObjMonthPtr;
    NSString                    *m_cObjDayPtr;
    NSString                    *m_cObjYearPtr;
    BOOL                        ISReloadTable;
    NSString                    *m_cObjImageNamePathPtr;
    UIBarButtonItem             *lObjAddFavButton;
    BOOL                          isOfflineData;
    NSMutableArray              *m_cObjLogArrayPtr;
    NSString                    *m_cObjTempAthleteIdPtr;
    int                     m_cTotalNoOfRows;//sougat added this on 13/09/13
    UIPickerView                *m_cObjGenderPickerViewForeidtPtr;
    NSArray                  *m_cGenderArrayPtr;
   
   
}
@property (nonatomic,copy)NSString                    *m_cObjImageNamePathPtr;
@property (nonatomic,copy)NSString                    *m_cObjMonthPtr;
@property (nonatomic,copy)NSString                    *m_cObjDayPtr;
@property (nonatomic,copy)NSString                    *m_cObjYearPtr;
@property (nonatomic)    BOOL                        isIDexists;
@property (nonatomic,retain) Athlete   *m_cObjAthleteDetailsDataPtr;
@property (nonatomic,retain) NSURL         *m_cObjURlPtr;
@property (nonatomic,retain) NSString      *m_cObjFolderPathPtr;
@property (nonatomic,retain) UIPickerView  *m_cObjPickerViewPtr;
@property (nonatomic,retain) UIToolbar     *m_cObjPickerToolBarPtr;
@property (nonatomic,retain) NSArray       *m_cObjSportsListPtr;
@property (nonatomic,retain) UIImage        *m_cObjImagePtr;
@property (nonatomic,retain) UIImagePickerController   *m_cImagePickerControllerPtr;
@property (nonatomic,retain) NSString                    *m_cObjSportNamePtr;
@property (nonatomic,retain) UISegmentedControl          *m_cObjSegementCtrlPtr;
@property (nonatomic,retain) UIPickerView                *m_cObjDOBPickerPtr;
@property (nonatomic,retain) NSMutableArray              *m_cObjDateArrayPtr;
@property (nonatomic,retain) NSMutableArray              *m_cObjMonthArrayPtr;
@property (nonatomic,retain) NSMutableArray              *m_cObjYearArrayPtr;
@property (nonatomic,retain) UIBarButtonItem             *lObjAddFavButton;
@property (nonatomic)    BOOL                          isOfflineData;
@property (nonatomic,retain)    NSMutableArray              *m_cObjLogArrayPtr;
@property (nonatomic,copy)    NSString                    *m_cObjTempAthleteIdPtr;
 @property (nonatomic,retain) UIPickerView  *m_cObjGenderPickerViewForeidtPtr;
 @property (nonatomic,retain) NSArray       *m_cGenderArrayPtr;

-(void)saveIntoDocs;
-(void) createElements;
-(void) createImageControls;
-(void) validateFields : (UITextField *)pObjTextFieldPtr;
-(void)savePhoto:(NSString *)pObjPhotoUrlPtr;
-(void)onBackButtonPressed : (id)sender;
-(BOOL)validateEmail: (NSString *)pEmailText;
-(void)createPickerControls;
-(void)createTopToolBar;
-(void)setAthletePhototo;
-(NSArray *)getAnimatedPlaceHolderImages;
-(void)adjustScrollView;


@end
