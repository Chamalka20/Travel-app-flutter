import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelapp/repositories/user/userAuth_repo.dart';

class  userProfileRepo {

  Future <String> createUser(email,userName,password,proPic) async {

    List signUpState = await userAuthRep.signUp(email,userName,password,proPic);
    print(signUpState);
    User user = signUpState[0]['user'];

    if(user.email !=null){

      await user.updateDisplayName(userName);
      await user.updatePhotoURL(proPic);
  
    }else{
      print('user null');
    }
    
    return signUpState[0]['AuthException'];

  }

}

final userProfileRep =userProfileRepo();