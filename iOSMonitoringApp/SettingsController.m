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

#import "SettingsController.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingsController ()
-(void)dismissKeyboard;
-(IBAction)saveSetting:(id)sender;
-(IBAction)deleteSetting:(id)sender;
@end

@implementation SettingsController
@synthesize apiText, descriptionText;
@synthesize saveSettingsButton, deleteSettingsButton;
@synthesize btcSwitch, ltcSwitch, ftcSwitch;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //sets the border of the api text border
    apiText.layer.borderWidth = 0.5f;
    apiText.layer.borderColor = GrayColor();
    
    //sets the border of the description border
    descriptionText.layer.borderWidth = 0.5f;
    descriptionText.layer.borderColor = GrayColor();
    
    //dismiss keyboard when touching outside of textfield
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)] autorelease];
    
    [self.view addGestureRecognizer:tap];
    
    
    //loads the NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *settings = [prefs dictionaryForKey:@"settings"];
    //Update the controllers
    if(settings)
    {
        btcSwitch.on = [[settings objectForKey:@"showBTC"] integerValue] == 1;
        ltcSwitch.on = [[settings objectForKey:@"showLTC"] integerValue] == 1;
        ftcSwitch.on = [[settings objectForKey:@"showFTC"] integerValue] == 1;
        apiText.text = [settings objectForKey:@"apiKey"];
    }
    else{
        apiText.text = local(@"Your API key without /pool/api-ltc...");
    }
}


-(void)dismissKeyboard
{
    [apiText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)scanButtonTapped:(id)sender
{
    //NSLog(@"scanButtonTapped...");
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}


-(IBAction)saveSetting:(id)sender
{
    //NSLog(@"saveSetting...");
    
    //loads the NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              apiText.text, @"apiKey",
                              [NSNumber numberWithInt:btcSwitch.on ? 1 : 0], @"showBTC",
                              [NSNumber numberWithInt:ltcSwitch.on ? 1 : 0], @"showLTC",
                              [NSNumber numberWithInt:ftcSwitch.on ? 1 : 0], @"showFTC",
                              nil];
    [prefs setObject:settings forKey:@"settings"];
    [prefs synchronize];
    
    [[iToast makeText:local(@"Settins has been successfully saved.")] show];
    
    //notify the other views
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingChangedNotification" object:self userInfo:nil];
}


//DIT gaat nog steeds fout...
-(IBAction)deleteSetting:(id)sender
{
    //NSLog(@"deleteSetting...");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //[prefs setObject:@"" forKey:@"settings"];
    [prefs removeObjectForKey:@"settings"];
    [prefs synchronize];
    
    btcSwitch.on = YES;
    ltcSwitch.on = YES;
    ftcSwitch.on = YES;
    apiText.text = local(@"Your API key with /pool/api-ltc...");
    
    [[iToast makeText:local(@"Settins has been successfully deleted.")] show];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    apiText.text = symbol.data;
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}

-(IBAction)switchValueChanged:(id)sender
{
    //TODO: Always keep one switch enabled
}


@end
