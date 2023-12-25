import 'dart:convert';
import 'package:http/http.dart' as http;


class fechLastViews{


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
       
      }else if(datasetStatus == 'TIMED-OUT'){

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
    if(results[0]['city']!=null){

       hotelList = results.map((result) {
          
          return {
          'name': result['title'] ?? '',
          'image': result['imageUrls'] != null && result['imageUrls'].isNotEmpty ? result['imageUrls'][0] : '',
          'city': result['city'] ?? '',
          };
        }).toList();
    }
       
      
    print(hotelList[0]);
    return hotelList;
  } else {
    throw Exception('Failed to retrieve dataset items status:${datasetItemsResponse.statusCode}');
  }
}

  
}

