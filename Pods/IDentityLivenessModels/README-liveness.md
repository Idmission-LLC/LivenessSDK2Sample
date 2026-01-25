#  IDentityLiveness SDK
  
<br />

## Getting Started

### **Step 1: Create Podfile**
Add [CocoaPods](https://cocoapods.org/) pod file to your project using `pod init` command.  

### **Step 2: Add IDentityLivenessSDK2.0 SDK to your app**

##### **Add SDK using podfile :**
Add the following pods in your podfile which you have created in Step-1

```swift
pod 'IDentityLivenessSDK2.0'
pod 'IDentityLivenessModels'
```

##### **Add SDK manually :** 
To add IDentityLivenessSDK2.0 manually, download it from below link.

- [Download IDentityLivenessSDK2.0](https://drive.google.com/file/d/1X9ahwKrRLGYrgvkPGnjh_XBSSDJbAGik/view?usp=sharing) : Drag & drop following files in your project
    - `IDentityLivenessSDK.xcframework`
    - `SelfieCaptureLiveness.xcframework`
    - `IDentityLivenessModels.xcframework`    

Once added `.xcframeworks` in your project, make sure to make it all as a `Embed & Sign` in **YourTarget -> General -> Frameworks, Libraries & and Embeded Content**.

### **Step 3: Add Required Dependencies**
As per SDK flavour which you choose to integrate, add the following dependencies in your podfile which you have created in Step-2

- **IDentityLivenessSDK2.0**  *dependencies*.  
    
```swift
pod 'TensorFlowLiteSwift', '~> 2.7.0'
pod 'GoogleMLKit/FaceDetection'
pod 'GoogleMLKit/ImageLabeling'
pod 'GZIP'
```

### **Step 4: Steps to reduce size of your app bundle (Optional steps)**
Optionally add the following `post_install` script (replacing `APP_TARGET` with the name of your app target) to the end of your `Podfile` to prevent [CocoaPods](https://cocoapods.org/) from statically-linking the above dependencies to your app binary, unnecessarily increasing the size of your app bundle:  

```swift
post_install do |installer|
    installer.aggregate_targets.each do |aggregate_target|
        if aggregate_target.name == 'Pods-APP_TARGET'
            aggregate_target.xcconfigs.each do |config_name, config_file|
                aggregate_target.pod_targets.each do |pod_target|
                    pod_target.specs.each do |spec|
                        if spec.attributes_hash['vendored_frameworks'] != nil or (spec.attributes_hash['ios'] != nil and spec.attributes_hash['ios']['vendored_frameworks'] != nil)
                            puts "Removing #{spec.name}"
                            config_file.frameworks.delete(spec.name)
                        end
                    end
                end
                xcconfig_path = aggregate_target.xcconfig_path(config_name)
                config_file.save_as(xcconfig_path)
            end
        end
    end
end
```  

### **Step 5: Install pod**
Run `pod install` to install above mentioned dependencies.  

### **Step 6: Add Permissions**

- Add an [`NSCameraUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nscamerausagedescription) key to the app's `Info.plist` to allow camera access.  

### **Step 7: Add API Required Reasons**

Add the following dependency [API required reasons](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api) to the app's `PrivacyInfo.xcprivacy` file:

- File Timestamp: `C617.1`, `3B52.1`
- System Boot Time: `35F9.1`
- Disk Space: `E174.1`
- User Defaults: `CA92.1`, `1C8F.1`, `C56D.1`

<br />


## SDK Initialization

While Initializing the SDK, first `import` below frameworks as per requirement

```swift
import IDentityLivenessSDK
import SelfieCaptureLiveness
```

Once you done with importing above frameworks, You need to Call the following SDK Initialization API.

```swift

//Parameter for SDK initialization API.
let modelPublicKey = "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALkrecgvngP/vTNHVnNk8AYPbvePdZcAq7bDk2/Esdkt7pBzWtlTlnI545OSHepHyOyKGoorA3xvZ0ZPbKM1ho0CAwEAAQ=="
let language = Language.en    //Optional: Default is `.en`

//Start SDK Initialization using following method.
IDentitySDK.initializeSDK(modelPublicKey: modelPublicKey, language: language) { error in
   if let error = error {
      // Handle Error
   } else {
      // Success!
   }
}
```

Once the SDK has been initialized, the application can start capturing selfie using following `IDentitySDK` methods. 

<br />

## SDK Features

<br />

### 1) Live face Check.  

You can do `Live Face Check` using following method from a `UIViewController`.

```swift
// Start live face capture, presenting it from view controller
IDentitySDK.liveFaceCheck(from: self) { result in
    switch result {
        case .success(let liveFaceCheckResult):
            // Review successful response from SDK
            print(response)

        case .failure(let error):
            // Handle error
            print(error.localizedDescription)
    }
}
```

<br />


## Optional Customizations

-   Before starting a Selfie Capture flow, optionally adjust the following <a href="./Classes/SelfieCapture.html">SelfieCapture</a> static properties:

```swift
//SelfieCapture Customization
SelfieCapture.options.minFaceWidth = 0.6
SelfieCapture.options.eyeOpenProbability = 0.4
SelfieCapture.options.minHeadEulerAngle = -10
SelfieCapture.options.maxHeadEulerAngle = 10
SelfieCapture.options.minRelativeNoseHeight = 0.48
SelfieCapture.options.maxRelativeNoseHeight = 0.67
SelfieCapture.options.labelsConfidenceThreshold = 0.79
SelfieCapture.options.faceMaskProbabilityThreshold = 0.98
SelfieCapture.options.liveFaceProbabilityThreshold = 0.9
SelfieCapture.options.consecutiveFakeFaceLimit = 10
SelfieCapture.options.lightIntensityThreshold = 0.05
SelfieCapture.options.focusThreshold = 0.2
SelfieCapture.options.isDebugMode = true
SelfieCapture.options.enableInstructionScreen = true
SelfieCapture.options.capture4K = false
SelfieCapture.options.ovalScaleMultiplier = 0.7
SelfieCapture.options.cameraPosition = .front
SelfieCapture.options.showToggleCamera = false

//SelfieCapture Camera Screen UI Customization
SelfieCapture.strings.captureSelfie = "Capture Selfie"
SelfieCapture.strings.multipleFacesDetected = "Multiple Faces Detected"
SelfieCapture.strings.closeButtonText = "Cancel"
SelfieCapture.strings.alignOval = "Align your face inside oval"
SelfieCapture.strings.notInFocus = "Face Not In Focus"
SelfieCapture.strings.moveAway = "Move Face Away"
SelfieCapture.strings.moveCloser = "Move Face Closer"
SelfieCapture.strings.leftEyeClosed = "Left eye are closed"
SelfieCapture.strings.rightEyeClosed = "right eye are closed"
SelfieCapture.strings.faceMaskDetected = "Face mask detected"
SelfieCapture.strings.sunglassesDetected = "Sunglasses Detected"
SelfieCapture.strings.removeHat = "Hat Detected"
SelfieCapture.strings.fakeFace = "Fake face Detected"
SelfieCapture.strings.realFace = "Real face Detected"
SelfieCapture.strings.straightenHead = "Make Sure your head is straight"
SelfieCapture.strings.moveFaceDown = "Move face Down"
SelfieCapture.strings.moveFaceUp = "Move face Up"
SelfieCapture.strings.moveFaceDown = "Move face Down"
SelfieCapture.strings.capturingFace = "Capturing Face"
SelfieCapture.strings.tooMuchLight = "Too much light around face"
SelfieCapture.colors.backgroundColor = .white
SelfieCapture.colors.overlayTopViewColor = .white
SelfieCapture.colors.closeButtonTextColor = .black
SelfieCapture.colors.closeButtonColor = .clear
SelfieCapture.colors.closeButtonImageTintColor = .white
SelfieCapture.colors.successLabelBackgroundColor = .green
SelfieCapture.colors.errorLabelBackgroundColor = .red
SelfieCapture.colors.successLabelTextColor = .white
SelfieCapture.colors.errorLabelTextColor = .white
SelfieCapture.fonts.labelFont = UIFont.systemFont(ofSize: 20)
SelfieCapture.fonts.closeButtonTextFont = UIFont.systemFont(ofSize: 20)
SelfieCapture.layout.labelPosition = .top
SelfieCapture.images.closeButtonImage = UIImage(named: "Close")
SelfieCapture.images.silhouetteImage = UIImage(named: "SelfieOverlay")
SelfieCapture.images.bottomInfoImage = UIImage(named: "Selfieinfo")

//SelfieCapture Instruction Screen UI Customization
SelfieCapture.strings.instructionScreenText = "Lorem ipsum text"
SelfieCapture.strings.instructionScreenButtonText = "Continue"
SelfieCapture.colors.instructionScreenBackgroundColor = .white
SelfieCapture.colors.instructionScreenTextBackgroundColor = .orange
SelfieCapture.colors.instructionScreenBackButtonImageTintColor = .gray
SelfieCapture.colors.instructionScreenImageTintColor = .white
SelfieCapture.colors.instructionScreenLabelTextColor = .black
SelfieCapture.colors.instructionScreenButtonTextColor = .white
SelfieCapture.colors.instructionScreenButtonBackgroundColor = .gray
SelfieCapture.fonts.instructionScreenLabelFont = UIFont.systemFont(ofSize: 20)
SelfieCapture.fonts.instructionScreenButtonFont = UIFont.systemFont(ofSize: 20)
SelfieCapture.images.instructionScreenImage = UIImage(named: "SelfieCaptureImage")
SelfieCapture.images.instructionBackButtonImage = UIImage(named: "BackButtonImage")

//SelfieCapture Retry Screen UI Customization
SelfieCapture.strings.retryScreenText = "Live face not Detected. Please try again"
SelfieCapture.strings.retryButtonText = "Retry"
SelfieCapture.strings.cancelButtonText = "Cancel"
SelfieCapture.colors.retryScreenBackgroundColor = .white
SelfieCapture.colors.retryScreenLabelTextColor = .black
SelfieCapture.colors.retryScreenImageTintColor = .blue
SelfieCapture.colors.retryScreenButtonTextColor = .blue
SelfieCapture.colors.retryScreenButtonBackgroundColor = .clear
SelfieCapture.fonts.retryScreenLabelFont = UIFont.systemFont(ofSize: 20)
SelfieCapture.fonts.retryScreenButtonFont = UIFont.systemFont(ofSize: 20)
SelfieCapture.images.retryScreenImage = UIImage(named: "SelfieRetryImage")

```

## SDK Version History

### **v 10.1.18.2.1 (11 November 2025)**
- Updated the default maximum allowed fake face capture count from 15 to 10.

### **v 10.1.16.2.5 (22 September 2025)**
- Updated liveness models to v81

### **v 10.1.16.2.3 (19 September 2025)**
- Updated iOS SDK Minimum Deployment Target to iOS 13.0.
- Ability to detect & throw error while ScreenRecording.
- Added configurable spoof detection count.
- Added configurable to capture selfie using front & back camera.
- Added ability to detect faceMask & Mutiple faces
- Added ability to detect Hat & Sunglasses.
