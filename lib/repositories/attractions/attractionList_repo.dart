import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelapp/models/review.dart';

import '../../models/place.dart';

class attractionListRepo {


  const attractionListRepo();

  Future <Place>  getAttractionDetailes(placeId)async{

    
    final  query = await FirebaseFirestore.instance
            .collection('attractions')
            .where('placeId', isEqualTo: placeId)
            .get();


    Place data =Place.fromMap(query.docs[0].data());
    print(data);
    return data;

  }

   Future<List<Place>> searchAttractions(input)async{

    final  query =await FirebaseFirestore.instance.collection("attractions")
                       .orderBy('title')
                       .startAt([input])
                       .limit(5)
                       .get();
                       
     

    final List<Place> list = [];

     for(var i=0;i<query.docs.length;i++){
      var attraction = Place.fromMap(query.docs[i].data());
       list.add(attraction);
    }

    
    return list;


  }

  Future<List<Place>> getAttractionPlaces(placeName)async{

    
    final query = await FirebaseFirestore.instance
            .collection('attractions')
            .where('city', isEqualTo: placeName)
            .get();
       
  
    final List<Place> list = [];

    for(var i=0;i<query.docs.length;i++){
      var attracrion = Place.fromMap(query.docs[i].data());
       list.add(attracrion);
    }
    
    return list;

  }

   Future<List<Review>> getReviews (placeId) async {

    // ignore: prefer_typing_uninitialized_variables
    var result;
    final List<Review> reviewslist = [];

    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attractions')
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

  Future<void> addReview (placeId,Review review) async{

    try {

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attractions')
          .where('placeId', isEqualTo: placeId)
          .get();

      for (var ele in querySnapshot.docs) {
        await ele.reference.collection('reviews').doc(review.reviewId).set(review.toJson());
      }

    } catch (e) {
      print(e);
    }
    
  }

  Future<void> deleteReview (placeId,reviewId) async{

    try {
      
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attractions')
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

final attractionListRep = attractionListRepo();