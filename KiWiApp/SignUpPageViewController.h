//
//  SignUpPageViewController.h
//  KiWi
//
//  Created by Kapil Gowru on 4/2/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpPageViewController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate>{
    NSURLConnection *currentConnection;
}

@property (weak, nonatomic) NSDictionary *apiReturnJSONDictionary;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)cancelButton:(id)sender;

- (IBAction)signUpButton:(id)sender;



@end
