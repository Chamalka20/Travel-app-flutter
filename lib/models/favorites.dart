class Favorite {

  String placeId;
  String placeName;
  String placePhotoUrl;
  String placeType;


  Favorite({
    required this.placeId,
    required this.placeName,
    required this.placePhotoUrl,
    required this.placeType,
  });

  
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
