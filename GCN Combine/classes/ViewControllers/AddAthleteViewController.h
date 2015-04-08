//
//  AddAthleteViewController.h
//  GCN Combine
//
//  Created by Debi Samantrai on 30/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberKeypadDecimalPoint.h"
#import "Athlete.h"
#import "ServerTransactionDelegate.h"

@interface AddAthleteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ServerTransactionDelegate,UIAlertViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITableView                 *m_cObjUpperTableViewPtr;
    UITableView                 *m_cObjLowerTableViewPtr;
    UIImagePickerController     *m_cImagePickerControllerPtr;
    UIButton                    *m_cTakeImageButtonPtr;
    UIScrollView                *m_cObjScrollViewPtr;
    UIImage                     *m_cObjImagePtr;
    CGRect                      m_cApplicationSize;
    BOOL                        IsFirstNameValidationSuccess;
    BOOL                        IsLastNameValidationSuccess;
    BOOL                        IsEmailValidationSuccess;
    UITextField                  *m_cObjActiveTextFieldPtr;
    Athlete                     *m_cObjAthleteDetailsPtr;
    NSURL                      *m_cObjURlPtr;
    NSString                    *m_cObjFolderPathPtr;
    UIPickerView                *m_cObjPickerViewPtr;
    UIToolbar                   *m_cObjPickerToolBarPtr;
    NSArray                     *m_cObjSportsListPtr;
    BOOL                        IsTextView;
    NSString                    *m_cObjSportNamePtr;
    UISegmentedControl          *m_cObjSegementCtrlPtr;
    UIPickerView                *m_cObjDOBPickerPtr;
    UIPickerView                *m_cObjGenderPickerViewPtr;
    NSMutableArray              *m_cObjDateArrayPtr;
    NSMutableArray              *m_cObjMonthArrayPtr;
    NSMutableArray              *m_cObjYearArrayPtr;
    NSString                    *m_cObjMonthPtr;
    NSString                    *m_cObjDayPtr;
    NSString                    *m_cObjYearPtr;
     int                     m_cTotalNoOfRows;//sougat added this on 13/09/13
    NSArray                  *m_cGenderArrayPtr;
}

@property (nonatomic,copy)NSString                    *m_cObjMonthPtr;
@property (nonatomic,copy)NSString                    *m_cObjDayPtr;
@property (nonatomic,copy)NSString                    *m_cObjYearPtr;
@property (nonatomic,retain) Athlete   *m_cObjAthleteDetailsPtr;
@property (nonatomic,retain) NSURL         *m_cObjURlPtr;
@property (nonatomic,retain) NSString      *m_cObjFolderPathPtr;
@property (nonatomic,retain) UIPickerView  *m_cObjPickerViewPtr;
@property (nonatomic,retain) UIPickerView  *m_cObjGenderPickerViewPtr;
@property (nonatomic,retain) UIToolbar     *m_cObjPickerToolBarPtr;
@property (nonatomic,retain) NSArray       *m_cObjSportsListPtr;
@property (nonatomic,retain) NSArray       *m_cGenderArrayPtr;
@property (nonatomic,retain) NSString      *m_cObjSportNamePtr;
@property (nonatomic,retain) UISegmentedControl          *m_cObjSegementCtrlPtr;
@property (nonatomic,retain) UIPickerView                *m_cObjDOBPickerPtr;
@property (nonatomic,retain) NSMutableArray              *m_cObjDateArrayPtr;
@property (nonatomic,retain) NSMutableArray              *m_cObjMonthArrayPtr;
@property (nonatomic,retain) NSMutableArray              *m_cObjYearArrayPtr;


-(void)saveIntoDocs;
-(void) createElements;
-(void) createImageControls;
-(void) validateFields : (UITextField *)pObjTextFieldPtr;
-(void)savePhoto:(NSString *)pObjPhotoUrlPtr;
-(void)onBackButtonPressed : (id)sender;
-(BOOL)validateEmail: (NSString *)pEmailText;
-(void)createPickerControls;
-(void)adjustScrollView;

@end


