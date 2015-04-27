//
//  WelcomeViewController.m
//  KiWi
//
//  Created by Kapil Gowru on 4/1/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "WelcomeViewController.h"
#import "GlobalVars.h"
#import "SWRevealViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController{
    GlobalVars *globals;
}

//@synthesize welcomeLabel;
//@synthesize signUpButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString: @"Welcome to KiWi"];
//    [attrStr addAttribute:NSKernAttributeName value:@(2.0) range:NSMakeRange(0, attrStr.length)];
//    
//   // self.welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 300, 100)];
//    self.welcomeLabel.attributedText = attrStr;
//    [self.welcomeLabel setCenter:self.view.center];
    
    globals = [GlobalVars sharedInstance];
    
    self.view.backgroundColor = globals.BLACK_COLOR;
    
    self.signUpButton.layer.borderColor = globals.BRIGHTBLUE_COLOR.CGColor;
    self.signUpButton.layer.borderWidth = 1.0;
    self.signUpButton.layer.cornerRadius = 5;
    [self.signUpButton setBackgroundColor:globals.BRIGHTBLUE_COLOR];
    
    self.logInButton.layer.borderColor = globals.BRIGHTBLUE_COLOR.CGColor;
    [self.logInButton setTitleColor:globals.BRIGHTBLUE_COLOR forState:UIControlStateNormal];
    self.logInButton.layer.borderWidth = 1.0;
    self.logInButton.layer.cornerRadius = 5;
    
    
   
    
//    for(NSString *fontfamilyname in [UIFont familyNames])
//    {
//        NSLog(@"Family:'%@'",fontfamilyname);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//        NSLog(@"~~~~~~~~");
//    }


    
}

- (void)viewDidAppear:(BOOL)animated{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
   
//    NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
//    [newUser setValue:globals.firstName forKey:@"firstName"];
//    [newUser setValue:globals.lastName forKey:@"lastName"];
//    [newUser setValue:globals.email forKey:@"email"];
//    [newUser setValue:[NSString stringWithFormat:@"%@", globals.phoneNumber] forKey:@"phoneNumber"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    self.user = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(self.user.count != 0){
        NSManagedObject *thisUser = [self.user objectAtIndex:0];
        if(![[thisUser valueForKey:@"firstName"] isEqualToString:@""] && thisUser != nil){
            globals.firstName = [thisUser valueForKey:@"firstName"];
            globals.lastName = [thisUser valueForKey:@"lastName"];
            globals.email = [thisUser valueForKey:@"email"];
            globals.phoneNumber = [thisUser valueForKey:@"phoneNumber"];
            globals.userName = [thisUser valueForKey:@"userName"];
            globals.password = [thisUser valueForKey:@"password"];
            
            NSString *restCallString = [NSString stringWithFormat:@"%@rest/account/login?client_id=dev&username=%@&password=%@", globals.serverURL,globals.userName,globals.password];
            NSURL *restURL = [NSURL URLWithString:restCallString];
            NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
            if (currentConnection){
                [currentConnection cancel];
                currentConnection = nil;
            }
            currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];

            
            
        }
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
    NSDictionary *apiReturnJSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    
    NSLog(@"My JSON is %@", apiReturnJSONDictionary);
    //    self.authenticatedToken = [[self.apiReturnJSONDictionary objectForKey:@"data"] objectForKey:@"token"];
    //    NSLog(@"My data token is %@", self.authenticatedToken);
    //
    //    self.authenticatedSocketSecret = [[self.apiReturnJSONDictionary objectForKey:@"data"] objectForKey:@"secret"];
    
    
    if(apiReturnJSONDictionary != nil){
        globals.authenticatedToken = [[apiReturnJSONDictionary objectForKey:@"data"]objectForKey:@"token"];
        SWRevealViewController *swRevealViewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"swRevealViewController"];
        [self presentViewController:swRevealViewController animated:YES completion:nil];
    } else{
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"Error" message:@"Login failed. Server is down." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlertView show];
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    currentConnection = nil;
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

@end
