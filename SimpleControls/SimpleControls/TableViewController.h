//
//  TableViewController.h
//  SimpleControl
//
//  Created by Cheong on 7/11/12.
//  Copyright (c) 2012 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface TableViewController : UITableViewController <BLEDelegate>
{
    //main page
    IBOutlet UISwitch *switchOff;
    IBOutlet UISwitch *switchIR;
    IBOutlet UISwitch *switchAux;
    IBOutlet UISwitch *switchManual;
    IBOutlet UISwitch *switchMic;
    
    IBOutlet UIActivityIndicatorView *indConnecting;
    IBOutlet UILabel *lblRSSI;
    IBOutlet UIButton *btnConnect;

    //manual controls
    IBOutlet UISlider *strobeSlider;
    IBOutlet UISlider *redSlider;
    IBOutlet UISlider *greenSlider;
    IBOutlet UISlider *blueSlider;
    
    //labels
    IBOutlet UILabel *lightOutLabel;
    IBOutlet UILabel *colorIRLabel;
    IBOutlet UILabel *colorManualLabel;
    IBOutlet UILabel *colorAuxLabel;
    IBOutlet UILabel *colorMicLabel;
       
    IBOutlet UILabel *blueLabel;
    IBOutlet UILabel *greenLabel;
    IBOutlet UILabel *redLabel;
    IBOutlet UILabel *strobeSpeedLabel;
}

@property (strong, nonatomic) BLE *ble;

@end
