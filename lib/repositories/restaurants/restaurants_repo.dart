import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/restaurants.dart';

class restaurantsRepo {

  final String placeName; 

  const restaurantsRepo({required this.placeName,});


  Future<List<Restaurants>> getRestaurants()async{

    print("this is resRepo"+placeName);
  
    final query = await FirebaseFirestore.instance
            .collection('restaurants')
            .where('city', isEqualTo: placeName)
            .get();
    

    final List<Restaurants> list = [];

    for(var i=0;i<query.docs.length;i++){
      var restaurants = Restaurants.fromMap(query.docs[i].data());
       list.add(restaurants);
    }

    
    return list;

  }



}