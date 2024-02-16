import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart' as intl;

import '../../models/trip.dart';

class trip_repo{
 
  final auth.User? user=auth.FirebaseAuth.instance.currentUser;

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

}

final tripRepo = trip_repo();