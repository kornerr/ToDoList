//
//  XYZGroupListViewController.m
//  ToDoList
//
//  Created by Kirill Skulkin on 18.03.14.
//
//

#import "XYZGroupListViewController.h"
#import "XYZAddGroupViewController.h"
#import "XYZTGroupItem.h"
#import "XYZAppDelegate.h"
#import "Groups.h"

@interface XYZGroupListViewController ()

//@property NSMutableArray *groupItems;
@property (nonatomic,strong)NSMutableArray* groups;

@end

@implementation XYZGroupListViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



- (void)loadInitialData {
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Groups"];
    self.groups = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
   /* XYZAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.fetchedRecordsArray = [appDelegate getAllGroups];
    [self.tableView reloadData];*/
    /*
        XYZAddGroupViewController *source = [segue sourceViewController];
    XYZTGroupItem *item = source.groupItem;

    if (item != nil) {
        [self.groupItems addObject:item];
        [self.tableView reloadData];
    }*/
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  /*  XYZAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.fetchedRecordsArray = [appDelegate getAllGroups];
    [self.tableView reloadData];*/
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Groups"];
    self.groups = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
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
    return [self.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   static NSString *CellIdentifier = @"GroupPrototypeCell";
  //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
  //  XYZTGroupItem *groupItem = [self.groupItems objectAtIndex:indexPath.row];
  //  XYZTGroupItem *selectedRow;
  //  cell.textLabel.text = groupItem.groupName;
    
  /*  if (selectedRow == nil) {
        cell.backgroundColor = [UIColor whiteColor];
    }else {
        cell.backgroundColor = [UIColor lightGrayColor];
    }*/
/*    switch (selectedRow) {
        case 0:
            <#statements#>
            break;
            case 1:
 cell.backgroundColor = [UIColor yellow];
break;
 
        default:
            break;
    }*/
    
    
    static NSString *CellIdentifier = @"GroupCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];



    
    Groups * group = [self.groups objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@" %@ ",group.groupName];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.groups objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.groups removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 if ([[segue identifier] isEqualToString:@"UpdateGroup"]) {
 NSManagedObject *selectedDevice = [self.groups objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
 XYZAddGroupViewController *destViewController = segue.destinationViewController;
 destViewController.group = selectedDevice;
     NSManagedObjectID *moID = [destViewController.group objectID];
     NSLog(@"Done %i", moID);
 }
}




@end
