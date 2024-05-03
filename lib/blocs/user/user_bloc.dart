import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelapp/blocs/user/user_event.dart';
import 'package:travelapp/blocs/user/user_state.dart';
import '../../repositories/user/userAuth_repo.dart';
import '../../repositories/user/userProfile_repo.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;


class userBloc extends Bloc<userEvent,userState>{

  Stream<auth.User?> get authState => auth.FirebaseAuth.instance.authStateChanges();
  Stream<auth.User?> get userState => auth.FirebaseAuth.instance.userChanges();

  Future<auth.User?> getUserDetails() async {

   auth.FirebaseAuth.instance.currentUser?.reload();  

   return auth.FirebaseAuth.instance.currentUser;

  }

  userBloc():super(InitialUserState()){

    on<userEvent>((event, emit) async {

      if(event is readUserEmailEvent){

        List userState =await userAuthRep.checkIfEmailInUse(event.email);
        emit(checkEmailAlreadyExistState(userState));


      }else if(event is signUpEvent){

        final String userStates = await userProfileRep.createUser(event.email,event.name,event.password,event.proPicUrl);

        emit(singUpState(userStates));

      }else if(event is signInEvent){

        final List userStates=await userAuthRep.signIn(event.email, event.password);
        emit(singInState(userStates));

      }else if (event is emailVerification){

        await userAuthRep.emailVerification();

      }else if (event is editProfile){  

        await userAuthRep.updateProfile(event.user);

      }else if (event is resetPassword){

        List resetState =await userAuthRep.resetPassword(event.email);
        emit(resetPasswordState(resetState));

      }else if(event is signInWithGoogle){

        await userAuthRep.signInWithGoogle();

      }else if(event is signOutEvent){

        await userAuthRep.signOut();
        emit(signOutState());

      }


    });


  }
}

final userBlo = userBloc();