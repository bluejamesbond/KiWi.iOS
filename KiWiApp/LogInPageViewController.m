//
//  LogInPageViewController.m
//  KiWi
//
//  Created by Kapil Gowru on 4/1/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "LogInPageViewController.h"
#import "GlobalVars.h"
//#import "HomePageViewController.h"
#import "SWRevealViewController.h"

@interface LogInPageViewController ()

@end

@implementation LogInPageViewController{
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
    self.userNameField.textAlignment = NSTextAlignmentCenter;
    
    self.passwordField.backgroundColor = globals.DARKBLUE_COLOR;
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: globals.LIGHTGRAY_COLOR, NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaT-Thin" size:15.0]}];
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.passwordField.secureTextEntry = YES;
    
    
    self.logInButton.layer.borderColor = globals.BRIGHTBLUE_COLOR.CGColor;
    [self.logInButton setTitleColor:globals.BRIGHTBLUE_COLOR forState:UIControlStateNormal];
    self.logInButton.layer.borderWidth = 1.0;
    self.logInButton.layer.cornerRadius = 5;
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

- (IBAction)logInButton:(id)sender {
    BOOL errorShow = NO;
    NSString *errorMessage = nil;
    if(self.passwordField.text.length == 0 && self.userNameField.text.length == 0 ){
        errorShow = YES;
        errorMessage = [NSString stringWithFormat:@"Username and password field are both empty"];
    } else if (self.passwordField.text.length == 0){
        errorShow = YES;
        errorMessage = [NSString stringWithFormat:@"Password field is empty"];
    } else if (self.userNameField.text.length == 0){
        errorShow = YES;
        errorMessage = [NSString stringWithFormat:@"Username field is empty"];
    }
    
    if(errorShow){
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                           initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlertView show];
        return;
    }
    
    NSString *restCallString = [NSString stringWithFormat:@"%@rest/account/login?client_id=dev&username=%@&password=%@", globals.serverURL, self.userNameField.text, self.passwordField.text];
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    if (currentConnection){
        [currentConnection cancel];
        currentConnection = nil;
        self.apiReturnJSONDictionary = nil;
    }
    currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection with the KiWi main frame has failed");
    UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"Error" message:@"Connection with the KiWi server has failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlertView show];
    currentConnection = nil;
    return;
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
    
    
    if(self.apiReturnJSONDictionary != nil)
        [self checkLoginResponse:self.apiReturnJSONDictionary];
    else{
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"Error" message:@"Login failed. Server is down." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlertView show];
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    self.apiReturnJSONDictionary = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    currentConnection = nil;
}

- (void)checkLoginResponse:(NSDictionary*)response {
    NSString *authenticatedToken = [[response objectForKey:@"data"] objectForKey:@"token"];
    if(authenticatedToken.length != 0 && authenticatedToken != nil){
        NSLog(@"Authenticated Token: %@", authenticatedToken);
        globals.authenticatedToken = authenticatedToken;
        globals.firstName = [[[[response objectForKey:@"data"] objectForKey:@"account"] objectForKey:@"name"]objectForKey:@"first"];
        globals.lastName = [[[[response objectForKey:@"data"] objectForKey:@"account"] objectForKey:@"name"]objectForKey:@"last"];
        globals.email = [[[response objectForKey:@"data"] objectForKey:@"account"]objectForKey:@"email"];
        globals.phoneNumber = [[[response objectForKey:@"data"] objectForKey:@"account"] objectForKey:@"mobile"];
        
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        NSMutableArray *user = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        if(user.count == 1){
            NSManagedObject *thisUser = [user objectAtIndex:0];
            [thisUser setValue:globals.firstName forKey:@"firstName"];
            [thisUser setValue:globals.lastName forKey:@"lastName"];
            [thisUser setValue:globals.email forKey:@"email"];
            [thisUser setValue:globals.phoneNumber forKey:@"phoneNumber"];
            [thisUser setValue:self.userNameField.text forKey:@"userName"];
            [thisUser setValue:self.passwordField.text forKey:@"password"];
        } else {
            NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
            [newUser setValue:globals.firstName forKey:@"firstName"];
            [newUser setValue:globals.lastName forKey:@"lastName"];
            [newUser setValue:globals.email forKey:@"email"];
            [newUser setValue:[NSString stringWithFormat:@"%@", globals.phoneNumber] forKey:@"phoneNumber"];
            [newUser setValue:self.userNameField.text forKey:@"userName"];
            [newUser setValue:self.passwordField.text forKey:@"password"];
            
            NSError *error;
            if (![managedObjectContext save:&error]) {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
                 */
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        
        
        
        SWRevealViewController *swRevealViewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"swRevealViewController"];
        [self presentViewController:swRevealViewController animated:YES completion:nil];
        
//        HomePageViewController *homePageViewController =
//        [self.storyboard instantiateViewControllerWithIdentifier:@"homePageViewController"];
//        [self presentViewController:homePageViewController animated:YES completion:nil];
////
//        UINavigationController *homePageViewNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"homePageViewNavigationController"];
//        [self presentViewController:homePageViewNavigationController animated:YES completion:nil];
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *homePageViewController = [storyboard instantiateViewControllerWithIdentifier:@"homePageViewController"];
//        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//        [(UINavigationController*) window.rootViewController pushViewController:homePageViewController animated:NO ];
        
    } else {
        UIAlertView *loginFailAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"Error" message:@"Login failed. Please check username and password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [loginFailAlertView show];
    }
}

- (NSManagedObjectContext * )managedObjectContext{
    NSManagedObjectContext *context= nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectModel)]){
        context = [delegate managedObjectContext];
    }
    return context;
}
@end
