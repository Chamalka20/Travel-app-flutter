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

      
      data.forEach((element) {
        
        var attr = Favorite.fromMap(element);
        list.add(attr);

      });


      return list;

  }

    Future <bool> addToFavorite (String placeId,String placeName,String placePhotoUrl,String placeType)async{
  
      bool isDataAdd = false;
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
      
        }).then((value) => {
          print('add'),
          isDataAdd = true,
        }).catchError((error)=>{
            print('not add'),
            isDataAdd = false,
        });

        print(isDataAdd);
        return isDataAdd;
     


  }

  Future <bool> removeFavorites (String placeId) async{

      bool isRemove = false;
      var userId;
      var favId;

      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userDbId');

    //get spesific id to remove the favorite place-------------------
      await FirebaseFirestore.instance
            .collection('users')
            .doc(userId).collection('favorites').where('placeId',isEqualTo: placeId).get()
            .then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) {

                  doc.reference.delete();
                   print("delete");
                   isRemove = true;
                });
                
            }).catchError((error)=>{
            print('not add'),
            isRemove = false,
             });

     

      print(isRemove);
      return isRemove;      

    }



}

final favRepo = favoritesRepo();