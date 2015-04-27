//
//  SettingsViewController.h
//  KiWi
//
//  Created by Kapil Gowru on 4/8/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

- (IBAction)logOutButton:(id)sender;

@end
