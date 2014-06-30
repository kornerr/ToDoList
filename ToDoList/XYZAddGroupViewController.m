//
//  XYZAddGroupViewController.m
//  ToDoList
//
//  Created by Kirill Skulkin on 18.03.14.
//
//

#import "XYZAddGroupViewController.h"
#import "XYZAppDelegate.h"
#import "Groups.h"

@interface XYZAddGroupViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *SwitchTwo;
@property (weak, nonatomic) IBOutlet UIPickerView *Colors;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property NSMutableArray *allColors;


@end

@implementation XYZAddGroupViewController
@synthesize group;
@synthesize selectedRow;

- (IBAction)GetVisible:(id)sender {
    {
        if (self.SwitchTwo.on) {
            self.Colors.hidden = NO;
        } else {
            self.Colors.hidden = YES;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
   // NSInteger *selectedRow = [self.Colors selectedRowInComponent:0];
    selectedRow = row;
    NSLog(@"You selected this: %i", selectedRow);

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 7;
    return numRows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void) addElementsToArray {
    self.allColors = [NSMutableArray array];
    [self.allColors addObject:@"White"];
    [self.allColors addObject:@"Yellow"];
    [self.allColors addObject:@"Orange"];
    [self.allColors addObject:@"Red"];
    [self.allColors addObject:@"Green"];
    [self.allColors addObject:@"Blue"];
    [self.allColors addObject:@"Purple"];
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [self.allColors objectAtIndex:row];
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    return sectionWidth;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.doneButton) return;
    if (self.textField.text.length > 0) {
       // self.groupItem = [[XYZTGroupItem alloc] init];
        // self.groupItem.groupName = self.textField.text;
        if (self.group) {
            // Update existing device
            [self.group setValue:self.textField.text forKey:@"groupName"];
            NSManagedObjectID *moID = [group objectID];
            NSLog(@"Updating Done %i", moID);
            NSSet *groupnotes = [self.group valueForKeyPath:@"fromGroupsToNotes.group"];
            NSLog(@"%@", groupnotes);
        } else {
        
        //Здесь код сохранения записи о группе в БД
        //  1
        Groups *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Groups"
                                                         inManagedObjectContext:self.managedObjectContext];
        //  2
        newEntry.groupName = self.textField.text;
        newEntry.color = 0;
        
        //  3
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        //  5
        NSLog(@"Inserting Done: %@,%@", newEntry.groupName, newEntry.color);
        
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

    XYZAppDelegate * blabla = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = blabla.managedObjectContext;
    if (self.group) {
        [self.textField setText:[self.group valueForKey:@"groupName"]];
    }
    
    [self addElementsToArray];
    self.Colors.delegate = self;
    self.Colors.showsSelectionIndicator = YES;
    
  
    
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
