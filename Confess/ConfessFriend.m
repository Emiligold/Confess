//
//  ConfessFriend.m
//  Confess
//
//  Created by Noga badhav on 13/02/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "ConfessFriend.h"

@interface ConfessFriend ()

@property (nonatomic, assign) CGRect prevFrame;
@property (nonatomic, assign) CGRect prevFrameButton;
@property (nonatomic, assign) BOOL isFullScreen;
@property (weak, nonatomic) IBOutlet UILabel *textareaLabel;
@property (nonatomic, assign) NSUInteger previousLineNumberWrapper;
@property (nonatomic, assign) NSUInteger currLineNumberWrapper;

@end

@implementation ConfessFriend

NSUInteger const MAX_LINES = 5;
BOOL fadedin = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.numberOfLines = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageButton.layer.masksToBounds = YES;
    self.imageButton.layer.cornerRadius = 20;
    self.imageButton.contentMode = UIViewContentModeScaleAspectFit;
    self.content.backgroundColor = [UIColor redColor];
    self.textareaLabel.hidden = NO;
    self.textareaLabel.alpha = 0.0;
    self.content.text = @"";
    self.content.delegate = self;
    [self.content setReturnKeyType:UIReturnKeyDone];
    //self.content.textContainer.maximumNumberOfLines = 4;
    //[self.content.layoutManager textContainerChangedGeometry:self.content.textContainer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDetailItem:(NSString*) name : (NSString*) userID : (FriendsTab*) view :
    (NSMutableArray*) dialogs : (CodeUrls*) url url: (UIImage*) image
{
    self.name.text = name;
    self.userID = userID;
    self.friendsView = view;
    self.userUrl = url;
    self.profileImage = image;
    [self.imageButton setBackgroundImage:self.profileImage forState:UIControlStateNormal];
    self.textareaLabel.hidden = NO;
    self.content.text = @"";
    [self.content becomeFirstResponder];
    
    if (!fadedin)
    {
        fadedin = YES;
        [self fadein];
    }
}

-(void) fadein
{
    self.textareaLabel.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //don't forget to add delegate.....
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDuration:1];
    self.textareaLabel.alpha = 1;
    
    //also call this before commit animations......
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}

-(void) fadeout
{
    self.textareaLabel.alpha = 1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //don't forget to add delegate.....
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDuration:1];
    self.textareaLabel.alpha = 0;
    
    //also call this before commit animations......
    [UIView setAnimationDidStopSelector:@selector(fadein)];
    [UIView commitAnimations];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished    context:(void *)context
{
    //[UIView beginAnimations:nil context:nil];
    //[UIView setAnimationDuration:1];
    //self.textareaLabel.alpha = 0;
    [UIView commitAnimations];
    [self fadeout];
}

- (IBAction)exitClicked:(UIButton *)sender
{
    [self.friendsView exitFriendClicked];
}

- (IBAction)imageClicked:(id)sender {
    //[self imgToFullScreen];
}

-(void)imgToFullScreen{
    if (!self.isFullScreen) {
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            self.prevFrame = self.navigationItem.rightBarButtonItem.customView.frame;
            self.prevFrameButton = self.navigationItem.rightBarButtonItem.customView.frame;
            [self.navigationItem.rightBarButtonItem.customView setFrame:[[UIScreen mainScreen] bounds]];
            //[self.imageButton setFrame:[[UIScreen mainScreen] bounds]];
            //self.confessesTableView.hidden = YES;
        }completion:^(BOOL finished){
            self.isFullScreen = true;
            self.tabBarController.tabBar.hidden = YES;
        }];
        return;
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            [self.navigationItem.rightBarButtonItem.customView setFrame:self.prevFrame];
            //[self.imageButton setFrame:self.prevFrameButton];
        }completion:^(BOOL finished){
            self.isFullScreen = false;
            self.tabBarController.tabBar.hidden = NO;
            //self.confessesTableView.hidden = NO;
        }];
        return;
    }
}

-(void)sendConfess:(NSString*) confess
{
    
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.textareaLabel.hidden = YES;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
   
    self.previousLineNumberWrapper = [self countLineNumberWrapper];
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currLineNumberWrapper = [self countLineNumberWrapper];
    
    if (self.currLineNumberWrapper > self.previousLineNumberWrapper && self.numberOfLines != self.currLineNumberWrapper)
    {
        self.numberOfLines++;
    }
    else if (self.currLineNumberWrapper < self.previousLineNumberWrapper && self.numberOfLines != self.currLineNumberWrapper)
    {
        self.numberOfLines--;
    }
    if (self.currLineNumberWrapper > MAX_LINES || self.numberOfLines > MAX_LINES)
    {
        textView.text = [textView.text substringToIndex:textView.text.length - 1];
        [textView resignFirstResponder];
    }
    
}

-(unsigned)countLineNumberWrapper
{
    NSLayoutManager *layoutManager = [self.content layoutManager];
    unsigned numberOfLines, index, numberOfGlyphs =
    [layoutManager numberOfGlyphs];
    NSRange lineRange;
    for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
        (void) [layoutManager lineFragmentRectForGlyphAtIndex:index
                                               effectiveRange:&lineRange];
        index = NSMaxRange(lineRange);
    }
    
    return numberOfLines ;//+ self.numberOfLines;
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
