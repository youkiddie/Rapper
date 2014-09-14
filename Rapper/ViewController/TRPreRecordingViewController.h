//
//  TRPreRecordingViewController.h
//  Rapper
//
//  Created by 雪本大樹 on 2014/05/01.
//  Copyright (c) 2014年 tolve. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TRPreRecordingViewController : BaseViewController
{
    AVAudioPlayer *audio;
    BOOL playing;
}

@property IBOutlet UISlider *beatTimer;
@property IBOutlet UISlider *volume;
@property IBOutlet UIButton *playBtn;
@property IBOutlet UILabel *audioDurationLbl;
@property IBOutlet UILabel *currentTimeLbl;

- (IBAction)playAndStop:(id)sender;
- (IBAction)volumeChanged:(id)sender;
- (IBAction)beatTimeChanged:(id)sender;

@end
