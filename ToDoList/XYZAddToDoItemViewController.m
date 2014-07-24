//
//  XYZAddToDoItemViewController.m
//  ToDoList
//
//  Created by Kirill Skulkin on 15.03.14.
//
//

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

- (IBAction)CloseForm:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.SwitchOne.on) {
        [self.textField resignFirstResponder];
        
        // Get the current date
        NSDate *pickerDate = [self.DatePKR date];
        
        // Schedule the notification
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
      //  self.toDoItem = [[XYZToDoItem alloc] init];
      //  self.toDoItem.itemName = self.textField.text;
      //  self.toDoItem.completed = NO;
        if (self.note) {
            // Update existing device
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    XYZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    if (self.note) {
        [self.textField setText:[self.note valueForKey:@"noteName"]];
        [self.textField2 setText:[self.note valueForKey:@"describtion"]];
        //[self.companyTextField setText:[self.device valueForKey:@"company"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
