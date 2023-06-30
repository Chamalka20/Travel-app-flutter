import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class fechApiData {

  static  fetchSuggestions(var apiUrl, final payload) async {

  const apiKey = 'apify_api_i3o0mIz66q0XQLwEJUyefixu3GnZAA1IqEw2';
  var newApiUrl = '$apiUrl$apiKey'; 
  dynamic runId;
  dynamic keyValue;

 

   final response = await http.post(
    Uri.parse(newApiUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(payload),
  );




  if (response.statusCode == 201) {
    // Request successful
    print("Request successful status:${response.statusCode}");
    final decodedData = json.decode(response.body);
    runId = decodedData["data"]["id"];
    print(runId);

    
    
  } else {
    // Request failed
    print('Request failed with status: ${response.statusCode}.');
  }

   const delayDuration = Duration(seconds: 2); 
  bool datasetReady = false;
  

  // ignore: unrelated_type_equality_checks
  while (datasetReady == false) {
    await Future.delayed(delayDuration);

    final datasetStatusResponse = await http.get(Uri.parse('https://api.apify.com/v2/actor-runs/$runId?token=$apiKey'));
    if (datasetStatusResponse.statusCode == 200) {
      final datasetStatusData = json.decode(datasetStatusResponse.body);
      final datasetStatus = datasetStatusData['data']['status'];
      
      print(datasetStatus);  
      if (datasetStatus == 'SUCCEEDED') {
        datasetReady = true;
         keyValue = datasetStatusData['data']['defaultDatasetId'];
        print(keyValue);
       
      }
    }
  }

    late List<Map<String, dynamic>> hotelList = [];

  
  final datasetItemsResponse = await http.get(Uri.parse('https://api.apify.com/v2/datasets/$keyValue/items?token=$apiKey'));
  if (datasetItemsResponse.statusCode == 200) {

    print("Request successful status:${datasetItemsResponse.statusCode}");
    final datasetItemsData = json.decode(datasetItemsResponse.body);
    final results = datasetItemsData as List<dynamic>;
    print(results.length);

     
        hotelList = results.map((result) {
          return {
            'name': result['name'],
            'image': result['image'],
            'rating': result['rating'],
            'address':result['address'],
            'type':result['type'],
          };
        }).toList();
      

    print(hotelList);
    return hotelList;
  } else {
    throw Exception('Failed to retrieve dataset items status:${datasetItemsResponse.statusCode}');
  }
}

 static getCityDetails ()async {

   

      final databaseReference = FirebaseDatabase.instance.ref('city-List');
      final dataSnapshot = await databaseReference.once();

      final data =  dataSnapshot.snapshot.value as List<dynamic>;
      
      final  datago =data;
      
      return datago;      

   }

 static getattractionDetails ()async {

  

      final databaseReference = FirebaseDatabase.instance.ref('places');
      final dataSnapshot = await databaseReference.once();

      final data = dataSnapshot.snapshot.value as List<dynamic>;

      
      return data;      

   }

  static getResturantDetails ()async {

  

      final databaseReference = FirebaseDatabase.instance.ref('restaurants');
      final dataSnapshot = await databaseReference.once();

      final data = dataSnapshot.snapshot.value as List<dynamic>;

      
      return data;      

   }   

  
}




