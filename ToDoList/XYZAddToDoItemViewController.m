

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
// REVIEW Почему у часть есть retain, у части нет?
// REVIEW Надо назвать аутлеты по-человечески - по их предназначению


@end


@implementation XYZAddToDoItemViewController


@synthesize note;
// REVIEW Зачем это?


- (IBAction)CloseForm:(id)sender
// REVIEW Почему не camelCase?
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) viewWillAppear:(BOOL)animated {
// REVIEW Почему пробел после возвращаемого типа?
// REVIEW Почему открывающая скобка не на новой строке?
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(goHome)];
    [item autorelease];
    self.navigationItem.rightBarButtonItem = item;
// REVIEW Зачем создавать rightBarButtonItem при каждом отображении?
// REVIEW Почему не сделать это раз?
// REVIEW Где это можно сделать кроме viewWillAppear и viewDidLoad?
    //self.navigationItem.title = @"???";
    XYZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
// REVIEW Непотребство. Поменять на прямую установку managedObjectContext
// REVIEW при создании контроллера. Всё должно быть явно.
    self.managedObjectContext = appDelegate.managedObjectContext;
    _textField.text = nil;
// REVIEW Что это?
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
// REVIEW Как можно переписать if-else так, чтобы кода стало в 2 раза меньше?
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
	// REVIEW Почему pop до root view controller?
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
// REVIEW Должен ли быть release/autorelease? Почему?
                    localNotification.fireDate = pickerDate;
                    localNotification.alertBody = self.textField.text;
                    localNotification.alertAction = @"Show me the item";
                    localNotification.timeZone = [NSTimeZone defaultTimeZone];
                    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                } else {
                newEntry.date = 0;  
// REVIEW Почему неверный отступ?
                }
            _textField.text = nil;
            _textField2.text = nil;
            _edit = NO;
// REVIEW Зачем? Ведь и так NO.
            [[self navigationController] popToRootViewControllerAnimated:YES];
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
// REVIEW Сообщать с помощью UIAlertView.
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
// REVIEW Упростить. Можно использовать Tap. Также лучше заменить resignFirstResponder на [UIView endEditing]. Почему?
}


- (IBAction)HideKeyBoard:(id)sender {
    [self.view endEditing:YES];
// REVIEW Почему здесь не resignFirstResponder, а более корректный endEditing?
}


- (IBAction)GetVisible:(id)sender {
// REVIEW Почему не camelCase? Почему открывающая скобка не на новой строке?
    {
// REVIEW Зачем { { ?
        if (self.SwitchOne.on) {
// REVIEW Зачем скобки, если всего лишь одна строка следует?
// REVIEW Как можно переписать это всё в одну строку?
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
// REVIEW Почему не все аутлеты?
}
@end
