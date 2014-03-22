/**
 * 	Copyrights reserved to the author (Adil Ben Moussa <adil.benmoussa@gmail.com>) of this code (available from Github
 * 	repository https://github.com/adilbenmoussa/give-me-coins-iOSMonitoringApp
 *
 *
 *  This file is part of Give-me-coins.com Dashboard iOS App
 *
 *	Give-me-coins.com Dashboard is free software: you can redistribute it
 *	and/or modify it under the terms of the GNU General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "UIViewControllerWithBar.h"

@interface UIViewControllerWithBar ()
@end

@implementation UIViewControllerWithBar
@synthesize segmentedControl;
@synthesize request;

- (void)dealloc
{
    if(request != nil)
        RELEASE_SAFELY(request);
    
    if(segmentedControl != nil){
        [segmentedControl removeTarget:self action:@selector(segmetsValueChanged:) forControlEvents:UIControlEventValueChanged];
        RELEASE_SAFELY(segmentedControl);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settingChangedNotification:)
                                                 name:@"SettingChangedNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectedCoinChangeNotification:)
                                                 name:@"SelectedCoinChangedNotification"
                                               object:nil];
    
    //create the segmentedControl
    NSArray *items = [NSArray arrayWithObjects: local(@"BTC"), local(@"LTC"), local(@"FTC"), local(@"VTC"), nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    [segmentedControl setWidth:55 forSegmentAtIndex:0];
    [segmentedControl setWidth:55 forSegmentAtIndex:1];
    [segmentedControl setWidth:55 forSegmentAtIndex:2];
    [segmentedControl setWidth:55 forSegmentAtIndex:3];
    [segmentedControl addTarget:self action:@selector(segmetsValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    
    UIBarButtonItem *seg = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    self.navigationItem.rightBarButtonItem = seg;
    [seg release];

    //create the refresh button
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refresh:)];
    self.navigationItem.leftBarButtonItem = refreshBtn;
    [refreshBtn release];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSLog(@"settings= %@", settings);
    //Update the controllers
    selectedCoin = [[prefs objectForKey:@"selectedCoin"] integerValue];
    [self updateSegmentControl];
    [segmentedControl setSelectedSegmentIndex:selectedCoin];
    [self updateViewColor:selectedCoin];
    
	[self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSegmentControl{
    //Sets the correct color
    //loads the NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSLog(@"settings= %@", settings);
    //Update the controllers
    selectedCoin = [[prefs objectForKey:@"selectedCoin"] integerValue];
    NSDictionary *settings = [prefs objectForKey:@"settings"];
    BOOL showBTC = [[settings objectForKey:@"showBTC"] integerValue] == 1;
    BOOL showLTC = [[settings objectForKey:@"showLTC"] integerValue] == 1;
    BOOL showFTC = [[settings objectForKey:@"showFTC"] integerValue] == 1;
    BOOL showVTC = ![settings objectForKey:@"showVTC"] ? YES : [[settings objectForKey:@"showVTC"] integerValue] == 1;
    
    [self.segmentedControl setEnabled:showBTC forSegmentAtIndex:BTC];
    [self.segmentedControl setEnabled:showLTC forSegmentAtIndex:LTC];
    [self.segmentedControl setEnabled:showFTC forSegmentAtIndex:FTC];
    [self.segmentedControl setEnabled:showVTC forSegmentAtIndex:VTC];
}


- (void)settingChangedNotification:(NSNotification*)ntf
{
    //NSLog(@"settingChangedNotification");
    //notify the other views
    [self updateSegmentControl];
	[self fetchData];
}

- (void)selectedCoinChangeNotification:(NSNotification*)ntf
{
    //NSLog(@"selectedCoinChangeNotification");
    
    int selectedCoindInNotification = [[ntf.userInfo objectForKey:@"selectedCoin"] integerValue];
    if(selectedCoindInNotification != -1 && selectedCoindInNotification != segmentedControl.selectedSegmentIndex){
        segmentedControl.selectedSegmentIndex = selectedCoindInNotification;
        [self updateViewColor:selectedCoindInNotification];
        [self fetchData];
    }
}

-(void)segmetsValueChanged:(id)sender
{
    //NSLog(@"segmetsValueChanged");
    UISegmentedControl *control = sender;
	NSInteger index = [control selectedSegmentIndex];
    
    NSString *msg = [self updateViewColor:index];
    if (msg) {
        [[iToast makeText:msg] show];
    }
    
    [self reset];
    [self fetchData];
    
    //save to the default
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithInt:index] forKey:@"selectedCoin"];
    [prefs synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedCoinChangedNotification" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index], @"selectedCoin", nil]];
}


- (NSString *)updateViewColor:(CoinType)coinType
{
    //NSLog(@"coinType %d", coinType);
    NSString *msg = nil;
    switch (coinType)
	{
		case BTC:
			[self.view setBackgroundColor:BTCColor()];
            msg = local(@"Coin changed to BTC");
			break;
		case LTC:
			[self.view setBackgroundColor:LTCColor()];
            msg = local(@"Coin changed to LTC");
			break;
        case FTC:
			[self.view setBackgroundColor:FTCColor()];
            msg = local(@"Coin changed to FTC");
			break;
        case VTC:
			[self.view setBackgroundColor:VTCColor()];
            msg = local(@"Coin changed to VTC");
			break;
		default:
			break;
	}
    
    return msg;
}

- (NSString *)getKeyLabelBySelectedCoin
{
    NSString *label = @"b";
    switch (segmentedControl.selectedSegmentIndex)
	{
		case LTC:
            label = @"l";
			break;
        case FTC:
            label = @"f";
			break;
            break;
        case VTC:
            label = @"v";
			break;
		default:
			break;
	}
    return label;
}

- (NSString *)getCoinBySelectedCoin
{
    NSString *label = local(@"BTC");
    switch (segmentedControl.selectedSegmentIndex)
	{
		case LTC:
            label = local(@"LTC");
			break;
        case FTC:
            label = local(@"FTC");
			break;
            break;
        case VTC:
            label = local(@"VTC");
			break;
		default:
			break;
	}
    return label;
}

- (void)refresh:(id)sender
{
    //NSLog(@"refresh");
}

//To be overriden
- (void)fetchData
{
}

- (BOOL)canFetchData
{
    //skip fetching data when no coin is selected to be shown
    return segmentedControl.selectedSegmentIndex != -1 && [segmentedControl isEnabledForSegmentAtIndex:segmentedControl.selectedSegmentIndex];
}

- (void)fetchingFailedWithError:(NSError *)error
{
    //NSLog(@"data = %@", error);
    [[iToast makeText:local(@"Error getting data.")] show];
}

- (NSString *)readableHashSize:(id)size
{
    double convertedSize = [size doubleValue];
    if(size <= 0)
        return [NSString stringWithFormat:@"%f", convertedSize];
    
    int multiplyFactor = 0;
    NSArray *units = @[@"Kh/s", @"Mh/s", @"Gh/s", @"Th/s", @"Ph/s", @"Eh/s"]; //we left ouh h/s because API puts dot at kh/s!!
    while (convertedSize > 1000) {
        convertedSize /= 1000;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedSize, units[multiplyFactor]];
}

- (void)reset
{
}


@end
