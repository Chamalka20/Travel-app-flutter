import '../../models/trip.dart';

abstract class tripState{


}

class  InitialTripState extends tripState{

}

class temporarilyStoreTripState extends tripState{
  Trip trip;
  temporarilyStoreTripState(this.trip);
}


class getTripDetailsSate extends tripState{
  Trip trip;
  getTripDetailsSate(this.trip);

}

class addTripPlacesState extends tripState {
  bool isEditTrip;
  List placesIds;
  
  addTripPlacesState({
    required this.isEditTrip,
    required this.placesIds,
  });


}

class storeTripPlacesState extends tripState{

  var storeTripPlaces;
  storeTripPlacesState(this.storeTripPlaces);
  

}

class tripCreatingSuccessState extends tripState{
  tripCreatingSuccessState();
}

class tripCreateErrorState extends tripState{
  tripCreateErrorState();
}
