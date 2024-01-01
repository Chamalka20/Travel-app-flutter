
class Attractions {
  final String id;
  final String name;
  final String photoRef;
  final String rating;
  final String address;
  final String type;
  

  Attractions({
    required this.id,
    required this.name,
    required this.photoRef,
    required this.rating,
    required this.address,
    required this.type,
  });

  factory Attractions.fromMap( dynamic map)  {

      if (map['imageUrls'] != null && map['imageUrls'].isNotEmpty) {
      
        return Attractions(
          id: map["placeId"]??'',
          name: map["title"]??'',
          photoRef: map["imageUrls"][0],
          rating: map["rating"]??'',
          address: map["address"]??'',
          type: map["categoryName"]??'',
        );

      }else{

        return Attractions(
                name: '',
                photoRef: 'https://via.placeholder.com/150', 
                address: '', 
                id: '',
                rating: '', 
                type: '',
                    
      );
    }
  }
  
}