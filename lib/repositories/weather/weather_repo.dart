
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class weatherRepo{

  final double lat; 
  final double lng;

  const weatherRepo({required this.lat,required this.lng});

 
  Future<List> findWeather ()async {
  
  var setgetPhrase ='';
  double temperature =0.0;
  var weatherIcon ='';  

  const apiUrl = 'https://atlas.microsoft.com/weather/currentConditions/json';
  final url ='$apiUrl?api-version=1.1&query=$lat,$lng&unit=metric&subscription-key=${dotenv.env['azureApiKey']}';
  
  final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        print("Weather calculate sucsuss:${response.statusCode}");
        final responseData = jsonDecode(response.body);
        List<dynamic> results = responseData['results'];


        if(results.isNotEmpty){
          String getPhrase = results[0]['phrase']??'';
          setgetPhrase = getPhrase;
          bool isDayTime = results[0]['isDayTime']??false;
          temperature = results[0]['temperature']['value']??0.0;
          print( "getPhrase:$getPhrase");
          print( "daytime:$isDayTime");
          print( "temperature:$temperature");

          //change icon when weather changers---------------------------------
          if(isDayTime==false && getPhrase=="Cloudy"){
            weatherIcon = 'assets/images/cloudy.png';

          }else if(isDayTime==false && getPhrase=="Some clouds"){
            weatherIcon = 'assets/images/PartlyCloudyNightV2.png';

          }else if(isDayTime==false && getPhrase=="Mostly clear"){  
            weatherIcon = 'assets/images/MostlyClearNight.png';

          }else if(isDayTime==false && getPhrase=="Mostly cloudy"){
            weatherIcon = 'assets/images/MostlyCloudyNightV2.png';  

          }else if(isDayTime==false && getPhrase=="Partly cloudy"){
            weatherIcon = 'assets/images/PartlyCloudyNightV2.png';

          }else if(isDayTime==false && getPhrase=="Light rain"){
            weatherIcon = 'assets/images/N210LightRainShowersV2.png'; 

          }else if(isDayTime==false && getPhrase=="Light rain shower"){  
            weatherIcon = 'assets/images/N210LightRainShowersV2.png';

          }else if(isDayTime==false && getPhrase=="Rain"){
            weatherIcon = '';
          }else if(isDayTime==true && getPhrase=="A shower"){
            weatherIcon = 'assets/images/Light-rain.png';

            
          }else if(isDayTime==true && getPhrase=="Light rain"){
            weatherIcon = 'assets/images/Light-rain.png';

          }else if(isDayTime==true && getPhrase=="Cloudy"){
            weatherIcon = 'assets/images/cloudy.png';

          }else if(isDayTime==true && getPhrase=="Mostly cloudy"){
            weatherIcon = 'assets/images/mostly-cloudy.png';

          }else if(isDayTime==true && getPhrase=="Clouds and sun"){

            weatherIcon = 'assets/images/cloudsAndSun.png';
          }else if(isDayTime==true && getPhrase=="Partly sunny"){

            weatherIcon = 'assets/images/Partly-sunny.png';
            
          }else if(isDayTime==true && getPhrase=="Mostly sunny"){ 
            weatherIcon = 'assets/images/Mostly-Sunny-Day.png';

          }else if(isDayTime==true && getPhrase=="Sunny"){ 
              weatherIcon = 'assets/images/sunny.png';

          }else{
            weatherIcon = 'assets/images/time-left.png';
          }

        }else{
          print( "no weather data");
          weatherIcon = 'assets/images/time-left.png';
        }
        
      }else{

        print("Weather calculate not sucsuss:${response.statusCode}");

      }
      print(weatherIcon);

      List data=[{"weatherIcon":weatherIcon,"temperature":temperature,"phrase":setgetPhrase}];
         

      return data;
  }

}
