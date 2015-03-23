//
//  ViewController.m
//  KiWI
//
//  Created by Kapil.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"KiWi";
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
