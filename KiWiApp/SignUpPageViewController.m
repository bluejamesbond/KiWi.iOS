//
//  SignUpPageViewController.m
//  KiWi
//
//  Created by Kapil Gowru on 4/2/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "SignUpPageViewController.h"

#import "GlobalVars.h"

@interface SignUpPageViewController ()

@end

@implementation SignUpPageViewController{
    GlobalVars *globals;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.userNameField.background = [UIColor]
    globals = [GlobalVars sharedInstance];
    
    self.view.backgroundColor = globals.DARKBLUE_COLOR;
    
    self.userNameField.backgroundColor = globals.DARKBLUE_COLOR;
    self.userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: globals.LIGHTGRAY_COLOR, NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaT-Thin" size:15.0]}];
    self.userNameField.textAlignment = NSTextAlignmentRight;
    
    self.passwordField.backgroundColor = globals.DARKBLUE_COLOR;
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: globals.LIGHTGRAY_COLOR, NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaT-Thin" size:15.0]}];
    self.passwordField.textAlignment = NSTextAlignmentLeft;
    self.passwordField.secureTextEntry = YES;
    
    self.firstNameField.backgroundColor = globals.DARKBLUE_COLOR;
    self.firstNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: globals.LIGHTGRAY_COLOR, NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaT-Thin" size:15.0]}];
    self.firstNameField.textAlignment = NSTextAlignmentRight;
    
    self.lastNameField.backgroundColor = globals.DARKBLUE_COLOR;
    self.lastNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: globals.LIGHTGRAY_COLOR, NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaT-Thin" size:15.0]}];
    self.lastNameField.textAlignment = NSTextAlignmentLeft;
    
    self.emailField.backgroundColor = globals.DARKBLUE_COLOR;
    self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: globals.LIGHTGRAY_COLOR, NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaT-Thin" size:15.0]}];
    self.emailField.textAlignment = NSTextAlignmentCenter;
    
    self.phoneNumberField.backgroundColor = globals.DARKBLUE_COLOR;
    self.phoneNumberField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: globals.LIGHTGRAY_COLOR, NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaT-Thin" size:15.0]}];
    self.phoneNumberField.textAlignment = NSTextAlignmentCenter;
    
    self.signUpButton.layer.borderColor = globals.BRIGHTBLUE_COLOR.CGColor;
    self.signUpButton.layer.borderWidth = 1.0;
    self.signUpButton.layer.cornerRadius = 5;
    [self.signUpButton setBackgroundColor:globals.BRIGHTBLUE_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUpButton:(id)sender {
    BOOL errorShow = NO;
    NSString *errorMessage = nil;
    int errorCount = 0;

    if (self.passwordField.text.length == 0){
        errorShow = YES;
        errorMessage = [NSString stringWithFormat:@"Password field is empty"];
        errorCount++;
    }
    if (self.userNameField.text.length == 0){
        errorShow = YES;
        errorMessage = [NSString stringWithFormat:@"Username field is empty"];
        errorCount++;
    }
    if (self.firstNameField.text.length == 0){
        errorShow = YES;
        errorMessage = [NSString stringWithFormat:@"First Name field is empty"];
        errorCount++;
    }
    if (self.lastNameField.text.length == 0){
        errorShow = YES;
        errorMessage = [NSString stringWithFormat:@"Last Name field is empty"];
        errorCount++;
    }
    if (self.emailField.text.length == 0){
        errorShow = YES;
        errorMessage = [NSString stringWithFormat:@"Email field is empty"];
        errorCount++;
    }
    if (self.phoneNumberField.text.length == 0){
        errorShow = YES;
        errorMessage = [NSString stringWithFormat:@"Phone field is empty"];
        errorCount++;
    }
    
    if(errorCount > 1){
        errorMessage = [NSString stringWithFormat:@"More than one field is empty"];
    }
    
    if(errorShow){
        UIAlertView *userNameFieldEmpty = [[UIAlertView alloc]
                                           initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [userNameFieldEmpty show];
        return;
    }
    
    if(!errorShow){
        NSString *restCallString = [NSString stringWithFormat:@"%@rest/account/create?client_id=dev&name[first]=%@&name[last]=%@&username=%@&password=%@&email=%@&mobile=%@",globals.serverURL, self.firstNameField.text, self.lastNameField.text, self.userNameField.text, self.passwordField.text, self.emailField.text, self.phoneNumberField.text];
        NSURL *restURL = [NSURL URLWithString:restCallString];
        NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
        if (currentConnection){
            [currentConnection cancel];
            currentConnection = nil;
            self.apiReturnJSONDictionary = nil;
        }
        currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    }
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection with the KiWi main frame has failed");
    currentConnection = nil;
    
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    NSLog([NSString stringWithUTF8String:[data bytes]]);
    
    NSError *error = [NSError errorWithDomain:@"Invalid JSON data, could not be seralized." code:200 userInfo:nil];
    self.apiReturnJSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    
    NSLog(@"My JSON is %@", self.apiReturnJSONDictionary);
    //    self.authenticatedToken = [[self.apiReturnJSONDictionary objectForKey:@"data"] objectForKey:@"token"];
    //    NSLog(@"My data token is %@", self.authenticatedToken);
    //
    //    self.authenticatedSocketSecret = [[self.apiReturnJSONDictionary objectForKey:@"data"] objectForKey:@"secret"];
    
    
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    self.apiReturnJSONDictionary = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    currentConnection = nil;
}


@end

