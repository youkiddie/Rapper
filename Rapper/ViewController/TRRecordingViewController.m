//
//  TRRecordingViewController.m
//  Rapper
//
//  Created by 雪本大樹 on 2014/05/10.
//  Copyright (c) 2014年 tolve. All rights reserved.
//

#import "TRRecordingViewController.h"

@implementation TRRecordingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RAPPR_SampleTrack" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
//    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    audio.numberOfLoops = 1;
    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [audioSession setActive:YES error:nil];
//    
//    captureSession = [[AVCaptureSession alloc] init];
//    
//    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
//    
//    NSError *error = nil;
//    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
//    
//    if (!audioInput) {
//        NSLog(@"error:%@",error);
//        return;
//    }
//    
//    [captureSession addInput:audioInput];
//    
//    audioFileOutput = [[AVCaptureMovieFileOutput alloc] init];
//    [captureSession addOutput:audioFileOutput];
//    
//    [captureSession startRunning];
}

- (IBAction)recAndStop:(id)sender
{
    if (recEnd) {
//        [audio stop];
        [audioFileOutput stopRecording];
        recEnd = NO;
    } else {
//        [audio prepareToPlay];
        [_recBtn setTitle:@"OK" forState:UIControlStateNormal];
        [audio play];
        recEnd = YES;
        [self recStart];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editSegue"]) {
        TREditRecordingViewController* nvc = (TREditRecordingViewController*)[segue destinationViewController];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (recEnd) {
        return YES;
    } else {
        return NO;
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    } else {
        NSLog(@"recorderror : %@",error);
    }
    
    
    if (RecordedSuccessfully)
    {
        //書き込んだのは/tmp以下なのでカメラーロールの下に書き出す
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {
                     NSLog(@"allibrary : %@",error);
                 }
             }];
        }
        
    }
    
    recordedFileURL = outputFileURL;
}

- (void) recStart
{
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [filePaths objectAtIndex:0];
    NSString *uniqueFilename = [NSString stringWithFormat:@"myrap%.0f.mov",[[NSDate date] timeIntervalSince1970]];
    NSString *path = [documentDir stringByAppendingPathComponent:uniqueFilename];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    [audioFileOutput startRecordingToOutputFileURL:url recordingDelegate:self];
}

@end
