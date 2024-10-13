# FTMO challenge

In this project i implemented all objectives

-  basic table according to design and fill it with data from symbols.json
   endpoint
-  live data updates from websocket for a single instrument category/tab
   (such as Forex)
- instrument category tab switching using tabs as well as websocket
  subscribe/unsubscribe
- responsive design


## What i could have done better
- Instead of rendering whole table I could rerender only changed cells. It would lead to better performance. I would use better data structure for that.
- I would add notification for tabs where data cannot be loaded (usually due to weekend or holiday)

## Supported platforms
- Android - I could only test on android because don't have own development account for ios 

## How to run
- Install latest flutter 3.24.3
- Clone the repository
- run `flutter pub get`
- run `cd ftmo_challenge`
- run `flutter run`
