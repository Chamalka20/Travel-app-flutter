
class Place {

final String id;
  final String name;
  final String photoRef;
  final double rating;
  final String address;
  final String type;
  final String phone;
  final List openingHours;
  final List reviews;
  final double latitude;
  final double longitude;

   Place({
    required this.id,
    required this.name,
    required this.photoRef,
    required this.rating,
    required this.address,
    required this.type,
    required this.phone,
    required this.openingHours,
    required this.reviews,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromMap( dynamic map)  {

      
        return Place(
          id: map["placeId"]??'',
          name: map['title'] != null?map["title"]:'',
          photoRef:map['imageUrls'] != null? map["imageUrls"][0]:'https://via.placeholder.com/150',
          rating:0.0,
          address:map['address'] != null? map["address"]:'',
          type:map['categoryName'] != null? map["categoryName"]:'',
          phone:'No numbers found',
          openingHours: [],
          reviews: [],
          latitude: map['location']['lat'] ?? 0.0,
          longitude: map['location']['lng'] ?? 0.0,
        );

      
  }



}