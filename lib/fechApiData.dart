import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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

    static getUserData()async{
      
    var userId ;

      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');
      print('userid:${userId}');

      final data=await FirebaseFirestore.instance
      .collection('users').doc(userId).get().then((doc) => doc.data());
      
      
      

        return data;
    }
    
    static readUsersEmails()async{

      List data =[];
      await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              
                data.add(doc['email']) ;
              
              
            });
            
        });
      return data; 
    }
    
    static addUser(String? name,String email,String password,String? photoUrl)async{

      var userId ;

      await FirebaseFirestore.instance.collection('users').add({
      
            'name':name,
            'email':email,
            'password':password,
            'proPicUrl':photoUrl,

          }).then((value) async {
            //get and store auto genareted doc id----------------------------
            print('docid:${value.id}');
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('userDbId', value.id);
            userId = value.id;
          });
    return userId;

    }

    static setUserLocation(String? city)async{
      var userId ;

      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');
             
      await FirebaseFirestore.instance
      .collection('users').doc(userId).update({

        'location':city,
    
      });

    }

    static creatTrip(String? tripName,String tripBudget, String tripLocation,String tripDuration, 
            String description,String tripCoverPhoto,String duration,String endDate,String places)async{

      var userId ;
      final deData = jsonDecode(places);
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');

      var uuid = const Uuid();

      await FirebaseFirestore.instance
      .collection('users').doc(userId).collection('trips').add({

        
            "tripId":uuid.v1(),
            "tripName":tripName,
            "tripBudget":tripBudget,
            "tripLocation":tripLocation,
            "tripDuration":tripDuration,
            "tripDescription":description,
            "tripCoverPhoto":tripCoverPhoto,
            "duration":duration,
            'endDate':endDate,
            "places":deData,
        
    
      });


    }

    static getTrips ()async{

      List data =[];
      var userId;
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');

      await FirebaseFirestore.instance
        .collection('users').doc(userId).collection('trips').get().then((QuerySnapshot querySnapshot) => {

           querySnapshot.docs.forEach((doc) {
              
                data.add(doc.data()) ;
              
              
            })
        });
      
      return data;

    }

    static getTripDocId(String tripId)async{

      var userId ;
      var userDocId;

      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');

      await FirebaseFirestore.instance
        .collection('users')
        .doc(userId).collection('trips')
        .get()
        .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {

              if(doc['tripId']==tripId){
              
                userDocId = doc.id;
              
              }
            });
            
      });

      return userDocId;


    }


    static editTrip (String? tripName,String tripBudget, String tripLocation,String tripDuration, 
            String description,String tripCoverPhoto,String duration,String endDate,String places)async{

      var userId ;
      var tripId;
      final deData = jsonDecode(places);
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');
      tripId=prefs.getString('triDocId');

      print('tripocid:${tripId}');
       await FirebaseFirestore.instance
      .collection('users').doc(userId).collection('trips').doc(tripId).update({
        
            "tripName":tripName,
            "tripBudget":tripBudget,
            "tripLocation":tripLocation,
            "tripDuration":tripDuration,
            "tripDescription":description,
            "tripCoverPhoto":tripCoverPhoto,
            "duration":duration,
            'endDate':endDate,
            "places":deData,

      });
    }

    static countTotalTrips()async{

      var userId ;
      var count ;

      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');

      await FirebaseFirestore.instance
      .collection('users').doc(userId).collection('trips').count().get().then(
        
        (ele) => count=ele.count,
        
        );

        return count;

    }

    static addToFavorite (String placeId,String placeName,String placePhotoUrl,String placeType)async{

      var userId ;
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');

      var uuid = const Uuid();

      await FirebaseFirestore.instance
      .collection('users').doc(userId).collection('favorites').add({

        
          "placeId":placeId,
          'placeName':placeName,
          'placePhotoUrl':placePhotoUrl,
          'placeType':placeType,
    
      });

    }

    static getFavorites () async{

      var userId ;
      var data =[];
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');

      await FirebaseFirestore.instance
        .collection('users').doc(userId).collection('favorites').get().then((QuerySnapshot querySnapshot) => {

           querySnapshot.docs.forEach((doc) {
              
                data.add(doc.data()) ;
              
              
            })
        });

      return data;

    }

    static removeFavorites (placeId) async{

      var userId;
      var favId;

      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');

    //get spesific id to remove the favorite place-------------------
      await FirebaseFirestore.instance
            .collection('users')
            .doc(userId).collection('favorites').get()
            .then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) {

                  if(doc['placeId']==placeId){
                  
                    favId = doc.id;
                  
                  }
                });
                
            });

      //then remove the item from the favorite list-------------
     FirebaseFirestore.instance
        .collection('users').doc(userId).collection('favorites').doc(favId).delete()
          .then((_) => print('Deleted'))
          .catchError((error) => print('Delete failed: $error'));

    }

  
}




