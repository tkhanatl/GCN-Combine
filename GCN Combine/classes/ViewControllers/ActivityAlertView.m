/*
 *
 * File Name       : ActivityAlertView.m
 *
 * Created Date    : 12/17/2012
 * 
 * Description     : Common Activity Alert view class
 *
 */

#import "ActivityAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "Macros.h"
#import "AppDelegate.h"


@implementation ActivityAlertView
@synthesize m_cObjCacelButtonPtr;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{     
    if ((self = [super initWithFrame:frame]))
	{
        m_cObjActivityViewPtr   = (UIActivityIndicatorView *)nil;
        m_cObjMsgLblPtr         = (UILabel *)nil;
        m_cObjCacelButtonPtr =(UIButton *)nil;
        
                
                
         //change the view color to transparent
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];    
        self.layer.cornerRadius = 10.0;
        self.userInteractionEnabled = YES;
        [self createTheProgressViewElements:frame];
    }	
    return self;
}

#pragma mark - User Defined methods

- (void)createTheProgressViewElements:(CGRect)pFrame
{
    CGRect lRect = CGRectZero;
    //UIButton *m_cObjCacelButtonPtr =(UIButton *)nil;
    
    //create label
    
    //activiy indicator    
    m_cObjActivityViewPtr = [[UIActivityIndicatorView alloc]
                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];	
    m_cObjActivityViewPtr.center = CGPointMake(CGRectGetMidX(self.bounds), 
                                                SPACING*4);
   // m_cObjActivityViewPtr.center = CGPointMake(CGRectGetMidX(self.bounds), 
                                               //CGRectGetMidY(self.bounds) - SPACING * 2);
    [self addSubview:m_cObjActivityViewPtr];
    m_cObjActivityViewPtr.autoresizingMask =    UIViewAutoresizingFlexibleLeftMargin |
                                                UIViewAutoresizingFlexibleRightMargin |
                                                UIViewAutoresizingFlexibleTopMargin |
                                                UIViewAutoresizingFlexibleBottomMargin;
    m_cObjActivityViewPtr.alpha = 1.0;
m_cObjActivityViewPtr.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    lRect = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(m_cObjActivityViewPtr.frame)+SPACING * 3, CGRectGetWidth(self.bounds)-SPACING*2, SPACING*6);
    m_cObjMsgLblPtr = [[UILabel alloc]initWithFrame:lRect];
    m_cObjMsgLblPtr.textColor = [UIColor whiteColor];
    m_cObjMsgLblPtr.textAlignment = UITextAlignmentCenter;
    m_cObjMsgLblPtr.font = [UIFont boldSystemFontOfSize:12.0];
    m_cObjMsgLblPtr.numberOfLines = 0;
    m_cObjMsgLblPtr.lineBreakMode = UILineBreakModeWordWrap;
    m_cObjMsgLblPtr.backgroundColor = [UIColor clearColor];
    m_cObjMsgLblPtr.alpha = 1.0;
    m_cObjMsgLblPtr.center = CGPointMake(self.center.x, m_cObjMsgLblPtr.center.y);
   [self addSubview:m_cObjMsgLblPtr];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;//sougata addedd this on 8/8/13
    
    m_cObjCacelButtonPtr = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_cObjCacelButtonPtr setFrame:CGRectMake(48, CGRectGetMaxY(m_cObjMsgLblPtr.bounds)+55, 80, 25.0f)];
    
    [m_cObjCacelButtonPtr setBackgroundImage:[UIImage imageNamed:@"CancelBtn.png"] forState:UIControlStateNormal];
    
    [m_cObjCacelButtonPtr setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [m_cObjCacelButtonPtr addTarget:self action:@selector(OnCancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    m_cObjCacelButtonPtr.titleLabel.textColor= [UIColor blackColor];
    //[self addSubview:m_cObjCacelButtonPtr];
}

- (void)startActivityIndicator:(NSString *)pObjMsgPtr 
{
    m_cObjMsgLblPtr.text = pObjMsgPtr;
    [m_cObjActivityViewPtr startAnimating];
    
}
-(void)OnCancelButtonPressed:(id)sender
{
    [gObjAppDelegatePtr stopProgressHandler];
    NSLog(@"%@",gObjAppDelegatePtr.m_cObjHttpHandlerPtr);
    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr cancelDownload];
}

- (void)close
{ 
    [m_cObjActivityViewPtr stopAnimating];    
}


#pragma mark - Memory management
- (void)dealloc
{ 	
	SAFE_RELEASE(m_cObjActivityViewPtr)
    SAFE_RELEASE(m_cObjMsgLblPtr)
    
	[super dealloc];
}

@end
