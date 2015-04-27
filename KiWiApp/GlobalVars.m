//
//  GlobalVars.m
//  KiWi
//
//  Created by Kapil Gowru on 4/1/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "GlobalVars.h"

@implementation GlobalVars

@synthesize PINK_COLOR;
@synthesize BACKGROUND_COLOR;
@synthesize GRAY_COLOR;

//new color scheme
@synthesize DARKBLUE_COLOR;
@synthesize BRIGHTBLUE_COLOR;
@synthesize BLACK_COLOR;
@synthesize LIGHTGRAY_COLOR;
@synthesize BRIGHTGREEN_COLOR;
@synthesize RED_COLOR;
@synthesize DARKGRAY_COLOR;

@synthesize serverURL;
@synthesize authenticatedToken;
@synthesize authenticatedSecret;
@synthesize lockId;

@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize phoneNumber;

@synthesize userName;
@synthesize password;


+ (GlobalVars *)sharedInstance {
    static dispatch_once_t onceToken;
    static GlobalVars *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalVars alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
//        _truckBoxes = [[NSMutableArray alloc] init];
//        _farmerlist = [[NSMutableArray alloc] init];
//        // Note these aren't allocated as [[NSString alloc] init] doesn't provide a useful object
//        _farmerCardNumber = nil;
//        _fName = ;
        float rd = 241.00/255.00;
        float gr = 94.00/255.00;
        float bl = 92.00/255.00;
        PINK_COLOR = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
        
        rd = 4.00/255.00;
        gr = 13.00/255.00;
        bl = 20.00/255.00;
        BACKGROUND_COLOR = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
        
        rd = 238.00/255.00;
        gr = 238.00/255.00;
        bl = 238.00/255.00;
        GRAY_COLOR = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];

        
        
        rd = 28.00/255.00;
        gr = 51.00/255.00;
        bl = 67.00/255.00;
        DARKBLUE_COLOR = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
        
        rd = 25.00/255.00;
        gr = 170.00/255.00;
        bl = 199.00/255.00;
        BRIGHTBLUE_COLOR = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
        
        rd = 18.00/255.00;
        gr = 16.00/255.00;
        bl = 32.00/255.00;
        BLACK_COLOR = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
        
        rd = 163.00/255.00;
        gr = 205.00/255.00;
        bl = 57.00/255.00;
        BRIGHTGREEN_COLOR = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
        
        rd = 240.00/255.00;
        gr = 243.00/255.00;
        bl = 244.00/255.00;
        LIGHTGRAY_COLOR = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
        
        rd = 223.00/255.00;
        gr = 100.00/255.00;
        bl = 67.00/255.00;
        RED_COLOR = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
        
        rd = 151.00/255.00;
        gr = 162.00/255.00;
        bl = 177.00/255.00;
        DARKGRAY_COLOR = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
        
        serverURL = @"http://kiwik.t.proxylocal.com/";
        
        lockId = nil;
        
        authenticatedToken = nil;
        authenticatedSecret = nil;
        
        firstName = nil;
        lastName = nil;
        email = nil;
        phoneNumber = nil;
        
        userName = nil;
        password = nil;
        
        
        
    }
    return self;
}
@end
