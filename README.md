# bigbluebutton-mobile-sdk

This repository contains BigBlueButton react-native component, that's used in our [sample implementation](https://github.com/bigbluebutton/bigbluebutton-mobile).

![version](https://img.shields.io/npm/v/bigbluebutton-mobile-sdk.svg)


## Installation

```sh
npm install bigbluebutton-mobile-sdk
```

## Usage

```js
import { BigBlueButtonMobile } from "bigbluebutton-mobile-sdk";

// ...

<BigbluebuttonMobile
        broadcastAppBundleId="org.bigbluebutton.mobile-sdk.example.BigbluebuttonMobileSdkBroadcastUploadExtension"
        url="https://demo.bigbluebutton.org"
        style={styles.box}
      />
```

## Architecture

This SDK (in combination with bigbluebutton-html5 code tweaks) implements replacement functions to navigator and WebRTC functions.

### getDisplayMedia

The following sequence diagram represents what happens when BigBlueButton calls the `navigator.getDisplayMedia` function:

![getDisplayMedia sequence diagram](/docs/uml/ios-screenshare/exported/BigBlueButton Mobile screenshare.svg "getDisplayMedia sequence diagram")



## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## WebRTC

This project references the library [WebRTC](https://webrtc.org).

## License

LGPL-3.0
