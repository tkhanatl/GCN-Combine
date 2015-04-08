//
//  SplashImageViewController.m
//  GCN Combine
//
//  Created by Debi Samantrai on 16/01/13.
//  Copyright (c) 2013 DP Samantrai. All rights reserved.
//

#import "SplashImageViewController.h"
#import "AppDelegate.h"
#import "Macros.h"

@implementation SplashImageViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        m_cObjSplashImageViewPtr = (UIImageView *)nil;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    m_cObjSplashImageViewPtr=[[UIImageView alloc]initWithImage:
                              [UIImage imageNamed:@"Homescreen320x480.png"]];
   
	
    m_cObjSplashImageViewPtr.center= gObjAppDelegatePtr.m_cObjWindowPtr.center;
	[gObjAppDelegatePtr.m_cObjWindowPtr addSubview:m_cObjSplashImageViewPtr];
    
    m_cObjSplashImageViewPtr.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:2];
    m_cObjSplashImageViewPtr.transform = CGAffineTransformMakeScale(1.0,1.0);
	m_cObjSplashImageViewPtr.alpha = 1.0;
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	[UIView commitAnimations];
}

-(void)animationDidStop
{
    //To display Splash Screen atleast for 2 Seconds
    sleep(2);
    //To SetUp Main Screen
    [gObjAppDelegatePtr displayLoginPage];
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
    SAFE_RELEASE(m_cObjSplashImageViewPtr)
    [super dealloc];
}

@end
