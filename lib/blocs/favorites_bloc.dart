import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:travelapp/models/favorites.dart';
import '../repositories/favorites/favorites_repo.dart';

abstract class favorites_bloc { 

  StreamSink get stateStreamSink ;
  Stream<dynamic> get stateStream;

  StreamSink get eventStreamSink;
  Stream<dynamic> get eventStream;
  

}


class attractionFavorites extends favorites_bloc{


  final  _stateStreamController=  BehaviorSubject<dynamic>();

  @override
  StreamSink get stateStreamSink => _stateStreamController.sink;
  @override
  Stream<dynamic> get stateStream => _stateStreamController.stream;

  final  _eventStreamController= BehaviorSubject<dynamic>();

  @override
  StreamSink get eventStreamSink => _eventStreamController.sink;
  @override
  Stream<dynamic> get eventStream => _eventStreamController.stream;

  attractionFavorites(){

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

    print(isaddAttractionToFavorite);
    
    
    stateStreamSink.add(isaddAttractionToFavorite);

    
    
    
    

    });

    

  }



}

final attracFavBloc = attractionFavorites();

class restaurantsFavorites extends favorites_bloc{


  final  _stateStreamController=  BehaviorSubject<dynamic>();

  @override
  StreamSink get stateStreamSink => _stateStreamController.sink;
  @override
  Stream<dynamic> get stateStream => _stateStreamController.stream;

  final  _eventStreamController= BehaviorSubject<dynamic>();

  @override
  StreamSink get eventStreamSink => _eventStreamController.sink;
  @override
  Stream<dynamic> get eventStream => _eventStreamController.stream;

  restaurantsFavorites(){

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

    print(isaddAttractionToFavorite);
    
    
    stateStreamSink.add(isaddAttractionToFavorite);

    
    
    
    

    });

    

  }



}

final restFavBloc = restaurantsFavorites();


