import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travelapp/models/atttractions.dart';

class attractionListRepo {

  final String placeName; 

  const attractionListRepo({required this.placeName,});


  Future<List<Attractions>> getAttractionPlaces()async{

    final query = await FirebaseFirestore.instance
            .collection('attractions')
            .where('city', isEqualTo: placeName)
            .get();
       
  
    final List<Attractions> list = [];

    for(var i=0;i<query.docs.length;i++){
      var attracrion = Attractions.fromMap(query.docs[i].data());
       list.add(attracrion);
    }
    

    
    return list;

  }



}