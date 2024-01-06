class Restaurants {
  final String id;
  final String name;
  final String photoRef;
  final String rating;
  final String address;
  final String type;
  

  Restaurants({
    required this.id,
    required this.name,
    required this.photoRef,
    required this.rating,
    required this.address,
    required this.type,
  });

  factory Restaurants.fromMap( dynamic map)  {

      if (map['imageUrls'] != null) {
      
        return Restaurants(
          id: map["placeId"]??'',
          name: map["title"]??'',
          photoRef: map["imageUrls"][0],
          rating: map["rating"]??'',
          address: map["address"]??'',
          type: "Restaurants",
        );

      }else{

        return Restaurants(
                name: '',
                photoRef: 'https://via.placeholder.com/150', 
                address: '', 
                id: map["placeId"],
                rating: '', 
                type: '',
                    
      );
    }
  }
  
}