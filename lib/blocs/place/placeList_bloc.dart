import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelapp/models/favorites.dart';

import '../../models/place.dart';
import '../../repositories/attractions/attractionList_repo.dart';
import '../../repositories/city/city_repo.dart';
import '../../repositories/directions/directions_repo.dart';
import '../../repositories/favorites/favorites_repo.dart';
import '../../repositories/restaurants/restaurants_repo.dart';
import '../../repositories/weather/weather_repo.dart';
import 'place_event.dart';
import 'place_state.dart';



class placeListBloc extends Bloc<place_event,place_state>{

  Future<Place> getPlaceDetailes(placeId,placeType) async {
   late Place details;
   
    if(placeType =='city'){
        
     details = await cityRep.getcityDetailes(placeId);

    }else if(placeType =='attraction'){

     details = await attractionListRep.getAttractionDetailes(placeId);

    }else if(placeType =='restaurant'){

      details = await restaurantRepo.getRestaurantDetailes(placeId);

    }

    
    return  details;

  }

  Future <List<Place>>  searchPlaces(input,placeType) async {
    
    late List<Place> details;

    if(placeType =='city'){
        
     details = await cityRep.searchCities(input);

    }else if(placeType =='attraction'){

     details = await attractionListRep.searchAttractions(input);

    }else if(placeType =='restaurant'){

      details = await restaurantRepo.searchRestaurants(input);

    }

    return  details;

  }


  Future <List<Place>> getplaces(String name,String placeType) async {

    late List<Place> details;

    if(placeType =='attraction'){
      
     details = await attractionListRep.getAttractionPlaces(name);

    }else if(placeType =='restaurant'){

      details = await restaurantRepo.getRestaurants(name);

    }


    return details;
  }

  Future <List> checkFavorites(data) async {
    
    final List isFavorites = await favRepo.isChecktFavorites(data);
      
      return isFavorites;

  }

  Future <List> getWeather(lat,lng) async {

    weatherRepo repo = weatherRepo(lat: lat, lng: lng);

    List weatherData =await repo.findWeather();

    return weatherData;
  }

  Future <List> getRoute (lat,lng) async {

    directionsRepo repo = directionsRepo(lat: lat, lng:lng);
    List directionData = await repo.calculateDistance();

    return directionData;

  }

  
  Future<List<Place>> getUserRecentlySearch() async {

    List<Place> details = await cityRep.getUserRecentlySearch();
    
    return details;
  }

  placeListBloc():super(InitialPlaceState()){

    on<place_event>((event, emit) async {
      
      if(event is placeAddToFavorites){
    
      print('this is addToFavorites');
      bool isAdd =await favRepo.addToFavorite(Favorite(placeId: event.atPlaceId, placeName: event.placeName, placePhotoUrl: event.placeImgUrl, placeType: event.type,));
      emit(placeAddToFavoriteState(isAdd,));  

      }else if(event is placeRemoveFromFavorites){

        print("this is removeFavorite");
        bool isRemove =await favRepo.removeFavorites(event.atPlaceId);
        emit(placeRemoveFromFavoriteState(isRemove));

      }else if(event is addUserRecentlySearch){

        if(event.type=='locality'){

         await cityRep.addUserRecentlySearch(Place(id: event.id, name: event.name, photoRef: event.photoRef,
           rating:0.0, address: event.address, type: event.type, phone: event.phone,
            openingHours: event.openingHours, reviews: event.reviews, latitude: event.latitude, longitude: event.longitude));
        }
        
      }
    },);
   
   
  }
  
 

}

final placeBloc = placeListBloc();