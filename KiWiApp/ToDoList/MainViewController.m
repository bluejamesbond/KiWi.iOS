//
//  ViewController.m
//  KiWI
//
//  Created by Kapil.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "GlobalVars.h"
#import "LogViewCell.h"
#import "TransparentToolbar.h"

#define METERS_PER_MILE 1609.344
#define CIRCLE_RADIUS 10
#define INIT_LATITUDE 30.287071842021795
#define INIT_LONGITUDE -97.73662939667702

@interface MainViewController ()

@end

@implementation MainViewController{
    SRWebSocket *webSocket;
    GlobalVars *globals;
    CFTimeInterval startTime;
    CFTimeInterval elapsedTime;
    NSTimer *timer;
    
    CLLocationManager *locationManager;
    CLGeocoder *geoCoder;
    CLPlacemark *placeMark;
    bool isWithinCircle;
    bool isFirstCheckInCircle;
    CLLocationCoordinate2D initLocation;
    CLLocationCoordinate2D zoomLocation;
    
    NSArray *sampleTableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    globals = [GlobalVars sharedInstance];

    //self.title = @"KiWi";
    self.authenticatedToken = nil;
    self.authenticatedSocketSecret = nil;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    self.view.backgroundColor = globals.DARKBLUE_COLOR;
    
    self.sidebarButton.tintColor = globals.LIGHTGRAY_COLOR;
    
    self.kiwiBatteryLabel.textColor = globals.LIGHTGRAY_COLOR;
    self.kiwiStatusLabel.textColor = globals.LIGHTGRAY_COLOR;
    
    self.shareKeyButton.layer.borderColor = globals.BRIGHTGREEN_COLOR.CGColor;
    self.shareKeyButton.layer.borderWidth = 1.0;
    self.shareKeyButton.layer.cornerRadius = 5;
    self.shareKeyButton.adjustsImageWhenHighlighted = YES;
    [self.shareKeyButton setTitleColor:globals.BRIGHTGREEN_COLOR forState:UIControlStateNormal];
    [self.shareKeyButton setTitleColor:globals.LIGHTGRAY_COLOR forState:UIControlStateHighlighted];
    
//    UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(375, 568, 60, 60)];
//    holder.autoresizingMask =
//    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    holder.backgroundColor = globals.PINK_COLOR;
    
    
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [longPress setMinimumPressDuration:2];
//    [self.lockButton addGestureRecognizer:longPress];
    
    self.lockSlider.tintColor = globals.BRIGHTBLUE_COLOR;
    self.lockSlider.onTintColor = globals.BRIGHTBLUE_COLOR;
   self.lockSlider.transform = CGAffineTransformMakeScale(2, 2);
    
    self.lockButtonText.text = @"Hold to lock";
    self.lockButtonText.textAlignment = NSTextAlignmentCenter;
    
    self.lockButtonProgressView.progress = 0;
    self.lockButtonProgressView.trackTintColor = globals.DARKBLUE_COLOR;
    self.lockButtonProgressView.progressTintColor = globals.BRIGHTGREEN_COLOR;
    
    [self.logMapSelecter setTintColor:globals.BRIGHTBLUE_COLOR];
    [self.logMapSelecter setBackgroundColor:globals.DARKBLUE_COLOR];
    [self.logMapSelecter setTitleTextAttributes:@{NSForegroundColorAttributeName:globals.BRIGHTBLUE_COLOR, NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0]} forState:UIControlStateNormal];
    
    
    
    MKUserTrackingBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    
//    self.navigationItem.rightBarButtonItem = trackingButton;
//    
//    UIButton *centerMyLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(40,40,40,40)];
//    [centerMyLocationButton addTarget:self action:@selector(followUserLocation) forControlEvents:UIControlEventTouchUpInside];
//    [centerMyLocationButton setTitle:@"IDK" forState:UIControlStateNormal];
//    [self.mapView addSubview:centerMyLocationButton];
    
    UIToolbar *mapViewToolbar = [[TransparentToolbar alloc] init];
    mapViewToolbar.frame = CGRectMake(0, self.mapView.frame.size.height - 44, self.view.frame.size.width, 44);
    NSMutableArray *items = [[NSMutableArray alloc] init];
//    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = self.mapView.frame.size.width - 60;
//    [items addObject:flexibleSpace];
    [items addObject:negativeSpace];
    [items addObject:trackingButton];
    [mapViewToolbar setItems:items animated:NO];
    mapViewToolbar.tintColor = globals.BRIGHTBLUE_COLOR;
    [self.mapView addSubview:mapViewToolbar];
    
    locationManager = [[CLLocationManager alloc] init];
    geoCoder = [[CLGeocoder alloc] init];
    [locationManager requestWhenInUseAuthorization];
    self.mapView.delegate = self;
    self.mapView.tintColor = globals.BRIGHTBLUE_COLOR;
    self.mapView.hidden = YES;
//    self.logView.hidden = YES;
    isWithinCircle = YES;
    isFirstCheckInCircle = YES;
    
    initLocation.latitude = INIT_LATITUDE;
    initLocation.longitude = INIT_LONGITUDE;
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:initLocation radius:CIRCLE_RADIUS];
    [self.mapView addOverlay:circle];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    self.logView.delegate = self;
    self.logView.dataSource = self;
    self.logView.backgroundColor = globals.LIGHTGRAY_COLOR;
    [self.logView setSeparatorColor:globals.DARKGRAY_COLOR];
    self.logView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [self imageWithColor:globals.DARKBLUE_COLOR size:(CGSizeMake(self.view.frame.size.width, -44))];
//    self.navigationController.navigationBar.translucent = NO;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateLogView:) forControlEvents:UIControlEventValueChanged];
    [self.logView addSubview:refreshControl];
    
    sampleTableData = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Mathew Kurian", @"username", @"ENTERED HOME", @"event", @"7:45 AM", @"time", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Kapil Gowru", @"username", @"LEFT HOME", @"event", @"8:30 AM", @"time", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Caroline Schram", @"username", @"LOCKED KIWI", @"event", @"9:00 AM", @"time", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Jesun David", @"username", @"UNLOCKED KIWI", @"event", @"10:00 AM", @"time", nil], nil];
    
    NSString *restCallString = [NSString stringWithFormat:@"%@rest/lock/list?client_id=dev&token=%@", globals.serverURL, globals.authenticatedToken];
    NSLog(@"rest url: %@", restCallString);
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    if (currentConnection){
        [currentConnection cancel];
        currentConnection = nil;
        self.apiReturnJSONDictionary = nil;
    }
    currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
}

-(void)viewDidLayoutSubviews{
    CGRect frame= self.logMapSelecter.frame;
    [self.logMapSelecter setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,44)];
    
    
//    frame = self.lockSlider.frame;
//    [self.lockSlider setFrame:CGRectMake(self.lockSlider.frame.origin.x, self.lockSlider.frame.origin.y, self.lockSlider.frame.size.width, 44)];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
    [color setFill];
    [rPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - log mapview selector

- (IBAction)logMapSelection:(id)sender {
    if(self.logMapSelecter.selectedSegmentIndex == 0){
        self.logView.hidden = NO;
        self.mapView.hidden = YES;
        
    } else if (self.logMapSelecter.selectedSegmentIndex == 1){
        
        
        self.logView.hidden = YES;
        self.mapView.hidden = NO;
    }
}

#pragma mark - log table view
- (void)updateLogView:(UIRefreshControl *)refreshControl{
    [refreshControl endRefreshing];
    NSLog(@"updating log view");
}
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return sampleTableData.count;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString *CellIdentifier = [_menuItems objectAtIndex:indexPath.row];
//    NSString *cellIdentifier = @"Testing";
//    UITableViewCell *cell = [self.logView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = [sampleTableData objectAtIndex:indexPath.row];
    NSString *userName = [dict objectForKey:@"username"];
    NSString *event = [dict objectForKey:@"event"];
    NSString *time = [dict objectForKey:@"time"];
    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[dict objectForKey:userName]];
    
    LogViewCell *cell  = (LogViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userName];
    

    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LogViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    cell.backgroundColor = globals.LIGHTGRAY_COLOR;
    cell.backgroundView.backgroundColor = globals.LIGHTGRAY_COLOR;
    
//    cell.textLabel.textColor = globals.PINK_COLOR;
//    cell.imageView.image = [UIImage imageNamed:@"user62.png"];
    
    cell.nameLabel.text = userName;
    cell.nameLabel.textColor = globals.BLACK_COLOR;
    cell.eventLabel.text = event;
    cell.eventLabel.textColor = globals.BRIGHTBLUE_COLOR;
    cell.timeLabel.text = time;
    cell.timeLabel.textColor = globals.BRIGHTGREEN_COLOR;
    
    cell.thumbnailImageView.image = [UIImage imageNamed:@"UserProfileDefaultDark.png"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LogViewCell" owner:self options:nil];
    LogViewCell *cell = [nib objectAtIndex:0];

    return cell.frame.size.height;
}


//#pragma mark - UITableViewDelegate
//// when user tap the row, what action you want to perform
//- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"selected %d row", indexPath.row);
//}

#pragma mark - lock/unlock button mechanism
- (void)updateProgressView{
    float actual = [self.lockButtonProgressView progress];
    if (actual < 1) {
        self.lockButtonProgressView.progress = actual + (0.05/2);
    }
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture {
//    if(gesture.state == UIGestureRecognizerStateBegan){
//        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgressView) userInfo:nil repeats:NO];
//    }
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Long Press");
        self.lockButtonProgressView.progress = 0;
        if([self.lockButton.titleLabel.text  isEqual: @"Lock"]){
            UIImage *buttonImage = [UIImage imageNamed:@"padlock48.png"];
            [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
            [self.lockButton setTitle:@"Unlock" forState:UIControlStateNormal];
            self.lockButtonText.text = @"Press to unlock";
        } else {
            UIImage *buttonImage = [UIImage imageNamed:@"padlock50.png"];
            [self.lockButton setTitle:@"Lock" forState:UIControlStateNormal];
            [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
            self.lockButtonText.text = @"Press to lock";
        }
    }
}


- (IBAction)lockButtonTouchDown:(id)sender {
    NSLog(@"Touch down");
    startTime = CACurrentMediaTime();
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05/2 target:self selector:@selector(updateProgressView) userInfo:nil repeats:YES];
}

- (IBAction)lockButtonTouchUp:(id)sender {
    NSLog(@"Touch up");
    [timer invalidate];
    self.lockButtonProgressView.progress = 0;
    elapsedTime = CACurrentMediaTime() - startTime;
    NSLog(@"%f", elapsedTime);
    if(elapsedTime > 1){
        if([self.lockButton.titleLabel.text  isEqual: @"Lock"]){
            UIImage *buttonImage = [UIImage imageNamed:@"UnlockIcon.png"];
            [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
            [self.lockButton setTitle:@"Unlock" forState:UIControlStateNormal];
            self.lockButtonText.text = @"Hold to unlock";
            
            NSString *restCallString = [NSString stringWithFormat:@"%@rest/lock/lock?client_id=dev&token=%@&lock=%@&location[lat]=%f&location[long]=%f", globals.serverURL, globals.authenticatedToken, globals.lockId,zoomLocation.latitude, zoomLocation.longitude];
            NSLog(@"rest url: %@", restCallString);
            NSURL *restURL = [NSURL URLWithString:restCallString];
            NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
            if (currentConnection){
                [currentConnection cancel];
                currentConnection = nil;
                self.apiReturnJSONDictionary = nil;
            }
            currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];

            
        } else {
            UIImage *buttonImage = [UIImage imageNamed:@"LockIcon.png"];
            [self.lockButton setTitle:@"Lock" forState:UIControlStateNormal];
            [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
            self.lockButtonText.text = @"Hold to lock";
            
           NSString *restCallString = [NSString stringWithFormat:@"%@rest/lock/unlock?client_id=dev&token=%@&lock=%@&location[lat]=%f&location[long]=%f", globals.serverURL, globals.authenticatedToken, globals.lockId,zoomLocation.latitude, zoomLocation.longitude];
            NSLog(@"rest url: %@", restCallString);
            NSURL *restURL = [NSURL URLWithString:restCallString];
            NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
            if (currentConnection){
                [currentConnection cancel];
                currentConnection = nil;
                self.apiReturnJSONDictionary = nil;
            }
            currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];

        }
    }
}

- (IBAction)lockButtonTouchUpOutside:(id)sender {
    NSLog(@"touch up outside");
    [timer invalidate];
    elapsedTime = 0;
    startTime = 0;
    self.lockButtonProgressView.progress = 0;
}

- (IBAction)lockButtonTouchCancel:(id)sender {
    NSLog(@"touch cancel");
    [timer invalidate];
    elapsedTime = 0;
    startTime = 0;
    self.lockButtonProgressView.progress = 0;
}

- (IBAction)lockButtonTouchDragExit:(id)sender {
    NSLog(@"touch drag exit");
    [timer invalidate];
    elapsedTime = 0;
    startTime = 0;
    self.lockButtonProgressView.progress = 0;
}

- (IBAction)lockButtonTouchDragOutside:(id)sender {
    NSLog(@"touch drag outside");
    [timer invalidate];
    elapsedTime = 0;
    startTime = 0;
    self.lockButtonProgressView.progress = 0;
}

#pragma mark - location management

-(bool)checkIfWithinCircle:(CLLocationCoordinate2D)passedZoomLocation {
    MKMapPoint p1 = MKMapPointForCoordinate(passedZoomLocation);
    MKMapPoint p2 = MKMapPointForCoordinate(initLocation);
    CLLocationDistance dist = MKMetersBetweenMapPoints(p1, p2);
    
    if(dist < CIRCLE_RADIUS){
        return YES;
    } else return NO;
}

-(void)changeMapView:(CLLocationCoordinate2D)passedZoomLocation {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(passedZoomLocation, 100,100);
    [self.mapView setRegion:viewRegion animated:YES];
}

-(void)followUserLocation{
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Failed with error: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //Check to see if new location is indeed new
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation;
    if (locations.count > 1){
        oldLocation = [locations objectAtIndex:locations.count-2];
    } else {
        oldLocation = nil;
    }
    
    //Set new zoom location
    
    zoomLocation.latitude = newLocation.coordinate.latitude;
    zoomLocation.longitude = newLocation.coordinate.longitude;
    
    if (isFirstCheckInCircle == YES){
        if([self checkIfWithinCircle:zoomLocation]){
            isWithinCircle = YES;
        } else isWithinCircle = NO;
        isFirstCheckInCircle = NO;
        [self changeMapView:zoomLocation];
    } else {
        if([self checkIfWithinCircle:zoomLocation] && !isWithinCircle){
            UIAlertView *withinCircleAlert = [[UIAlertView alloc]
                                              initWithTitle:@"Welcome!" message:@"You are home, KiWi will promptly unlock." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [withinCircleAlert show];
            
            UIImage *buttonImage = [UIImage imageNamed:@"LockIcon.png"];
            [self.lockButton setTitle:@"Lock" forState:UIControlStateNormal];
            [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
            self.lockButtonText.text = @"Hold to lock";
            
            NSString *restCallString = [NSString stringWithFormat:@"%@rest/lock/unlock?client_id=dev&token=%@&lock=%@&location[lat]=%f&location[long]=%f", globals.serverURL, globals.authenticatedToken, globals.lockId,zoomLocation.latitude, zoomLocation.longitude];
            NSLog(@"rest url: %@", restCallString);
            NSURL *restURL = [NSURL URLWithString:restCallString];
            NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
            if (currentConnection){
                [currentConnection cancel];
                currentConnection = nil;
                self.apiReturnJSONDictionary = nil;
            }
            currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
            isWithinCircle = YES;
        }
        
        if(![self checkIfWithinCircle:zoomLocation] && isWithinCircle){
            UIAlertView *outsideCircleAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Goodbye!" message:@"KiWi will promptly lock behind  you. Safe travels. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [outsideCircleAlert show];
            
            UIImage *buttonImage = [UIImage imageNamed:@"UnlockIcon.png"];
            [self.lockButton setTitle:@"Unlock" forState:UIControlStateNormal];
            [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
            self.lockButtonText.text = @"Hold to unlock";
            
            NSString *restCallString = [NSString stringWithFormat:@"%@rest/lock/lock?client_id=dev&token=%@&lock=%@&location[lat]=%f&location[long]=%f", globals.serverURL, globals.authenticatedToken, globals.lockId,zoomLocation.latitude, zoomLocation.longitude];
            NSLog(@"rest url: %@", restCallString);
            NSURL *restURL = [NSURL URLWithString:restCallString];
            NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
            if (currentConnection){
                [currentConnection cancel];
                currentConnection = nil;
                self.apiReturnJSONDictionary = nil;
            }
            currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
            isWithinCircle = NO;
        }
        
        isFirstCheckInCircle = NO;
    }
    
    
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


#pragma mark - rest api stuff

//- (IBAction)restAPIGetSecret:(id)sender {
//    NSString *restCallString = [NSString stringWithFormat:@"http://kiwi.t.proxylocal.com/rest/socket/open?token=%@&client_id=dev",self.authenticatedToken];
//    NSURL *restURL = [NSURL URLWithString:restCallString];
//    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
//    if (currentConnection){
//        [currentConnection cancel];
//        currentConnection = nil;
//        self.apiReturnXMLData = nil;
//        self.apiReturnJSONDictionary = nil;
//    }
//    
//    currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
//    self.apiReturnXMLData = [NSMutableData data];
//}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection with the KiWi main frame has failed");
    UIAlertView *errorAlertView = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Connection with the KiWi server has failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlertView show];
    currentConnection = nil;
    return;
    
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
//    [self.apiReturnXMLData appendData:data];
    NSLog([NSString stringWithUTF8String:[data bytes]]);
    
    NSError *error = [NSError errorWithDomain:@"Invalid JSON data, could not be seralized." code:200 userInfo:nil];
    self.apiReturnJSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    
    
    NSLog(@"My JSON is %@", self.apiReturnJSONDictionary);
//    self.authenticatedToken = [[self.apiReturnJSONDictionary objectForKey:@"data"] objectForKey:@"token"];
//    NSLog(@"My data token is %@", self.authenticatedToken);
//    
//    self.authenticatedSocketSecret = [[self.apiReturnJSONDictionary objectForKey:@"data"] objectForKey:@"secret"];
    
    NSURL *myURL = [[connection currentRequest] URL];
    if(self.apiReturnJSONDictionary == nil && [[myURL absoluteString] containsString:@"/lock/lock?"]){
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"Error" message:@"Uh oh, Lock/Unlock failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlertView show];
    } else if ([[myURL absoluteString] containsString:@"/rest/socket/open"]){
        globals.authenticatedSecret = [[self.apiReturnJSONDictionary objectForKey:@"data"] objectForKey:@"secret"];
//        NSLog(@"socket connection failed");
        [self connectSocket];
    } else if(self.apiReturnJSONDictionary != nil && [[myURL absoluteString] containsString:@"/lock/list?"]){
        //get locks informastion
        NSDictionary *myLock = [[[self.apiReturnJSONDictionary objectForKey:@"data"] objectForKey:@"locks"] objectAtIndex:1];
        if(myLock != nil){
            globals.lockId = [myLock objectForKey:@"_id"];
            
            self.kiwiNameLabel.text = [myLock objectForKey:@"name"];
            self.navigationItem.title = [myLock objectForKey:@"name"];
            self.kiwiBatteryLabel.text = [NSString stringWithFormat:@"%@", [myLock objectForKey:@"battery"]] ;
            
            if ([(NSNumber *)[myLock objectForKey:@"enabled"] isEqualToNumber:[NSNumber numberWithInt:1]])
                self.kiwiStatusLabel.text = @"Enabled";
            else
                self.kiwiStatusLabel.text = @"Disabled";
            
            if([[myLock objectForKey:@"locked"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                UIImage *buttonImage = [UIImage imageNamed:@"UnlockIcon.png"];
                [self.lockButton setTitle:@"Unlock" forState:UIControlStateNormal];
                [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
                self.lockButtonText.text = @"Hold to unlock";
            } else if ([[myLock objectForKey:@"locked"] isEqualToNumber:[NSNumber numberWithInt:0]]){
                UIImage *buttonImage = [UIImage imageNamed:@"LockIcon.png"];
                [self.lockButton setTitle:@"Lock" forState:UIControlStateNormal];
                [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
                self.lockButtonText.text = @"Hold to lock";

            }
        }
        
        NSString *restCallString = [NSString stringWithFormat:@"%@rest/socket/open?token=%@&client_id=dev&action=account",globals.serverURL, globals.authenticatedToken];
        NSLog(restCallString);
        NSURL *restURL = [NSURL URLWithString:restCallString];
        NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
        if (currentConnection){
            [currentConnection cancel];
            currentConnection = nil;
            self.apiReturnXMLData = nil;
            self.apiReturnJSONDictionary = nil;
        }
        
        currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
        self.apiReturnXMLData = [NSMutableData data];
    }

//    currentConnection = nil;
    
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
//    [self.apiReturnXMLData setLength:0];
    self.apiReturnJSONDictionary = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    currentConnection = nil;
}

#pragma mark - web socket connection

//- (IBAction)connectSocket:(id)sender {
//    webSocket.delegate = nil;
//    [webSocket close];
//    //webSocket = nil;
////    NSLog(@"token for socket is: %@", globals.authenticatedToken);
//    NSString *socketURL = [NSString stringWithFormat:@"ws://kiwi.t.proxylocal.com/socket?secret=%@&action=account",globals.authenticatedSecret];
//    NSLog(@"%@", socketURL);
//    
//    webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:socketURL]]];
//    webSocket.delegate = self;
//    //newWebSocket.delegate = self;
//    
//    [webSocket open];
//}

-(void)connectSocket{
    webSocket.delegate = nil;
    [webSocket close];
    //webSocket = nil;
    //    NSLog(@"token for socket is: %@", globals.authenticatedToken);
    NSString *socketURL = [NSString stringWithFormat:@"%@socket?secret=%@&action=account",globals.serverURL, globals.authenticatedSecret];
    NSLog(@"%@", socketURL);
    
    webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:socketURL]]];
    webSocket.delegate = self;
    //newWebSocket.delegate = self;
    
    [webSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //[webSocket send:[NSString stringWithFormat:<#(NSString *), ...#>]]
    NSLog(@"websocket connected!");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    //[self connectSocket:@"1"];
    NSLog(@"failed with error: %@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    //[self connectSocket:@"1"];
    NSLog(@"failed with code: %ld", code);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"%@",[NSString stringWithFormat:@"Recevied message: %@", message]);
    if([message containsString:@"\"event\":18"]){
        UIImage *buttonImage = [UIImage imageNamed:@"UnlockIcon.png"];
        [self.lockButton setTitle:@"Unlock" forState:UIControlStateNormal];
        [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
        self.lockButtonText.text = @"Hold to unlock";
        NSLog(@"LOCKED");
    } else if ([message containsString:@"\"event\":20"] ){
        UIImage *buttonImage = [UIImage imageNamed:@"LockIcon.png"];
        [self.lockButton setTitle:@"Lock" forState:UIControlStateNormal];
        [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
        self.lockButtonText.text = @"Hold to lock";
    } else if ([message containsString:@"\"event\":24"]){
        UIImage *buttonImage = [UIImage imageNamed:@"UnlockIcon.png"];
        [self.lockButton setTitle:@"Unlock" forState:UIControlStateNormal];
        [self.lockButton setImage:buttonImage forState:UIControlStateNormal];
        self.lockButtonText.text = @"Hold to unlock";
        NSLog(@"LOCKED");
    }
}



- (IBAction)lockSliderAction:(id)sender {
}
@end
