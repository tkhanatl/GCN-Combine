//
//  DecimalPointButton.h
//  GCN Combine
//
//  Created by DP Samantrai on 01/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 *	The UIButton that will have the decimal point on it
 */
@interface DecimalPointButton : UIButton
{
	
}

+ (DecimalPointButton *) decimalPointButton;

@end


/**
 *	The class used to create the keypad
 */

@protocol NumberKeyPadDelegate

-(void)keyBoardCustomDoneButtonClicked:(UITextField*)textField;

@end


@interface NumberKeypadDecimalPoint : NSObject 
{
	
	UITextField *currentTextField;
	
	DecimalPointButton *decimalPointButton;
	
	NSTimer *showDecimalPointTimer;
    
    id<NumberKeyPadDelegate>delegate;
   
}

@property (assign) id<NumberKeyPadDelegate>delegate ;

@property (nonatomic, retain) NSTimer *showDecimalPointTimer;
@property (nonatomic, retain) DecimalPointButton *decimalPointButton;

@property (assign) UITextField *currentTextField;

#pragma mark -
#pragma mark Show the keypad

+ (NumberKeypadDecimalPoint *) keypadForTextField:(UITextField *)textField; 

- (void) removeButtonFromKeyboard;
- (void) addButtonToKeyboard:(DecimalPointButton *)button;

@end



