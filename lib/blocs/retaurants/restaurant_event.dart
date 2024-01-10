abstract class restaurant_event{

  const restaurant_event();


}

class restaurantAddToFavorites extends restaurant_event{

  final String atPlaceId;
  final String placeName;
  final String placeImgUrl;
  final String type;

  const restaurantAddToFavorites({required this.atPlaceId,required this.placeName,required this.placeImgUrl,
  required this.type});

}

class restaurantRemoveFromFavorites extends restaurant_event{

  final String atPlaceId;

  const restaurantRemoveFromFavorites({required this.atPlaceId});
}