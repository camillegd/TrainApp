# Train Stations App

## Version
- **Flutter**: 3.24.5
- **Dart**: 3.5.4

## Features
- Display a map with train stations in France.
- Center the map on the user's current location.
- Search for train stations by name.
- View details of a selected train station (departures and arrivals in real time).
- Add and remove train stations from favorites.

## APIs Used
- **OpenStreetMap**: For map tiles and attributions.
- **Train Station API**: For fetching train station data.

## API Connection with Token
To connect to the Train Station API, you need to request an API token. Follow these steps:

1. **Request API Token**: Visit [API Token Request Page](https://numerique.sncf.com/startup/api/token-developpeur/) to request your API token. You will receive an email with the token.
2. **Setup .env File**: Create a `.env` file in the root of your project and add your API token as follows:
    ```env
    API_TOKEN=your_api_token_here
    ```

Make sure to replace `your_api_token_here` with the actual token you received from the API provider.

## Run the App
1. **Clone the Repository**: Run the following command to clone the repository:
    ```bash
    git clone https://github.com/camillegd/TrainApp.git
    ```
2. **Navigate to the Project Directory**: Make sure to have all the dependencies installed by running the following command:
    ```bash
    flutter pub get
    ```
3. **Launch the App**: Launch the app with the Chrome(web) emulator. Do not launch the app with the mobile emulator.
    