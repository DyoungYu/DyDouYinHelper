#import <UIKit/UIKit.h>


static NSString * const NOTIFY_VIDEO_PLAY_END = @"notifyVideoPlayEnd";

@interface AWEFeedTableViewController : UIViewController

@property (nonatomic, assign) NSInteger currentPlayIndex;

- (void)playNext:(NSNotification *)aNotification;

@end



//MARK => 弹框取消
%hook UIViewController
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(id)completion{
    
if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
return;
}
%orig;
}
%end


//MARK => 自动播放
%hook AWEFeedTableViewController
//纯净模式。无广告，但是会屏蔽标题和评论按钮等控件。
- (BOOL)pureMode{
  return NO;
}
- (void)viewDidLoad{
%orig;
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNext:) name:NOTIFY_VIDEO_PLAY_END object:nil];
}
%new
- (void)playNext:(NSNotification *)notification{
    UITableView *tableView = MSHookIvar<UITableView*>(self,"_tableView");
    NSInteger currentPlayIndex = MSHookIvar<NSInteger>(self,"_currentPlayIndex");
    NSIndexPath *path = [NSIndexPath indexPathForRow:++currentPlayIndex inSection:0];
    [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

%end

%hook AWEVideoPlayerController
- (void)playerItemDidReachEnd:(id)arg1{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_VIDEO_PLAY_END object:nil userInfo:nil];
}
%end
