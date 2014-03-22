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

#import "PoolController.h"

@interface PoolController ()
- (void)receivedJSON:(NSData *)data;
@end

@implementation PoolController
@synthesize poolStatusLbl, poolHashrateLbl, poolActiveWorkersLbl, poolSharesThisRoundLbl, poolLastBlockIdLbl, poolLastBlockSharesLbl, poolLastBlockFoundByLbl, poolLastBlockRewardLbl, poolDifficultyLbl;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh:(id)sender
{
    //NSLog(@"refresh");
    
    [self reset];
    [self fetchData];
}

- (void)reset
{
    self.poolStatusLbl.text = local(@"Getting data...");
    self.poolHashrateLbl.text = @"...";
    self.poolActiveWorkersLbl.text = @"...";
    self.poolSharesThisRoundLbl.text = @"...";
    self.poolLastBlockIdLbl.text = @"...";
    self.poolLastBlockSharesLbl.text = @"...";
    self.poolLastBlockFoundByLbl.text = @"...";
    self.poolLastBlockRewardLbl.text = @"...";
    self.poolDifficultyLbl.text = @"...";

}

- (void)fetchData
{
    //skip fetching data when no coin is selected to be shown
    if(![self canFetchData])
        return;
    
    self.poolStatusLbl.text = local(@"Getting data...");
    
    //Gets the api url
    NSString *apiUrl = [NSString stringWithFormat:poolPrefix, [self getKeyLabelBySelectedCoin]];
    NSURL *url = [[NSURL alloc] initWithString:apiUrl];
    
    if(request != nil)
        RELEASE_SAFELY(request);
    
    request = [[NSURLRequest requestWithURL:url] retain];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self fetchingFailedWithError:error];
        } else {
            [self receivedJSON:data];
        }
    }];
    //NSLog(@"%@", apiUrl);
}

- (void)receivedJSON:(NSData *)data
{
    //NSLog(@"data= %@", data);
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        [self fetchingFailedWithError:nil];
        return;
    }
    
    //NSLog(@"parsedObject= %@", parsedObject);
    self.poolStatusLbl.text = [NSString stringWithFormat:local(@"GMC %@ Pool Status"), [self getCoinBySelectedCoin]];
    self.poolHashrateLbl.text = [self readableHashSize:[parsedObject objectForKey:@"hashrate"]];
    self.poolActiveWorkersLbl.text = [parsedObject objectForKey:@"workers"];
    self.poolSharesThisRoundLbl.text = [NSString stringWithFormat:@"%d", [[parsedObject objectForKey:@"shares_this_round"] intValue]];
    self.poolLastBlockIdLbl.text = [parsedObject objectForKey:@"last_block"];
    self.poolLastBlockSharesLbl.text = [parsedObject objectForKey:@"last_block_shares"];
    self.poolLastBlockFoundByLbl.text = [parsedObject objectForKey:@"last_block_finder"];
    self.poolLastBlockRewardLbl.text = [parsedObject objectForKey:@"last_block_reward"];
    self.poolDifficultyLbl.text = [parsedObject objectForKey:@"difficulty"];
}

@end
