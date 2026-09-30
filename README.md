# Craft Journal

Craft Journal is an iOS app for documenting traditional crafts. This project was developed as a lab report for CTE308 - Mobile Application Development and demonstrates a SwiftUI interface backed by Core Data.

## Features

- Create and edit craft entries with a title, craft type, artisan name, notes, and date.
- Add a photo by taking a picture or choosing one from the photo library.
- Browse entries in date order, search by title, and delete entries.
- Mark entries as favorites and view their details.
- Store entries locally using Core Data.

## Requirements

- macOS with Xcode 26.6 or later.
- An iOS simulator or iPhone/iPad running iOS 26.5 or later, matching the deployment target configured in the project.
- A signing team configured in Xcode to run the app on a physical device.

## Run the App

1. Clone the repository:

   ```sh
   git clone https://github.com/sonameyden/lap_report_7.git
   ```

2. Open `CraftJournal.xcodeproj` in Xcode.
3. Select the `CraftJournal` scheme and an iOS simulator or connected device.
4. If running on a physical device, choose your Apple development team under the target's **Signing & Capabilities** settings.
5. Build and run the app with **Product > Run** (or press **Cmd+R**).

The camera option is available only on devices that provide a camera. The photo library picker can be used to attach an existing image.

## Project Structure

- `CraftJournal/` contains the SwiftUI views, app entry point, craft type list, Core Data persistence setup, and data model.
- `CraftJournal.xcodeproj/` contains the Xcode project and build configuration.

## Data

Entries are saved on the device in a local Core Data store. The app does not currently sync entries between devices or provide a cloud backup.
