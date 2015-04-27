//
//  SidebarViewController.m
//  KiWI
//
//  Created by Kapil.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "GlobalVars.h"
#import "UserSideBarCell.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController{
    GlobalVars *globals;
}

@synthesize backgroundColor;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
//        self.view.backgroundColor = globals.BACKGROUND_COLOR;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    globals = [GlobalVars sharedInstance];
    backgroundColor = globals.BLACK_COLOR;
    [self.tableView setSeparatorColor:globals.LIGHTGRAY_COLOR];
    [self.tableView setBackgroundColor: backgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _menuItems = @[@"user", @"home", @"mykiwis", @"settings"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [_menuItems objectAtIndex:indexPath.row];
    if(indexPath.row == 0){

        //working attempt but not clicking
//        UserSideBarCell *cell  = (UserSideBarCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
////        UserSideBarCell *cell = (UserSideBarCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserSideBarCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
        
        
        //attempt #2
        UserSideBarCell *cell = (UserSideBarCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"UserSideBarCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",globals.firstName, globals.lastName];
        cell.nameLabel.textColor = globals.LIGHTGRAY_COLOR;
        cell.thumbnailImageView.image  = [UIImage imageNamed:@"UserProfileDefault.png"];
        cell.backgroundColor = backgroundColor;
        cell.backgroundView.backgroundColor = backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = backgroundColor;
        cell.backgroundView.backgroundColor = backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    
    }
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"userCellToAccountView" sender:cell];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 200;
    else
        return 44;
}


@end
