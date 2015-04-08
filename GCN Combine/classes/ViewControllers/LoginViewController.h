//
//  ViewController.h
//  GCN Combine
//
//  Created by DP Samantrai on 28/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerTransactionDelegate.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate,ServerTransactionDelegate>
{
    UITextField                 *m_cObjUserIDTextFieldPtr;
	UITextField                 *m_cObjPasswordTextFieldPtr;
    UIBarButtonItem              *lObjSignInButtonPtr;
}
@property (nonatomic,retain) UIBarButtonItem              *lObjSignInButtonPtr;
@property (nonatomic,retain) UITextField  *m_cObjUserIDTextFieldPtr;
@property (nonatomic,retain) UITextField  *m_cObjPasswordTextFieldPtr;

-(void)createLoginFields;
- (BOOL)validateTheFields;
-(void)OnSignInBtnClicked;
-(BOOL)validateEmail:(NSString *)pEmailText;

@end
