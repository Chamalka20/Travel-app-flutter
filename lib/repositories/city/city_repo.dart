import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../models/place.dart';

class cityRepo {

  final auth.User? user=auth.FirebaseAuth.instance.currentUser;

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

    await FirebaseFirestore.instance
      .collection('users').doc(user?.uid).collection('recentlySearch').add(

        place.toJson()
    
      );

   }

   Future<List<Place>> getUserRecentlySearch() async {

    final query=await FirebaseFirestore.instance
                  .collection('users').doc(user?.uid).collection('recentlySearch').get();


     final List<Place> list = [];

     for(var i=0;i<query.docs.length;i++){
      var city = Place.fromMap(query.docs[i].data());
       list.add(city);
     }

    
    return list;
   }

}

final cityRep = cityRepo();


