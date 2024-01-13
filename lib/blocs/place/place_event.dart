abstract class place_event {

 const place_event();
 

}

class placeAddToFavorites extends place_event{

  final String atPlaceId;
  final String placeName;
  final String placeImgUrl;
  final String type;

  const placeAddToFavorites({required this.atPlaceId,required this.placeName,required this.placeImgUrl,
  required this.type});

}

class placeRemoveFromFavorites extends place_event{

  final String atPlaceId;

  const placeRemoveFromFavorites({required this.atPlaceId});
}

