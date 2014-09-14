//
//  TRPreRecordingViewController.m
//  Rapper
//
//  Created by 雪本大樹 on 2014/05/01.
//  Copyright (c) 2014年 tolve. All rights reserved.
//

#import "TRPreRecordingViewController.h"

@implementation TRPreRecordingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RAPPR_SampleTrack" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _volume.value = audio.volume;
    audio.numberOfLoops = 1;

    _beatTimer.maximumValue = audio.duration;
    _audioDurationLbl.text = [self setTimeValueString:audio.duration];
    _currentTimeLbl.text = [self setTimeValueString:audio.currentTime];
    _beatTimer.minimumValue = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (playing) {
        playing = NO;
        [_playBtn setTitle:@"play" forState:UIControlStateNormal];
        [audio stop];
    }
}

- (IBAction)playAndStop:(id)sender
{
    if (playing) {
        playing = NO;
        [_playBtn setTitle:@"play" forState:UIControlStateNormal];
        [audio stop];
        
    } else {
        [audio prepareToPlay];
        [_playBtn setTitle:@"stop" forState:UIControlStateNormal];
        [audio play];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        
        playing = YES;
    }
}

- (IBAction)volumeChanged:(id)sender
{
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)sender;
        if (audio) {
            audio.volume = slider.value;
        }
    }
}

- (IBAction)beatTimeChanged:(id)sender
{
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)sender;
        if (audio) {
//            audio.currentTime = CMTimeMakeWithSeconds((int)slider.value,1);
            [audio setCurrentTime:(NSInteger)slider.value];
            [self updateTime];
        }
    }
}

- (void)updateTime {
    _beatTimer.value = audio.currentTime;
    _currentTimeLbl.text = [self setTimeValueString:audio.currentTime];
}

- (NSString *)setTimeValueString:(NSTimeInterval)time
{
    int minutes = floor(time / 60);
    int second = (int)time % 60;
    NSString *timeValue = [NSString stringWithFormat:@"%02d:%02d",minutes,second];
    
    return timeValue;
}

@end
