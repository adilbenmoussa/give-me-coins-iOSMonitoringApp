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

//Define the macros
#define local(str) NSLocalizedString(str, nil)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// Safe releases
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define UA_runOnMainThread if (![NSThread isMainThread]) { dispatch_sync(dispatch_get_main_queue(), ^{ [self performSelector:_cmd]; }); return; };

//Define the constants
#define poolMinerPrefix @"https://give-me-coins.com/pool/api-%@tc?api_key=%@"
#define poolPrefix @"https://give-me-coins.com/pool/api-%@tc"

#define GrayColor() [[UIColor grayColor] CGColor]
#define BTCColor() RGBCOLOR(255, 153, 0)
#define LTCColor() RGBCOLOR(61, 122, 184)
#define FTCColor() RGBCOLOR(153, 102, 153)
#define VTCColor() RGBCOLOR(129, 153, 77)


#define BOLD14() [UIFont boldSystemFontOfSize:14.0f]
#define NORMAL14() [UIFont systemFontOfSize:14.0f]



