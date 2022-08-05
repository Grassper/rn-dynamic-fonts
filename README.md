
### React Native Dynamic Font Loader
[![npm version](https://badge.fury.io/js/rn-dynamic-fonts.svg)](https://badge.fury.io/js/rn-dynamic-fonts) [![npm](https://img.shields.io/npm/dt/rn-dynamic-fonts.svg)](https://www.npmjs.org/package/rn-dynamic-fonts) ![MIT](https://img.shields.io/dub/l/vibe-d.svg) ![Platform - Android and iOS](https://img.shields.io/badge/platform-Android%20%7C%20iOS-yellow.svg)

A React Native module that allows you to load fonts dynamically at runtime via base64 encoded TTF or OTF, like so:

#### Table of contents
- [Install](#install)
- [Usage](#usage)
- [Options](#options)
- [Response object](#the-response-object)

#### Install

`npm install rn-dynamic-fonts@latest --save`

#### Automatic Installation

If you've created your project either with `react-native init` or `create-react-native-app` you can link DynamicFonts automatically:

```bash
react native link
```

#### Alternative Installation

##### iOS

###### Cocoapods

```podspec
pod 'DynamicFonts', :path => 'node_modules/rn-dynamic-fonts'
```

###### Manually

1. In the XCode's "Project navigator", right click on your project's Libraries folder ➜ `Add Files to <...>`
2. Go to `node_modules` ➜ `rn-dynamic-fonts` ➜ `ios` ➜ select `RCTDynamicFonts.xcodeproj`
3. Add `libRCTDynamicFonts.a` to `Build Phases -> Link Binary With Libraries`
4. Compile and have fun

##### Android
1. Add the following lines to `android/settings.gradle`:
    ```gradle
    include ':rn-dynamic-fonts'
    project(':rn-dynamic-fonts').projectDir = new File(rootProject.projectDir, '../node_modules/rn-dynamic-fonts/android')
    ```
    
2. Add the compile line to the dependencies in `android/app/build.gradle`:
    ```gradle
    dependencies {
        compile project(':rn-dynamic-fonts')
    }
    ```
    
3. Add the import and link the package in `MainApplication.java`:
    ```java
    import org.th317erd.react.DynamicFontsPackage; // <-- add this import

    public class MainApplication extends Application implements ReactApplication {
        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                new MainReactPackage(),
                new DynamicFontsPackage() // <-- add this line
            );
        }
    }
    ```

#### Example of how to use

To load a font dynamically, you must first have a base64 string of your font file (TTF or OTF):
```javascript
import { loadFont, loadFonts } from 'rn-dynamic-fonts';

...
/* Load a single font */
loadFont('nameOfFont', base64FontString, 'ttf').then(function(name) {
	console.log('Loaded font successfully. Font name is: ', name);
});

/* Load a list of fonts */
loadFonts([{name: 'nameOfFont', data: base64FontString, type: 'ttf'}]).then(function(names) {
	console.log('Loaded all fonts successfully. Font names are: ', names);
});

...

```

#### Font loading using file path
You can download font file to file system and then load it to app without sending base64 to bridge.
 
```javascript
import {loadFontFromFile} from 'rn-dynamic-fonts';
import RNFetchBlob from 'rn-fetch-blob'

const fontFilePath = RNFetchBlob.fs.dirs.DocumentDir + "fonts/roboto.ttf";

loadFontFromFile("Roboto",  fontFilePath)
   .then(function(name) {
   	    console.log('Loaded font successfully. Font name is: ', name);
   });

```

#### Note

On iOS, it isn't possible to specify the font name. For this reason BOTH Android and iOS return the ACTUAL registered font name. For Android this is whatever you pass in, for iOS it is whatever is embedded in the font. I suggest you always use the full name embedded in the font to avoid issues.

#### Options

option | iOS  | Android | Info
------ | ---- | ------- | ----
name | Not used | Used | Specify registered font name (doesn't work for iOS)
data | Used | Used | This can be a data URI or raw base64... if it is raw base64 type must be specified, but defaults to TTF (data URI mime: font/ttf or font/otf)
type | Used | Used | (optional) Specify the type of font in the encoded data (ttf or otf). Defaults to "ttf"

#### The Response

The ACTUAL name the font was registered with. Use this for your fontFamily.

#### Credits

Thank you [eVisit](http://www.evisit.com) for this package 