import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;

import '../../models/trip.dart';

class trip_repo{
 


  Future<List<Trip>>  onGoingTrips () async {

    var userId;
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userDbId');
    DateTime currentDate = DateTime.parse( intl.DateFormat("yyyy-MM-dd").format(DateTime.now()));

    final query= await FirebaseFirestore.instance
        .collection('users').doc(userId).collection('trips').where('endDate',isLessThan: currentDate).get();


    final List<Trip> list = [];

    for(var i=0;i<query.docs.length;i++){
      var trip = Trip.fromMap(query.docs[i].data());
       list.add(trip);
    }

    return list;

        
  }

}

final tripRepo = trip_repo();