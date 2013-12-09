//
//  KGViewController.m
//  selfCenterExample
//
//  Created by Gellci, Kriser on 12/9/13.
//  Copyright (c) 2013 Gellci, Kris. All rights reserved.
//

#import "KGViewController.h"
#import "KGSelfCenteringTextField.h"

@interface KGViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet KGSelfCenteringTextField *field;

@end

@implementation KGViewController {
    CGSize keyboardSize;
    KGSelfCenteringTextField *focusedTextField;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    keyboardSize = CGSizeMake(0, 0);
    [self addToolBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:Nil];
}

// Adding a tool bar to the first field to show keyboard size changes between fields
- (void) addToolBar {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _field.inputAccessoryView = toolBar;
}

#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    focusedTextField = (KGSelfCenteringTextField *)textField;
    
    // if the keyboard height is set, means the keyboard has appeared and the scrollview content size was adjusted
    if (keyboardSize.height != 0) {
        [focusedTextField centerSelf];
    }
    
}

#pragma mark - Keyboard Notifications

- (void) keyboardWillShow:(NSNotification *) notification {
    NSDictionary *info = notification.userInfo;
    CGRect rect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Adjust the scrollview content size based the keyboard size change
    self.contentHeightConstraint.constant += (rect.size.height - keyboardSize.height);
    keyboardSize = CGSizeMake(keyboardSize.width, keyboardSize.height + (rect.size.height - keyboardSize.height));
    
    // Centering on a delay so the scrollView has time to animate itself
    [focusedTextField performSelector:@selector(centerSelf) withObject:Nil afterDelay:0.1f];
}

- (void) keyboardWillHide:(NSNotification *) notification {
    NSDictionary *info = notification.userInfo;
    CGRect rect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    keyboardSize = CGSizeMake(keyboardSize.width, keyboardSize.height - rect.size.height);
    
    // resetting the scrollViews content size when the keyboard leaves the screen
    self.contentHeightConstraint.constant -= rect.size.height;
}

@end
