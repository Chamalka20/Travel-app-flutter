import 'package:firebase_database/firebase_database.dart';
import 'package:travelapp/models/atttractions.dart';

class attractionListRepo {

  final String placeName; 

  const attractionListRepo({required this.placeName,});


  Future<List<Attractions>> getAttractionPlaces()async{

    print("this is repo"+placeName);
  
    final databaseReference =  FirebaseDatabase.instance.ref('places');
    final query = await databaseReference.orderByChild('city').equalTo(placeName).get();
    final map = query.value as Map<dynamic, dynamic>;

    final List<Attractions> list = [];
    
    map.forEach((key, value) {
      var attracrion = Attractions.fromMap(value);
      list.add(attracrion);
    });

    
    return list;

  }



}