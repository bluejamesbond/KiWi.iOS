//
//  WelcomeViewController.h
//  KiWi
//
//  Created by Kapil Gowru on 4/1/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface WelcomeViewController : UIViewController < NSURLConnectionDelegate> {
    NSURLConnection *currentConnection;
}
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UILabel *suggestionText;

@property (strong) NSMutableArray *user;

@end
