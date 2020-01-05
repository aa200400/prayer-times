// TODO: Put public facing types in this file.

// https://aladhan.com/prayer-times-api

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class PrayerTimes {
  DateTime date;
  Methods method;
  Map<Timings, DateTime> timingsMap;

  num latitude;
  num longitude;

  PrayerTimes({DateTime date, Methods this.method = Methods.Ithna_Ansari, this.longitude = 0, this.latitude = 0}) {
    if (date == null)
      this.date = DateTime.now();
    else
      this.date = date;
  }

  Future<Map<Timings, DateTime>> getTimings() async {
    if (timingsMap != null)
      return timingsMap;

    http.Response response = await getResponse();

    if (response.statusCode != 200)
      throw Exception('Failed to get data from API: ${response.statusCode}');

    timingsMap = convertFromStringMap(json.decode(response.body)["data"]["timings"]);
    return timingsMap;
  }

  Future<http.Response> getResponse() async {
    var parameters = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "method": method.index.toString()
    };
    
    http.Response response = await http.get(
        Uri.http('api.aladhan.com', getEndpoint(), parameters),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }
    );
    return response;
  }

  String getEndpoint() {
    return '/v1/timings/${date.millisecondsSinceEpoch/1000}';
  }

  Map<Timings, DateTime> convertFromStringMap(Map<String, dynamic> decode) {
    Map<Timings, DateTime> converted = Map<Timings, DateTime>();
    for (int i = 0; i < decode.length; i++) {
      String time = decode[Timings.values[i].toString().split('.')[1]];
      converted[Timings.values[i]] = DateTime(date.year, date.month, date.day, int.parse(time.split(':')[0]), int.parse(time.split(':')[1]));
    }
    return converted;
  }
}

enum Timings {
  Fajr,
  Sunrise,
  Dhuhr,
  Asr,
  Sunset,
  Maghrib,
  Isha,
  Imsak,
  Midnight,
}

/**
 * 0 - Shia Ithna-Ansari
    1 - University of Islamic Sciences, Karachi
    2 - Islamic Society of North America
    3 - Muslim World League
    4 - Umm Al-Qura University, Makkah
    5 - Egyptian General Authority of Survey
    7 - Institute of Geophysics, University of Tehran
    8 - Gulf Region
    9 - Kuwait
    10 - Qatar
    11 - Majlis Ugama Islam Singapura, Singapore
    12 - Union Organization islamic de France
    13 - Diyanet İşleri Başkanlığı, Turkey
    14 - Spiritual Administration of Muslims of Russia
 */

enum Methods {
  Ithna_Ansari,
  University_of_Islamic_Sciences,
  Islamic_Society,
  Muslim_World_League,
  Umm_Al_Qura_University,
  Egyptian_General_Authority_of_Survey,
  University_of_Tehran,
  Gulf_Region,
  Kuwait,
  Qatar,
  Majlis_Ugama_Islam_Singapura,
  Union_Organization_islamic,
  Diyanet_Isleri_Baskanligi,
  Spiritual_Administration_of_Muslims
}