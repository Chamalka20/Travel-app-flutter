import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/place.dart';

class restaurantsRepo {

  

  const restaurantsRepo();

  Future<Place> getRestaurantDetailes(placeId)async{

    final  query = await FirebaseFirestore.instance
            .collection('restaurants')
            .where('placeId', isEqualTo: placeId)
            .get();


    final Place data =Place.fromMap(query.docs[0].data());

    return data;
  }


  Future<List<Place>> getRestaurants(placeName)async{

    print("this is resRepo"+placeName);
  
    final query = await FirebaseFirestore.instance
            .collection('restaurants')
            .where('city', isEqualTo: placeName)
            .get();
    

    final List<Place> list = [];

    for(var i=0;i<query.docs.length;i++){
      var restaurants = Place.fromMap(query.docs[i].data());
       list.add(restaurants);
    }

    
    return list;

  }



}

final restaurantRepo = restaurantsRepo();