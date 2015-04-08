/*
 *
 *
 * File Name       : ActivityAlertView.h
 *
 * Created Date    : 12/17/2012
 * 
 * Description     : Common Activity Alert view class
 *
 
 */

#import <Foundation/Foundation.h>

@interface ActivityAlertView : UIView 
{
	UIActivityIndicatorView     *m_cObjActivityViewPtr;
    UILabel                     *m_cObjMsgLblPtr;
    UIButton                    *m_cObjCacelButtonPtr;
	
}
@property(nonatomic,retain) UIButton   *m_cObjCacelButtonPtr;

- (void)createTheProgressViewElements:(CGRect)frame;
- (void)startActivityIndicator:(NSString *)pObjMsgPtr;
- (void)close;
@end
