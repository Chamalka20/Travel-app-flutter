import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/atttractions.dart';
import '../../models/favorites.dart';
import '../../repositories/attractions/attractionList_repo.dart';
import '../../repositories/favorites/favorites_repo.dart';
import 'attraction_event.dart';
import 'attraction_state.dart';



class attractionListBloc extends Bloc<attraction_event,attraction_state>{



  Future <List<Attractions>> getAttractions(String name) async {

    attractionListRepo repo =  attractionListRepo(placeName:name );
    List<Attractions> attractions = await repo.getAttractionPlaces();

    return attractions;
  }

  Future <List> checkFavorites( data) async {
    
    final List<Favorite> favorites = await favRepo.getFavorites();
       List isaddAttractionToFavorite = [];

      for (var e in data) {
        bool found = false;

        for (var i = 0; i < favorites.length; i++) {
          if (e.id != null) {
            if (favorites[i].placeId.contains(e.id)) {
              found = true;
              break; // Break out of the loop once a match is found
            }
          }
        }

        isaddAttractionToFavorite.add(found);
      }
      
      return isaddAttractionToFavorite;

  }

 
  attractionListBloc():super(InitialAttractionState()){

    on<attraction_event>((event, emit) async {
      
      if(event is attractionAddToFavorites){

      print('this is addToFavorites');
      bool isAdd =await favRepo.addToFavorite(event.atPlaceId, event.placeName, event.placeImgUrl, event.type);
      emit(attractionAddToFavoriteState(isAdd));  

      }else if(event is attractionRemoveFromFavorites){

        print("this is removeFavorite");
        bool isRemove =await favRepo.removeFavorites(event.atPlaceId);
        emit(attractionRemoveFromFavoriteState(isRemove));
      }
    },);
   
   
  }
  
 

}

final attraBloc = attractionListBloc();