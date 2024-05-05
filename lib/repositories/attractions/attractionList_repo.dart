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

    print("this is attracRepo"+placeName);
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

  Future<void> addReview (placeId,reviews,userId) async{

  List<String> userIds = [];
    try{

        QuerySnapshot attractionsQuery =await FirebaseFirestore.instance.collection('attractions')
      .where('placeId',isEqualTo: placeId).get();

         for (var ele in attractionsQuery.docs) {
          var value = await FirebaseFirestore.instance.collection('attractions').doc(ele.id).get();
          List<dynamic>? ids = value.data()?['userIds']; 
          if (ids != null) {
            userIds.addAll(ids.cast<String>()); 
          }
          if (!userIds.contains(userId)) {
            userIds.add(userId); 
          }
        }

        for (var ele in attractionsQuery.docs) {

            FirebaseFirestore.instance
            .collection('attractions')
            .doc(ele.id)
            .update({
              'reviews': reviews});
          
        }

        for (var ele in attractionsQuery.docs) {
          await FirebaseFirestore.instance.collection('attractions').doc(ele.id).update({
            'userIds': userIds,
          });
        }
 
    }catch(e){
      print(e);
    }
    
  }

  Future<void> deleteReview (reviews,placeId,userId) async{

    bool isUserFound= false;
    List userIds = [];
    try{

       QuerySnapshot attractionsQuery =await FirebaseFirestore.instance.collection('attractions')
      .where('placeId',isEqualTo: placeId).get();

        for (var ele in attractionsQuery.docs) {

            FirebaseFirestore.instance
            .collection('attractions')
            .doc(ele.id)
            .update({
              'reviews': reviews});
          
        }

         QuerySnapshot attractionsQuery2 =await FirebaseFirestore.instance.collection('attractions')
      .where('placeId',isEqualTo: placeId).get();

        for (var ele in attractionsQuery2.docs) {

          reviews=ele.get("reviews");
        }
        
        for(var i=0;i<reviews.length;i++){
          if(reviews[i]["userId"]==userId){
            isUserFound= true;
            print("found");
            break;
          }else{
            isUserFound= false;
          }
        
        }

        if(isUserFound == false){
          for (var ele in attractionsQuery.docs) {
            var value = await FirebaseFirestore.instance.collection('attractions').doc(ele.id).get();
            List<dynamic>? ids = value.data()?['userIds']; 
            if (ids != null) {
              userIds.addAll(ids); 
            }
            userIds.removeWhere((element) => element==userId);
            }
            for (var ele in attractionsQuery.docs) {
            await FirebaseFirestore.instance.collection('attractions').doc(ele.id).update({
              'userIds': userIds,
            });
        }

        }
    

    }catch(e){
      print(e);
    }
    
  }


}

final attractionListRep = attractionListRepo();