cd customer_app
flutter clean
cd ios
pod deintegrate
rm Podfile.lock
rm -rf Pods
pod install
pod repo update
cd ..
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd ..