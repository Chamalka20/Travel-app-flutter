import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/place.dart';

class cityRepo {

  Future<Place> getcityDetailes(placeId)async{

    print("this is citydetailesRepo"+placeId);
  
    final query = await FirebaseFirestore.instance
            .collection('cities')
            .where('placeId', isEqualTo: placeId)
            .get();
    
    final Place data = Place.fromMap(query.docs[0].data() );
    
    return data;

  }

   Future<List<Place>> searchCities(input)async{

    final  query =await FirebaseFirestore.instance.collection("cities")
                       .orderBy('title')
                       .startAt([input])
                       .limit(5)
                       .get();
                       
     

    final List<Place> list = [];

     for(var i=0;i<query.docs.length;i++){
      var city = Place.fromMap(query.docs[i].data());
       list.add(city);
    }

    
    return list;

  }

   Future addUserRecentlySearch(Place place)async{

    var userId ;
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userDbId');

    await FirebaseFirestore.instance
      .collection('users').doc(userId).collection('recentlySearch').add(

        place.toJson()
    
      );

   }

   Future<List<Place>> getUserRecentlySearch() async {

    var userId ;
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userDbId');

    final query=await FirebaseFirestore.instance
                  .collection('users').doc(userId).collection('recentlySearch').get();


     final List<Place> list = [];

     for(var i=0;i<query.docs.length;i++){
      var city = Place.fromMap(query.docs[i].data());
       list.add(city);
     }

    
    return list;
   }

}

final cityRep = cityRepo();


