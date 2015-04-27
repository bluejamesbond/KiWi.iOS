//
//  AccountViewController.m
//  KiWi
//
//  Created by Kapil Gowru on 3/25/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "AccountViewController.h"
#import "SWRevealViewController.h"
#import "GlobalVars.h"

@interface AccountViewController ()

@end

@implementation AccountViewController{
    GlobalVars *globals;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    globals = [GlobalVars sharedInstance];
    
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    self.sidebarButton.tintColor = globals.LIGHTGRAY_COLOR;
    
    self.saveButton.layer.borderColor = globals.BRIGHTBLUE_COLOR.CGColor;
    self.saveButton.layer.borderWidth = 1.0;
    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.adjustsImageWhenHighlighted = YES;
    [self.saveButton setTitleColor:globals.BRIGHTBLUE_COLOR forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.userAvatar.image = [UIImage imageNamed:@"UserProfileDefault.png"];
    
    self.view.backgroundColor = self.userNameTextField.backgroundColor = self.emailTextField.backgroundColor = self.phoneNumberTextField.backgroundColor = globals.DARKBLUE_COLOR;

    self.userNameTextField.text = [NSString stringWithFormat:@"%@ %@", globals.firstName, globals.lastName];
    self.emailTextField.text = [NSString stringWithFormat:@"%@", globals.email];
    self.phoneNumberTextField.text = [NSString stringWithFormat:@"%@", globals.phoneNumber];
    
    self.userNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    
    [self setTextFieldAppearance];
   
}

//Enables return button for keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - setting up text fields
- (void) doClear:(UIButton *) button{
    switch(button.tag){
        case 0:
            self.userNameTextField.text = @"";
            break;
        case 1:
            self.emailTextField.text = @"";
            break;
        case 2:
            self.phoneNumberTextField.text = @"";
            break;
    }
}

- (void) setTextFieldAppearance{
    //set text and tint color
    self.userNameTextField.textColor = self.userNameTextField.tintColor = self.emailTextField.textColor = self.emailTextField.tintColor = self.phoneNumberTextField.textColor = self.phoneNumberTextField.tintColor =  globals.LIGHTGRAY_COLOR;
    
    //create bottom border for each text field
    self.userNameTextField.layer.shadowOpacity = 0.0;
    self.userNameTextField.layer.shadowRadius = 0.0;
    self.userNameTextField.layer.shadowColor = [UIColor clearColor].CGColor;
    self.userNameTextField.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    
    CALayer *userBottomBorder = [CALayer layer];
    userBottomBorder.borderColor = globals.BRIGHTGREEN_COLOR.CGColor;
    userBottomBorder.borderWidth = 3;
    userBottomBorder.frame = CGRectMake(5.0f, self.userNameTextField.frame.size.height-2.0f, self.userNameTextField.frame.size.width - 10.0f,2.0f);
    CALayer *emailBottomBorder = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:userBottomBorder]];;
    CALayer *phoneBottomBorder = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:userBottomBorder]];;
    
    [self.userNameTextField.layer addSublayer:userBottomBorder];
    [self.emailTextField.layer addSublayer:emailBottomBorder];
    [self.phoneNumberTextField.layer addSublayer:phoneBottomBorder];
    
    //create clear buttons for each text field
    CGFloat myWidth = 26.0f;
    CGFloat myHeight = 30.0f;
    UIButton *myUserButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myWidth, myHeight)];
    UIButton *myEmailButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myWidth, myHeight)];
    UIButton *myPhoneButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myWidth, myHeight)];
    
    [myUserButton setImage:[UIImage imageNamed:@"ClearIcon.png"] forState:UIControlStateNormal];
    [myUserButton setImage:[UIImage imageNamed:@"ClearIcon.png"] forState:UIControlStateHighlighted];
    myUserButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 2.5, 7.5, 7.5);
    [myUserButton setTag:0];
    [myUserButton addTarget:self action:@selector(doClear:) forControlEvents:UIControlEventTouchUpInside];

    self.userNameTextField.rightView = myUserButton;
    self.userNameTextField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    [myEmailButton setImage:[UIImage imageNamed:@"ClearIcon.png"] forState:UIControlStateNormal];
    [myEmailButton setImage:[UIImage imageNamed:@"ClearIcon.png"] forState:UIControlStateHighlighted];
    myEmailButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 2.5, 7.5, 7.5);
    [myEmailButton setTag:1];
    [myEmailButton addTarget:self action:@selector(doClear:) forControlEvents:UIControlEventTouchUpInside];
    
    self.emailTextField.rightView = myEmailButton;
    self.emailTextField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    [myPhoneButton setImage:[UIImage imageNamed:@"ClearIcon.png"] forState:UIControlStateNormal];
    [myPhoneButton setImage:[UIImage imageNamed:@"ClearIcon.png"] forState:UIControlStateHighlighted];
    myPhoneButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 2.5, 7.5, 7.5);
    [myPhoneButton setTag:2];
    [myPhoneButton addTarget:self action:@selector(doClear:) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneNumberTextField.rightView = myPhoneButton;
    self.phoneNumberTextField.rightViewMode = UITextFieldViewModeWhileEditing;
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


- (IBAction)saveButton:(id)sender {
}

@end
