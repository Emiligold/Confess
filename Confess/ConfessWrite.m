//
//  ConfessWrite.m
//  Confess
//
//  Created by Noga badhav on 09/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "ConfessWrite.h"
#import "AppDelegate.h"
#import "ColorsHandler.h"
#import "DBServices.h"

@interface ConfessWrite ()

@property (nonatomic, strong) AppDelegate *appDelegate;
//-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation ConfessWrite

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
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[[NSNotificationCenter defaultCenter] addObserver:self
    //                                         selector:@selector(didReceiveDataWithNotification:)
    //                                             name:@"MCDidReceiveDataNotification"
    //                                           object:nil];
    [self.textArea setReturnKeyType:UIReturnKeyDone];
    [self.textArea setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [self.textArea setTextColor:[UIColor lightGrayColor]];
    self.textArea.clipsToBounds = YES;
    self.textArea.layer.cornerRadius = 25.0f;
    [self.initailText setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [self.initailText setTextColor:[UIColor lightGrayColor]];
    self.initailText.text = [NSString stringWithFormat:@"%@%@", @"Confess ", self.name];
    self.view.backgroundColor = [DBServices getNextColor:[[LocalStorageService shared] currentUser].ID];
    self.textArea.backgroundColor = self.view.backgroundColor;
    self.textArea.textColor = [UIColor whiteColor];
    self.initailText.textColor = [UIColor whiteColor];
    self.closeButto.backgroundColor = self.view.backgroundColor;
    self.infoButton.backgroundColor = self.view.backgroundColor;
    self.confessButton.backgroundColor = self.view.backgroundColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initProperties : (NSString*) pName : (ConfessView*) view
{
    self.name = pName;
    self.confessView = view;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)confessClicked:(id)sender
{
    if([self.textArea.text  isEqualToString: @""]){
        return;
    }
    
    [self sendMessage];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)sendMessage
{
    [self.confessView sendConfess:self.textArea.text];
}

- (IBAction)closeClicked:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (!self.textArea.hidden) {
        self.textArea.text = @"";
        self.textArea.textColor = [UIColor blackColor];
        self.initailText.hidden = YES;
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.textArea.text.length == 0){
        self.textArea.textColor = [UIColor lightGrayColor];
        //self.textArea.text = [NSString stringWithFormat:@"%@%@", @"Confess ", self.name];
        [self.textArea resignFirstResponder];
        self.initailText.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(self.textArea.text.length == 0){
            self.textArea.textColor = [UIColor lightGrayColor];
            //self.textArea.text = [NSString stringWithFormat:@"%@%@", @"Confess ", self.name];
            [self.textArea resignFirstResponder];
            self.initailText.hidden = NO;
        }
        return NO;
    }
    
    return YES;
}

- (IBAction)swipedAction:(id)sender {
    self.view.backgroundColor = [DBServices getNextColor:[[LocalStorageService shared] currentUser].ID];
    self.textArea.backgroundColor = self.view.backgroundColor;
    self.closeButto.backgroundColor = self.view.backgroundColor;
    self.infoButton.backgroundColor = self.view.backgroundColor;
    self.confessButton.backgroundColor = self.view.backgroundColor;
}

- (IBAction)leftSwipedAction:(id)sender {
    self.view.backgroundColor = [DBServices getPreviousColor:[[LocalStorageService shared] currentUser].ID];
    self.textArea.backgroundColor = self.view.backgroundColor;
    self.closeButto.backgroundColor = self.view.backgroundColor;
    self.infoButton.backgroundColor = self.view.backgroundColor;
    self.confessButton.backgroundColor = self.view.backgroundColor;
}

@end
