# NetworkClient

![License Badge](https://img.shields.io/badge/license-MIT-lightgray)
![iOS +17.0 Badge](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![SPM Badge](https://shields.io/badge/SPM-compatible-brightgreen)
![SwiftUI](https://img.shields.io/badge/SwiftUI--orange)

Network client with support for streaming and HTTP requests!

## Installation
NetworkClient is distributed via **Swift Package Manager**

To install NetworkClient, please add the following line to the `dependencies:` section in your `Package.swift`file:

```swift
.package(url: "https://github.com/NitoApps/NetworkClient.git", .upToNextMinor(from: "1.0.0")
```

## Usage

Import module in the file which will be used in

```swift
import NetworkClient
```

Select from one of the available methods

### Request

```swift
try await Network.Request(url: "", method: .get, headers: [], body: nil, parameters: []).run()
```

### Stream Request

```swift
try await Network.StreamRequest(url: "", method: .post, headers: [], body: nil)
``` 
## License
MIT License

Copyright (c) 2023 German Hernandez del Rosario

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

