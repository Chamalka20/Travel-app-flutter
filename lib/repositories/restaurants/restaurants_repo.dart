import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/place.dart';
import '../../models/review.dart';

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

  Future<List<Place>> searchRestaurants(input)async{

    final  query =await FirebaseFirestore.instance.collection("restaurants")
                       .orderBy('title')
                       .startAt([input])
                       .limit(5)
                       .get();
                       
     

    final List<Place> list = [];

     for(var i=0;i<query.docs.length;i++){
      var restaurant = Place.fromMap(query.docs[i].data());
       list.add(restaurant);
    }

    
    return list;


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

  Future<List<Review>> getReviews (placeId) async {

   // ignore: prefer_typing_uninitialized_variables
    var result;
    final List<Review> reviewslist = [];

    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('placeId', isEqualTo: placeId)
          .get();
      
        for (var ele in querySnapshot.docs) {
          result= await ele.reference.collection('reviews').get(); 
        }

  


      for(var i=0;i<result.docs.length;i++){
        var review = Review.fromMap(result.docs[i].data());
        reviewslist.add(review);
      }

    }catch(e){
      print(e);
    }

    return reviewslist;
  }

  Future<void> addReview (placeId,reviews) async{

    try{

      await FirebaseFirestore.instance.collection('restaurants')
      .where('placeId',isEqualTo: placeId).get()
      .then((querySnapshot) {
        for (var ele in querySnapshot.docs) {

            FirebaseFirestore.instance
            .collection('attractions')
            .doc(ele.id)
            .update({
              'reviews': reviews});
          
        }

      });

    }catch(e){
      print(e);
    }
    
  }


   Future<void> deleteReview (placeId,reviewId) async{

    try {

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('placeId', isEqualTo: placeId)
          .get();

      for (var ele in querySnapshot.docs) {
        await ele.reference.collection('reviews').doc(reviewId).delete();
      }

    } catch (e) {
      print(e);
    }
    
  }


}

final restaurantRepo = restaurantsRepo();