//
//  ToDoListTableViewController.m
//  ToDoList
//
//  Created by Kapil Gowru on 12/22/14.
//  Copyright (c) 2014 Kapil Gowru. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "ToDOItem.h"
#import "AddToDoItemViewController.h"

@interface ToDoListTableViewController ()

@property NSMutableArray *toDoItems;

@end

@implementation ToDoListTableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
    AddToDoItemViewController *source = [segue sourceViewController];
    ToDoItem *toDoItem = source.toDoItem;
    
    if(toDoItem != nil){
        [self.toDoItems addObject:toDoItem];
        [self.tableView reloadData];
    }
    
    
}

- (void)loadInitialData {
    ToDoItem *item1 = [[ToDoItem alloc] init];
    item1.itemName = @"Buy Milk";
    [self.toDoItems addObject:item1];
    
    ToDoItem *item2 = [[ToDoItem alloc] init];
    item2.itemName = @"Return pants";
    [self.toDoItems addObject:item2];
    
    ToDoItem *item3 = [[ToDoItem alloc] init];
    item3.itemName = @"Read a book";
    [self.toDoItems addObject:item3];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //allowing for sliding left on item to edit
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.toDoItems = [[NSMutableArray alloc] init];
    [self loadInitialData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.toDoItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    ToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;
    if(toDoItem.completed){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (IBAction)trash:(id)sender {
    //NSUInteger numCount = [self.toDoItems count];
    for (NSUInteger numCount = 0; numCount < [self.toDoItems count]; numCount ++) {
        ToDoItem *tappedItem = [self.toDoItems objectAtIndex:numCount];
        if (tappedItem.completed) {
            [self.toDoItems removeObject:tappedItem];
            numCount--;
        }
    }
    [self.tableView reloadData];
    
}
@end
