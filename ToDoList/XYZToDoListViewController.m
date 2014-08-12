

#import "XYZToDoListViewController.h"
#import "XYZAddToDoItemViewController.h"
#import "XYZAppDelegate.h"
#import "Notes.h"


@interface XYZToDoListViewController ()


@property (strong) NSMutableArray *notes;
// REVIEW Почему не retain?
// REVIEW Почему не nonatomic?

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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.notes objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
	// REVIEW Использовать UIAlertView для сообщения об ошибке.
            return;
        }
        [self.notes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self.tableView reloadData];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoteCellID";
// REVIEW Зачем придумывать константу длиннее сокращаемой строки
// REVIEW да ещё и используемую один раз?
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSManagedObject *note = [self.notes objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [note valueForKey:@"noteName"]]];
// REVIEW В требования была всё же своя ячейка, а не стандартная. Нужно сделать свою.
    return cell;
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
    self.navigationController.navigationBar.barTintColor = [UIColor
                                                            colorWithRed:59/255.0f
                                                            green:111/255.0f
                                                            blue:255/255.0f
                                                            alpha:1.0f];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(onNextPage)];
    [item autorelease];
// REVIEW Почему нужен autorelease?
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = @"To-Do List";
// REVIEW Почему не локализовано?
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NoteCellID"];
// REVIEW В каком другом сообщении (методе) можно зарегистрировать ячейку
// REVIEW ранее вызова viewDidLoad?
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Notes"];
    self.notes = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    _edit = NO;
// REVIEW Использовать self.edit. В чём отличия от _edit? Когда нужно использовать self.edit, а когда _edit? Почему?
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog (@"viewWillAppear?");
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Notes"];
    self.notes = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
// REVIEW Зачем снова получать self.notes, если уже получили во viewDidLoad?
    [self.tableView reloadData];
    _edit = NO;
}


- (void)onNextPage
{
    _edit = NO;
    
    [self.navigationController pushViewController:self.add animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
// REVIEW Почему 1?
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notes count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *selectedDevice = [self.notes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
// REVIEW Почему selectedDevice? Надо переименовать.
// REVIEW Почему такое странное получение row?
// REVIEW Разве нельзя просто исползовать indexPath.row? 
    _add.note = selectedDevice;
// REVIEW Почему нельзя сразу присвоить add.note,
// REVIEW зачем промеужточный selectedDevice?`
    _edit = YES;
    [self.add setEdit:self];
    [self.navigationController pushViewController:self.add animated:YES];
}


@end

