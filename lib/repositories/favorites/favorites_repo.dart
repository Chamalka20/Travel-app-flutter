import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/models/favorites.dart';
import 'package:uuid/uuid.dart';

class favoritesRepo {


  Future<List<Favorite>> getFavorites () async{

      var userId ;
      var data =[];
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');
      final List<Favorite> list = [];

      await FirebaseFirestore.instance
        .collection('users').doc(userId).collection('favorites').get().then((QuerySnapshot querySnapshot) => {

           querySnapshot.docs.forEach((doc) {
              
                data.add(doc.data()) ;
              
              
            })
        });

      print(data);
      data.forEach((element) {
        
        var attr = Favorite.fromMap(element);
        list.add(attr);

      });


      return list;

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