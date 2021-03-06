#import "AROptions.h"
#import "ARAppDelegate.h"
#import "ARAppDelegate+Emission.h"

static NSDictionary *options = nil;

// Up here is the NSUserDefault set, and sent into Emission

// UI Tweaks
NSString *const AROptionsBidManagement = @"AROptionsBidManagement";
NSString *const AROptionsEnableMyCollection = @"AROptionsEnableMyCollection";
NSString *const AROptionsLoadingScreenAlpha = @"AROptionsLoadingScreenAlpha";
NSString *const AROptionsShowAnalyticsOnScreen = @"AROptionsShowAnalyticsOnScreen";
NSString *const AROptionsShowMartsyOnScreen = @"AROptionsShowMartsyOnScreen";
NSString *const AROptionsViewingRooms = @"AROptionsViewingRooms";

// UX changes
NSString *const AROptionsDisableNativeLiveAuctions = @"AROptionsDisableNativeLiveAuctions";
NSString *const AROptionsDebugARVIR = @"AROptionsDebugARVIR";

// RN
NSString *const AROptionsStagingReactEnv = @"AROptionsStagingReactEnv";
NSString *const AROptionsDevReactEnv = @"AROptionsDevReactEnv";

// Dev
NSString *const AROptionsPriceTransparency = @"AROptionsPriceTransparency";
NSString *const AROptionsArtistSeries = @"AROptionsArtistSeries";
NSString *const AROptionsNewSalePage = @"AROptionsNewSalePage";
NSString *const AROptionsNewFirstInquiry = @"AROptionsNewFirstInquiry";


@implementation AROptions

// Down here is the user-facing description

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = @{
         AROptionsDebugARVIR: @"Debug AR View in Room",
         AROptionsDisableNativeLiveAuctions: @"Disable Native Live Auctions",
         AROptionsEnableMyCollection: @"Enable new MyCollection view",
         AROptionsViewingRooms: @"Enable Viewing Rooms",
         AROptionsPriceTransparency: @"Price Transparency",
         AROptionsLoadingScreenAlpha: @"Loading screens are transparent",
         AROptionsBidManagement: @"Enable Bid Management (a.k.a My Bids)",
         AROptionsNewSalePage: @"Enable new sale (auction) page",
         AROptionsNewFirstInquiry: @"Enable new first inquiry flow",
        };
    });
}

+ (NSArray *)labsOptions
{
    return options.allKeys;
}

+ (NSString *)descriptionForOption:(NSString *)option
{
    return options[option];
}

+ (NSDictionary *)labOptionsMap
{
    NSArray *options = [self labsOptions];
    NSMutableDictionary *mutableOptions = [NSMutableDictionary dictionary];

    for (NSString *option in options) {
        [mutableOptions setObject:@([self boolForOption:option]) forKey:option];
    }
    return [mutableOptions copy];
}

+ (NSArray *)labsOptionsThatRequireRestart
{
    return @[
        AROptionsDisableNativeLiveAuctions,
        AROptionsViewingRooms,
    ];
}

+ (BOOL)optionExists:(NSString *)option
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:option];
}

+ (BOOL)boolForOption:(NSString *)option
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:option];
}

+ (void)setBool:(BOOL)value forOption:(NSString *)option
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:option];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[ARAppDelegate sharedInstance] updateEmissionOptions];
}

@end
