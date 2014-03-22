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

typedef enum
{
    BTC = 0,
    LTC,
    FTC,
    VTC
}CoinType;

@interface UIViewControllerWithBar : UIViewController{
    UISegmentedControl *segmentedControl;
    CoinType selectedCoin;
    NSURLRequest *request;
}

@property (nonatomic, retain)  UISegmentedControl *segmentedControl;
@property (nonatomic, retain) NSURLRequest *request;

- (NSString *)updateViewColor:(CoinType)coinType;
- (NSString *)getKeyLabelBySelectedCoin;
- (void)updateSegmentControl;
- (void)settingChangedNotification:(NSNotification*)ntf;
- (void)fetchData;
- (void)refresh:(id)sender;
- (void)segmetsValueChanged:(id)sender;
- (BOOL)canFetchData;
- (void)fetchingFailedWithError:(NSError *)error;
- (NSString *)readableHashSize:(id)size;
- (void)reset;

@end
