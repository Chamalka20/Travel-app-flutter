import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class directionsRepo{

  
  final double lat; 
  final double lng;

  const directionsRepo({required this.lat,required this.lng});
  

  Future<List> calculateDistance ()async{

    final prefs = await SharedPreferences.getInstance();
    final getSheardData = prefs.getString('currentLocation');
    final currentLocation = jsonDecode(getSheardData!) ;

    late String distance;
    late String duration;

    String? currentCity = prefs.getString('currentCity');

    const String apiUrl = 'https://atlas.microsoft.com/route/directions/json';
    final url ='$apiUrl?api-version=1.0&query=${currentLocation['lat']},${currentLocation['lng']}:$lat,$lng&report=effectiveSettings&subscription-key=${dotenv.env['azureApiKey']}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("compute route sucssus");

      final data = jsonDecode(response.body);
      final routes = data['routes'];

      if (routes != null && routes.isNotEmpty) {
        final firstRoute = routes[0];
        final summary = firstRoute['summary'];

        if (summary != null && summary.isNotEmpty) {

          final meters = summary['lengthInMeters'] ?? 0;
          final kilometers = meters / 1000;
          final convkilometers =kilometers.toStringAsFixed(0);

          distance = convkilometers.toString();
          
          var d = Duration(seconds:summary['travelTimeInSeconds']);
          List<String> parts = d.toString().split(':');
          duration='${parts[0].padLeft(2, '0')}h ${parts[1].padLeft(2, '0')}m';
          
         
        }
      }
    } else {
      print('Failed to compute route');
    }

    List data =[{"currentCity":currentCity,"distance":distance,"duration":duration}];
  
    return data;

  }

}