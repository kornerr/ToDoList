
#import "XYZToDoListViewController.h"
#import "XYZAddToDoItemViewController.h"
#import "XYZAppDelegate.h"
#import "Notes.h"

@interface XYZAddToDoItemViewController ()
@property (nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic) IBOutlet UISwitch *SwitchOne;
@property (nonatomic) IBOutlet UIDatePicker *DatePKR;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) IBOutlet UITextField *textField2;
@property (nonatomic) IBOutlet UIButton *Hidebutton;
@property (nonatomic) IBOutlet UIButton *changeGroupButton;

@end

@implementation XYZAddToDoItemViewController

@synthesize note;


- (IBAction)CloseForm:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.SwitchOne.on) {
        [self.textField resignFirstResponder];
        NSDate *pickerDate = [self.DatePKR date];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = pickerDate;
        localNotification.alertBody = self.textField.text;
        localNotification.alertAction = @"Show me the item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else {
    }
    if (sender != self.doneButton) return;
    if (self.textField.text.length > 0) {
        if (self.note) {
            [self.note setValue:self.textField.text forKey:@"noteName"];
            [self.note setValue:self.textField2.text forKey:@"describtion"];
            NSManagedObjectID *moID = [note objectID];
            NSLog(@"Updating Done %@", moID);
        } else {
            Notes * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Notes"
                                                             inManagedObjectContext:self.managedObjectContext];
            newEntry.noteName = self.textField.text;
            newEntry.describtion = self.textField2.text;
            if (self.SwitchOne.on) {
                newEntry.date = self.DatePKR.date;;
            } else {
                newEntry.date = 0;;
            }
            
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            NSLog(@"Date: %@", newEntry.date);
        }
        [self.view endEditing:YES];
    }
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(goHome)];
    [item autorelease];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = @"To-Do List";
    XYZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    if (self.note) {
        [self.textField setText:[self.note valueForKey:@"noteName"]];
        [self.textField2 setText:[self.note valueForKey:@"describtion"]];
    }
}


- (void)goHome
{
    if (self.SwitchOne.on) {
        [self.textField resignFirstResponder];
        NSDate *pickerDate = [self.DatePKR date];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = pickerDate;
        localNotification.alertBody = self.textField.text;
        localNotification.alertAction = @"Show me the item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else {
    }
    if (self.textField.text.length > 0) {
        if (self.note) {
            [self.note setValue:self.textField.text forKey:@"noteName"];
            [self.note setValue:self.textField2.text forKey:@"describtion"];
            NSManagedObjectID *moID = [note objectID];
            NSLog(@"Updating Done %@", moID);
            NSLog (@"Welcome home!");
            [[self navigationController] popToRootViewControllerAnimated:YES];
            _textField.text = nil;
            
        } else {
            Notes * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Notes"
                                                             inManagedObjectContext:self.managedObjectContext];
            newEntry.noteName = self.textField.text;
            newEntry.describtion = self.textField2.text;
            if (self.SwitchOne.on) {
                newEntry.date = self.DatePKR.date;;
            } else {
                newEntry.date = 0;;
            }
            [[self navigationController] popToRootViewControllerAnimated:YES];
            _textField.text = nil;
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            NSLog(@"Date: %@", newEntry.date);
        }
        [self.view endEditing:YES];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([_textField isFirstResponder] && [touch view] != _textField) {
        [_textField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


- (IBAction)HideKeyBoard:(id)sender {
    [self.view endEditing:YES];
}


- (IBAction)GetVisible:(id)sender {
    {
        if (self.SwitchOne.on) {
            self.DatePKR.hidden = NO;
        } else {
            self.DatePKR.hidden = YES;
        }
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.textField)
   {
       [self.textField resignFirstResponder];
       return NO;
    }
    return YES;
}


@end

