

#import "XYZToDoListViewController.h"
#import "XYZAddToDoItemViewController.h"
#import "XYZAppDelegate.h"
#import "Notes.h"


@interface XYZAddToDoItemViewController ()


@property (nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) IBOutlet UISwitch *SwitchOne;
@property (nonatomic) IBOutlet UIDatePicker *DatePKR;
@property (retain, nonatomic) IBOutlet UIDatePicker *DatePKR2;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) IBOutlet UITextField *textField2;
@property (retain, nonatomic) IBOutlet UILabel *Lbl;
@property (retain, nonatomic) IBOutlet UILabel *Lbl2;


@end


@implementation XYZAddToDoItemViewController


@synthesize note;


- (IBAction)CloseForm:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(goHome)];
    [item autorelease];
    self.navigationItem.rightBarButtonItem = item;
    //self.navigationItem.title = @"???";
    XYZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    _textField.text = nil;
    _textField2.text = nil;
    if (_edit == YES) {
        [self.textField setText:[self.note valueForKey:@"noteName"]];
        [self.textField2 setText:[self.note valueForKey:@"describtion"]];
        [self.navigationItem setHidesBackButton:YES];
        [self.Lbl setEnabled:NO];
        [self.SwitchOne setEnabled:NO];
        [self.Lbl2 setEnabled:NO];
        [self.SwitchOne setOn:NO];
        if (self.SwitchOne.on) {
            self.DatePKR.hidden = NO;
        } else {
            self.DatePKR.hidden = YES;
        }
    } else {
        [self.navigationItem setHidesBackButton:NO];
        [self.Lbl setEnabled:YES];
        [self.SwitchOne setEnabled:YES];
        [self.DatePKR setEnabled:YES];
        [self.Lbl2 setEnabled:YES];
        [self.SwitchOne setOn:NO];
        if (self.SwitchOne.on) {
            self.DatePKR.hidden = NO;
        } else {
            self.DatePKR.hidden = YES;
        }
    }
}


- (void)goHome
{
    if (self.textField.text.length > 0) {
        if (_edit == YES) {
            [self.note setValue:self.textField.text forKey:@"noteName"];
            [self.note setValue:self.textField2.text forKey:@"describtion"];
            [self.note setValue:self.DatePKR.date forKey:@"date"];
            NSManagedObjectID *moID = [note objectID];
            NSLog(@"Updating Done %@", moID);
            NSLog (@"Welcome home!");
            [[self navigationController] popToRootViewControllerAnimated:YES];
            _textField.text = nil;
            _textField2.text = nil;
            _edit = NO;
        } else {
            Notes * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Notes"
                                                             inManagedObjectContext:self.managedObjectContext];
            newEntry.noteName = self.textField.text;
            newEntry.describtion = self.textField2.text;
            // Switch checking and add new remind
                if (self.SwitchOne.on) {
                    newEntry.date = self.DatePKR.date;;
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
                newEntry.date = 0;  
                }
            _textField.text = nil;
            _textField2.text = nil;
            _edit = NO;
            [[self navigationController] popToRootViewControllerAnimated:YES];
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


- (void)dealloc {
    [_Lbl release];
    [_Lbl2 release];
    [_DatePKR2 release];
    [super dealloc];
}
@end