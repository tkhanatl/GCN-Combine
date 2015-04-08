//
//  EditAthleteViewController.m
//  GCN Combine
//
//  Created by Debi Samantrai on 20/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "EditAthleteViewController.h"
#import "Macros.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "AddAthleteTableViewCell.h"
#import "AddAthleteDetailsTableViewCell.h"

@implementation EditAthleteViewController
@synthesize m_cObjAthleteDetailsDataPtr;
@synthesize m_cObjURlPtr;
@synthesize m_cObjFolderPathPtr,m_cObjPickerViewPtr,m_cObjPickerToolBarPtr,m_cObjSportsListPtr,m_cObjImagePtr,m_cImagePickerControllerPtr,m_cObjSportNamePtr;
@synthesize isIDexists,m_cObjSegementCtrlPtr,m_cObjDateArrayPtr,m_cObjDOBPickerPtr,m_cObjYearArrayPtr,m_cObjMonthArrayPtr;
@synthesize m_cObjMonthPtr,m_cObjDayPtr,m_cObjYearPtr,m_cObjImageNamePathPtr,lObjAddFavButton,isOfflineData,m_cObjLogArrayPtr,m_cObjTempAthleteIdPtr,m_cObjGenderPickerViewForeidtPtr,m_cGenderArrayPtr;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        m_cTotalNoOfRows=0;
        self.navigationItem.title = @"Edit Athlete";
        self.hidesBottomBarWhenPushed =YES;
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"LoginBackGround", @"")]];
      m_cImagePickerControllerPtr = (UIImagePickerController *)nil;
        IsFirstNameValidationSuccess = YES;
        IsLastNameValidationSuccess = YES;
        IsEmailValidationSuccess = YES;
        m_cObjActiveTextFieldPtr = (UITextField *)nil;
        IsTextView = NO;
        m_cObjToolBarPtr = (UIToolbar *)nil;
        m_cObjDayPtr = (NSString *)nil;
        m_cObjMonthPtr = (NSString *)nil;
        m_cObjYearPtr = (NSString *)nil;
        ISReloadTable = YES;
        isOfflineData = NO;
       // gObjAppDelegatePtr.IsUpdateForEthlete=NO;
     }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    m_cApplicationSize = self.view.frame;
    CGRect              lScrollRect = CGRectZero;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        lScrollRect = CGRectMake(CGRectGetMinY(self.view.bounds), 64, CGRectGetWidth(self.view.bounds),self.view.frame.size.height-64);
    }
    else
    {
        lScrollRect = CGRectMake(CGRectGetMinY(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));

    }
        m_cObjScrollViewPtr = [[UIScrollView alloc]initWithFrame:lScrollRect];
    m_cObjScrollViewPtr.scrollEnabled = YES;
    m_cObjScrollViewPtr.delegate = self;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
         m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 1930);
    }
    else
    {
         m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 1750);
    }
   
    [m_cObjScrollViewPtr setAutoresizingMask:UIViewAutoresizingFlexibleHeight];    
    m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0, 0.0);
    [self.view addSubview:m_cObjScrollViewPtr];
    
    Athlete *lObjAthleteDetailsPtr = [[Athlete alloc]init];
    self.m_cObjAthleteDetailsDataPtr = lObjAthleteDetailsPtr;
    SAFE_RELEASE(lObjAthleteDetailsPtr)

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createImageControls];
    [self createElements];
    [self createPickerControls];
}
-(void)createElements
{
    UIBarButtonItem		*lObjSaveButtonPtr = (UIBarButtonItem *)nil;
    UIBarButtonItem     *lObjBackBtnPtr = (UIBarButtonItem *)nil;
	CGRect				lObjRect = CGRectZero;
    CGRect              lRect = CGRectZero;
    
    
	// create a Back button with custom title
	lObjSaveButtonPtr = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSaveButtonPressed:) ]; 
	self.navigationItem.rightBarButtonItem = lObjSaveButtonPtr;
    SAFE_RELEASE(lObjSaveButtonPtr)
    
    
    lObjBackBtnPtr = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onBackButtonPressed:)];
    self.navigationItem.leftBarButtonItem = lObjBackBtnPtr;
    SAFE_RELEASE(lObjBackBtnPtr)
   if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
         lObjRect = CGRectMake(CGRectGetMaxX(m_cTakeImageButtonPtr.frame)+2, -80,CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(m_cTakeImageButtonPtr.frame)-5, 165);
    }
    else
    {
         lObjRect = CGRectMake(CGRectGetMaxX(m_cTakeImageButtonPtr.frame)+2, CGRectGetMinY(m_cTakeImageButtonPtr.frame) - 10,CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(m_cTakeImageButtonPtr.frame)-5, 160);
    
    }
    
   
    m_cObjUpperTableViewPtr = [[UITableView alloc] initWithFrame:lObjRect style:UITableViewStyleGrouped];	
	m_cObjUpperTableViewPtr.backgroundColor = [UIColor clearColor];
    m_cObjUpperTableViewPtr.backgroundView = nil;
	m_cObjUpperTableViewPtr.delegate = self;
	m_cObjUpperTableViewPtr.dataSource = self;
	m_cObjUpperTableViewPtr.autoresizesSubviews = YES;
	m_cObjUpperTableViewPtr.scrollEnabled = NO;
	m_cObjUpperTableViewPtr.allowsSelectionDuringEditing = YES;
    m_cObjUpperTableViewPtr.alpha = 1.0;
    m_cObjUpperTableViewPtr.tag = ADDATHLETEUPPERTABLE;
    [m_cObjScrollViewPtr addSubview:m_cObjUpperTableViewPtr];
    
    

    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        lRect = CGRectMake(10.0, CGRectGetMaxY(m_cObjUpperTableViewPtr.frame)+5, 310.0, 1800);
         //m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, );
    }
    else
    {
        lRect = CGRectMake(10.0, 170.0, 310.0, 1640.0);
    }
    

    m_cObjLowerTableViewPtr = [[UITableView alloc] initWithFrame:lRect style:UITableViewStyleGrouped];
	m_cObjLowerTableViewPtr.backgroundColor = [UIColor clearColor];
    m_cObjLowerTableViewPtr.backgroundView = nil;
	m_cObjLowerTableViewPtr.delegate = self;
	m_cObjLowerTableViewPtr.dataSource = self;
	m_cObjLowerTableViewPtr.autoresizesSubviews = YES;
	m_cObjLowerTableViewPtr.scrollEnabled = NO;
	m_cObjLowerTableViewPtr.allowsSelectionDuringEditing = YES;
    m_cObjLowerTableViewPtr.alpha = 1.0;
    m_cObjLowerTableViewPtr.tag = ADDATHLETELOWERTABLE;
    [m_cObjScrollViewPtr addSubview:m_cObjLowerTableViewPtr];
    
}

-(void)createImageControls
{
    m_cTakeImageButtonPtr = [UIButton buttonWithType:UIButtonTypeCustom];
	m_cTakeImageButtonPtr.backgroundColor = [UIColor clearColor];
    m_cTakeImageButtonPtr.layer.cornerRadius = 4.0;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
         m_cTakeImageButtonPtr.frame = CGRectMake(10, -45, 80, 80);
    }
    else
    {
         m_cTakeImageButtonPtr.frame = CGRectMake(10.0, 30,90, 91);
    }
   
    if (YES == gObjAppDelegatePtr.isImageFileDownloading) {
        m_cTakeImageButtonPtr.userInteractionEnabled = NO;
    }
    [m_cTakeImageButtonPtr addTarget:self action:@selector(onPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [m_cObjScrollViewPtr addSubview:m_cTakeImageButtonPtr];
    
}

-(void)createPickerControls
{
    UIPickerView        *lObjTempPickerPtr = (UIPickerView *)nil;
    UIBarButtonItem     *lObjDoneBtnPtr = (UIBarButtonItem *)nil;
    UIBarButtonItem     *lObjFlexBtnPtr = (UIBarButtonItem *)nil;
    UIBarButtonItem     *lObjSegBtnPtr = (UIBarButtonItem *)nil;
    
    lObjTempPickerPtr = [[UIPickerView alloc] init];
    self.m_cObjPickerViewPtr = lObjTempPickerPtr;
    SAFE_RELEASE(lObjTempPickerPtr)
    [self.m_cObjPickerViewPtr sizeToFit];
    self.m_cObjPickerViewPtr.delegate = self;
    self.m_cObjPickerViewPtr.dataSource = self;
    self.m_cObjPickerViewPtr.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.m_cObjPickerViewPtr.showsSelectionIndicator = YES;
    self.m_cObjPickerViewPtr.tag = ATHLETEADDPICKERTAG;
    [self.m_cObjPickerViewPtr selectRow:0 inComponent:0 animated:YES];
    
    m_cObjPickerToolBarPtr = [[UIToolbar alloc] init];
    m_cObjPickerToolBarPtr.barStyle = UIBarStyleBlack;
    m_cObjPickerToolBarPtr.translucent = YES;
    m_cObjPickerToolBarPtr.tintColor = nil;
    [m_cObjPickerToolBarPtr sizeToFit];
    
    m_cObjSegementCtrlPtr = [[UISegmentedControl alloc]initWithItems:
                             [NSArray arrayWithObjects:@"Previous",@"Next", nil]];
    m_cObjSegementCtrlPtr.segmentedControlStyle = UISegmentedControlStyleBar;
    m_cObjSegementCtrlPtr.selectedSegmentIndex = -1;
    m_cObjSegementCtrlPtr.momentary = YES;
    [m_cObjSegementCtrlPtr addTarget:self action:@selector(onSegmentBtnClicked:) forControlEvents:UIControlEventValueChanged];
    
    lObjSegBtnPtr = [[UIBarButtonItem alloc]initWithCustomView:m_cObjSegementCtrlPtr];
    
    lObjDoneBtnPtr = [[UIBarButtonItem alloc] initWithTitle:
                      @"Done"style:UIBarButtonItemStyleBordered target:self                                                      action:@selector(onPickerDoneBtnClicked:)];
    
    lObjFlexBtnPtr = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:  
                      UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [m_cObjPickerToolBarPtr setItems:[NSArray arrayWithObjects:lObjSegBtnPtr,lObjFlexBtnPtr,lObjDoneBtnPtr, nil]];
    SAFE_RELEASE(lObjDoneBtnPtr)
    SAFE_RELEASE(lObjFlexBtnPtr)
    SAFE_RELEASE(lObjSegBtnPtr)
    
    lObjTempPickerPtr = [[UIPickerView alloc]init];
    self.m_cObjDOBPickerPtr = lObjTempPickerPtr;
    SAFE_RELEASE(lObjTempPickerPtr)
    
    [self.m_cObjDOBPickerPtr sizeToFit];
    self.m_cObjDOBPickerPtr.delegate = self;
    self.m_cObjDOBPickerPtr.dataSource = self;
    self.m_cObjDOBPickerPtr.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.m_cObjDOBPickerPtr.showsSelectionIndicator = YES;
    self.m_cObjDOBPickerPtr.tag = ATHLETEADDDOBPICKERTAG;
    
    lObjTempPickerPtr = [[UIPickerView alloc]init];
    self.m_cObjGenderPickerViewForeidtPtr = lObjTempPickerPtr;
    SAFE_RELEASE(lObjTempPickerPtr)
    
    [self.m_cObjGenderPickerViewForeidtPtr sizeToFit];
    self.m_cObjGenderPickerViewForeidtPtr.delegate = self;
    self.m_cObjGenderPickerViewForeidtPtr.dataSource = self;
    self.m_cObjGenderPickerViewForeidtPtr.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.m_cObjGenderPickerViewForeidtPtr.showsSelectionIndicator = YES;
    self.m_cObjGenderPickerViewForeidtPtr.tag = ATHLETE_GENDER_PICKER_FOREDT;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self createTopToolBar];
    //Register For Keyboard Notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:m_cObjActiveTextFieldPtr];

    
    NSArray *athleteIdsPtr = gObjAppDelegatePtr.m_cObjDictionaryPtr.allKeys;
    if (athleteIdsPtr.count > 0) {
    for (int i=0; i<athleteIdsPtr.count; i++) {
        if ([m_cObjAthleteDetailsDataPtr.m_cAthleteId isEqualToString:[athleteIdsPtr objectAtIndex:i]]) {
            isIDexists = YES;
            self.m_cObjImageNamePathPtr = [gObjAppDelegatePtr.m_cObjDictionaryPtr objectForKey:[athleteIdsPtr objectAtIndex:i]];
        }
      }
    }
    
    [self setAthletePhototo];
    
    if(ISReloadTable == YES)
    {
    [m_cObjUpperTableViewPtr reloadData];
    [m_cObjLowerTableViewPtr reloadData];
        [self adjustScrollView];
    }
}

-(void)setAthletePhototo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = NO;
    NSString *lObjPhotoFolderPtr = (NSString *)nil;
    
    
    if (YES == isIDexists) {
        lObjPhotoFolderPtr = self.m_cObjImageNamePathPtr;
        fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
    }
    else{
    
        if ((NSString *)nil != self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr isEqualToString:@" "]){
          lObjPhotoFolderPtr = [gObjAppDelegatePtr getPhotoFolders :self.m_cObjAthleteDetailsDataPtr.m_cAthleteId AthImageName:self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr];
         // NSString *lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",self.m_cObjAthleteDetailsDataPtr.m_cAthleteId]];
            fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
            
            if (NO == fileExists && (NSString *)nil != self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                lObjPhotoFolderPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr];
                //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
            }
        }
    }
    if (NO == fileExists && (NSString *)nil != self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr isEqualToString:@" "]) {
        lObjPhotoFolderPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr];
        //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
        fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
    }
    if (YES == fileExists) {
        
        NSData *lObjImageDataPtr = [NSData dataWithContentsOfFile:lObjPhotoFolderPtr];
        self.m_cObjImagePtr = [UIImage imageWithData:lObjImageDataPtr];
        [m_cTakeImageButtonPtr setImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
    }
    else
    {
        m_cObjImagePtr = (UIImage *)nil;
        [m_cTakeImageButtonPtr setImage:[UIImage imageNamed:@"AddPhoto.png"] forState:UIControlStateNormal];
    }
    
    
    
    IsPhotoDeleted = NO;
}
-(NSArray *)getAnimatedPlaceHolderImages
{
    NSArray *lImages = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"loadingSpinner1.png"],
                        [UIImage imageNamed:@"loadingSpinner2.png"],
                        [UIImage imageNamed:@"loadingSpinner3.png"],
                        [UIImage imageNamed:@"loadingSpinner4.png"],
                        [UIImage imageNamed:@"loadingSpinner5.png"],
                        [UIImage imageNamed:@"loadingSpinner6.png"],
                        [UIImage imageNamed:@"loadingSpinner7.png"],
                        [UIImage imageNamed:@"loadingSpinner8.png"],
                        [UIImage imageNamed:@"loadingSpinner9.png"],
                        [UIImage imageNamed:@"loadingSpinner10.png"],
                        [UIImage imageNamed:@"loadingSpinner11.png"],
                        [UIImage imageNamed:@"loadingSpinner12.png"],
                        nil];
    return lImages;
}
-(void)photoDownloadSucceed
{
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    m_cTakeImageButtonPtr.userInteractionEnabled = YES;
    [self performSelector:@selector(setAthletePhoto) withObject:self afterDelay:1.0];
}
-(void)photoDownloadFailed
{
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    m_cTakeImageButtonPtr.userInteractionEnabled = YES;
}
-(void)InformPhotoDownloadSucceed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    gObjAppDelegatePtr.isForImageDownload = NO;
    
}
-(void)InformPhotoDownloadFailed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    gObjAppDelegatePtr.isForImageDownload = NO;
    gObjAppDelegatePtr.isImageFileDownloading = NO;
}
- (void)handleAthletDetailDownloadSucceed
{
    self.m_cObjAthleteDetailsDataPtr = gObjAppDelegatePtr.m_cObjAthleteDataStructurePtr;
}
-(void)handleAthletDetailDownloadFailed
{
    UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
    lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Athlete Detail is Empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [lObjAlertViewPtr show];
    SAFE_RELEASE(lObjAlertViewPtr)
}
-(void)setAthletePhoto
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *lObjPhotoFolderPtr = [gObjAppDelegatePtr getPhotoFolders:self.m_cObjAthleteDetailsDataPtr.m_cAthleteId AthImageName:self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr];
//    NSString *lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailsDataPtr.m_cAthleteId]];
    
    BOOL fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
    
    if (YES == fileExists) {
        NSData *lObjImageDataPtr = [NSData dataWithContentsOfFile:lObjPhotoFolderPtr];
        self.m_cObjImagePtr = [UIImage imageWithData:lObjImageDataPtr];
        [m_cTakeImageButtonPtr.imageView stopAnimating];
        [m_cTakeImageButtonPtr setImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
    }
    else
    {
        m_cObjImagePtr = (UIImage *)nil;
        [m_cTakeImageButtonPtr.imageView stopAnimating];
        [m_cTakeImageButtonPtr setImage:[UIImage imageNamed:@"AddPhoto.png"] forState:UIControlStateNormal];
    }
    IsPhotoDeleted = NO;
}
-(void)onPhotoButtonPressed : (id)sender
{
    ISReloadTable = NO;
    if(/*m_cObjActiveTextFieldPtr.tag == ATHLETEAGETAG ||*/ m_cObjActiveTextFieldPtr.tag == ATHLETEPHONETAG || m_cObjActiveTextFieldPtr.tag == ATHLETECELLPHONETAG || m_cObjActiveTextFieldPtr.tag == ATHLETEZIPTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEHEIGHTTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEWEIGHTTAG || m_cObjActiveTextFieldPtr.tag == ATHLETESHOESIZETAG)
    {
        [m_cObjActiveTextFieldPtr resignFirstResponder];
    }    
    if(nil != m_cObjImagePtr)
    {
        UIActionSheet *lObjActionSheetPtr = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo",@"Delete Photo", nil];
        lObjActionSheetPtr.tag = 10;
        
        [lObjActionSheetPtr showFromTabBar:gObjAppDelegatePtr.m_cObjTabBarControllerPtr.tabBar ];
        SAFE_RELEASE(lObjActionSheetPtr)
    }
    else
    {
        UIActionSheet *lObjActionSheetPtr = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo", nil];
        lObjActionSheetPtr.tag = 10;
        
        [lObjActionSheetPtr showFromTabBar:gObjAppDelegatePtr.m_cObjTabBarControllerPtr.tabBar];
        SAFE_RELEASE(lObjActionSheetPtr)
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if((UIImagePickerController *)nil == m_cImagePickerControllerPtr)
    {
        UIImagePickerController *lObjImgPkrCntrlr = [[UIImagePickerController alloc] init];
        self.m_cImagePickerControllerPtr = lObjImgPkrCntrlr;
        SAFE_RELEASE(lObjImgPkrCntrlr)
        self.m_cImagePickerControllerPtr.delegate = self;
        self.m_cImagePickerControllerPtr.allowsEditing = YES;
    }
    
    if(actionSheet.tag == 10)
    {
        switch(buttonIndex) {
            case 0:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    IsPhotoDeleted = NO;
                    m_cImagePickerControllerPtr.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentModalViewController:m_cImagePickerControllerPtr animated:YES];
                }
                break;
            case 1:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    IsPhotoDeleted = NO;
                    m_cImagePickerControllerPtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentModalViewController:m_cImagePickerControllerPtr animated:YES];
                }
                break;
            case 2:
                if(nil != m_cObjImagePtr)
                {
                    UIActionSheet *lObjActionSheetPtr = (UIActionSheet *)nil;
                    lObjActionSheetPtr = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:nil, nil];
                    IsPhotoDeleted = NO;
                    lObjActionSheetPtr.tag = 11;
                    [lObjActionSheetPtr showFromTabBar:gObjAppDelegatePtr.m_cObjTabBarControllerPtr.tabBar];
                    SAFE_RELEASE(lObjActionSheetPtr)
                }
                break;
            default:
                break;
        }
    }
    else if(actionSheet.tag == 11)
    {
        if(buttonIndex == 0)
        {
            [m_cTakeImageButtonPtr setImage:nil forState:UIControlStateNormal];
            IsPhotoDeleted = YES;
            [m_cTakeImageButtonPtr setBackgroundImage:nil forState:UIControlStateNormal];
            m_cObjImagePtr = (UIImage *) nil;
            [m_cTakeImageButtonPtr setImage:[UIImage imageNamed:@"AddPhoto.png"] forState:UIControlStateNormal];
        }
    }
}
-(void)deletePhoto
{
    NSString *imageNamePtr = [gObjAppDelegatePtr getPhotoFolders:self.m_cObjAthleteDetailsDataPtr.m_cAthleteId AthImageName:self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr];
    
//    NSString *lObjImageNamePtr = [imageNamePtr stringByAppendingPathComponent:[NSString stringWithFormat: @"/Athlete-%@.png",self.m_cObjAthleteDetailsDataPtr.m_cAthleteId ]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL fileExists = [fileManager fileExistsAtPath:imageNamePtr];
    
    if (fileExists)
    {
        BOOL success = [fileManager removeItemAtPath:imageNamePtr error:&error];
        success = [fileManager removeItemAtPath:imageNamePtr error:&error];

        if (!success)
            DSLog(@"Error: %@", [error localizedDescription]);
    }
    gObjAppDelegatePtr.m_cObjImageDatePtr = (NSData *)nil;
    self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr = @"";
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *lObjImage = [info objectForKey:UIImagePickerControllerEditedImage];
    IsPhotoDeleted = NO;
    m_cTakeImageButtonPtr.imageView.frame =CGRectMake(m_cTakeImageButtonPtr.bounds.origin.x+5, m_cTakeImageButtonPtr.bounds.origin.y+5, m_cTakeImageButtonPtr.frame.size.width-10, m_cTakeImageButtonPtr.frame.size.height-30); 
    [m_cTakeImageButtonPtr setImage:lObjImage forState:UIControlStateNormal]; 
    m_cTakeImageButtonPtr.imageView.clipsToBounds = YES;
    m_cTakeImageButtonPtr.imageView.layer.cornerRadius = 4.0;
    m_cTakeImageButtonPtr.imageView.layer.borderWidth = 2.0;
    m_cTakeImageButtonPtr.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    [m_cTakeImageButtonPtr setTintColor:[UIColor clearColor]];
    
    [self dismissModalViewControllerAnimated:YES];
    self.m_cObjImagePtr = lObjImage;
    gObjAppDelegatePtr.m_cObjImageDatePtr = UIImagePNGRepresentation(m_cObjImagePtr);
//    gObjAppDelegatePtr.m_cObjImageDatePtr = UIImageJPEGRepresentation(m_cObjImagePtr, 0.0);
    
    [m_cTakeImageButtonPtr setImage:m_cObjImagePtr forState:UIControlStateNormal];
    [m_cTakeImageButtonPtr setBackgroundImage:m_cObjImagePtr forState:UIControlStateNormal];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    IsPhotoDeleted = NO;
    [self dismissModalViewControllerAnimated:YES];
}

-(void)saveIntoDocs
{
    m_cObjFolderPathPtr =  [gObjAppDelegatePtr createPhotoFolders:m_cObjAthleteDetailsDataPtr.m_cAthleteId];
    if ((UIImage *)nil != m_cObjImagePtr) 
    {
        [self savePhoto:m_cObjFolderPathPtr];
    }
}


#pragma mark - Video File Saving Delegate Methods
- (void)savePhoto:(NSString *)pObjPhotoUrlPtr
{
        
        NSString *imagePath = [m_cObjFolderPathPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.m_cObjAthleteDetailsDataPtr.m_cAthleteId]];
        gObjAppDelegatePtr.m_cObjphotonamePtr = imagePath;
        
        
        if ((NSString *)nil != gObjAppDelegatePtr.m_cObjphotonamePtr) {
            self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr =[gObjAppDelegatePtr.m_cObjphotonamePtr lastPathComponent];
        }
        else if( YES == [[gObjAppDelegatePtr.m_cObjphotonamePtr lastPathComponent] isEqualToString:@"Athlete--1.jpg"] )
        {
            self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr = @"";
        }
        
        
        //extracting image from the picker and saving it
        NSData *webData = UIImagePNGRepresentation(m_cObjImagePtr);
//        NSData *webData = UIImageJPEGRepresentation(m_cObjImagePtr, 0.0);
        [webData writeToFile:imagePath atomically:YES];
        

}
-(void)adjustScrollView
{
   // m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0,((m_cTotalNoOfRows+4) * 52)+35);
    m_cTotalNoOfRows = 0;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = nil;
   // m_cObjNumberKeypadDecimalPointPtr = (NumberKeypadDecimalPoint *)nil;
}

-(void)serverTransactionSucceeded
{
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    m_cTakeImageButtonPtr.userInteractionEnabled = YES;
    [gObjAppDelegatePtr stopProgressHandler];
    NSString    *lObjMsgString = (NSString *)nil;
    if([gObjAppDelegatePtr isNetworkAvailable])
    {
        lObjMsgString = @"The Athlete has been successfully updated";
    }
    else
    {
       // gObjAppDelegatePtr.IsUpdateForEthlete=YES;
        lObjMsgString = @"Data stored for sync";
    }

    
    if (YES ==isOfflineData && (NSData *)nil != gObjAppDelegatePtr.m_cObjImageDatePtr) {
        
        self.m_cObjAthleteDetailsDataPtr.m_cAthleteId = gObjAppDelegatePtr.m_cAthleteId;
      
        m_cObjLogArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAthleteLogsAddedinOfflineModeforAthlete:gObjAppDelegatePtr.m_cObjTempAthleteIdPtr] retain];
        if (m_cObjLogArrayPtr.count) {
            isOfflineData = YES;
            [gObjAppDelegatePtr.m_cDbHandler updateLogTableAthleteID :self.m_cObjAthleteDetailsDataPtr AthId:gObjAppDelegatePtr.m_cObjTempAthleteIdPtr];
        }
        if(YES == gObjAppDelegatePtr.isNetworkAvailable)
            [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadImage:self.m_cObjAthleteDetailsDataPtr];
        }

    if ((UIImage *)nil != m_cObjImagePtr)
    {
        [self saveIntoDocs];
    }
    UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
    lObjAlertViewPtr = [[UIAlertView alloc]
                        initWithTitle:@"Athlete Logger"
                        message:lObjMsgString
                        delegate:self
                        cancelButtonTitle:@"Ok"
                        otherButtonTitles:nil,
                        nil];
    [lObjAlertViewPtr show];
    lObjAlertViewPtr.tag = 400;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    SAFE_RELEASE(lObjAlertViewPtr)
    
}
-(void)serverTransactionFailed
{
    if(YES == gObjAppDelegatePtr.isConnectionTimeout)
    {
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cIsAddedinOfflineMode = YES;
        self.m_cObjAthleteDetailsDataPtr.m_cIsAddedinOfflineMode = YES;
        [gObjAppDelegatePtr.m_cDbHandler updateNewAthlete:self.m_cObjAthleteDetailsDataPtr];
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr =self;
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
    }
    else{
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        gObjAppDelegatePtr.isImageFileDownloading = NO;
        m_cTakeImageButtonPtr.userInteractionEnabled = YES;
        UIAlertView *lObjAlertViewPtr;
        lObjAlertViewPtr = [[UIAlertView alloc]
                            initWithTitle:@"Athlete Logger"
                            message:@"The Athlete's Details could not be updated"
                            delegate:self
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil,
                            nil];
        lObjAlertViewPtr.tag = 401;
        [lObjAlertViewPtr show];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        SAFE_RELEASE(lObjAlertViewPtr)
    }
}

- (void)keyBoardWillShow:(NSNotification *)pObjNotificationPtr
{
       if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
             m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 2200);
        }
        else
       {
            m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 2000);
        }
    
        if (m_cObjActiveTextFieldPtr.tag == ATHLETEFIRSTNAMETAG || m_cObjActiveTextFieldPtr.tag == ATHLETELASTNAMETAG || m_cObjActiveTextFieldPtr.tag == ATHLETENICKNAMETAG  )
        {
            CGFloat lOffset;
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                lOffset = -63;
            }
            else
            {
                lOffset = 0;
            }
    
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjUpperTableViewPtr.contentInset = contentInsets;
            m_cObjUpperTableViewPtr.scrollIndicatorInsets = contentInsets;
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
    
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:NO];
            [UIView commitAnimations];
    
        }
    
        if (m_cObjActiveTextFieldPtr.tag == ATHLETESCHOOLTAG)
        {
    
    
    
           CGFloat lOffset = 105.0;
    
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
    
        }
        else if (m_cObjActiveTextFieldPtr.tag == ATHLETESPORTSTAG ||  m_cObjActiveTextFieldPtr.tag == ATHLETEPOSITIONTAG  )
        {
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                 lOffset = 105.0;
            }
            else
            {
                lOffset=185;
            }
    
           UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
           [UIView setAnimationDuration:1.0];
           [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
    
        }
        else if (m_cObjActiveTextFieldPtr.tag == ATHLETETEAMTAG || m_cObjActiveTextFieldPtr.tag == ATHLETESCHOOLCOACHNAMETAG  || m_cObjActiveTextFieldPtr.tag == ATHLETEYEARTAG)
        {
    
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
               lOffset = 250.0;
            }
            else
            {
                lOffset=310;
            }
    
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
           m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
    
        }
        else if ( m_cObjActiveTextFieldPtr.tag ==ATHLETECLUBCOACHNAMETAG)
        {
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
               lOffset = 290.0;
            }
           else
            {
                lOffset=330;
            }
    
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
           CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
    
        }
        else if (m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILTAG)
        {
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                lOffset = 370.0;
            }
         else
            {
                lOffset=410;
            }
    
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
    
        }
    
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILPASSWORDTAG)
        {
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
           {
                lOffset = 450.0;
            }
          else
            {
                lOffset=490;
            }
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
           [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
           [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
        }
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETEFBIDTAG )
        {
        CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                lOffset = 530.0;
            }
            else
            {
                lOffset=570;
            }

           UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];

      }
      else if(m_cObjActiveTextFieldPtr.tag == ATHLETETWITIDTAG)
        {
            CGFloat lOffset = 610.0;
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
           m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
    
        }
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETEAGETAG)
        {
            CGFloat lOffset = 690.0;
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
           [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];

        }
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETE_GENDER_TAG)
        {
            CGFloat lOffset = 770.0;
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
    
        }
    
    
    
        else if (  m_cObjActiveTextFieldPtr.tag == ATHLETEPERSONALINFOTAG )
        {
            CGFloat lOffset = 870.0;
           UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
           CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
            //
    
        }
    
    
    
        else if(IsTextView == YES)
        {
            CGFloat lOffset = 950.0;
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
    
        }
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETECITYTAG )
    {
            CGFloat lOffset = 1030.0;
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
        }
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETESTATETAG)
        {
            CGFloat lOffset = 1110.0;
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
           m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
        }
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETEZIPTAG)
        {
            CGFloat lOffset = 1190.0;
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
           [UIView commitAnimations];
        }
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETEPHONETAG )
        {
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                lOffset = 1270.0;
            }
            else
            {
                lOffset=1250;
            }
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
           m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
           [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
        }
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETECELLPHONETAG )
        {
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                lOffset = 1350.0;
            }
            else
            {
                lOffset=1310;
            }
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
        }
        else if (m_cObjActiveTextFieldPtr.tag == ATHLETEHEIGHTTAG)
        {
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
               lOffset = 1430.0;
                
           }
          else
          {
            lOffset=1350;
           }
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
           m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
        }
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETEWEIGHTTAG)
        {
         CGFloat lOffset;
    
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                lOffset = 1510.0;
               
            }
           else
            {
             lOffset=1400;
           }
           UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
           [UIView commitAnimations];
        }
       else if(m_cObjActiveTextFieldPtr.tag == ATHLETEWINGSPANTAG )
        {
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
           {
                lOffset = 1590.0;
               
            }
           else
           {
                lOffset=1450;
            }
            
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
           m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
        }
        else if( m_cObjActiveTextFieldPtr.tag == ATHLETEREACHTAG )
        {
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
           {
                lOffset = 1670.0;
               
            }
            else
            {
                lOffset=1500;
            }
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
   
           CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
           [UIView commitAnimations];
       }
        else if(m_cObjActiveTextFieldPtr.tag == ATHLETESHOESIZETAG)
        {
            CGFloat lOffset;
    
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
           {
                lOffset = 1750.0;
               
            }
            else
            {
                lOffset=1550;
           }
           UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
    
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
           [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
            [UIView commitAnimations];
    
        }

    
}

- (void)keyBoardWillHide : (NSNotification *)pObjNotificationPtr
{

    if (m_cObjActiveTextFieldPtr.tag == ATHLETESCHOOLTAG || m_cObjActiveTextFieldPtr.tag == ATHLETETEAMTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEPOSITIONTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEYEARTAG  || m_cObjActiveTextFieldPtr.tag == ATHLETESPORTSTAG)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        m_cObjLowerTableViewPtr.contentInset = UIEdgeInsetsZero;
        m_cObjLowerTableViewPtr.scrollIndicatorInsets = UIEdgeInsetsZero;
        [UIView commitAnimations];
    }
    else if(m_cObjActiveTextFieldPtr.tag == ATHLETECITYTAG || m_cObjActiveTextFieldPtr.tag == ATHLETESTATETAG || m_cObjActiveTextFieldPtr.tag == ATHLETEPHONETAG || m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILPASSWORDTAG || m_cObjActiveTextFieldPtr.tag == ATHLETECELLPHONETAG || m_cObjActiveTextFieldPtr.tag == ATHLETETYPETAG || m_cObjActiveTextFieldPtr.tag == ATHLETEFBIDTAG || m_cObjActiveTextFieldPtr.tag == ATHLETETWITIDTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEPERSONALINFOTAG || m_cObjActiveTextFieldPtr.tag == ATHLETESCHOOLCOACHNAMETAG || m_cObjActiveTextFieldPtr.tag == ATHLETECLUBCOACHNAMETAG || m_cObjActiveTextFieldPtr.tag == ATHLETEAGETAG || m_cObjActiveTextFieldPtr.tag == ATHLETEHEIGHTTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEWEIGHTTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEWINGSPANTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEREACHTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEUIDTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEACTIVETAG || m_cObjActiveTextFieldPtr.tag == ATHLETE_GENDER_TAG)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        CGRect lRect = m_cObjLowerTableViewPtr.frame;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            lRect.size.height = 1850.0;
        }
        else
        {
            lRect.size.height = 1550.0;
        }
        
        m_cObjLowerTableViewPtr.frame = lRect;
        [UIView commitAnimations];
    }
    else if(IsTextView == YES)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        CGRect lRect = m_cObjLowerTableViewPtr.frame;
        lRect.size.height = 1550.0;
        m_cObjLowerTableViewPtr.frame = lRect;
        [UIView commitAnimations];
        
    }
    if (m_cObjActiveTextFieldPtr.tag == ATHLETEPOSITIONTAG || m_cObjActiveTextFieldPtr.tag == ATHLETESPORTSTAG)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
//        CGRect lRect = m_cObjLowerTableViewPtr.frame;
//        lRect.size.height = 1550.0;
//        m_cObjLowerTableViewPtr.frame = lRect;
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 1750.0);
        [UIView commitAnimations];
    }
   
}

-(void)scrollTableViewToCell:(UITextField *)pTextFieldPtr height:(CGFloat)pHeight
{
//    NSInteger   lTag = pTextFieldPtr.tag;
    NSInteger   lSection = 0, lRow = 0;
    
    
    if (pTextFieldPtr.tag == ATHLETEWINGSPANTAG )
    {
        lSection = 15;
        lRow = 0;
    }
    else if (pTextFieldPtr.tag == ATHLETEREACHTAG)
    {
        lSection = 16;
        lRow = 0;
    }
    else if (pTextFieldPtr.tag == ATHLETESHOESIZETAG)
    {
        lSection = 17;
        lRow = 0;
    }
    
    
    //ananymous added on 22.8.12 -start
    // to solve the payscreen scroll issue
//    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 1750.0);
    m_cObjLowerTableViewPtr.contentInset = UIEdgeInsetsMake(0, 0, 226.0, 0);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lRow inSection:lSection];
    [m_cObjLowerTableViewPtr selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    //ananymous added on 22.8.12 -end
}
-(void)onSaveButtonPressed : (id)sender
{
    UITextField *lObjTextField = (UITextField *)nil;
    BOOL lRetval = NO;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)
    {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320, 1750.0);
        m_cObjScrollViewPtr.contentOffset = CGPointMake(0, 0);
        
        CGRect lRect = m_cObjLowerTableViewPtr.frame;
        lRect.size.height = 1550.0;
        m_cObjLowerTableViewPtr.frame = lRect;
        m_cObjLowerTableViewPtr.contentInset = UIEdgeInsetsZero;
        m_cObjLowerTableViewPtr.scrollIndicatorInsets = UIEdgeInsetsZero;
        
        [UIView commitAnimations];

        
    }
    
    
    lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEFIRSTNAMETAG];
    [self validateFields:lObjTextField];
    lObjTextField = (UITextField *)nil;
    
    lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETELASTNAMETAG];
    [self validateFields:lObjTextField];
    lObjTextField = (UITextField *)nil;
    
    lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILTAG];
    if(lObjTextField.text.length > 0)
    {
    lRetval = [self validateEmail:lObjTextField.text];
    }
    else
    {
        lRetval = NO;
    }
    
    if(IsFirstNameValidationSuccess == YES && IsLastNameValidationSuccess == YES && lRetval == YES)
    {

        IsEmailValidationSuccess = YES;
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEFIRSTNAMETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjFirstNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETELASTNAMETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjLastNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETENICKNAMETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjNickNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPORTSTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjSportsPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESCHOOLTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjSchoolNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETETEAMTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjTeamNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEPOSITIONTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjPositionPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEYEARTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjSchoolYearPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjEmailIdPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILPASSWORDTAG];
        // added this as per narayan's report to add default password,if password is nil
        if( 0 >= [lObjTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
        {
            m_cObjAthleteDetailsDataPtr.m_cObjPasswordPtr = @"tempPWD"; 
        }
        else
        {
        m_cObjAthleteDetailsDataPtr.m_cObjPasswordPtr = lObjTextField.text;
        }
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEPHONETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjPhoneNumberPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETECELLPHONETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjCellPhoneNumberPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        UITextView *lObjTextView= (UITextView *)[self.view viewWithTag:ATHLETEADDRESSTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjAddressPtr = lObjTextView.text;
        lObjTextView = (UITextView *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETECITYTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjCityNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESTATETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjStateNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEZIPTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjZipCodePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETETYPETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjTypePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEFBIDTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjFB_IDPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETETWITIDTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjTwit_IDPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEPERSONALINFOTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjPersonal_InfoPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESCHOOLCOACHNAMETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjSchoolCoachNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETECLUBCOACHNAMETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjClubCoachNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEAGETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjBirthDatePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETE_GENDER_TAG];
        if ([lObjTextField.text isEqualToString:@"Male"])
        {
            m_cObjAthleteDetailsDataPtr.m_cObjGenderPtr=@"M";
        }
        else
        {
            m_cObjAthleteDetailsDataPtr.m_cObjGenderPtr = @"F";
        }
        lObjTextField = (UITextField *)nil;
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEHEIGHTTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjHeightPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEWEIGHTTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjWeightPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEWINGSPANTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjWingSpanPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEREACHTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjReachPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESHOESIZETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjShoeSizePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEUIDTAG];
        m_cObjAthleteDetailsDataPtr.m_cObjU_IDPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEACTIVETAG];
        m_cObjAthleteDetailsDataPtr.m_cObjActivePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;

        
        if(IsPhotoDeleted == YES)
        {
            [self deletePhoto];
        }
        if((UIImage *)nil != self.m_cObjImagePtr)
        {
        [self saveIntoDocs];
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *lObjPhotoFolderPtr;
        if ((NSString *)nil != self.m_cObjAthleteDetailsDataPtr.m_cAthleteId) {
            lObjPhotoFolderPtr = [gObjAppDelegatePtr getPhotoFolders:self.m_cObjAthleteDetailsDataPtr.m_cAthleteId AthImageName:self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr];
            BOOL fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
            
            if (NO == fileExists && (NSString *)nil != self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                lObjPhotoFolderPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:self.m_cObjAthleteDetailsDataPtr.m_cPhotoNamePtr];
                //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
            }
            
            if (YES == fileExists) {
                NSData *lObjImageDataPtr = [NSData dataWithContentsOfFile:lObjPhotoFolderPtr];
                [m_cTakeImageButtonPtr setImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
                [m_cTakeImageButtonPtr setBackgroundImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
            }
            else{
                gObjAppDelegatePtr.m_cObjImageDatePtr = (NSData *)nil;
            }
            
        }
        
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        gObjAppDelegatePtr.m_cSignInAttemptCount += 1;
        
        if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
        
            gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cIsAddedinOfflineMode = NO;
            [self.view endEditing:YES];
            [gObjAppDelegatePtr displayProgressHandler:@"Sending Athlete Information to server"];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
         
            
           if([self.m_cObjAthleteDetailsDataPtr.m_cAthleteId rangeOfString:@"ABCSFTXYZ_"].length > 0)
           {
               isOfflineData = YES;
               gObjAppDelegatePtr.m_cObjTempAthleteIdPtr =self.m_cObjAthleteDetailsDataPtr.m_cAthleteId;
               self.m_cObjAthleteDetailsDataPtr.m_cIsAddedinOfflineMode = YES;
               gObjAppDelegatePtr.isOfflineData = YES;
               [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadRequest :self.m_cObjAthleteDetailsDataPtr isNewAthlete:YES];
//               gObjAppDelegatePtr.m_cObjImageDatePtr  = UIImageJPEGRepresentation(m_cObjImagePtr, 0.0);
               gObjAppDelegatePtr.m_cObjImageDatePtr  = UIImagePNGRepresentation(m_cObjImagePtr);

           }
           else{
                isOfflineData = NO;
               [gObjAppDelegatePtr.m_cDbHandler updateNewAthlete:self.m_cObjAthleteDetailsDataPtr];
               [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadRequest :self.m_cObjAthleteDetailsDataPtr isNewAthlete:NO];
           }
        }
        else{
           
                gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cIsAddedinOfflineMode = YES;
                self.m_cObjAthleteDetailsDataPtr.m_cIsAddedinOfflineMode = YES;
            if(m_cObjImagePtr != (UIImage *)nil)
            self.m_cObjAthleteDetailsDataPtr.m_cIsPhotoAddedInOfflineMode = YES;
            else
                self.m_cObjAthleteDetailsDataPtr.m_cIsPhotoAddedInOfflineMode = NO;
                [gObjAppDelegatePtr.m_cDbHandler updateNewAthlete:self.m_cObjAthleteDetailsDataPtr];
                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr =self;
                [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
        
        }
    }
    else if(IsFirstNameValidationSuccess == NO && IsLastNameValidationSuccess == NO && lRetval == NO)
    {
        IsEmailValidationSuccess = NO;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
        [self adjustScrollView];
    }
    else if(IsFirstNameValidationSuccess == NO && IsLastNameValidationSuccess == NO && lRetval == YES)
    {
        IsEmailValidationSuccess = YES;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
        [self adjustScrollView];
    }
    
    else if(IsFirstNameValidationSuccess == NO && IsLastNameValidationSuccess == YES && lRetval == NO)
    {
        IsEmailValidationSuccess = NO;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
        [self adjustScrollView];
    }
    
    else if(IsFirstNameValidationSuccess == YES && IsLastNameValidationSuccess == NO && lRetval == NO)
    {
        IsEmailValidationSuccess = NO;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
        [self adjustScrollView];
    }
    
    
    else if(IsFirstNameValidationSuccess == NO)
    {
        IsEmailValidationSuccess = YES;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
        [self adjustScrollView];
        
    }
    else if(IsLastNameValidationSuccess == NO)
    {
        IsEmailValidationSuccess = YES;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
        [self adjustScrollView];
    }
    else if(lRetval == NO)
    {
        IsEmailValidationSuccess = NO;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
        [self adjustScrollView];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 400 || alertView.tag == 401){
        [self.view endEditing:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (alertView.tag == 502) {
        lObjAddFavButton.title = @"Remove From Favorite";
    }
    else if (alertView.tag == 504){
        lObjAddFavButton.title = @"Add To Favorite";
    }
}

-(void)onBackButtonPressed : (id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRow = -1;
    if(tableView.tag == ADDATHLETEUPPERTABLE)
    {
        lRow =  3;
         m_cTotalNoOfRows  = m_cTotalNoOfRows +lRow;
    }
    else if(tableView.tag == ADDATHLETELOWERTABLE)
    {
        if(section == 0)
        {
            lRow = 7;
        }
        else
        {
            lRow = 1;
        }
         m_cTotalNoOfRows  = m_cTotalNoOfRows +lRow;
    }
    return lRow;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger lSection = -1;
    if(tableView.tag == ADDATHLETEUPPERTABLE)
    {
        lSection =  1;
    }
    else if(tableView.tag == ADDATHLETELOWERTABLE)
    {
        lSection = 19;
    }
    return lSection;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lHeight = {0.0};
    if(tableView.tag == ADDATHLETELOWERTABLE && indexPath.section == 7 && indexPath.row == 0)
    {
        lHeight = 70.0;
    }
    else
        lHeight = 44.0;
    return lHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *lObjErrorImageViewPtr = (UIImageView *)nil; 
    if(tableView.tag == ADDATHLETEUPPERTABLE)
    {
        static NSString		*lObjCellIdentifierPtr = @"AddAthleteUpperDetailCell";
        AddAthleteTableViewCell		*lObjCustomCellPtr = (AddAthleteTableViewCell *)nil;
        
        lObjCustomCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr];	
        if((AddAthleteTableViewCell *)nil == lObjCustomCellPtr)
        {
            lObjCustomCellPtr = [[[AddAthleteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjCellIdentifierPtr] autorelease];
        }
        lObjCustomCellPtr.accessoryView = (UIView *)nil;
        
        switch (indexPath.row)
        {
            case 0:
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.placeholder = @"First Name";
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjFirstNamePtr;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.tag = ATHLETEFIRSTNAMETAG;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.delegate = self;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                
                if(IsFirstNameValidationSuccess == NO)
                {
                    lObjErrorImageViewPtr = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ErrorArrow.png"]];
                    lObjCustomCellPtr.accessoryView = lObjErrorImageViewPtr;
                    SAFE_RELEASE(lObjErrorImageViewPtr)
                }
                break;
            case 1:
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.placeholder = @"Last Name";
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjLastNamePtr;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.tag = ATHLETELASTNAMETAG;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.delegate = self;
                if(IsLastNameValidationSuccess == NO)
                {
                    lObjErrorImageViewPtr = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ErrorArrow.png"]];
                    lObjCustomCellPtr.accessoryView = lObjErrorImageViewPtr;
                    SAFE_RELEASE(lObjErrorImageViewPtr)
                }
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                break;
            case 2:

                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.placeholder = @"NickName";
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.tag = ATHLETENICKNAMETAG;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.delegate = self;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjNickNamePtr;
                break;
            default:
                break;
        }
        lObjCustomCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return lObjCustomCellPtr;
    }
    else if(tableView.tag == ADDATHLETELOWERTABLE)
    {
        static NSString		*lObjCellIdentifierPtr = @"AddAthleteLowerDetailCell";
        AddAthleteDetailsTableViewCell		*lObjCellPtr = (AddAthleteDetailsTableViewCell *)nil;
        
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr];	
        if((AddAthleteDetailsTableViewCell *)nil == lObjCellPtr)
        {
            lObjCellPtr = [[[AddAthleteDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjCellIdentifierPtr] autorelease];
        }
        lObjCellPtr.accessoryView = (UIView *)nil;
        lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
        switch (indexPath.section)
        {
            case 0:
                switch (indexPath.row)
            {
                case 0:
                    

                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"College";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjSchoolNamePtr;
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"College Name";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESCHOOLTAG;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                    break;
                    
                case 1:

                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Sports";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjSportsPtr;
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Sports List";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESPORTSTAG;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = self.m_cObjPickerViewPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                    break;

                    
                case 2:

                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Position";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjPositionPtr;
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Position";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEPOSITIONTAG;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = self.m_cObjPickerViewPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                    break;
                    
                case 3:

                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Grade";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjSchoolYearPtr;
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Grade";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEYEARTAG;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = self.m_cObjPickerViewPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                    break;
                    
                case 4:

                     lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Club Team";
                     lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjTeamNamePtr;
                     lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                     lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Club Team Name";
                     lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
                     lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETETEAMTAG;
                     lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                     lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                     break;

                case 5:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"School Coach";
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:13];
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"School Coach Name";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESCHOOLCOACHNAMETAG;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjSchoolCoachNamePtr;
                    break;
                case 6:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Club Coach";
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Club Coach Name";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETECLUBCOACHNAMETAG;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjClubCoachNamePtr;
                    break;
                    
                    
                    
                default:
                    break;
            }
                break;
                
            case 1:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Email";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjEmailIdPtr;
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Email";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeEmailAddress;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEEMAILTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                if(IsEmailValidationSuccess == NO)
                {
                    lObjErrorImageViewPtr = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ErrorArrow.png"]];
                    lObjCellPtr.accessoryView = lObjErrorImageViewPtr;
                    SAFE_RELEASE(lObjErrorImageViewPtr)
                }
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                break;
                
            case 2:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Password";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeEmailAddress;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Password";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEEMAILPASSWORDTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.returnKeyType = UIReturnKeyNext;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjPasswordPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.secureTextEntry = YES;
                break;
                
            case 3:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Facebook ID";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeEmailAddress;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Facebook ID";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEFBIDTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjFB_IDPtr;
                break;
            case 4:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Twitter ID";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeEmailAddress;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Twitter ID";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETETWITIDTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjTwit_IDPtr;
                break;
            case 5:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Date of Birth";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Date of Birth";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEAGETAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = m_cObjDOBPickerPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjBirthDatePtr;
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                
                break;
            case 6:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Gender";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Gender";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETE_GENDER_TAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjGenderPtr;
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                
                break;

            case 7:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Personal Info";
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Personal Info";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEPERSONALINFOTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjPersonal_InfoPtr;
                break;
            case 8:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Address";
                lObjCellPtr.m_cObjAthleteTextViewPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjAddressPtr;
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = NO;
                lObjCellPtr.m_cObjAthleteTextViewPtr.keyboardType = UIKeyboardTypeDefault;
                lObjCellPtr.m_cObjAthleteTextViewPtr.tag = ATHLETEADDRESSTAG;
                lObjCellPtr.m_cObjAthleteTextViewPtr.returnKeyType = UIReturnKeyNext;
                lObjCellPtr.m_cObjAthleteTextViewPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextViewPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                break;
            case 9:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"City";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjCityNamePtr;
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"City";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETECITYTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.returnKeyType = UIReturnKeyNext;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                
                break;
            case 10:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"State";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjStateNamePtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"State";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESTATETAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = self.m_cObjPickerViewPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                
                break;
            case 11:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Zip Code";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjZipCodePtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeNumberPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Zip Code";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEZIPTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                break;
            case 12:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Home Phone";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjPhoneNumberPtr;
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeNumberPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Home Phone";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEPHONETAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                break;
            case 13:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Cell Phone";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeNumberPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Cell Phone";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETECELLPHONETAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjCellPhoneNumberPtr;
                break;
            case 14:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Height";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDecimalPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Height";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEHEIGHTTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjHeightPtr;
                break;
            case 15:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Weight";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDecimalPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Weight";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEWEIGHTTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjWeightPtr;
                break;
            case 16:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Wing Span";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDecimalPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Wing Span";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEWINGSPANTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjWingSpanPtr;
                break;
            case 17:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Reach";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDecimalPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Reach";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEREACHTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjReachPtr;
                break;
            case 18:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Shoe Size";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeNumberPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Shoe Size";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESHOESIZETAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailsDataPtr.m_cObjShoeSizePtr;
                break;
                

           default:
                break;
        }
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        return lObjCellPtr;
    }
    else
        return nil;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_cObjActiveTextFieldPtr = textField;
    if(textField.tag == ATHLETE_GENDER_TAG)
    {
        NSArray *lObjArrayPtr = [NSArray arrayWithObjects:@"Male",@"Female", nil];
        self.m_cGenderArrayPtr = lObjArrayPtr;
        [self.m_cObjGenderPickerViewForeidtPtr reloadAllComponents];
        textField.inputView = self.m_cObjGenderPickerViewForeidtPtr;
        textField.inputAccessoryView = m_cObjPickerToolBarPtr;
        textField.text = [self.m_cGenderArrayPtr objectAtIndex:0];
        [self.m_cObjGenderPickerViewForeidtPtr selectRow:0 inComponent:0 animated:YES];
    }
    
   else if(textField.tag == ATHLETESPORTSTAG)
    {
        NSArray *lObjArrayPtr = [NSArray arrayWithObjects:@"General",@"Baseball",@"Basketball",@"Football",@"Lacrosse",@"Volleyball", nil];
        self.m_cObjSportsListPtr = lObjArrayPtr;
        [self.m_cObjPickerViewPtr reloadAllComponents];
        textField.inputView = self.m_cObjPickerViewPtr;
        textField.inputAccessoryView = m_cObjPickerToolBarPtr;
    }
    else if(textField.tag == ATHLETEPOSITIONTAG)
    {
        UITextField *lObjTextField = (UITextField *)nil;
        NSArray *lObjArrayPtr = (NSArray *)nil;
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPORTSTAG];
        
        if(lObjTextField.text.length <= 0)
        {
            [textField resignFirstResponder];
            m_cObjScrollViewPtr.contentSize = CGSizeMake(320, 950);
            UIAlertView *lObjAlertViewPtr;
            lObjAlertViewPtr = [[UIAlertView alloc]
                                initWithTitle:@"Athlete Logger"
                                message:@"Please at first choose a Sport then choose Position"
                                delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil,
                                nil];
            
            [lObjAlertViewPtr show];
            textField.userInteractionEnabled = YES;
            SAFE_RELEASE(lObjAlertViewPtr)
        }
        else
        {
            if([lObjTextField.text isEqualToString:@"General"])
            {
                lObjArrayPtr = [NSArray arrayWithObjects:@"General",nil];
            }
            if([lObjTextField.text isEqualToString:@"Baseball"])
            {
                lObjArrayPtr = [NSArray arrayWithObjects:@"Pitcher",@"Catcher",@"First Baseman",@"Second Baseman",@"Third Baseman",@"Shortstop",@"Left Fielder",@"Center Fielder",@"Right Fielder", nil];
            }
            else if([lObjTextField.text isEqualToString:@"Basketball"])
            {
                lObjArrayPtr = [NSArray arrayWithObjects:@"Point Guard",@"Shooting Guard",@"Small Forward",@"Power Forward",@"Center", nil];
            }
            else if([lObjTextField.text isEqualToString:@"Football"])
            {
                lObjArrayPtr = [NSArray arrayWithObjects:@"Center",@"Offensive Guard",@"Offensive Tackle",@"Quarterback",@"Running Back",@"Wide Receiver",@"Tight End",@"Defensive Tackle",@"Defensive End",@"Middle Linebacker",@"Outside Linebacker",@"Cornerback",@"Safety",@"Nickelback",@"Dimeback",@"Kicker",@"Holder",@"Long Snapper",@"Punter",@"Punt Returner",@"Kick Returner",@"Upback",@"Gunner", nil];
            }
            else if([lObjTextField.text isEqualToString:@"Lacrosse"])
            {
                lObjArrayPtr = [NSArray arrayWithObjects:@"Attack",@"Middle",@"Defense",@"Goalie",nil];
            }
            else if([lObjTextField.text isEqualToString:@"Volleyball"])
            {
                lObjArrayPtr = [NSArray arrayWithObjects:@"Setter",@"Outside Hitter",@"Middle Hitter",@"Opposite Hitter",@"Libero", nil];
            }
            
            self.m_cObjSportsListPtr = lObjArrayPtr;
            [self.m_cObjPickerViewPtr reloadAllComponents];
            textField.inputView = self.m_cObjPickerViewPtr;
            textField.inputAccessoryView = m_cObjPickerToolBarPtr;
        }
    }
    
    else if(textField.tag == ATHLETEYEARTAG)
    {
        NSArray *lObjArrayPtr = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
        self.m_cObjSportsListPtr = lObjArrayPtr;
        [self.m_cObjPickerViewPtr reloadAllComponents];
        textField.inputView = self.m_cObjPickerViewPtr;
        textField.inputAccessoryView = m_cObjPickerToolBarPtr;
    }
    else if(textField.tag == ATHLETESTATETAG)
    {
        NSArray *lObjArrayPtr = [NSArray arrayWithObjects:@"Alabama(AL)",@"Alaska(AK)",@"Arizona(AZ)",@"Arkansas(AR)",@"California(CA)",@"Colorado(CO)",@"Connecticut(CT)",@"Delaware(DE)",@"Florida(FL)",@"Georgia(GA)",@"Hawaii(HI)",@"Idaho(ID)",@"Illinois(IL)",@"Indiana(IN)",@"Iowa(IA)",@"Kansas(KS)",@"Kentucky(KY)",@"Louisiana(LA)",@"Maine(ME)",@"Maryland(MD)",@"Massachusetts(MA)",@"Michigan(MI)",@"Minnesota(MN)",@"Mississippi(MS)",@"Missouri(MO)",@"Montana(MT)",@"Nebraska(NE)",@"Nevada(NV)",@"New Hampshire(NH)",@"New Jersey(NJ)",@"New Mexico(NM)",@"New York(NY)",@"North Carolina(NC)",@"North Dakota(ND)",@"Ohio(OH)",@"Oklahoma(OK)",@"Oregon(OR)",@"Pennsylvania(PA)",@"Rhode Island(RI)",@"South Carolina(SC)",@"South Dakota(SD)",@"Tennessee(TN)",@"Texas(TX)",@"Utah(UT)",@"Vermont(VT)",@"Virginia(VA)",@"Washington(WA)",@"West Virginia(WG)",@"Wisconsin(WI)",@"Wyoming(WY)", nil];
        self.m_cObjSportsListPtr = lObjArrayPtr;
        [self.m_cObjPickerViewPtr reloadAllComponents];
        textField.inputView = self.m_cObjPickerViewPtr;
        textField.inputAccessoryView = m_cObjPickerToolBarPtr;
    }
    if(textField.tag == ATHLETESPORTSTAG || textField.tag == ATHLETEYEARTAG || textField.tag == ATHLETESTATETAG)
    {
        if(textField.text.length <= 0)
        {
            textField.text = [self.m_cObjSportsListPtr objectAtIndex:0];
            [self.m_cObjPickerViewPtr selectRow:0 inComponent:0 animated:NO];
        }
        else
        {
            for(int i = 0 ; i<self.m_cObjSportsListPtr.count ; i++)
            {
                if([textField.text isEqualToString:[self.m_cObjSportsListPtr objectAtIndex:i]])
                {
                    [self.m_cObjPickerViewPtr selectRow:i inComponent:0 animated:NO];
                }
            }
        }
    }
    else if(textField.tag == ATHLETEPOSITIONTAG)
    {
        UITextField *lObjTextField = (UITextField *)nil;
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPORTSTAG];
        if(lObjTextField.text.length > 0)
        {
            if(textField.text.length <= 0)
            {
                textField.text = [self.m_cObjSportsListPtr objectAtIndex:0];
                [self.m_cObjPickerViewPtr selectRow:0 inComponent:0 animated:NO];
            }
            else
            {
                for(int i = 0 ; i<self.m_cObjSportsListPtr.count ; i++)
                {
                    if([textField.text isEqualToString:[self.m_cObjSportsListPtr objectAtIndex:i]])
                    {
                        [self.m_cObjPickerViewPtr selectRow:i inComponent:0 animated:NO];
                    }
                }
            }
            
        }
        lObjTextField = (UITextField *)nil;
    }
    if(textField.tag == ATHLETESPORTSTAG)
    {
        self.m_cObjSportNamePtr = textField.text;
    }
    if(textField.tag == ATHLETEAGETAG)
    {
        
        if ((NSMutableArray *)nil == m_cObjDateArrayPtr)
            m_cObjDateArrayPtr = [[NSMutableArray alloc]init];
        if ((NSMutableArray *)nil == m_cObjMonthArrayPtr)
            m_cObjMonthArrayPtr = [[NSMutableArray alloc]init];
        if ((NSMutableArray *)nil == m_cObjYearArrayPtr)
            m_cObjYearArrayPtr = [[NSMutableArray alloc]init];
        
        
        NSInteger lDate = -1;
        NSInteger lMonth = -1;
        NSInteger lYear = -1;
        
        for(int i = 1; i<=31 ;i++)
        {
            if(i<=9)
            {
                [self.m_cObjDateArrayPtr addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else
            {
                [self.m_cObjDateArrayPtr addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        for(int i = 1930 ; i<=2014 ; i++)
        {
            [self.m_cObjYearArrayPtr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        for(int i = 1 ; i <=12 ; i++)
        {
            if(i<=9)
            {
                [self.m_cObjMonthArrayPtr addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else
            {
                [self.m_cObjMonthArrayPtr addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        [self.m_cObjDOBPickerPtr reloadAllComponents];
        textField.inputView = m_cObjDOBPickerPtr;
        textField.inputAccessoryView = m_cObjPickerToolBarPtr;
        
        if(textField.text.length <= 0)
        {
            NSDate *lNow = [[NSDate date] retain];
            NSCalendar *lCalendar = [NSCalendar currentCalendar];
            NSDateComponents* comps = [lCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:lNow];
            
            lDate = [comps day];
            lMonth  = [comps month];
            lYear = [comps year];
            
            if(lDate <=9)
            {
                
                self.m_cObjDayPtr = [NSString stringWithFormat:@"0%d",lDate];
            }
            else
            {
                
                self.m_cObjDayPtr = [NSString stringWithFormat:@"%d",lDate];
            }
            if(lMonth <= 9)
            {
                
                self.m_cObjMonthPtr = [NSString stringWithFormat:@"0%d",lMonth];
            }
            else
            {
                
                self.m_cObjMonthPtr = [NSString stringWithFormat:@"%d",lMonth];
            }
            
            self.m_cObjYearPtr = [NSString stringWithFormat:@"%d",lYear];
            textField.text = [NSString stringWithFormat:@"%@/%@/%@",self.m_cObjMonthPtr,self.m_cObjDayPtr,self.m_cObjYearPtr];
            
            [self.m_cObjDOBPickerPtr selectRow:lMonth - 1 inComponent:0 animated:NO];
            [self.m_cObjDOBPickerPtr selectRow:lDate - 1 inComponent:1 animated:NO];
            [self.m_cObjDOBPickerPtr selectRow:lYear - 1930 inComponent:2 animated:NO];
        }
        else
        {
            NSArray *lObjArrayPtr = [textField.text componentsSeparatedByString:@"/"];
            
            self.m_cObjMonthPtr = [lObjArrayPtr objectAtIndex:0];
            
            self.m_cObjDayPtr = [lObjArrayPtr objectAtIndex:1];
            
            self.m_cObjYearPtr = [lObjArrayPtr objectAtIndex:2];
            [self.m_cObjDOBPickerPtr selectRow:[[lObjArrayPtr objectAtIndex:0] intValue]-1 inComponent:0 animated:NO];
            [self.m_cObjDOBPickerPtr selectRow:[[lObjArrayPtr objectAtIndex:1] intValue]-1 inComponent:1 animated:NO];
            [self.m_cObjDOBPickerPtr selectRow:[[lObjArrayPtr objectAtIndex:2] intValue]-1930 inComponent:2 animated:NO];
            
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == ATHLETEPHONETAG || textField.tag == ATHLETECELLPHONETAG || textField.tag == ATHLETEZIPTAG || textField.tag == ATHLETEHEIGHTTAG || textField.tag == ATHLETEWEIGHTTAG || textField.tag == ATHLETESHOESIZETAG || textField.tag == ATHLETEWINGSPANTAG || textField.tag == ATHLETEREACHTAG || textField.tag == ATHLETEUIDTAG)
    {
        //[m_cObjNumberKeypadDecimalPointPtr removeButtonFromKeyboard];
    }
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *lObjTextFieldPtr = (UITextField *)nil;
    if(textField.tag == ATHLETEFIRSTNAMETAG)
    {
        
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETELASTNAMETAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
        
    }
    else if(textField.tag == ATHLETELASTNAMETAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETENICKNAMETAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETENICKNAMETAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETESCHOOLTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETESCHOOLTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETESPORTSTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
        
    }
    else if(textField.tag == ATHLETETEAMTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETESCHOOLCOACHNAMETAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETESCHOOLCOACHNAMETAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETECLUBCOACHNAMETAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETECLUBCOACHNAMETAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEEMAILTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETEEMAILTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEEMAILPASSWORDTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETEEMAILPASSWORDTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEFBIDTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    
    else if(textField.tag == ATHLETECITYTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETESTATETAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    
    else if(textField.tag == ATHLETEFBIDTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETETWITIDTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETETWITIDTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEAGETAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETEAGETAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETE_GENDER_TAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETE_GENDER_TAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEPERSONALINFOTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETEPERSONALINFOTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEADDRESSTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == ATHLETEPHONETAG || textField.tag == ATHLETECELLPHONETAG || textField.tag == ATHLETEZIPTAG || textField.tag == ATHLETEHEIGHTTAG || textField.tag == ATHLETEWEIGHTTAG || textField.tag == ATHLETESHOESIZETAG || textField.tag == ATHLETEREACHTAG || textField.tag == ATHLETEWINGSPANTAG || textField.tag == ATHLETEUIDTAG)
    {
        //[self performSelector:@selector(showCustomDoneButton:) withObject:textField afterDelay:0.2f];
    }
    if(textField.tag == ATHLETEFIRSTNAMETAG)
    {
        [m_cObjSegementCtrlPtr setEnabled:NO forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
    }
    else if(textField.tag != ATHLETEFIRSTNAMETAG && textField.tag != ATHLETESHOESIZETAG)
    {
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
    }
    else if(textField.tag == ATHLETESHOESIZETAG)
    {
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:NO forSegmentAtIndex:1];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL lRetval = NO;
    if(textField.tag == ATHLETEPHONETAG)
    {
        if ([string isEqualToString:@""])
        {
            lRetval = YES;
        }
        else
        {
            if (textField.text.length==0)
            {
                textField.text = [NSString stringWithFormat:@"(%@",textField.text];
                
            }
            else if (textField.text.length==4)
            {
                NSString *sampletext = textField.text;
                textField.text = [NSString stringWithFormat:@"%@)",sampletext];
                
            }
            else if (textField.text.length==8)
            {
                textField.text = [NSString stringWithFormat:@"%@-",textField.text];
                
            }
            lRetval = YES;
        }
    }
    else if(textField.tag == ATHLETECELLPHONETAG)
    {
        if ([string isEqualToString:@""])
        {
            lRetval = YES;
        }
        else
        {
            if (textField.text.length==3)
            {
                textField.text = [NSString stringWithFormat:@"%@-",textField.text];
                
            }
            else if (textField.text.length==7)
            {
                NSString *sampletext = textField.text;
                textField.text = [NSString stringWithFormat:@"%@-",sampletext];
                
            }
            lRetval = YES;
        }
        
    }
    else if(textField.tag == ATHLETEACTIVETAG || textField.tag == ATHLETETYPETAG)
    {
        if([string isEqualToString:@""])
        {
            lRetval = YES;
        }
        else if(textField.text.length == 1)
        {
            lRetval = NO;
        }
        else
        {
            lRetval = YES;
        }
    }
    else
    {
        lRetval = YES;
    }
    return lRetval;
}

-(void)textFieldDidChange : (NSNotification *)pObjNotification
{
    if(m_cObjActiveTextFieldPtr.tag == ATHLETESPORTSTAG && m_cObjActiveTextFieldPtr.text.length >0)
    {
        if ( NO == [self.m_cObjSportNamePtr isEqualToString:m_cObjActiveTextFieldPtr.text])
        {
            UITextField *lObjTextFieldPtr = (UITextField *)nil;
            lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEPOSITIONTAG];
            if(lObjTextFieldPtr.text.length > 0)
            {
                lObjTextFieldPtr.text = @"";
            }
            lObjTextFieldPtr = (UITextField *)nil;
        }
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        UITextField *lObjTextField = (UITextField *)nil;
        [textView resignFirstResponder];
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETECITYTAG];
        [lObjTextField becomeFirstResponder];
        return NO;
    }
    
    return YES;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    m_cObjActiveTextFieldPtr = (UITextField *)nil;
    IsTextView = YES;
//    [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
//    [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
    //[textView becomeFirstResponder];
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    IsTextView = NO;
}

-(BOOL)validateEmail:(NSString *)pEmailText
{
    BOOL lRetval = YES;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    lRetval = [emailTest evaluateWithObject:pEmailText];
    return lRetval;
}

-(void)onSegmentBtnClicked : (id)sender
{
 
    UISegmentedControl *lObjSegCtrlPtr = (UISegmentedControl *)nil;
    lObjSegCtrlPtr = (UISegmentedControl *)sender;
    UITextField *lObjTextField = (UITextField *)nil;
    UITextView *lObjTextView = (UITextView *)nil;
    switch (lObjSegCtrlPtr.selectedSegmentIndex) 
    {
        case 0:
            if(m_cObjActiveTextFieldPtr.tag == ATHLETELASTNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                [m_cObjScrollViewPtr scrollRectToVisible:m_cObjUpperTableViewPtr.frame animated:YES];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEFIRSTNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETENICKNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETELASTNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESCHOOLTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETENICKNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESPORTSTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESCHOOLTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEPOSITIONTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPORTSTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEYEARTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEPOSITIONTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETETEAMTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEYEARTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESCHOOLCOACHNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETETEAMTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETECLUBCOACHNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESCHOOLCOACHNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETECLUBCOACHNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILPASSWORDTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextView = (UITextView *)[self.view viewWithTag:ATHLETEEMAILTAG];
                [lObjTextView becomeFirstResponder];
                lObjTextView = (UITextView *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEFBIDTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILPASSWORDTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETETWITIDTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEFBIDTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEAGETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETETWITIDTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETE_GENDER_TAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEAGETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(IsTextView == YES)
            {
                lObjTextView = (UITextView *)[self.view viewWithTag:ATHLETEPERSONALINFOTAG];
                [lObjTextView resignFirstResponder];
                lObjTextView = (UITextView *)nil;
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETE_GENDER_TAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETECITYTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEADDRESSTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESTATETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETECITYTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEZIPTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESTATETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEPHONETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEZIPTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETECELLPHONETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEPHONETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEHEIGHTTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETECELLPHONETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEWEIGHTTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEHEIGHTTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEWINGSPANTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEWEIGHTTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEREACHTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEWINGSPANTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESHOESIZETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEREACHTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
        break;
        case 1:
            
            if(m_cObjActiveTextFieldPtr.tag == ATHLETEFIRSTNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETELASTNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETELASTNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETENICKNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETENICKNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESCHOOLTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESCHOOLTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPORTSTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESPORTSTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEPOSITIONTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEPOSITIONTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEYEARTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEYEARTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETETEAMTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETETEAMTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESCHOOLCOACHNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESCHOOLCOACHNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETECLUBCOACHNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETECLUBCOACHNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }          
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILPASSWORDTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILPASSWORDTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEFBIDTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEFBIDTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETETWITIDTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETETWITIDTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEAGETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEAGETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETE_GENDER_TAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETE_GENDER_TAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEPERSONALINFOTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEPERSONALINFOTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEADDRESSTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(IsTextView == YES)
            {
                lObjTextView = (UITextView *)[self.view viewWithTag:ATHLETEADDRESSTAG];
                [lObjTextView resignFirstResponder];
                lObjTextView = (UITextView *)nil;
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETECITYTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETECITYTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESTATETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESTATETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEZIPTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEZIPTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEPHONETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEPHONETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETECELLPHONETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETECELLPHONETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextView = (UITextView *)[self.view viewWithTag:ATHLETEHEIGHTTAG];
                [lObjTextView becomeFirstResponder];
                lObjTextView = (UITextView *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEHEIGHTTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEWEIGHTTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEWEIGHTTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEWINGSPANTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEWINGSPANTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEREACHTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEREACHTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESHOESIZETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            
            break;
        default:
            break;
    }
}
#if 0
-(void)showCustomDoneButton:(UITextField *)textField
{
	gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = nil;
   
    gObjAppDelegatePtr.m_cObjNumkeyPadString = @"NEXT";
    if (textField.tag == ATHLETEPHONETAG || textField.tag == ATHLETECELLPHONETAG || textField.tag == ATHLETEZIPTAG || textField.tag == ATHLETEHEIGHTTAG || textField.tag == ATHLETEWEIGHTTAG || textField.tag == ATHLETESHOESIZETAG || textField.tag == ATHLETEWINGSPANTAG || textField.tag == ATHLETEREACHTAG || textField.tag == ATHLETEUIDTAG)
    { 
        
	}
}
#endif

-(void)keyBoardCustomDoneButtonClicked:(UITextField *)textField
{
    UITextField *lObjTextFieldPtr = (UITextField *)nil;
    UITextView *lObjTextViewPtr = (UITextView *)nil;
    if(textField.tag == ATHLETEPHONETAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETECELLPHONETAG];
        [lObjTextFieldPtr becomeFirstResponder]; 
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETECELLPHONETAG)
    {
        [textField resignFirstResponder];
        lObjTextViewPtr = (UITextView *)[self.view viewWithTag:ATHLETEHEIGHTTAG];
        [lObjTextViewPtr becomeFirstResponder];
        lObjTextViewPtr = (UITextView *)nil;
    }
    else if(textField.tag == ATHLETEZIPTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEPHONETAG];
        [lObjTextFieldPtr becomeFirstResponder]; 
        lObjTextFieldPtr = (UITextField *)nil;
       }
    else if(textField.tag == ATHLETEHEIGHTTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEWEIGHTTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETEWEIGHTTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEWINGSPANTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETEWINGSPANTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEREACHTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETEREACHTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETESHOESIZETAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    
    
}

-(void)validateFields:(UITextField *)pObjTextFieldPtr
{
    NSString *lObjStrPtr = (NSString *)nil;
    lObjStrPtr = [pObjTextFieldPtr.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(pObjTextFieldPtr.tag == ATHLETEFIRSTNAMETAG)
    {
        if(0 >= lObjStrPtr.length)
        {
            IsFirstNameValidationSuccess = NO;
        }
        else
            IsFirstNameValidationSuccess = YES;
    }
    else if(pObjTextFieldPtr.tag == ATHLETELASTNAMETAG)
    {
        if(0 >= lObjStrPtr.length)
        {
            IsLastNameValidationSuccess = NO;
        }
        else
            IsLastNameValidationSuccess = YES;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger lRow = -1;
    if(pickerView.tag == ATHLETE_GENDER_PICKER_FOREDT)
    {
        lRow = [self.m_cGenderArrayPtr count];
    }
    else if(pickerView.tag == ATHLETEADDPICKERTAG)
    {
        lRow = [m_cObjSportsListPtr count];
    }
    else if(pickerView.tag == ATHLETEADDDOBPICKERTAG)
    {
        if(component == 0)
        {
            lRow = [self.m_cObjMonthArrayPtr count];
        }
        else if(component == 1)
        {
            lRow = [self.m_cObjDateArrayPtr count];
        }
        else if(component == 2)
        {
            lRow = [self.m_cObjYearArrayPtr count];
        }
    }
    return lRow;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger lComponents = -1;
    if(pickerView.tag == ATHLETE_GENDER_PICKER_FOREDT)
    {
        lComponents = 1;
    }
    else if(pickerView.tag == ATHLETEADDPICKERTAG)
    {
        lComponents = 1;
    }
    else if(pickerView.tag == ATHLETEADDDOBPICKERTAG)
    {
        lComponents = 3;
    }
    return lComponents;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *lObjTitlePtr = (NSString *)nil;
    if(pickerView.tag == ATHLETE_GENDER_PICKER_FOREDT)
    {
        lObjTitlePtr = [self.m_cGenderArrayPtr objectAtIndex:row];
    }
    else if(pickerView.tag == ATHLETEADDPICKERTAG)
    {
        lObjTitlePtr = [m_cObjSportsListPtr objectAtIndex:row];
    }
    else if(pickerView.tag == ATHLETEADDDOBPICKERTAG)
    {
        if(component == 0)
        {
            lObjTitlePtr = [self.m_cObjMonthArrayPtr objectAtIndex:row];
        }
        else if(component == 1)
        {
            lObjTitlePtr = [self.m_cObjDateArrayPtr objectAtIndex:row];
        }
        else if(component == 2)
        {
            lObjTitlePtr = [self.m_cObjYearArrayPtr objectAtIndex:row];
        }
    }
    return lObjTitlePtr;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == ATHLETE_GENDER_PICKER_FOREDT)
    {
        m_cObjActiveTextFieldPtr.text = [self.m_cGenderArrayPtr objectAtIndex:row];
    }
    else if(pickerView.tag == ATHLETEADDPICKERTAG)
    {
        m_cObjActiveTextFieldPtr.text = [self.m_cObjSportsListPtr objectAtIndex:row];
    }
    else if(pickerView.tag == ATHLETEADDDOBPICKERTAG)
    {
        if(component == 0)
        {
            self.m_cObjMonthPtr = [self.m_cObjMonthArrayPtr objectAtIndex:row];
        }
        else if(component == 1)
        {
            self.m_cObjDayPtr = [self.m_cObjDateArrayPtr objectAtIndex:row];
        }
        else if(component == 2)
        {
            self.m_cObjYearPtr = [self.m_cObjYearArrayPtr objectAtIndex:row];
        }
        m_cObjActiveTextFieldPtr.text = [NSString stringWithFormat:@"%@/%@/%@",self.m_cObjMonthPtr,self.m_cObjDayPtr,self.m_cObjYearPtr];
    }
}
-(void)onPickerDoneBtnClicked : (id)sender
{

        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            CGFloat lOffset;
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                lOffset = -63;
            }
            else
            {
                lOffset = 0;
            }
            
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            m_cObjLowerTableViewPtr.contentInset = contentInsets;
            m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
            m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 1930);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:NO];
            [UIView commitAnimations];
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.4f];
            m_cObjScrollViewPtr.contentSize = CGSizeMake(320, 1750);
            m_cObjScrollViewPtr.contentOffset = CGPointMake(0, 0);
           
            [UIView commitAnimations];
        }
        
   // }
    if(m_cObjActiveTextFieldPtr != (UITextField *)nil)
    {
        
        [m_cObjActiveTextFieldPtr resignFirstResponder];
    }
    
    if(IsTextView == YES)
    {
        UITextView *lObjTextView = (UITextView *)nil;
        lObjTextView = (UITextView *)[self.view viewWithTag:ATHLETEADDRESSTAG];
        [lObjTextView resignFirstResponder];
    }
   
    
}

-(void)createTopToolBar
{
     
    m_cObjToolBarPtr = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, 372.0, self.view.frame.size.width, 44.0)];
    m_cObjToolBarPtr.barStyle = UIBarStyleBlack;
    [self.view addSubview:m_cObjToolBarPtr];
    
    
    UIBarButtonItem *lObjFlexBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (gObjAppDelegatePtr.IsinFavourites == 1)
        lObjAddFavButton = [[UIBarButtonItem alloc]initWithTitle:@"Remove From Favorite" style:UIBarButtonItemStyleBordered target:self action:@selector(onAddOrRemoveFromFacButtonPressed:)];
    else if (gObjAppDelegatePtr.IsinFavourites == 0)
        lObjAddFavButton = [[UIBarButtonItem alloc]initWithTitle:@"Add To Favorite" style:UIBarButtonItemStyleBordered target:self action:@selector(onAddOrRemoveFromFacButtonPressed:)];
    
    
    [m_cObjToolBarPtr setItems:[NSArray arrayWithObjects:lObjFlexBtn,lObjAddFavButton , nil]];
    
     SAFE_RELEASE(lObjFlexBtn)

    
 
 }
-(void)onAddOrRemoveFromFacButtonPressed :(id)sender
{
    UIAlertView *lObjAlertView = (UIAlertView *)nil;
    
    if ([lObjAddFavButton.title isEqualToString:@"Add To Favorite"]) {
        BOOL lRetval = NO;
        self.m_cObjAthleteDetailsDataPtr.isFavouriteAthlete = 1;
        gObjAppDelegatePtr.IsinFavourites = 1;
        lRetval = [gObjAppDelegatePtr.m_cDbHandler insertToFavourites:self.m_cObjAthleteDetailsDataPtr];
        if (lRetval)
        {
            [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr addObject:self.m_cObjAthleteDetailsDataPtr];
            lObjAlertView = [[UIAlertView alloc]
                             initWithTitle:@"Athlete Logger"
                             message:@"The Athlete has been added successfully to the Favorite list"
                             delegate:self
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil, nil];
            lObjAlertView.tag = 502;
            [lObjAlertView show];
            SAFE_RELEASE(lObjAlertView)
        }
        else
        {
            lObjAlertView = [[UIAlertView alloc]
                             initWithTitle:@"Athlete Logger"
                             message:@"The Athlete could not be added to the Favorite list"
                             delegate:self
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil, nil];
            lObjAlertView.tag = 503;
            [lObjAlertView show];
            SAFE_RELEASE(lObjAlertView)
            
        }
    }
    else if ([lObjAddFavButton.title isEqualToString:@"Remove From Favorite"])
    {
        BOOL lRetval = NO;
        self.m_cObjAthleteDetailsDataPtr.isFavouriteAthlete = 0;
        gObjAppDelegatePtr.IsinFavourites = 0;
        lRetval = [gObjAppDelegatePtr.m_cDbHandler removeFromFavourites:self.m_cObjAthleteDetailsDataPtr];
        if (lRetval) {
            [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr removeObject:self.m_cObjAthleteDetailsDataPtr];
            lObjAlertView = [[UIAlertView alloc]
                             initWithTitle:@"Athlete Logger"
                             message:@"The Athlete has been removed successfully from the Favorite list"
                             delegate:self
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil, nil];
            lObjAlertView.tag = 504;
            [lObjAlertView show];
            SAFE_RELEASE(lObjAlertView)
        }
        else{
            lObjAlertView = [[UIAlertView alloc]
                             initWithTitle:@"Athlete Logger"
                             message:@"The Athlete could not be removed from the Favorite list"
                             delegate:self
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil, nil];
            lObjAlertView.tag = 505;
            [lObjAlertView show];
            SAFE_RELEASE(lObjAlertView)
        }
    }
}





- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    SAFE_RELEASE(m_cObjUpperTableViewPtr)
    SAFE_RELEASE(m_cObjLowerTableViewPtr)
    SAFE_RELEASE(m_cObjScrollViewPtr)
    SAFE_RELEASE(m_cImagePickerControllerPtr)
    SAFE_RELEASE(m_cObjAthleteDetailsDataPtr)
    SAFE_RELEASE(m_cObjPickerViewPtr)
    SAFE_RELEASE(m_cObjToolBarPtr)
    SAFE_RELEASE(m_cObjSportsListPtr)
    SAFE_RELEASE(m_cObjPickerToolBarPtr)
    SAFE_RELEASE(m_cObjSportNamePtr)
    SAFE_RELEASE(m_cObjSegementCtrlPtr)
    SAFE_RELEASE(m_cObjDOBPickerPtr)
    SAFE_RELEASE(m_cObjYearArrayPtr)
    SAFE_RELEASE(m_cObjMonthArrayPtr)
    SAFE_RELEASE(m_cObjDateArrayPtr)
    SAFE_RELEASE(m_cObjYearPtr)
    SAFE_RELEASE(m_cObjDayPtr)
    SAFE_RELEASE(m_cObjMonthPtr)
    SAFE_RELEASE(m_cObjImagePtr)
     SAFE_RELEASE(m_cObjGenderPickerViewForeidtPtr)
    [super dealloc];
}

@end
