import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelapp/blocs/place/placeList_bloc.dart';
import 'package:travelapp/blocs/place/place_event.dart';
import 'package:travelapp/models/review.dart';
import 'package:travelapp/repositories/user/userAuth_repo.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class reviewList extends StatefulWidget {

  final placeId;
  final searchType;
  final Function() methodFromParent;
  reviewList({super.key,required this.placeId,required this.searchType,required this.methodFromParent});

  @override
  State<reviewList> createState() => _reviewListState(placeId,searchType,methodFromParent);
}

class _reviewListState extends State<reviewList> {

  final placeId;
  final searchType;
  final Function() methodFromParent;
  final reviewTextController = TextEditingController();
  late String userName;
  late String proPic;
  late String? userId;
  late Future<List<Review>> reviews;
  _reviewListState(this.placeId,this.searchType,this.methodFromParent);
  
  void addReview (){

    if(reviewTextController.text.isNotEmpty){
      var uuid = const Uuid();
      final Review newReview = Review (
        userId: userId,
        reviewId: uuid.v1(),
        name: userName,
        publishAt: DateTime.now().toString(), 
        reviewerPhotoUrl: proPic, 
        text: reviewTextController.text
      );

      BlocProvider.of<placeListBloc>(context).add(addReviewEvent(newReview, searchType, placeId));

    }

  }

  void getReviews () {
    
   reviews = placeBloc.getReviewList(searchType, placeId);
   setState(() {
     reviews;
   });

  }

  @override
  void initState() {

    userAuthRep.onAuthStateChanged.listen((user) {
      userId = user!.uid;
      userName=user.displayName??"";
      proPic= user.photoURL??"https://cdn-icons-png.flaticon.com/64/3177/3177440.png";

    });
    
    super.initState();

    getReviews ();
     
  }

  
  @override
  Widget build(BuildContext context) {
  return SafeArea(
    child: DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      direction: DismissiblePageDismissDirection.vertical,
      isFullScreen: true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 13),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Text("Reviews",
                        style: GoogleFonts.cabin(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 547, 
                child: FutureBuilder <List<Review>>(
                  future: reviews,
                  builder: (BuildContext context,snapshot) { 
                    if(snapshot.hasData) {
                      return
                        ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0,right: 10,left: 10),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 240, 238, 238),
                                    borderRadius: BorderRadius.circular(13)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 13),
                                              child: Container(
                                                width: 35,
                                                height: 35,
                                                child: CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: NetworkImage(snapshot.data
                                                    ![index].reviewerPhotoUrl),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 7, top: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 200,
                                                        child: Text(snapshot.data![index].name,
                                                          style: GoogleFonts.cabin(
                                                            textStyle: const TextStyle(
                                                              color: Color.fromARGB(255, 0, 0, 0),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(snapshot.data![index].publishAt,
                                                        style: GoogleFonts.cabin(
                                                          textStyle: const TextStyle(
                                                            color: Color.fromARGB(255, 112, 112, 112),
                                                            fontSize: 9,
                                                            fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 13),
                                          child: SizedBox(
                                            width: 250,
                                            child: Text(snapshot.data![index].text,
                                              style: GoogleFonts.cabin(
                                                textStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 112, 112, 112),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ),
                                Visibility(
                                  visible: userId == snapshot.data![index].userId,
                                  child: GestureDetector(
                                    onTap: () {
                                      
                                      BlocProvider.of<placeListBloc>(context).add(deleteReviewEvent(placeId
                                      ,snapshot.data![index].reviewId,searchType));
                                      
                                      getReviews();
                                    },
                                    child: Text("Delete",
                                      style: GoogleFonts.cabin(
                                        textStyle: const TextStyle(
                                          color: Color.fromARGB(255, 250, 3, 3),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );

                    }else{
                      return
                        ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0,right: 10,left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 240, 238, 238),
                                borderRadius: BorderRadius.circular(13)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 13),
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              borderRadius: BorderRadius.circular(13)
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 7, top: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    child:  Container(
                                                        width: 100,
                                                        height: 11,
                                                        decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                      ),
                                                    ),
                                                   Container(
                                                    width: 100,
                                                    height: 9,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13),
                                      child: SizedBox(
                                        width: 250,
                                        child: 
                                         Container(
                                            width: 100,
                                            height: 11,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          );
                        },
                      );

                    }
                    
                      
                  },
                  
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20,bottom:5,left:4), 
                child: Row(
                  children: [
                    Container(
                      width: 310,
                      height:45,
                      child: TextField(
                        onTap: () {
                          
                        },
                        onChanged:(value) {
                          setState(() {
                            reviewTextController;
                          });
                        },
                        showCursor: true,
                        controller: reviewTextController,
                        decoration: InputDecoration(
                          hintText: "add review",
                          filled: true,
                          contentPadding: EdgeInsets.only(left: 14),
                          fillColor: Color.fromARGB(255, 207, 207, 207),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:5),
                      child: GestureDetector(
                        onTap: (){
                          addReview ();
                          getReviews ();
                          methodFromParent.call();
                        },
                        child: SizedBox(
                          width:34,
                          height:34,
                          child: Image.asset(reviewTextController.text.isNotEmpty?
                          'assets/images/chat-arrow.png':'assets/images/chat-arrow-before.png'
                          ),
                        )
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

       
  }
}