import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

Position get mockPosition => Position(
    latitude: 52.561270,
    longitude: 5.639382,
    timestamp: DateTime.fromMillisecondsSinceEpoch(
      500,
      isUtc: true,
    ),
    altitude: 3000.0,
    accuracy: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0);

void main() {
  group('Geolocator', () {
    setUp(() {
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
    });

    test('checkPermission', () async {
      final permission = await geolocator.checkPermission();

      expect(permission, geolocator.LocationPermission.whileInUse);
    });

    test('requestPermission', () async {
      final permission = await geolocator.requestPermission();

      expect(permission, geolocator.LocationPermission.whileInUse);
    });

    test('isLocationServiceEnabled', () async {
      final isLocationServiceEnabled =
          await geolocator.isLocationServiceEnabled();

      expect(isLocationServiceEnabled, true);
    });

    test('getLastKnownPosition', () async {
      final position = await geolocator.getLastKnownPosition();

      expect(position, mockPosition);
    });

    test('getCurrentPosition', () async {
      final position = await geolocator.getCurrentPosition();

      expect(position, mockPosition);
    });

    test('getPositionStream', () async {
      final position = await geolocator.getPositionStream();

      expect(position, emitsInOrder([emits(mockPosition), emitsDone]));
    });

    test('openAppSettings', () async {
      final hasOpened = await geolocator.openAppSettings();
      expect(hasOpened, true);
    });

    test('openLocationSettings', () async {
      final hasOpened = await geolocator.openLocationSettings();
      expect(hasOpened, true);
    });
  });
}

class MockGeolocatorPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        GeolocatorPlatform {
  @override
  Future<geolocator.LocationPermission> checkPermission() =>
      Future.value(geolocator.LocationPermission.whileInUse);

  @override
  Future<geolocator.LocationPermission> requestPermission() =>
      Future.value(geolocator.LocationPermission.whileInUse);

  @override
  Future<bool> isLocationServiceEnabled() => Future.value(true);

  @override
  Future<geolocator.Position> getLastKnownPosition(
          {geolocator.LocationAccuracy desiredAccuracy =
              LocationAccuracy.best}) =>
      Future.value(mockPosition);

  @override
  Future<geolocator.Position> getCurrentPosition(
          {geolocator.LocationAccuracy desiredAccuracy = LocationAccuracy.best,
          Duration timeLimit}) =>
      Future.value(mockPosition);

  @override
  Stream<geolocator.Position> getPositionStream(
          {geolocator.LocationAccuracy desiredAccuracy = LocationAccuracy.best,
          int distanceFilter = 0,
          int timeInterval = 0,
          Duration timeLimit}) =>
      Stream.value(mockPosition);

  @override
  Future<bool> openAppSettings() => Future.value(true);

  @override
  Future<bool> openLocationSettings() => Future.value(true);
}
