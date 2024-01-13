import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelapp/blocs/trip/trip_event.dart';
import 'package:travelapp/blocs/trip/trip_state.dart';

import '../../models/trip.dart';
import '../../repositories/trips/trip_repo.dart';

class tripBloc extends Bloc<trip_event,trip_state> {




 Future<List<Trip>> getOnGoingTrips() async {

    List <Trip> trips =await tripRepo.onGoingTrips();

    return trips;

 }

  tripBloc():super(InitialTripState()){

    on<trip_event>((event, emit) =>{




    });


  }

}

final tripBlo = tripBloc();