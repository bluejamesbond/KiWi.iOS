//
//  LogInPageViewController.h
//  KiWi
//
//  Created by Kapil Gowru on 4/1/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface LogInPageViewController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate> {
    NSURLConnection *currentConnection;
}

@property (weak, nonatomic) NSDictionary *apiReturnJSONDictionary;

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

- (IBAction)cancelButton:(id)sender;
- (IBAction)logInButton:(id)sender;

@end
