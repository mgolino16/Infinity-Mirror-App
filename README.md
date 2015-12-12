## Synopsis

This app was created to act as an interface between an iphone and a Red Bear BLE chip connected to an mbed microcontroller. The app is based on a sample project by Red Bear Labs that can be found here (https://github.com/RedBearLab/iOS), however it has been expanded from the simple controls app to add more controls and communication.
For more information about the infinity mirror project and the main mbed code, feel free to check out the mbed notebook page (https://developer.mbed.org/users/mgolino/notebook/infinity-mirror/).

## Code Functionality

Functionally the app is simply a series of switches and sliders, designed to create a simple and clean user interface. Each time a switch is flipped or a slider is adjusted an array of of 4 separate 2 digit hexidecimal numbers (ranging in value from 0-255) are sent to the mbed. These are interpretted as codes for various functions within the main mirror control code of the app.

## API Reference

Red Bear Labs provided a few basic libraries to help interface with their bluetooth chip from an iphone, most importantly they provided the ability to read and write data.

## License

This project was created as part of a Georgia Tech ECE 4180 class on embedded systems
