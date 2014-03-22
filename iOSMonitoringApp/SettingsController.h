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

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface SettingsController : UIViewController <ZBarReaderDelegate>{
    
    UITextView *apiText;
    UITextView *descriptionText;
    
    UISwitch *btcSwitch;
    UISwitch *ltcSwitch;
    UISwitch *ftcSwitch;
    UISwitch *vtcSwitch;
    
    BOOL keyBoadVisible;
}


@property (nonatomic, retain)  IBOutlet UITextView *apiText;
@property (nonatomic, retain)  IBOutlet UITextView *descriptionText;
@property (nonatomic, retain)  IBOutlet UISwitch *btcSwitch;
@property (nonatomic, retain)  IBOutlet UISwitch *ltcSwitch;
@property (nonatomic, retain)  IBOutlet UISwitch *ftcSwitch;
@property (nonatomic, retain)  IBOutlet UISwitch *vtcSwitch;
@property (nonatomic, assign)  BOOL keyBoadVisible;

-(IBAction)scanButtonTapped:(id)sender;
-(IBAction)switchValueChanged:(id)sender;


@end
