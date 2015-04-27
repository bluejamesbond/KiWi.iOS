//
//  ShareKeyViewController.h
//  KiWi
//
//  Created by Kapil Gowru on 4/26/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareKeyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UITableView *keyTablePeersView;

@end
