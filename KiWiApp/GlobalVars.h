//
//  GlobalVars.h
//  KiWi
//
//  Created by Kapil Gowru on 4/1/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalVars : NSObject
{
//    UIColor *PINK_COLOR;
//    UIColor *BACKGROUND_COLOR;
//    UIColor *GRAY_COLOR;
    NSString *serverURL;
    
}

+ (GlobalVars *)sharedInstance;

@property (strong,retain,nonatomic) UIColor *PINK_COLOR;
@property (strong,retain,nonatomic) UIColor *BACKGROUND_COLOR;
@property (strong,retain,nonatomic) UIColor *GRAY_COLOR;

@property (strong,retain,nonatomic) UIColor *DARKBLUE_COLOR;
@property (strong,retain,nonatomic) UIColor *BRIGHTBLUE_COLOR;
@property (strong,retain,nonatomic) UIColor *BLACK_COLOR;
@property (strong,retain,nonatomic) UIColor *BRIGHTGREEN_COLOR;
@property (strong,retain,nonatomic) UIColor *LIGHTGRAY_COLOR;
@property (strong,retain,nonatomic) UIColor *RED_COLOR;
@property (strong,retain,nonatomic) UIColor *DARKGRAY_COLOR;

@property (strong,retain,nonatomic) NSString *serverURL;
@property (strong,retain,nonatomic) NSString *authenticatedToken;
@property (strong,retain,nonatomic) NSString *authenticatedSecret;
@property (strong,retain,nonatomic) NSString *lockId;

@property (strong,retain,nonatomic) NSString *firstName;
@property (strong,retain,nonatomic) NSString *lastName;
@property (strong,retain,nonatomic) NSString *email;
@property (strong,retain,nonatomic) NSString *phoneNumber;

@property (strong,retain,nonatomic) NSString *userName;
@property (strong,retain,nonatomic) NSString *password;


@end