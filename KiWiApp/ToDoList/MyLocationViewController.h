//
//  MyLocationViewController.h
//  ToDoList
//
//  Created by Kapil Gowru on 2/16/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyLocationViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
extern CLLocationCoordinate2D initLocation;

- (IBAction)getMyLocation:(id)sender;

@end
