//
//  TREditRecordingViewController.h
//  Rapper
//
//  Created by 雪本大樹 on 2014/05/11.
//  Copyright (c) 2014年 tolve. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TREditRecordingViewController : BaseViewController
{
    AVAudioPlayer *audio;
    AVPlayer *myPlayer;
    NSURL *recordedFileURL;
    BOOL playFlag;
}

@property NSURL *myFileURL;

@property IBOutlet UIButton *playBtn;

- (IBAction)playAndStop:(id)sender;

@end
