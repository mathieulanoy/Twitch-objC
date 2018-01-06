//
//  TTChatView.m
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "TTChatView.h"
#import "TTChatServices.h"
#import "TTRoom.h"
#import "NSBundle+TwitchChatSDK.h"
#import "UIImageView+WebCache.h"
#import <TwitchSDK/TwitchSDK.h>

@interface TTChatView()<TTRoomDelegate, UITextViewDelegate>

#pragma mark - UI
@property (weak, nonatomic) IBOutlet UIWebView              *chatView;

@property (weak, nonatomic) IBOutlet UIView                 *v_input;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *input_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *close_input_height;

@property (weak, nonatomic) IBOutlet UIView                 *v_input_text;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *input_text_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *input_text_bottom;
@property (weak, nonatomic) IBOutlet UITextView             *tf_text;
@property (weak, nonatomic) IBOutlet UIButton               *bt_emoticon;
- (IBAction)emoticon_click:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton               *bt_send;
- (IBAction)send_click:(id)sender;

#pragma mark - Headers
@property (weak, nonatomic) IBOutlet UILabel                *lb_channel;
@property (weak, nonatomic) IBOutlet UIImageView            *img_moderators;
@property (weak, nonatomic) IBOutlet UILabel                *lb_moderators;
@property (weak, nonatomic) IBOutlet UILabel *lb_viewers;

- (void) setupUI;

#pragma mark - Datas
@property (strong, nonatomic) NSMutableArray                *ar_messages;
@property (strong, nonatomic) NSArray                       *ar_emoticons;
@property (strong, nonatomic) TTChatBadges                  *badges;

@property (strong, nonatomic) NSString                      *channel;

@property (strong, nonatomic) TTRoom                        *room;

@end

@implementation TTChatView

- (void) connectToChat: (NSString *) channel
                  user:(NSString *) user
                 token:(NSString *) token{
    if (user && [user length] > 0){
        [[TTChatServices sharedChat] setUser:user];
        [[TTChatServices sharedChat] setToken:token];
    }
    
    self.channel = channel;
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userFetched:)
                                                 name:TTCoreDidFetchUserNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //set notification for when a key is pressed.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(keyPressed:)
                                                 name: UITextViewTextDidChangeNotification 
                                               object: nil];
    
    [[TTChatServices sharedChat] joinChatForChannel:channel delegate:self];
    self.ar_messages = [NSMutableArray new];
    
    TTChatView __weak *this = self;
    [TTCore getEmoticonsForChannel:channel success:^(NSArray *emoticons) {
        this.ar_emoticons = emoticons;
    } failure:^(NSError *error) {
    }];
    
    [TTCore getBadgesForChannel:channel success:^(TTChatBadges *badges) {
        this.badges = badges;
        [this.img_moderators sd_setImageWithURL:[NSURL URLWithString:badges.mod.image] placeholderImage:nil options:SDWebImageRefreshCached];
    } failure:^(NSError *error) {
    }];
    
    NSString *path = [[NSBundle TwitchChatResourcesBundle] pathForResource:@"twitchChat" ofType:@"html"];
    NSString *htmlTemplate = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.chatView loadHTMLString:htmlTemplate baseURL:nil];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void) setupUI {
    self.tf_text.delegate = self;
    self.tf_text.text = NSLocalizedString(@"Send a message", "");
    self.tf_text.textColor = [UIColor lightGrayColor];
    
    self.chatView.opaque = NO;
    self.chatView.backgroundColor = [UIColor clearColor];
    self.chatView.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    self.bt_send.layer.borderColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f].CGColor;
    self.bt_send.layer.borderWidth = 0.5f;
    self.bt_send.layer.cornerRadius = self.bt_send.frame.size.width / 2.0f;
    
    UIImage *image = [[UIImage imageNamed:@"img_ttchat_send" inBundle:[NSBundle TwitchChatResourcesBundle] compatibleWithTraitCollection:nil]
                      imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.bt_send setImage:image forState:UIControlStateNormal];
    self.bt_send.tintColor = [UIColor whiteColor];
    
    image = [[UIImage imageNamed:@"img_ttchat_emoticon" inBundle:[NSBundle TwitchChatResourcesBundle] compatibleWithTraitCollection:nil]
             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.bt_emoticon setImage:image forState:UIControlStateNormal];
    self.bt_emoticon.tintColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
    
    self.v_input_text.layer.borderColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f].CGColor;
    self.v_input_text.layer.borderWidth = 1.0f;
    self.v_input_text.layer.cornerRadius = 2.0f;
}

- (void) displayUserInput {
    self.input_height.priority = 999;
    self.close_input_height.priority = 750;
}

- (void) displayMessage:(NSDictionary *) datas {
    NSString *message = datas[@"message"];
    TTChatUser *user = datas[@"user"];
    NSDate *date = datas[@"time"];
    BOOL isSubscriber = [datas[@"isSubscriber"] boolValue];
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"HH:mm";
    NSString *date_str = [df stringFromDate:date];
    
    NSString *user_name = @"";
    if (self.room && self.badges){
        NSArray *moderators = [self.room getModerators];
        for (TTChatUser *moderator in moderators){
            if ([[moderator getDisplayName] isEqualToString:[user getDisplayName]]){
                user_name = [user_name stringByAppendingFormat:@"<img src=\"%@\" style=\"width: 15px; height: 15px; position: relative; top: 2px;\"/> ", self.badges.mod.image];
                break;
            }
        }
    }
    
    if (isSubscriber) {
        user_name = [user_name stringByAppendingFormat:@"<img src=\"%@\" style=\"width: 15px; height: 15px; position: relative; top: 2px;\"/> ", self.badges.subscriber.image];
    }
    
    if ([[NSString stringWithFormat:@"#%@", [user getDisplayName]] isEqualToString:[self.room getName]]){
        user_name = [user_name stringByAppendingFormat:@"<img src=\"%@\" style=\"width: 15px; height: 15px; position: relative; top: 2px;\"/> ", self.badges.broadcaster.image];
    }
    NSString *cssClass = @"lightBackground";
    if ([self.ar_messages count] % 2 == 0){
        cssClass = @"darkBackground";
    }
    user_name = [user_name stringByAppendingString:[[user getNickName] capitalizedString]];
    NSDictionary *dict = @{@"__DATE__" : date_str,
                           @"__AUTHOR__" : user_name,
                           @"__MESSAGE__" : message,
                           @"__CSS_CLASS__": cssClass,
                           @"__AUTHOR_COLOR__":[user getNicknameColor]};
    
    NSString *path = [[NSBundle TwitchChatResourcesBundle] pathForResource:@"chatMessage" ofType:@"html"];
    NSString *htmlTemplate = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *htmlContent = [NSMutableString stringWithString:htmlTemplate];
    for (NSString *key in [dict allKeys]) {
        [htmlContent replaceOccurrencesOfString:key
                                     withString:[dict objectForKey:key]
                                        options:NSCaseInsensitiveSearch
                                          range:NSMakeRange(0, [htmlContent length])];
    }
    
    NSMutableString *mut_htmlContent = [NSMutableString stringWithString:htmlContent];
    for (TTChatEmoticon *emoticon in self.ar_emoticons){
        [mut_htmlContent replaceOccurrencesOfString:emoticon.regex
                                         withString:[NSString stringWithFormat:@"<img src=\"%@\" style=\"width: 20px; height: 20px;\"/>", emoticon.url]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [htmlContent length])];
    }
    

    CGFloat scrollPosition = self.chatView.scrollView.contentOffset.y;
    CGFloat contentHeight = self.chatView.scrollView.contentSize.height;
    BOOL shouldScroll = NO;
    if (scrollPosition >= contentHeight - self.chatView.frame.size.height - 150.0f){
        shouldScroll = YES;
    }
    NSString *js = [NSString stringWithFormat:@"document.body.innerHTML += '%@'", mut_htmlContent];
    [self.chatView stringByEvaluatingJavaScriptFromString:js];
    
    if (shouldScroll){
        contentHeight = self.chatView.scrollView.contentSize.height;
        [self.chatView.scrollView setContentOffset:CGPointMake(0.0f, contentHeight - self.chatView.frame.size.height) animated:NO];
    }
}

#pragma mark - TTRoomDelegate
- (void) roomJoined:(TTRoom *)room {
    NSLog(@"room joined: %@", [room getName]);
    NSString *room_name = [room getName];
    if ([room_name rangeOfString:@"#"].location == 0){
        room_name = [room_name substringFromIndex:1];
    }
    NSInteger mod_count = [[room getModerators] count];
    self.lb_moderators.text = [NSString stringWithFormat:@"%ld", (long)mod_count];
    
    mod_count = [[room getUsers] count];
    self.lb_viewers.text = [NSString stringWithFormat:@"%ld", (long)mod_count];
    
    self.lb_channel.text = room_name;
    self.room = room;
}

- (void) roomParted:(TTRoom *)room
             reason:(NSString *)reason {
    NSLog(@"room parted: %@ : %@", [room getName], reason);
}

- (void) room:(TTRoom *)room joinedByUser:(TTChatUser *)user {
    NSLog(@"===== %@ has joined [%@] =====", [user getDisplayName], [room getName]);
}

- (void) room:(TTRoom *)room partedByUser:(TTChatUser *)user reason:(NSString *)reason {
    NSLog(@"===== %@ has left [%@] : %@ =====", [user getDisplayName], [room getName], reason);
}

- (void) room:(TTRoom *)room hasMessage:(NSString *)message fromUser:(TTChatUser *)user isSubscriber:(BOOL)isSubscriber{
    NSDictionary *datas = @{@"message":message, @"user":user, @"time":[NSDate date], @"isSubscriber": @(isSubscriber)};
    NSInteger mod_count = [[room getModerators] count];
    self.lb_moderators.text = [NSString stringWithFormat:@"%ld", (long)mod_count];
    
    mod_count = [[room getUsers] count];
    self.lb_viewers.text = [NSString stringWithFormat:@"%ld", (long)mod_count];

    [self.ar_messages addObject:datas];
    [self displayMessage:datas];
}

- (void) userFetched:(NSNotification *) notification {
    TTUser *user = [[TTSession sharedSession] getUser];
    NSString *token = [[TTSession sharedSession] getToken];
    [[TTChatServices sharedChat] setUser:user.display_name];
    [[TTChatServices sharedChat] setToken:token];
    [[TTChatServices sharedChat] reconnect];
    [self displayUserInput];
}

#pragma mark - KeyBoards Notification

-(void) keyboardWillShow:(NSNotification *)note{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    CGFloat kbSizeH = keyboardBounds.size.height;
    
    self.input_text_bottom.constant = kbSizeH;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat contentHeight = self.chatView.scrollView.contentSize.height;
        [self.chatView.scrollView setContentOffset:CGPointMake(0.0f, contentHeight - self.chatView.frame.size.height) animated:YES];
    }];
}

-(void) keyPressed: (NSNotification*) notification{
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:self.tf_text.text attributes:@{NSFontAttributeName: self.tf_text.font}];
    CGRect rect = [text boundingRectWithSize:(CGSize){self.tf_text.frame.size.width, CGFLOAT_MAX}
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                     context:nil];
    CGSize size = rect.size;
    CGFloat height = ceilf(size.height);
    
    if (self.tf_text.hasText){
        if (height <= 51.0f){
            self.input_text_height.constant = height + 13.0f;
            [UIView animateWithDuration:0.1f animations:^{
                [self layoutIfNeeded];
            }];
        }
        else if (height > 51.0f){
        }
    }
}

-(void) keyboardWillHide:(NSNotification *) notification{
    self.input_text_bottom.constant = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:NSLocalizedString(@"Send a message", "")]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"Send a message", "");
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text; {
    if ([text isEqualToString:@"\n"]) {
        [self send_click:self.tf_text];
        return NO;
    }
    return YES;
}

#pragma mark - Button actions
- (IBAction)emoticon_click:(id)sender {
}

- (IBAction)send_click:(id)sender {
    [self.tf_text resignFirstResponder];
    NSString *text = self.tf_text.text;
    if ([text isEqualToString:NSLocalizedString(@"Send a message", "")]){
        return;
    }
    self.tf_text.text = NSLocalizedString(@"Send a message", "");
    self.tf_text.textColor = [UIColor lightGrayColor];
    self.input_text_height.constant = 30.0f;
    [UIView animateWithDuration:0.1f animations:^{
        [self layoutIfNeeded];
    }];
    [self.room sendMessage:text];
}
@end
