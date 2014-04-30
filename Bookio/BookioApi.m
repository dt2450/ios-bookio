//
//  BookioApi.m
//  Bookio
//
//  Created by Pooja Jain on 4/24/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "BookioApi.h"

@interface BookioApi ()

@end


// References
// Asynchronus request: http://codewithchris.com/tutorial-how-to-use-ios-nsurlconnection-by-example/

// creating a block of type completionBlock so that result can directly be stored in the completion block of the fucntion call
typedef void (^ completionBlock)(NSMutableDictionary *results);
completionBlock setResult;

@implementation BookioApi


#pragma mark - NSURLConnection Delegate Methods

/*
 This method is called when the connection is made and a response is received.
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // we initialize the response data only when a successful connection is made
    responseData = [[NSMutableData alloc] init];
}

/*
 This method is called once the connection startes receving responses.
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //  The responses may be recieved in numerous chunks and hence should be appended to the previously received response date.
    [responseData appendData:data];
}

/*
 This method ensures that the response to the request is not cached.
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

/*
 This method is called when the complete response is received and the request is complete.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // the responce is in NSData, so we first serialize it to JSON format and then convert it to a dicionary for easy access
    NSMutableDictionary *returnedResult= (NSMutableDictionary*)[NSJSONSerialization  JSONObjectWithData:responseData options:kNilOptions error:nil];

    // stores the results in the completion block
    setResult(returnedResult);
}

/*
 This method is called the request fails due to some error
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

#pragma mark - implementing the google search api

/*
 This method implements the search method
 */
-(void)urlOfQuery:(id)url queryCompletion:(void (^)(NSMutableDictionary *))completionHandler
{
    
    NSString *query = url;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:query]];
    
    // Create url connection and initiates the above request
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // this ensure that the result is passed to the completion handler block
    setResult = completionHandler;
}

-(NSMutableDictionary *)asyncurlOfQuery:(id)url
{
    NSString *query = url;
    
    NSMutableDictionary *Result = NULL;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:query]];
    
    NSURLResponse *response;
    NSError *error;
    //send it synchronous
    //NSLog(@"url = %@", url);
    
    NSData *asyncResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //NSString *responseString = [[NSString alloc] initWithData:asyncResponseData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response = %@", responseString);
    //NSLog(@"data = %@", asyncResponseData);
    
    // check for an error. If there is a network error, you should handle it here.
    if(!error)
    {
        //NSLog(@"Is valid JSON = %d", [NSJSONSerialization isValidJSONObject:asyncResponseData]);
        Result = (NSMutableDictionary*)[NSJSONSerialization  JSONObjectWithData:asyncResponseData options:kNilOptions error:&error];
        if(error) {
            NSString *errorString = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
            NSLog(@"Error = %@", errorString);
        }
        //NSLog(@"Result = %@", Result);
    } else {
        NSString *errorString = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
        UIAlertView *gotError = [[UIAlertView alloc]
                                 initWithTitle:@"Error in request"
                                 message:errorString
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [gotError show];
    }
    return Result;
}

@end
