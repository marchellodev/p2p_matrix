# P2P Matrix

This repository contains a front end to the [P2P Matrix Go](https://github.com/marchellodev/p2p_matrix_go) app

Tested on Windows (10) and Linux (Pop!_Os 20.10)

## Running

Before running, make sure that you have [Flutter installed](https://flutter.dev/docs/get-started/install) and [configured to use with desktop](https://flutter.dev/desktop).

To run the app:

```shell
flutter pub get
flutter run
```

## Utilities

To regenerate `.g.dart` files (for serialization and HiveDB):

```shell
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## License
MIT