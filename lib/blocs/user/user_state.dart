
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
class resetPasswordState extends userState{

  List resetState;
  resetPasswordState(this.resetState);

}

class signOutState extends userState{

  signOutState();
}