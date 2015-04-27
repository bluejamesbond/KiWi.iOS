//
//  ShareKeyViewController.m
//  KiWi
//
//  Created by Kapil Gowru on 4/26/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "ShareKeyViewController.h"
#import "GlobalVars.h"
#import "FriendListCell.h"

@interface ShareKeyViewController ()

@end

@implementation ShareKeyViewController{
    GlobalVars *globals;
    NSArray *sampleTableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    globals = [GlobalVars sharedInstance];
    // Do any additional setup after loading the view.
    self.backButton.tintColor = globals.LIGHTGRAY_COLOR;
    self.view.backgroundColor = globals.DARKBLUE_COLOR;
    
    self.keyTablePeersView.delegate = self;
    self.keyTablePeersView.dataSource = self;
    self.keyTablePeersView.backgroundColor = globals.LIGHTGRAY_COLOR;
    [self.keyTablePeersView setSeparatorColor:globals.DARKGRAY_COLOR];
    self.keyTablePeersView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    sampleTableData = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Mathew Kurian", @"username", @"1", @"keylevel", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Kapil Gowru", @"username", @"2", @"keylevel", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Caroline Schram", @"username", @"1", @"keylevel", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Jesun David", @"username", @"1", @"keylevel", nil], nil];

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

#pragma mark - table view

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
    
    NSDictionary *dict = [sampleTableData objectAtIndex:indexPath.row];
    NSString *userName = [dict objectForKey:@"username"];
    NSString *keyLevel = [dict objectForKey:@"keylevel"];
    
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[dict objectForKey:userName]];
    
    FriendListCell *cell  = (FriendListCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userName];
    
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendListCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    cell.backgroundColor = globals.LIGHTGRAY_COLOR;
    cell.backgroundView.backgroundColor = globals.LIGHTGRAY_COLOR;
    
    //    cell.textLabel.textColor = globals.PINK_COLOR;
    //    cell.imageView.image = [UIImage imageNamed:@"user62.png"];
    
    cell.userName.text = userName;
    cell.userName.textColor = globals.BLACK_COLOR;
    cell.keyLevel.text = keyLevel;
    cell.keyLevel.textColor = globals.BRIGHTBLUE_COLOR;
    
    cell.userImage.image = [UIImage imageNamed:@"UserProfileDefaultDark.png"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendListCell" owner:self options:nil];
    FriendListCell *cell = [nib objectAtIndex:0];
    
    return cell.frame.size.height;
}






@end
