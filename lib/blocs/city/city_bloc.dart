import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/directions/directions_repo.dart';
import '../../repositories/weather/weather_repo.dart';
import 'city_event.dart';
import 'city_state.dart';


class city_bloc extends Bloc<city_event,city_state>{



  Future <List> getWeather(lat,lng) async {

    weatherRepo repo = weatherRepo(lat: lat, lng: lng);

    List weatherData =await repo.findWeather();

    return weatherData;
  }

  Future <List> getRoute (lat,lng) async {

    directionsRepo repo = directionsRepo(lat: lat, lng:lng);
    List directionData = await repo.calculateDistance();

    return directionData;

  }

  city_bloc():super(InitialCityState()){



  }

}

final cityBloc = city_bloc();