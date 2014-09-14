//
//  TRRapListViewController.m
//  Rapper
//
//  Created by 雪本大樹 on 2014/05/17.
//  Copyright (c) 2014年 tolve. All rights reserved.
//

#import "TRRapListViewController.h"

#define MOVIE_ID        @"COkbC6upL-o"

@implementation TRRapListViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *htmlSrc = [NSString stringWithFormat:@"<html><body><object width=\"212\" height=\"172\"> <param name=\"movie\" value=\"http://www.youtube.com/v/%@\"></param> <param name=\"wmode\" value=\"transparent\"></param> <embed src=\"http://www.youtube.com/v/%@\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"212\" height=\"172\"></embed></object></body></html>",MOVIE_ID,MOVIE_ID];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame: CGRectMake(50, 50, 212, 172)];
    [webView loadHTMLString: htmlSrc baseURL: nil];
    [self.view addSubview: webView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RAPLIST"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RAPLIST"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
