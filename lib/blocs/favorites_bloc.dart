import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:travelapp/models/favorites.dart';
import '../repositories/favorites/favorites_repo.dart';

class favorites_bloc {

  final  _stateStreamController=  BehaviorSubject<dynamic>();

  StreamSink get stateStreamSink => _stateStreamController.sink;
  Stream<dynamic> get stateStream => _stateStreamController.stream;

  final  _eventStreamController= BehaviorSubject<dynamic>();

  StreamSink get eventStreamSink => _eventStreamController.sink;
  Stream<dynamic> get eventStream => _eventStreamController.stream;

  favorites_bloc(){

    eventStream.listen((event) async {
      
    favoritesRepo favRepo = favoritesRepo();
    final List<Favorite> favorites = await favRepo.getFavorites();
    final List<dynamic> isaddAttractionToFavorite=[];
      
      bool found;
      event.forEach((e) => {
         found = false,
        
         for( var i=0;i<favorites.length;i++){

            if(e.id!=null){

              if(favorites[i].placeId.contains(e.id)){

                found=true,
              
              }

            }
        },

        isaddAttractionToFavorite.add(found),

      }); 


    
    stateStreamSink.add(isaddAttractionToFavorite);
    
    

    });

    

  }


   // Method to reset the controllers and create new instances
  

  

}

final favBloc = favorites_bloc();

