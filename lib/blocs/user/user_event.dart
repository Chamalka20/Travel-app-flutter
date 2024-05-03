import '../../models/user.dart';

abstract class userEvent{

  
}


class readUserEmailEvent extends userEvent{

 String email; 

 readUserEmailEvent(this.email);

}

class signInEvent extends userEvent{

  String email;
  String password;

  signInEvent(this.email,this.password);

}

class signInWithGoogle extends userEvent{

  signInWithGoogle();
}

class signUpEvent extends userEvent {

  final String name;
  final String email;
  final String password;
  final String proPicUrl;
  
  signUpEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.proPicUrl,
  });

}

class emailVerification extends userEvent{
  emailVerification();
}

class resetPassword extends userEvent{
  final String email;
  resetPassword({required this.email});
}

class signOutEvent extends userEvent{

  signOutEvent();
}

class editProfile extends userEvent{

  User user;
  editProfile(this.user);

}