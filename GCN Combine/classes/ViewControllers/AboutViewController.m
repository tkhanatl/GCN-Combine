//
//  AboutViewController.m
//  GCN Combine
//
//  Created by DP Samantrai on 29/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "AboutViewController.h"
#import "Macros.h"
#import "AppDelegate.h"

@implementation AboutViewController
@synthesize m_cObjToolBarPtr;
 

-(id)initWithTabBar
{
    self = [super init];
    if (self) 
    {
        UITabBarItem *lObjTabbarItem = (UITabBarItem *)nil;
        lObjTabbarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", @"") image:[UIImage imageNamed:NSLocalizedString(@"AboutLogo", @"")] tag:0];
        self.tabBarItem = lObjTabbarItem;
        self.tabBarController.navigationController.navigationBar.hidden = YES;
        self.title = NSLocalizedString(@"About", @"");
        SAFE_RELEASE(lObjTabbarItem)

        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"ABOUTSCREEN2320x480", @"")]];
   
    }
    return self;
}

-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
//    UIBarButtonItem *lObjHelpBtnPtr = (UIBarButtonItem *)nil;
//    lObjHelpBtnPtr = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Need Help", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(onHelpButtonPressed:)];
//    self.navigationItem.rightBarButtonItem = lObjHelpBtnPtr;
    [super viewDidLoad];
	[self createLabels];
    //[self createToolbar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled =YES;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    gObjAppDelegatePtr.isOfflineData = NO;
    gObjAppDelegatePtr.IsPendingImage = NO;
}


-(void)onBackButtonPressed :(id)sender
{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)createToolbar
{
    UIToolbar *lObjToolBarPtr = (UIToolbar *)nil;
    lObjToolBarPtr = [[UIToolbar alloc]init];
    self.m_cObjToolBarPtr = lObjToolBarPtr;
    SAFE_RELEASE(lObjToolBarPtr)
    self.m_cObjToolBarPtr.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);
    self.m_cObjToolBarPtr.barStyle = UIBarStyleBlack;
    [self.view addSubview:m_cObjToolBarPtr];
    
    UIBarButtonItem *lObjBackBtnPtr = (UIBarButtonItem *)nil;
    UIBarButtonItem *lObjFlexBtnPtr = (UIBarButtonItem *)nil;
    lObjBackBtnPtr = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onBackButtonPressed:)];
    lObjFlexBtnPtr = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    
    UILabel *lObjLabelPtr =[[UILabel alloc]initWithFrame:CGRectMake(115.0, 0.0, 90.0, 44.0)];  
    lObjLabelPtr.backgroundColor = [UIColor clearColor];
    lObjLabelPtr.font = [UIFont boldSystemFontOfSize:20];
    lObjLabelPtr.textColor = [UIColor whiteColor];
    lObjLabelPtr.text = @"About";
    [lObjLabelPtr setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:lObjLabelPtr];
    
    
    UIBarButtonItem *lObjMenuBtnPtr = (UIBarButtonItem *)nil;
    lObjMenuBtnPtr = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Need Help", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(onHelpButtonPressed:)];

    
    
    
    
    [self.m_cObjToolBarPtr setItems:[NSArray arrayWithObjects:lObjBackBtnPtr,lObjFlexBtnPtr,lObjMenuBtnPtr,nil]];
   
    SAFE_RELEASE(lObjMenuBtnPtr)
    SAFE_RELEASE(lObjBackBtnPtr)
    SAFE_RELEASE(lObjFlexBtnPtr)
    SAFE_RELEASE(lObjLabelPtr)
}
-(void)onHelpButtonPressed :(id)sender
{
    
}
 
-(void)createLabels
{

    UILabel             *lObjLabelPtr = (UILabel *)nil;
    CGRect              lRect = CGRectZero;
    lRect = CGRectMake(CGRectGetMinX(self.view.bounds) +SPACING*12,
                       CGRectGetMinY(self.view.bounds) +190, 
                       200,
                       SPACING *8);
    lObjLabelPtr =[[UILabel alloc]initWithFrame:lRect];  
    lObjLabelPtr.backgroundColor = [UIColor clearColor];
    lObjLabelPtr.text = @"School Name";
    lObjLabelPtr.font = [UIFont boldSystemFontOfSize:18];
    lObjLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
    lObjLabelPtr.numberOfLines = 2;
    [lObjLabelPtr setTextAlignment:UITextAlignmentCenter];   
    //[self.view addSubview:lObjLabelPtr];
    SAFE_RELEASE(lObjLabelPtr)
    
    lRect = CGRectMake(CGRectGetMinX(self.view.bounds) +SPACING*12,
                       CGRectGetMinY(self.view.bounds)+140,
                       200,
                       SPACING *11);
    lObjLabelPtr =[[UILabel alloc]initWithFrame:lRect];
    lObjLabelPtr.backgroundColor = [UIColor clearColor];
    lObjLabelPtr.font = [UIFont boldSystemFontOfSize:16];
    lObjLabelPtr.text = @"Copyright© 2005-2013";
    lObjLabelPtr.textColor=[UIColor whiteColor];
    [lObjLabelPtr setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:lObjLabelPtr];
    SAFE_RELEASE(lObjLabelPtr)
    
    lRect = CGRectMake(CGRectGetMinX(self.view.bounds) +SPACING*12,
                        CGRectGetMinY(self.view.bounds)+180,
                       200,SPACING *4);
    lObjLabelPtr =[[UILabel alloc]initWithFrame:lRect];  
    lObjLabelPtr.backgroundColor = [UIColor clearColor];
    lObjLabelPtr.font = [UIFont boldSystemFontOfSize:16];
    lObjLabelPtr.text = @"All rights reserved";
    lObjLabelPtr.textColor=[UIColor whiteColor];
    [lObjLabelPtr setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:lObjLabelPtr];
    SAFE_RELEASE(lObjLabelPtr)
    
    lRect = CGRectMake(CGRectGetMinX(self.view.bounds) +SPACING*12-5,
                      CGRectGetMinY(self.view.bounds)+205,
                       200,SPACING *4);
    lObjLabelPtr =[[UILabel alloc]initWithFrame:lRect];  
    lObjLabelPtr.backgroundColor = [UIColor clearColor];
    lObjLabelPtr.font = [UIFont boldSystemFontOfSize:16];
    lObjLabelPtr.text = @"GC Nation";
    lObjLabelPtr.textColor=[UIColor whiteColor];
    [lObjLabelPtr setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:lObjLabelPtr];
    SAFE_RELEASE(lObjLabelPtr)    
    
    NSString *lObjVersion = (NSString *)nil;
    lObjVersion = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    lRect = CGRectMake(CGRectGetMinX(self.view.bounds) +SPACING*12,
                        CGRectGetMinY(self.view.bounds)+230,
                       200,SPACING*3 );
    lObjLabelPtr =[[UILabel alloc]initWithFrame:lRect];
    lObjLabelPtr.backgroundColor = [UIColor clearColor];
    lObjLabelPtr.font = [UIFont boldSystemFontOfSize:16];
    lObjLabelPtr.text = lObjVersion;
    lObjLabelPtr.textColor=[UIColor whiteColor];
    [lObjLabelPtr setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:lObjLabelPtr];
    SAFE_RELEASE(lObjLabelPtr)
    
    
}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
  [super dealloc];
}

@end
