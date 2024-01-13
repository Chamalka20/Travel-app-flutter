class Favorite {

  final String placeId;
  final String placeName;
  final String placePhotoUrl;
  final String placeType;


  Favorite({
    required this.placeId,
    required this.placeName,
    required this.placePhotoUrl,
    required this.placeType,
  });


  toJson ()=>{

    "placeId":placeId,
    'placeName':placeName,
    'placePhotoUrl':placePhotoUrl,
    'placeType':placeType,

  };

  
  factory Favorite.fromMap (dynamic map){

    return
    Favorite(
      placeId: map['placeId'],
      placeName: map['placeName'],
      placePhotoUrl: map['placePhotoUrl'],
      placeType: map['placeType']
    );

  }




}
