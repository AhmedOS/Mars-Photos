# 🛸 Mars Photos
NASA has three rovers on mars, and they are taking photos almost everyday since the day they landed on mars, and all of these photos are available on [this API](https://api.nasa.gov/api.html#MarsPhotos). This app consumes that API.
# Screenshots
<img src="https://i.imgur.com/r4Of90F.png" width="300"> <img src="https://i.imgur.com/UBQoRM1.png" width="300">
# Dependencies
#### CocoaPods:
```
pod 'Alamofire', '~> 4.7'
pod 'SwiftyJSON', '~> 4.0'
pod 'Kingfisher', '~> 4.0'
```
# API Key
The app uses `DEMO_KEY` as the API key, but it has very limited requests. For more freedom, request your API key from [here](https://api.nasa.gov/index.html#apply-for-an-api-key), and change `key` value at `/Utilities/API.swift` file with your key.
