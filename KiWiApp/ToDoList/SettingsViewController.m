//
//  SettingsViewController.m
//  KiWi
//
//  Created by Kapil Gowru on 4/8/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController.h"
#import "GlobalVars.h"
#import "WelcomeViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController{
    GlobalVars *globals;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globals = [GlobalVars sharedInstance];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    self.logOutButton.layer.borderColor = globals.PINK_COLOR.CGColor;
    self.logOutButton.layer.borderWidth = 1.0;
    self.logOutButton.layer.cornerRadius = 5;
    [self.logOutButton setBackgroundColor:globals.PINK_COLOR];
    
    self.sidebarButton.tintColor = globals.PINK_COLOR;
    self.view.backgroundColor = globals.BACKGROUND_COLOR;
    
}

- (NSManagedObjectContext * )managedObjectContext{
    NSManagedObjectContext *context= nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectModel)]){
        context = [delegate managedObjectContext];
    }
    return context;
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

- (IBAction)logOutButton:(id)sender {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSMutableArray *user = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [managedObjectContext deleteObject:[user objectAtIndex:0]];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    WelcomeViewController *welcomeViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"welcomeViewController"];
    [self presentViewController:welcomeViewController animated:YES completion:nil];
    
}
@end
