import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/restaurants.dart';
import '../repositories/restaurants/restaurants_repo.dart';

class restaurantsListBloc{

 final _stateStreamController= BehaviorSubject<dynamic>();

  StreamSink get stateStreamSink => _stateStreamController.sink;
  Stream<dynamic> get stateStream => _stateStreamController.stream;

  final _eventStreamController =BehaviorSubject<dynamic>();

  StreamSink get eventStreamSink => _eventStreamController.sink;
  Stream<dynamic> get eventStream => _eventStreamController.stream;

 
  restaurantsListBloc(){

   

    eventStream.listen((event) async {
      print('this is rest_bloc'+event);
      restaurantsRepo repo =  restaurantsRepo(placeName:event );
      final List<Restaurants>  restaurants =await repo.getRestaurants(); 
     
      stateStreamSink.add(restaurants);
      

    });
  }
  
 

}

final restBloc = restaurantsListBloc();