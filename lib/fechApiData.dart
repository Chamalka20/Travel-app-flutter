import 'dart:convert';
import 'package:http/http.dart' as http;

class fechApiData {

  static  fetchSuggestions() async {

  const apiKey = 'apify_api_Ji36tnDOBH9eVjhgk2inWHfV57BIKr328Ogj';
  var apiUrl = 'https://api.apify.com/v2/acts/maxcopell~free-tripadvisor/runs?token=$apiKey'; 
  dynamic runId;
  dynamic keyValue;

 final payload = {
    "currency": "USD",
    "debugLog": false,
    "includeAttractions": true,
    "includeHotels": true,
    "includeRestaurants": true,
    "includeReviews": true,
    "includeTags": true,
    "language": "en",
    "locationFullName": "Colombo, Sri Lanka", // Replace with your desired location
    "maxItems": 39,
    "maxReviews": 20,
    "proxyConfiguration": {
      "useApifyProxy": true
    },
    "scrapeReviewerInfo": true
  };

   final response = await http.post(
    Uri.parse(apiUrl),
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

  
}




