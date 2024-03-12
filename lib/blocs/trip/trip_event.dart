import '../../models/place.dart';
import '../../models/trip.dart';

abstract class trip_event{

  trip_event();

}

class temporarilyStoreTripEvent extends trip_event {

  final String tripName;
  final String durationCount;
  final String tripDuration;
  final String tripBudget;
  final String tripLocation;
  final String tripDescription;
  final String tripCoverPhot;
  final String endDate;

  temporarilyStoreTripEvent(
    this.tripName,
    this.durationCount,
    this.tripDuration,
    this.tripBudget,
    this.tripLocation,
    this.tripDescription,
    this.tripCoverPhot,
    this.endDate,
  );
  
}

class getSelectTrip extends trip_event{
  final tripId;
  getSelectTrip(this.tripId);
}

class addTripPalcesEvent extends trip_event {

  final bool isEditTrip;
  final List placesIds;
  final String tripId;

  addTripPalcesEvent({
    
    required this.tripId,
    required this.isEditTrip,
    required this.placesIds,
  });
  
}

class editTrip extends trip_event{

  final tripId;
  editTrip(this.tripId);

}

class planingPlaces extends trip_event{

  List<Place> places;
  int currentDay;
  planingPlaces(this.places,this.currentDay);
}

class creatTrip extends trip_event{

  Trip trip;
  creatTrip(this.trip);

}

class editPlaces extends trip_event{

  var places={};
  editPlaces(this.places);
}

class updateTrip extends trip_event{
  Trip trip;
  updateTrip(this.trip);
}



class cancelPlaningPlaces extends trip_event{

  cancelPlaningPlaces();
}