import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../models/atttractions.dart';
import '../repositories/attractions/attractionList_repo.dart';



class attractionListBloc{

 final _stateStreamController= BehaviorSubject<dynamic>();

  StreamSink get stateStreamSink => _stateStreamController.sink;
  Stream<dynamic> get stateStream => _stateStreamController.stream;

  final _eventStreamController =BehaviorSubject<dynamic>();

  StreamSink get eventStreamSink => _eventStreamController.sink;
  Stream<dynamic> get eventStream => _eventStreamController.stream;

 
  attractionListBloc(){

   

    eventStream.listen((event) async {
      print('this is attrac_bloc'+event);
      attractionListRepo repo =  attractionListRepo(placeName:event );
      final List<Attractions>  attraction= await repo.getAttractionPlaces(); 
     
      stateStreamSink.add(attraction);
      

    });
  }
  
 

}

final attraBloc = attractionListBloc();