//
//  TREditRecordingViewController.m
//  Rapper
//
//  Created by 雪本大樹 on 2014/05/11.
//  Copyright (c) 2014年 tolve. All rights reserved.
//

#import "TREditRecordingViewController.h"

@implementation TREditRecordingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myPlayer = [[AVPlayer alloc] initWithURL:recordedFileURL];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RAPPR_SampleTrack" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audio.numberOfLoops = 1;
}

- (IBAction)playAndStop:(id)sender
{
    if (playFlag) {
        [audio stop];
        [myPlayer pause];
        [_playBtn setTitle:@"play" forState:UIControlStateNormal];
    } else {
        [audio prepareToPlay];
        [audio play];
        [myPlayer play];
        [_playBtn setTitle:@"stop" forState:UIControlStateNormal];
    }
}

@end
