import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelapp/models/review.dart';
import '../../repositories/user/userAuth_repo.dart';
import '../../timeAgoSinceDate.dart';

typedef CallbackReviewText = void Function(String val);
typedef CallbackDeleteReview = void Function(List val);
// ignore: must_be_immutable
class reviewList extends StatefulWidget {
  final currentReviews;
  final Function() mFPAddReview;
  CallbackReviewText reviewText;
  CallbackDeleteReview deleteReviews;
  reviewList({super.key,required this.currentReviews,required this.mFPAddReview,
  required this.reviewText,required this.deleteReviews});

  @override
  State<reviewList> createState() => _reviewListState(currentReviews,mFPAddReview,reviewText,deleteReviews);
}

class _reviewListState extends State<reviewList> {

  List currentReviews;
  CallbackReviewText reviewText;
  CallbackDeleteReview deleteReviews;
  final Function() mFPAddReview;
  final reviewTextController = TextEditingController();
  late String userName;
  late String proPic;
  late String? userId;
  late Future<List<Review>> reviews;
  
  _reviewListState(this.currentReviews,this.mFPAddReview,this.reviewText,this.deleteReviews);
  
  
  @override
  void initState() {

    userAuthRep.onAuthStateChanged.listen((user) {
    setState(() {
      userId = user!.uid;
      userName = user.displayName ?? "";
      proPic = user.photoURL ?? "https://cdn-icons-png.flaticon.com/64/3177/3177440.png";
    });
  });

    super.initState();

  }

  bool isValidTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return true;
    } else if (timestamp is String) {
      try {
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
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
                child: 
                  
                  ListView.builder(
                  itemCount: widget.currentReviews.length,
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
                                            backgroundImage: NetworkImage(widget.currentReviews
                                              [index]["reviewerPhotoUrl"]),
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
                                                  child: Text(widget.currentReviews[index]["name"],
                                                    style: GoogleFonts.cabin(
                                                      textStyle: const TextStyle(
                                                        color: Color.fromARGB(255, 0, 0, 0),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(TimeAgoSince.timeAgoSinceDate(isValidTimestamp(widget.currentReviews[index]["publishAt"])?
                                                 widget.currentReviews[index]["publishAt"].toDate():widget.currentReviews[index]["publishAt"]),
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
                                      child: Text(widget.currentReviews[index]["text"],
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
                            visible: userId == widget.currentReviews[index]["userId"],
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                   currentReviews.removeWhere((element) =>
                                 element["reviewId"]==widget.currentReviews[index]["reviewId"]);
                                });
                               deleteReviews(currentReviews);
                                
                              },
                              child: Text("Delete",
                                style: GoogleFonts.cabin(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 250, 3, 3),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
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
                          if(reviewTextController.text.isNotEmpty){
                            reviewText(reviewTextController.text);
                            mFPAddReview.call();
                            setState(() {
                              currentReviews;
                            });
                            reviewTextController.text="";
                          }
                          
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