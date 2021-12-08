# shopBook

## Version

1.0

## Build and Runtime Requirements
+ Xcode 6.0 or later
+ iOS 8.0 or later
+ OS X v10.10 or later

## Configuring the Project

Configuring the Xcode project requires a few steps in Xcode to get up and running with iCloud capabilities. 

1) Configure each Mac and iOS device you plan to test with an iCloud account. Create or use an existing Apple ID account that supports iCloud.

2) Configure the Team for each target within the project.

Open the project in the Project navigator within Xcode and select each of the targets. Set the Team on the General tab to the team associated with your developer account.

3) Change the Bundle Identifier.

With the project's General tab still open, update the Bundle Identifier value. The project's Lister target ships with the value:


You should modify the reverse DNS portion to match the format that you use:

com.yourdomain.Lister

4) Ensure Automatic is chosen for the Provisioning Profile setting in the Code Signing section of Target > Build Settings for the following Targets:

- shopBook

5) Ensure iOS Developer is chosen for the Code Signing Identity setting in the Code Signing section of Target > Build Settings for the following Targets:

- shopBook

And that Mac Developer is chosen for the Code Signing Identity setting in the Code Signing section of Target > Build Settings for the following Targets:

- shopBook



