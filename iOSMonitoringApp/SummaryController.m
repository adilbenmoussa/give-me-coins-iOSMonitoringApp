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

#import "SummaryController.h"
#import "WorkerTableCell.h"

@interface SummaryController ()
- (void)receivedJSON:(NSData *)objectNotation;
- (void)fetchingFailedWithError:(NSError *)error;
- (NSMutableArray *)firstWorker;
@end

@implementation SummaryController
@synthesize workersTable;
@synthesize dataTitleLbl, hashRateLbl, confirmedRewardsLbl, roundEstimateLbl, roundSharesLbl, payoutHistoryLbl;
@synthesize workers;

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    workersTable.dataSource = self;
    workers = [[NSMutableArray alloc] init];
    [super viewDidLoad];
}

- (void)fetchData
{
    //Gets the api url
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *settings = [prefs dictionaryForKey:@"settings"];
    NSString *apiKey = [settings objectForKey:@"apiKey"];

    //skip fetching data when no coin is selected to be shown
    if(![self canFetchData] && [apiKey length] != kHashKeyLength)
        return;
    
    dataTitleLbl.text = local(@"Getting data...");
    
    if(workers != nil)
        [workers release];
    
    workers = [[NSMutableArray arrayWithObjects:[self firstWorker], nil] retain];
    [workersTable reloadData];
    
    NSString *apiUrl = [NSString stringWithFormat:poolMinerPrefix, [self getKeyLabelBySelectedCoin], [settings objectForKey:@"apiKey"]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)receivedJSON:(NSData *)data
{
    //NSLog(@"data= %@", data);
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        [self fetchingFailedWithError:nil];
        return ;
    }
    
    //NSLog(@"parsedObject= %@", parsedObject);
    
    NSString *username = [parsedObject objectForKey:@"username"];
    NSString *total_hashrate = [parsedObject objectForKey:@"total_hashrate"];
    double confirmed_rewards = [[parsedObject objectForKey:@"confirmed_rewards"] doubleValue];
    NSString *round_estimate = [parsedObject objectForKey:@"round_estimate"];
    NSString *round_shares = [parsedObject objectForKey:@"round_shares"];
    NSString *payout_history = [parsedObject objectForKey:@"payout_history"];
    
    self.dataTitleLbl.text = [NSString stringWithFormat:local(@"Data for user %@"), username];
    if(![total_hashrate isKindOfClass:[NSNull class]])
    {
        self.hashRateLbl.text = [self readableHashSize:total_hashrate];
    }
    self.confirmedRewardsLbl.text = [NSString stringWithFormat:@"%f", confirmed_rewards];
    if(![round_estimate isKindOfClass:[NSNull class]])
    {
        self.roundEstimateLbl.text = round_estimate;
    }
    
    if(![round_shares isKindOfClass:[NSNull class]])
    {
        self.roundSharesLbl.text = round_shares;
    }
    if(![payout_history isKindOfClass:[NSNull class]])
    {
        self.payoutHistoryLbl.text = payout_history;
    }
    
    NSMutableDictionary *jsonWorkers = [parsedObject objectForKey:@"workers"];
    //NSLog(@"jsonWorkers= %@", jsonWorkers);
    for (NSString* key in jsonWorkers) {
        id value = [jsonWorkers objectForKey:key];
        // do stuff
        //NSLog(@"value= %@", value);
        int active = [[value objectForKey:@"alive"] integerValue];
        [workers addObject:[NSMutableArray arrayWithObjects:key, active == 1 ? local(@"Active") : local(@"Not active"), [value objectForKey:@"hashrate"],  nil]];
    }
    
    //reload the workers table data
    if([workers count] > 1)
        [workersTable reloadData];
}


- (void)refresh:(id)sender
{
    //NSLog(@"refresh");
    
    [self reset];
    [self fetchData];
}

- (void)reset
{
    dataTitleLbl.text = local(@"Getting data...");
    self.dataTitleLbl.text = @"...";
    self.hashRateLbl.text = @"...";
    self.confirmedRewardsLbl.text = @"...";
    self.roundEstimateLbl.text = @"...";
    self.roundSharesLbl.text = @"...";
    self.payoutHistoryLbl.text = @"...";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [workers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"WorkerTableCell";
    
    WorkerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WorkerTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSMutableArray *data = [workers objectAtIndex:indexPath.row];
    if([data count]  == 4){
        //set the bold font
        cell.label1.font =  cell.label2.font = cell.label3.font =  BOLD14();
    }
    else{
        cell.label1.font =  cell.label2.font = cell.label3.font =  NORMAL14();
    }
    cell.label1.text = [data objectAtIndex:0];
    cell.label2.text = [data objectAtIndex:1];
    cell.label3.text = [data objectAtIndex:2];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

//Create a fake worker in order to set the header for workers table
- (NSMutableArray *)firstWorker
{
    return [NSMutableArray arrayWithObjects:local(@"Worker name"), local(@"Worker status"), local(@"Hash rate"), @"1", nil];
}


@end
