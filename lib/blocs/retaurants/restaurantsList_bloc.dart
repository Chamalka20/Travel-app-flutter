import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelapp/blocs/retaurants/restaurant_event.dart';
import 'package:travelapp/blocs/retaurants/restaurant_state.dart';

import '../../models/favorites.dart';
import '../../models/restaurants.dart';
import '../../repositories/favorites/favorites_repo.dart';
import '../../repositories/restaurants/restaurants_repo.dart';

class restaurantsListBloc extends Bloc<restaurant_event,restaurant_state>{


  Future <List<Restaurants>> getRestaurants(String name) async {

    restaurantsRepo repo =  restaurantsRepo(placeName:name );
    List<Restaurants> restaurants = await repo.getRestaurants();
    

    return restaurants;
  }

  Future <List> checkFavorites(data) async {
    
    final List<Favorite> favorites = await favRepo.getFavorites();
       List isaddRestaurantToFavorite = [];

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

        isaddRestaurantToFavorite.add(found);
      }

      
      return isaddRestaurantToFavorite;

  }


  restaurantsListBloc():super(InitialAttractionState()){

    on<restaurant_event>((event, emit) async {
          
          if(event is restaurantAddToFavorites){

          print('this is addToFavorites');
          bool isAdd =await favRepo.addToFavorite(event.atPlaceId, event.placeName, event.placeImgUrl, event.type);
          emit(restaurantAddToFavoriteState(isAdd));  

          }else if(event is restaurantRemoveFromFavorites){

            print("this is removeFavorite");
            bool isRemove =await favRepo.removeFavorites(event.atPlaceId);
            emit(restaurantRemoveFromFavoriteState(isRemove));
          }
        },);

    
  }
  
 

}

final restBloc = restaurantsListBloc();