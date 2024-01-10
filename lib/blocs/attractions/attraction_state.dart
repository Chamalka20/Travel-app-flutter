import '../../models/atttractions.dart';



abstract class attraction_state {

  attraction_state();

}

class InitialAttractionState extends attraction_state {
 
}


class attractionAddToFavoriteState extends attraction_state{

  final bool isAdd; 

  attractionAddToFavoriteState(this.isAdd);

}

class attractionRemoveFromFavoriteState extends attraction_state{

  final bool isRemove; 
  attractionRemoveFromFavoriteState(this.isRemove);
}