import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class userState {


}

class InitialUserState extends userState{

  
}

class checkEmailAlreadyExistState extends userState{

  List userState;
  checkEmailAlreadyExistState(this.userState);
}

class singInState extends userState{

  List userState;
  singInState(this.userState);

}

class singUpState extends userState{

 String SignUpData;
 singUpState(this.SignUpData);


}

class signOutState extends userState{

  signOutState();
}