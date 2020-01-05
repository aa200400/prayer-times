import 'package:prayer_times/prayer_times.dart';

main() async {
  var times = PrayerTimes(longitude: -90, latitude: 20);
  var timings = await (times.getTimings());
  print(timings.toString());
}
