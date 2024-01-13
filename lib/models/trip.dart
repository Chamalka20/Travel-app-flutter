class Trip {

  String tripId;
  String tripName;
  String tripBudget;
  String tripLocation;
  String tripDuration;
  String tripDescription;
  String tripCoverPhoto;
  String durationCount;
  String endDate;
  List places;
  
  Trip({
    required this.tripId,
    required this.tripName,
    required this.tripBudget,
    required this.tripLocation,
    required this.tripDuration,
    required this.tripDescription,
    required this.tripCoverPhoto,
    required this.durationCount,
    required this.endDate,
    required this.places,
  });


  toJson ()=>{

    'tripId':tripId,
    'tripName':tripName,
    'tripBudget':tripBudget,
    'tripLocation':tripLocation,
    'tripDuration':tripDuration,
    'tripDescription':tripDescription,
    'tripCoverPhoto':tripCoverPhoto,
    'durationCount':durationCount,
    'endDate':endDate,
    'places':places,


  };

  
  factory Trip.fromMap (dynamic map){

    return Trip(
      tripId: map['tripId'],
      tripName: map['tripName'],
      tripBudget: map['tripBudget'],
      tripLocation: map['tripLocation'],
      tripDuration: map['tripDuration'],
      tripDescription: map['tripDescription'],
      tripCoverPhoto: map['tripCoverPhoto'],
      durationCount: map['durationCount'],
      endDate: map['endDate'],
      places: map['places'], 
     );


  }


}
