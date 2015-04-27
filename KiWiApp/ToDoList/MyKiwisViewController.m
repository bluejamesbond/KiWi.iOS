//
//  MyLocationViewController.m
//  ToDoList
//
//  Created by Kapil Gowru on 2/16/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "MyKiwisViewController.h"
#import "SWRevealViewController.h"
#import "GlobalVars.h"

#define METERS_PER_MILE 1609.344
#define CIRCLE_RADIUS 10
#define INIT_LATITUDE 30.288503
#define INIT_LONGITUDE -97.744611

@interface MyKiwisViewController ()

@end

@implementation MyKiwisViewController {
    CLLocationManager *locationManager;
    CLGeocoder *geoCoder;
    CLPlacemark *placeMark;
    GlobalVars *globals;
    
}
    CLLocationCoordinate2D initLocation = {0};
    bool isWithinCircle;
    bool isFirstCheckInCircle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globals = [GlobalVars sharedInstance];
    self.view.backgroundColor = globals.BACKGROUND_COLOR;
    
    locationManager = [[CLLocationManager alloc] init];
    geoCoder = [[CLGeocoder alloc] init];
    [locationManager requestWhenInUseAuthorization];
    self.mapView.delegate = self;

    //initLocation = [[CLLocationCoordinate2D alloc] init];
    //isWithinCircle = YES;
    isWithinCircle = YES;
    isFirstCheckInCircle = YES;
    
    //self.title = @"KiWi";
   
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    self.longitudeLabel.textColor = globals.PINK_COLOR;
    self.longitudeText.textColor = globals.PINK_COLOR;
    self.latitudeLabel.textColor = globals.PINK_COLOR;
    self.latitudeText.textColor = globals.PINK_COLOR;
    [self.getLocationButton setTitleColor:globals.PINK_COLOR forState:UIControlStateNormal];
    [self.getLocationButton setTitleColor:globals.GRAY_COLOR forState:UIControlStateHighlighted];
    
    self.sidebarButton.tintColor = globals.PINK_COLOR;
    
    initLocation.latitude = INIT_LATITUDE;
    initLocation.longitude = INIT_LONGITUDE;
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:initLocation radius:CIRCLE_RADIUS];
    [self.mapView addOverlay:circle];
}

//- (void)viewWillAppear:(BOOL)animated {
//    // 1
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = self.latitudeLabel.text.integerValue;
//    zoomLocation.longitude= self.longitudeLabel.text.integerValue;
//    NSLog(@"%@", self.longitudeLabel.text);
//    
//    // 2
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//    
//    // 3
//    [self.mapView setRegion:viewRegion animated:YES];
//}

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

- (IBAction)getMyLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1;
    
    [locationManager startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"didUpdateToLocation: %@", newLocation);
//    CLLocation *currentLocation = newLocation;
//    
//    if (currentLocation != nil) {
//        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//    }
//}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation;
    if (locations.count > 1) {
        oldLocation = [locations objectAtIndex:locations.count-2];
    } else {
        oldLocation = nil;
    }
    NSLog(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
//    MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500.0, 1500.0);
//    [regionsMapView setRegion:userLocation animated:YES];
    if(newLocation != nil){
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.longitude];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.latitude];
    }
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.latitudeLabel.text.floatValue;
    zoomLocation.longitude= self.longitudeLabel.text.floatValue;
    NSLog(@"(%@,"@"%@)", self.longitudeLabel.text, self.latitudeLabel.text);
    
    if(isFirstCheckInCircle == YES){
        if([self checkIfWithinCircle:zoomLocation] == YES){
            isWithinCircle = YES;
        } else isWithinCircle = NO;
    } else {
        if([self checkIfWithinCircle:zoomLocation] == YES && (isWithinCircle == NO)){
            UIAlertView *withinCircleAlert = [[UIAlertView alloc]
                                             initWithTitle:@"Welcome!" message:@"You are home, KiWi will promptly unlock." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [withinCircleAlert show];
            isWithinCircle = YES;

        }

        if([self checkIfWithinCircle:zoomLocation] == NO && (isWithinCircle == YES)){
            UIAlertView *outsideCircleAlert = [[UIAlertView alloc]
                                              initWithTitle:@"Goodbye!" message:@"KiWi will promptly lock behind  you. Safe travels. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [outsideCircleAlert show];
            isWithinCircle = NO;
            
        }
        isFirstCheckInCircle = NO;
    }
    
//    // 2
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//    
//    // 3
//    [self.mapView setRegion:viewRegion animated:YES];
    
    [self changeMapView:zoomLocation];
}

-(void)changeMapView:(CLLocationCoordinate2D)zoomLocation {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 100,100);
    [self.mapView setRegion:viewRegion animated:YES];
}

-(bool)checkIfWithinCircle:(CLLocationCoordinate2D)zoomLocation {
    MKMapPoint p1 = MKMapPointForCoordinate(zoomLocation);
    MKMapPoint p2 = MKMapPointForCoordinate(initLocation);
    CLLocationDistance dist = MKMetersBetweenMapPoints(p1, p2);
    
    if(dist < CIRCLE_RADIUS){
        return YES;
    } else return NO;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    
    //MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    float rd = 171.00/255.00;
    float gr = 183.00/255.00;
    float bl = 183.00/255.00;
    
    [circleView setFillColor:[UIColor colorWithRed:rd green:gr blue:bl alpha:0.5f]];
    [circleView setStrokeColor:[UIColor blackColor]];
    [circleView setAlpha:0.5f];
    [circleView setLineWidth:1.0f];
    return circleView;
}
@end
