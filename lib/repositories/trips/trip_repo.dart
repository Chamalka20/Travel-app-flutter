import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart' as intl;
import '../../models/trip.dart';

class trip_repo{
 
  final auth.User? user=auth.FirebaseAuth.instance.currentUser;


  Future<bool> createTrip (Trip trip) async {

       bool isError=false;
    try{
    await FirebaseFirestore.instance
        .collection('users').doc(user?.uid).collection('trips').add(
           trip.toJson()
        );
    }catch(e){
      isError=true;
    }
    
    return isError;
  }

  Future<bool> updateTrip (Trip trip) async {
    bool isError=false;
    late String tripDocId;

    try{

      await FirebaseFirestore.instance
      .collection('users').doc(user?.uid).collection('trips')
      .where('tripId',isEqualTo:trip.tripId).get()
      .then((QuerySnapshot querySnapshot) => 

          querySnapshot.docs.forEach((element) {
            tripDocId=element.id;
          })
      );

      await FirebaseFirestore.instance
      .collection('users').doc(user?.uid).collection('trips')
      .doc(tripDocId).update(trip.toJson());


    }catch(e){
      isError=true;
      print(e);

    }

    return isError;
    
  }


  Future<List<Trip>>  onGoingTrips () async {

    DateTime currentDate = DateTime.parse( intl.DateFormat("yyyy-MM-dd").format(DateTime.now()));

    final query= await FirebaseFirestore.instance
        .collection('users').doc(user?.uid).collection('trips').where('endDate',isGreaterThan: currentDate).get();

    
    final List<Trip> list = [];

    for(var i=0;i<query.docs.length;i++){
      var trip = Trip.fromMap(query.docs[i].data());
       list.add(trip);
    }
    print(list);
    return list;

        
  }
  
  Future<List<Trip>>  pastTrips () async {

    DateTime currentDate = DateTime.parse( intl.DateFormat("yyyy-MM-dd").format(DateTime.now()));

    final query= await FirebaseFirestore.instance
        .collection('users').doc(user?.uid).collection('trips').where('endDate',isLessThan: currentDate).get();

    
    final List<Trip> list = [];

    for(var i=0;i<query.docs.length;i++){
      var trip = Trip.fromMap(query.docs[i].data());
       list.add(trip);
    }
    print(list);
    return list;

        
  }

  Future<Trip>  getSelectTrip (tripId) async {

     final query = await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid).collection('trips')
            .where('tripId',isEqualTo: tripId)
            .get();

     final Trip data = Trip.fromMap(query.docs[0].data());

     return data;

  }

  Future<int> countTotalTrips() async {

    late int count ;
    
    await FirebaseFirestore.instance
      .collection('users').doc(user?.uid).collection('trips').count().get().then(
        
        (ele) => count=ele.count!,
        
        );

    return count;
  }

}

final tripRepo = trip_repo();