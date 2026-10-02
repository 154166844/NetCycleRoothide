#import <substrate.h>
#import <Foundation/Foundation.h>

static NSString *TARGET_SSID = @"xmstsg";
static NSString *CMD_ON = @"defaults write com.xxx.conditionalwifi4 enable -bool true";
static NSString *CMD_OFF = @"defaults write com.xxx.conditionalwifi4 enable -bool false";

static void runShell(NSString *cmd) {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:@[@"-c", cmd]];
    @try {
        [task launch];
    } @catch(...) {}
}

void wifiNotify(NSNotification *notify) {
    NSDictionary *info = notify.userInfo;
    NSString *currentSSID = info[@"SSID"];
    NSNumber *isConnected = info[@"Connected"];

    if ([isConnected boolValue] && [currentSSID isEqualToString:TARGET_SSID]) {
        runShell(CMD_ON);
    } else if (![isConnected boolValue]) {
        runShell(CMD_OFF);
    }
}

%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"com.apple.network.wifi.state" object:nil queue:[NSOperationQueue mainQueue] usingBlock:wifiNotify];
}
