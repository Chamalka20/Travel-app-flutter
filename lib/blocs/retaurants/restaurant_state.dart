abstract class restaurant_state {

  const restaurant_state();

}

class InitialAttractionState extends restaurant_state {
}

class restaurantAddToFavoriteState extends restaurant_state{

  final bool isAdd; 

  restaurantAddToFavoriteState(this.isAdd);

}

class restaurantRemoveFromFavoriteState extends restaurant_state{

  final bool isRemove; 
  restaurantRemoveFromFavoriteState(this.isRemove);
}