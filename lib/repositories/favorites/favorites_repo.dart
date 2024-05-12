import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelapp/models/favorites.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class favoritesRepo {

  String? getCurrentUserId(){
    return auth.FirebaseAuth.instance.currentUser?.uid;
  }
  
  Future<List> isChecktFavorites (ids) async{
      
      List isaddRestaurantToFavorite = [];
      for (var e in ids) {
        bool found = false;

        if (e.id != null) {
        QuerySnapshot querySnapshot=  await FirebaseFirestore.instance
          .collection('users').doc(getCurrentUserId()).collection('favorites').where('placeId',isEqualTo: e.id).get();

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
        .collection('users').doc(getCurrentUserId()).collection('favorites').get()
        .then((QuerySnapshot querySnapshot) => {

           querySnapshot.docs.forEach((doc) {
              
                data.add(doc.data()) ;
              
              
            })
        });

      
      for (var element in data) {
        
        var attr = Favorite.fromMap(element);
        list.add(attr);

      }


      return list;

  }

    Future <bool> addToFavorite (Favorite favorite)async{
  
      bool isDataAdd = false;       

        await FirebaseFirestore.instance
        .collection('users').doc(getCurrentUserId()).collection('favorites').add(
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
     
    //get spesific id to remove the favorite place-------------------
      await FirebaseFirestore.instance
            .collection('users')
            .doc(getCurrentUserId()).collection('favorites').where('placeId',isEqualTo: placeId).get()
            .then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) {

                  doc.reference.delete();
                   print("delete");
                   isRemove = true;
                });
                
            // ignore: invalid_return_type_for_catch_error
            }).catchError((error)=>{
            print('not add'),
            isRemove = false,
             });

     

      print(isRemove);
      return isRemove;      

    }



}

final favRepo = favoritesRepo();