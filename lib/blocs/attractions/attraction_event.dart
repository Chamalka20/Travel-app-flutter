abstract class attraction_event {

 const attraction_event();
 

}

class attractionAddToFavorites extends attraction_event{

  final String atPlaceId;
  final String placeName;
  final String placeImgUrl;
  final String type;

  const attractionAddToFavorites({required this.atPlaceId,required this.placeName,required this.placeImgUrl,
  required this.type});

}

class attractionRemoveFromFavorites extends attraction_event{

  final String atPlaceId;

  const attractionRemoveFromFavorites({required this.atPlaceId});
}

