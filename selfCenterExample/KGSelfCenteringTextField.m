//
//  KGSelfCenteringTextField.m
//  LucidDream
//
//  Created by kris gellci on 12/7/13.
//  Copyright (c) 2013 kris gellci. All rights reserved.
//

#import "KGSelfCenteringTextField.h"

@implementation KGSelfCenteringTextField {
    CGSize keyboardSize;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:Nil];
}

- (void) centerSelf {
    UIScrollView *scrollView;
    UIView *superView = self.superview;
    
    // Search for a scrollview
    while (superView) {
        if ([superView isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)superView;
            break;
        } else {
            superView = superView.superview;
        }
    }
    
    // If a scrollView is found, set the proper offset
    if (scrollView) {
        [self centerTextfieldWithScrollView:scrollView];
    } else {
        NSLog(@"Error: This textView is not nested in a scrollView");
    }
}

- (void) centerTextfieldWithScrollView:(UIScrollView *) scrollView {
    // Get the scrollview size after we remove the keyboard and any toolbar sizes
    int visibleScreenHeight = scrollView.frame.size.height;
    visibleScreenHeight -= keyboardSize.height;
    
    // get the needed offset to center the textfield
    CGPoint translatedTextViewPosition = [self convertPoint:self.frame.origin toView:scrollView];
    int offset = (translatedTextViewPosition.y + self.frame.size.height/2) -visibleScreenHeight;
    
    // make sure the content does not scroll too high
    if (offset > scrollView.contentSize.height - scrollView.frame.size.height) {
        offset = scrollView.contentSize.height - scrollView.frame.size.height;
    }
    
    // make sure the content does not scroll too low
    if (offset < -scrollView.contentInset.top) {
        offset = -scrollView.contentInset.top;
    }
    
    // animate the scrollview
    [UIView animateWithDuration:0.25f animations:^{
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, offset);
    }];
}

#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification *)notification
{
    // Get the size of the keyboard.
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}

@end
