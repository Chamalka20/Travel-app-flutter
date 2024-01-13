import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/place.dart';

class attractionListRepo {


  const attractionListRepo();

  Future <Place>  getAttractionDetailes(placeId)async{

    final  query = await FirebaseFirestore.instance
            .collection('attractions')
            .where('placeId', isEqualTo: placeId)
            .get();


    Place data =Place.fromMap(query.docs[0].data());
    print(data);
    return data;

  }

  Future<List<Place>> getAttractionPlaces(placeName)async{

    final query = await FirebaseFirestore.instance
            .collection('attractions')
            .where('city', isEqualTo: placeName)
            .get();
       
  
    final List<Place> list = [];

    for(var i=0;i<query.docs.length;i++){
      var attracrion = Place.fromMap(query.docs[i].data());
       list.add(attracrion);
    }
    

    
    return list;

  }



}

final attractionListRep = attractionListRepo();