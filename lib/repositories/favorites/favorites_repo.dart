import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/models/favorites.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:uuid/uuid.dart';

class favoritesRepo {

  final auth.User? user=auth.FirebaseAuth.instance.currentUser;

  Future<List> isChecktFavorites (ids) async{
      
      var data =[];
      List isaddRestaurantToFavorite = [];

      for (var e in ids) {
        bool found = false;

        if (e.id != null) {
        QuerySnapshot querySnapshot=  await FirebaseFirestore.instance
          .collection('users').doc(user?.uid).collection('favorites').where('placeId',isEqualTo: e.id).get();

          if(querySnapshot.docs.isNotEmpty){

            found = true;
          }else{

            found = false;
          }

        }
        isaddRestaurantToFavorite.add(found);
      }

      
        

      print(isaddRestaurantToFavorite);
      return isaddRestaurantToFavorite;

  }

  Future<List<Favorite>> getFavorites () async{

      var data =[];
      final List<Favorite> list = [];

      await FirebaseFirestore.instance
        .collection('users').doc(user?.uid).collection('favorites').get().then((QuerySnapshot querySnapshot) => {

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

    Future <bool> addToFavorite (Favorite favorite)async{
  
      bool isDataAdd = false;       
      var uuid = const Uuid();

        await FirebaseFirestore.instance
        .collection('users').doc(user?.uid).collection('favorites').add(
           favorite.toJson()
        ).then((value) => {
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
      var favId;

    //get spesific id to remove the favorite place-------------------
      await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid).collection('favorites').where('placeId',isEqualTo: placeId).get()
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