import 'package:prayer_times/prayer_times.dart';
import 'package:test/test.dart';

void main() async {
  group('A group of tests', () {
    PrayerTimes prayerTimes;

    setUp(() {
      prayerTimes = PrayerTimes(date:DateTime(2019), longitude: 50, latitude: 20, method: Methods.University_of_Tehran);
    });

    test('First Test', () async {
      expect((await prayerTimes.getTimings())[Timings.Dhuhr].toString(), "2019-01-01 11:37:00.000");
    });
  });
}
