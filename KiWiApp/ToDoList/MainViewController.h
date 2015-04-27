//
//  ViewController.h
//  KiWi
//
//  Created by Kapil.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface MainViewController : UIViewController <NSURLConnectionDelegate, SRWebSocketDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSURLConnection *currentConnection;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *restAPIResponse;
@property (weak, nonatomic) IBOutlet UIButton *shareKeyButton;

@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UILabel *lockButtonText;
@property (weak, nonatomic) IBOutlet UIProgressView *lockButtonProgressView;
@property (weak, nonatomic) IBOutlet UISwitch *lockSlider;


@property (weak, nonatomic) IBOutlet UISegmentedControl *logMapSelecter;

@property (weak, nonatomic) IBOutlet UITableView *logView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *kiwiNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *kiwiBatteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *kiwiStatusLabel;

@property (retain, nonatomic) NSMutableData *apiReturnXMLData;
@property (retain, nonatomic) NSDictionary *apiReturnJSONDictionary;
@property (retain, nonatomic) NSString *authenticatedToken;
@property (retain, nonatomic) NSString *authenticatedSocketSecret;

@property BOOL socketIsConnected;
@property NSMutableDictionary *pins;

- (IBAction)lockButtonTouchDown:(id)sender;
- (IBAction)lockButtonTouchUp:(id)sender;
- (IBAction)lockButtonTouchUpOutside:(id)sender;
- (IBAction)lockButtonTouchCancel:(id)sender;

- (IBAction)lockSliderAction:(id)sender;

- (IBAction)logMapSelection:(id)sender;

@end
