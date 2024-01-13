

abstract class place_state {

  place_state();

}

class InitialPlaceState extends place_state {
 
}


class placeAddToFavoriteState extends place_state{

  final bool isAdd; 

  placeAddToFavoriteState(this.isAdd);

}

class placeRemoveFromFavoriteState extends place_state{

  final bool isRemove; 
  placeRemoveFromFavoriteState(this.isRemove);
}