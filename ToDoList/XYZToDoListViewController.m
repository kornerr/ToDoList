
#import "XYZToDoListViewController.h"
#import "XYZAddToDoItemViewController.h"
#import "XYZAppDelegate.h"
#import "Notes.h"

@interface XYZToDoListViewController ()

@property (strong)NSMutableArray* notes;

@end

@implementation XYZToDoListViewController


- (void)dealloc
{
    [_add release];
    [super dealloc];
}


- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)loadInitialData
{
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.notes objectAtIndex:indexPath.row]];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        [self.notes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoteCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSManagedObject *note = [self.notes objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [note valueForKey:@"noteName"]]];
    return cell;
}


- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Notes"];
    self.notes = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(onNextPage)];
    [item autorelease];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = @"To-Do List";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NoteCellID"];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Notes"];
    self.notes = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog (@"viewDidAppear?");
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Notes"];
    self.notes = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}


- (void)onNextPage
{
    NSLog (@"Add new page");
    [self.navigationController pushViewController:self.add animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notes count];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"UpdateNote"]) {
        NSManagedObject *selectedDevice = [self.notes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        XYZAddToDoItemViewController *destViewController = segue.destinationViewController;
        destViewController.note = selectedDevice;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *selectedDevice = [self.notes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    XYZAddToDoItemViewController *destViewController;
    destViewController.note = selectedDevice;
    [self.navigationController pushViewController:self.add animated:YES];
}


@end

