//
//  TableViewController.m
//  SimpleControl
//
//  Created by Cheong on 7/11/12.
//  Copyright (c) 2012 RedBearLab. All rights reserved.
//

#import "TableViewController.h"


@interface TableViewController ()

@end

@implementation TableViewController

@synthesize ble;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    ble = [[BLE alloc] init];
    [ble controlSetup];
    ble.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BLE delegate

NSTimer *rssiTimer;

//BLE DISCONNECTS
- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected");

    [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
    [indConnecting stopAnimating];
    
    //disable switches and sliders
    switchOff.enabled = false;
    switchIR.enabled = false;
    switchAux.enabled = false;
    switchManual.enabled = false;
    switchMic.enabled = false;
  
    strobeSlider.enabled = false;
    redSlider.enabled = false;
    greenSlider.enabled = false;
    blueSlider.enabled = false;
    
    //disable labels
    lightOutLabel.enabled = false;
    colorIRLabel.enabled = false;
    blueLabel.enabled = false;
    greenLabel.enabled = false;
    redLabel.enabled = false;
    strobeSpeedLabel.enabled = false;
    colorManualLabel.enabled = false;
    colorAuxLabel.enabled = false;
    colorMicLabel.enabled = false;
    
    
    //reset values
    switchOff.on = true;
    switchIR.on = false;
    switchAux.on = false;
    switchManual.on = false;
    switchMic.on = false;
    
    strobeSlider.value = 0;
    redSlider.value = 128;
    greenSlider.value = 128;
    blueSlider.value = 128;
    
    
    lblRSSI.text = @"---";
    
    [rssiTimer invalidate];
}

// When RSSI is changed, this will be called
-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    lblRSSI.text = rssi.stringValue;
}

-(void) readRSSITimer:(NSTimer *)timer
{
    [ble readRSSI];
}

// BLE CONNECTS When disconnected, this will be called
-(void) bleDidConnect
{
    NSLog(@"->Connected");

    [indConnecting stopAnimating];
    
    //enable switches and sliders
    switchOff.enabled = true;
    switchIR.enabled = true;
    switchAux.enabled = true;
    switchManual.enabled = true;
    switchMic.enabled = true;
    
    //enable labels
    lightOutLabel.enabled = true;
    colorIRLabel.enabled = true;
    colorManualLabel.enabled = true;
    colorAuxLabel.enabled = true;
    colorMicLabel.enabled = true;
    
   
    //initial values
    switchOff.on = true;
    switchIR.on = false;
    switchAux.on = false;
    switchManual.on = false;
    switchMic.on = false;
    
    
    strobeSlider.value = 0;
    redSlider.value = 128;
    greenSlider.value = 128;
    blueSlider.value = 128;
    
    
   //*****************
    // send reset
    UInt8 buf[] = {0x00, 0x00, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];

    // Schedule to read RSSI every 1 sec.
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}

/* IF need to read data from the device
// When data is coming, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSLog(@"Length: %d", length);

    // parse data, all commands are in 3-byte
    for (int i = 0; i < length; i+=3)
    {
        NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);

        if (data[i] == 0x0A)
        {
            if (data[i+1] == 0x01){
                }//swDigitalIn.on = true;
            else{}
                //swDigitalIn.on = false;
        }
        else if (data[i] == 0x0B)
        {
            UInt16 Value;
            
            Value = data[i+2] | data[i+1] << 8;
            //lblAnalogIn.text = [NSString stringWithFormat:@"%d", Value];
        }        
    }
}

 
 */


#pragma mark - Actions

// Connect button will call to this
- (IBAction)btnScanForPeripherals:(id)sender
{
    if (ble.activePeripheral)
        if(ble.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            return;
        }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
    [btnConnect setEnabled:false];
    [ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [indConnecting startAnimating];
}

-(void) connectionTimer:(NSTimer *)timer
{
    [btnConnect setEnabled:true];
    [btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    if (ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
        switchOff.enabled = true;
        switchIR.enabled = true;
        switchAux.enabled = true;
        switchManual.enabled = true;
        switchMic.enabled = true;

        
    }
    else
    {
        [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
        [indConnecting stopAnimating];
    }
}


//Sending data to MBED
-(IBAction)sendLightsOffSwitch:(id)sender
{
    UInt8 buf[4] = {0x01, 0x00, 0x00, 0x00};
    if (switchOff.on){
        buf[1] = 0x01;
        switchIR.on = false;
        switchAux.on = false;
        switchManual.on = false;
        switchMic.on = false;
        strobeSlider.enabled = false;
        redSlider.enabled = false;
        greenSlider.enabled = false;
        blueSlider.enabled = false;
        
        blueLabel.enabled = false;
        greenLabel.enabled = false;
        redLabel.enabled = false;
        strobeSpeedLabel.enabled = false;
    }
    else
        buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
    
    
    
}

-(IBAction)sendIRSwitch:(id)sender
{
    UInt8 buf[4] = {0x02, 0x00, 0x00, 0x00};
    if (switchIR.on){
        buf[1] = 0x01;
        switchOff.on = false;
        switchAux.on = false;
        switchManual.on = false;
        switchMic.on = false;
        strobeSlider.enabled = false;
        redSlider.enabled = false;
        greenSlider.enabled = false;
        blueSlider.enabled = false;
        
        blueLabel.enabled = false;
        greenLabel.enabled = false;
        redLabel.enabled = false;
        strobeSpeedLabel.enabled = false;
    }
    else
        buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
}

-(IBAction)sendMicSwitch:(id)sender
{
    UInt8 buf[4] = {0x03, 0x00, 0x00, 0x00};
    if (switchMic.on){
        buf[1] = 0x01;
        switchOff.on = false;
        switchIR.on = false;
        switchAux.on = false;
        switchManual.on = false;
        strobeSlider.enabled = false;
        redSlider.enabled = false;
        greenSlider.enabled = false;
        blueSlider.enabled = false;
        
        blueLabel.enabled = false;
        greenLabel.enabled = false;
        redLabel.enabled = false;
        strobeSpeedLabel.enabled = false;
    }
    else
        buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
}

-(IBAction)sendAuxSwitch:(id)sender
{
    UInt8 buf[4] = {0x04, 0x00, 0x00, 0x00};
    if (switchAux.on){
        buf[1] = 0x01;
        switchOff.on = false;
        switchIR.on = false;
        switchManual.on = false;
        switchMic.on = false;
        strobeSlider.enabled = false;
        redSlider.enabled = false;
        greenSlider.enabled = false;
        blueSlider.enabled = false;
        
        blueLabel.enabled = false;
        greenLabel.enabled = false;
        redLabel.enabled = false;
        strobeSpeedLabel.enabled = false;
    }
    else
        buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
}

-(IBAction)sendManualSwitch:(id)sender
{
    UInt8 buf[4] = {0x05, 0x00, 0x00, 0x00};
    if (switchManual.on){
        buf[1] = 0x01;
        switchOff.on = false;
        switchIR.on = false;
        switchAux.on = false;
        switchMic.on = false;
        
        strobeSlider.enabled = true;
        redSlider.enabled = true;
        greenSlider.enabled = true;
        blueSlider.enabled = true;
        
        blueLabel.enabled = true;
        greenLabel.enabled = true;
        redLabel.enabled = true;
        strobeSpeedLabel.enabled = true;
        
    }
    else{
        buf[1] = 0x00;
        strobeSlider.enabled = false;
        redSlider.enabled = false;
        greenSlider.enabled = false;
        blueSlider.enabled = false;
    
        blueLabel.enabled = false;
        greenLabel.enabled = false;
        redLabel.enabled = false;
        strobeSpeedLabel.enabled = false;
    }
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
}


-(IBAction)sendStrobe:(id)sender
{
    UInt8 buf[4] = {0x06, 0x00, 0x00, 0x00};
    
    buf[1] = strobeSlider.value;
        
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
}

//send colors
-(IBAction)sendRed:(id)sender
{
    UInt8 buf[4] = {0x07, 0x00, 0x00, 0x00};
    
    buf[1] = (int)redSlider.value;
    buf[2] = (int)greenSlider.value;
    buf[3] = (int)blueSlider.value;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
}

-(IBAction)sendGreen:(id)sender
{
    UInt8 buf[4] = {0x07, 0x00, 0x00, 0x00};
    
    buf[1] = (int)redSlider.value;
    buf[2] = (int)greenSlider.value;
    buf[3] = (int)blueSlider.value;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
}

-(IBAction)sendBlue:(id)sender
{
    UInt8 buf[4] = {0x07, 0x00, 0x00, 0x00};
    
    buf[1] = (int)redSlider.value;
    buf[2] = (int)greenSlider.value;
    buf[3] = (int)blueSlider.value;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
}



@end
