import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/place.dart';

class cityRepo {

  Future<Place> getcityDetailes(placeId)async{

    print("this is citydetailesRepo"+placeId);
  
    final query = await FirebaseFirestore.instance
            .collection('cities')
            .where('placeId', isEqualTo: placeId)
            .get();
    
    final Place data = Place.fromMap(query.docs[0].data() );
    
    return data;

  }



}

final cityRep = cityRepo();


