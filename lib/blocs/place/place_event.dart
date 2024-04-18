
import 'package:travelapp/models/review.dart';

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

class addUserRecentlySearch extends place_event {

  final String id;
  final String name;
  final String photoRef;
  final String address;
  final String type;
  final String phone;
  final List openingHours;
  final double latitude;
  final double longitude;

  addUserRecentlySearch({
    required this.id,
    required this.name,
    required this.photoRef,
    required this.address,
    required this.type,
    required this.phone,
    required this.openingHours,
    required this.latitude,
    required this.longitude,
  });

  
}
class addReviewEvent extends place_event{

  final Review review;
  final String placeType;
  final String placeId;
  addReviewEvent(this.review,this.placeType,this.placeId);
}

class deleteReviewEvent extends place_event{
  final reviewId;
  final placeId;
  final placeType;

  deleteReviewEvent(this.placeId,this.reviewId,this.placeType);

}

