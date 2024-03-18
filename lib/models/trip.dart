class Trip {

  final String tripId;
  final String tripName;
  final String tripBudget;
  final String tripLocation;
  final String tripDescription;
  final String tripCoverPhoto;
  final String tripDuration;
  final int durationCount;
  DateTime startDate;
  DateTime endDate;
  var places={};
  
  Trip({
    required this.tripId,
    required this.tripName,
    required this.tripBudget,
    required this.tripLocation,
    required this.tripDescription,
    required this.tripCoverPhoto,
    required this.tripDuration,
    required this.durationCount,
    required this.startDate,
    required this.endDate,
    required this.places,
  });


  toJson ()=>{

    'tripId':tripId,
    'tripName':tripName,
    'tripBudget':tripBudget,
    'tripLocation':tripLocation,
    'tripDescription':tripDescription,
    'tripCoverPhoto':tripCoverPhoto,
    'tripDuration':tripDuration,
    'durationCount':durationCount,
    'startDate':startDate,
    'endDate':endDate,
    'places':places
  };

  
  factory Trip.fromMap (dynamic map){
    
    return Trip(
      tripId: map['tripId'],
      tripName: map['tripName'],
      tripBudget: map['tripBudget'],
      tripLocation: map['tripLocation'],
      tripDescription: map['tripDescription'],
      tripCoverPhoto: map['tripCoverPhoto'],
      tripDuration: map['tripDuration'],
      durationCount: map['durationCount'],
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
      places: map['places'], 
     );


  }


}
