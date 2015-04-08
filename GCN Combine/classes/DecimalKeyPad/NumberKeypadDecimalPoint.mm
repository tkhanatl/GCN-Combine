//
//  DecimalPointButton.m
//  GCN Combine
//
//  Created by DP Samantrai on 01/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NumberKeypadDecimalPoint.h"
#import "Macros.h"
#import "AppDelegate.h"

static UIImage *backgroundImageDepressed;

/**
 *
 */
@implementation DecimalPointButton


+ (void) initialize 
{
	backgroundImageDepressed = [[[UIImage imageNamed:@"decimalKeyDownBackground.png"] retain] autorelease];
}

- (id) init 
{
	if(self = [super initWithFrame:CGRectMake(0, 480, 105, 53)]) 
    {
		
		self.titleLabel.font = [UIFont systemFontOfSize:20];
		[self setTitleColor:[UIColor colorWithRed:77.0f/255.0f green:84.0f/255.0f blue:98.0f/255.0f alpha:1.0] forState:UIControlStateNormal];	
		[self setBackgroundImage:backgroundImageDepressed forState:UIControlStateHighlighted];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitle:gObjAppDelegatePtr.m_cObjNumkeyPadString forState:UIControlStateNormal];

	}
	return self;
}

- (void)drawRect:(CGRect)rect 
{
	[super drawRect:rect];
	
	//Bring in the button at same speed as keyboard
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2]; //we lose 0.1 seconds when we display it with timer
	self.frame = CGRectMake(0, 427, 105, 53);
	[UIView commitAnimations];
}

+ (DecimalPointButton *) decimalPointButton 
{
    
	DecimalPointButton *lButton = [[DecimalPointButton alloc] init];
	return [lButton autorelease];
}

@end

/**
 *
 */

@implementation NumberKeypadDecimalPoint

static NumberKeypadDecimalPoint *keypad;

@synthesize decimalPointButton,showDecimalPointTimer,currentTextField;

@synthesize delegate;
-(id<NumberKeyPadDelegate>)delegate
{
	return delegate;
}
-(void)setDelegate:(id<NumberKeyPadDelegate>)del
{
	delegate = del;
}

#pragma mark -
#pragma mark Release

- (void) dealloc 
{
    SAFE_RELEASE(decimalPointButton)
    SAFE_RELEASE(showDecimalPointTimer)
    
	[super dealloc];
}

- (void) addButtonToKeyboard:(DecimalPointButton *)button 
{	
	//Add a button to the top, above all windows
	NSArray *allWindows = [[UIApplication sharedApplication] windows];
	int topWindow = [allWindows count] - 1;
	UIWindow *keyboardWindow = [allWindows objectAtIndex:topWindow];
	[keyboardWindow addSubview:button];	
}

- (void) addTheDecimalPointToKeyboard 
{	
	[keypad addButtonToKeyboard:keypad.decimalPointButton];
}

- (void) decimalPointPressed 
{
	[delegate keyBoardCustomDoneButtonClicked:keypad.currentTextField];
}

/*
 Show the keyboard
 */
+ (NumberKeypadDecimalPoint *) keypadForTextField:(UITextField *)textField 
{
    keypad = (NumberKeypadDecimalPoint *)nil;
	if ((NumberKeypadDecimalPoint *)nil == keypad) 
    {
		keypad = [[NumberKeypadDecimalPoint alloc] init];
		keypad.decimalPointButton = [DecimalPointButton decimalPointButton];
        keypad.decimalPointButton.titleLabel.text = gObjAppDelegatePtr.m_cObjNumkeyPadString;
		[keypad.decimalPointButton addTarget:keypad action:@selector(decimalPointPressed) forControlEvents:UIControlEventTouchUpInside];
	}
	keypad.currentTextField = textField;
	keypad.showDecimalPointTimer = [NSTimer timerWithTimeInterval:0.1 target:keypad selector:@selector(addTheDecimalPointToKeyboard) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:keypad.showDecimalPointTimer forMode:NSDefaultRunLoopMode];
	
    return keypad;
}

/* Hide the keyboard*/
- (void) removeButtonFromKeyboard 
{ 
    if((NSTimer *)nil != showDecimalPointTimer)
    {
        [self.showDecimalPointTimer invalidate];
        SAFE_RELEASE(showDecimalPointTimer)
    }
	[self.decimalPointButton removeFromSuperview];
}


@end

