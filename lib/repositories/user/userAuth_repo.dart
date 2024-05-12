import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/user.dart' ;

class userAuthRepo {

  final auth.FirebaseAuth _firebaseAuth;

  userAuthRepo({auth.FirebaseAuth? firebaseAuth}):_firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  Stream<auth.User?> get onUserStateChanged => _firebaseAuth.userChanges();
  Stream<auth.User?> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  Future <List>signUp(email,userName,password,proPic) async {

    String AuthException='';
    List signUpDeatails=[];
    late auth.UserCredential userCredential;
    try {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email:email,
        password:password,
      );
      AuthException='successful';
      signUpDeatails=[{'user':userCredential.user,'AuthException':AuthException}];
      await createUser(userCredential.user!.uid,userCredential.user!.email,userName,proPic);
      

    } on auth.FirebaseAuthException catch (e) {
      
      if (e.code == 'weak-password') {
        AuthException='The password provided is too weak';
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        AuthException='The account already exists for that email';
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    
    return signUpDeatails;

    
  }

  Future<List> checkIfEmailInUse(email) async {

   bool isFound =false;
   var userDetails;
   List userState;
   QuerySnapshot querySnapshot= await FirebaseFirestore.instance
                        .collection('users').where('email',isEqualTo: email).get();
    
    if(querySnapshot.docs.isNotEmpty){
      
      isFound=true;
      for(var i=0;i<querySnapshot.docs.length;i++){
        userDetails=User.fromMap(querySnapshot.docs[i].data());
      }
    }else{
      isFound =false;
    }

    userState=[{'isFound':isFound,'userDetails':userDetails}];
    return userState;
   
  }

  
  Future <List> signIn(email,password) async {

    bool isSignIn=true;
    String AuthException='';
    List signInDeatails=[];
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      
    } on auth.FirebaseAuthException catch (e) {
      isSignIn=false;
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        AuthException='No user found for that email';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        AuthException='Wrong password provided for that user';
      }
    }


    signInDeatails=[{'isSignIn':isSignIn,'AuthException':AuthException}];
    return signInDeatails;
           

  }

  Future<void> emailVerification() async {

   await _firebaseAuth.currentUser?.sendEmailVerification();

  }

  Future<List> resetPassword(email) async {

    String AuthException='';
    bool isSend=false;
    List signUpDeatails=[];
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      isSend=true;
    }on auth.FirebaseAuthException catch (e) {

      isSend=false;

      if (e.code == 'invalid-email') {
        AuthException='invalid email';
      }

    }catch (e){
      print(e);
    }

    signUpDeatails=[{'isSend':isSend,'AuthException':AuthException}];

    return signUpDeatails;

  }

  Future<void> updateProfile(User user) async {
  
    try{
      _firebaseAuth.currentUser?.updateDisplayName(user.name);
      //update user activity
       QuerySnapshot attractionsQuery = await FirebaseFirestore.instance
      .collection('attractions')
      .where('userIds', arrayContains:"IebH8ix2mePMYHPDe1ardR7Q21g1")
      .get();
      
       
      for (QueryDocumentSnapshot attractionDoc in attractionsQuery.docs) {
        List<dynamic> reviews = attractionDoc['reviews'];

        for (int i = 0; i < reviews.length; i++) {
          if (reviews[i]['userId'] == user.uid) {
            reviews[i]['name'] = user.name;
          }
        }
        await attractionDoc.reference.update({'reviews': reviews});
      }

    }catch(e){
      print(e);
    }

  }

  Future<dynamic> signInWithGoogle() async {

    try{

     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
     final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
          
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);

    } on Exception catch (e){
      print(e);
    }    
  }


  Future<void> signOut() async {
    
    try{
      await _firebaseAuth.signOut();
    }catch(e){
      print(e);
    }

  }
  
 Future<void> createUser(uid,email,userName,proPic) async {
   
  await FirebaseFirestore.instance
        .collection('users').doc(uid).set({
          'uid': uid,
          'displayName':userName,
          'email': email,
          'proPic': proPic,
        });
  }
  
  
}
final userAuthRep = userAuthRepo();