class Review {

  final String? userId;
  final String reviewId;
  final String name;
  final DateTime publishAt;
  final String reviewerPhotoUrl;
  final String text;

  Review({
    required this.userId,
    required this.reviewId,
    required this.name,
    required this.publishAt,
    required this.reviewerPhotoUrl,
    required this.text,
  });

  toJson ()=>{
    "userId":userId,
    "reviewId":reviewId,
    "name":name,
    "publishAt":publishAt,
    "reviewerPhotoUrl":reviewerPhotoUrl,
    "text":text
  };

  factory Review.fromMap( dynamic map)  {
      
    return Review(
      userId:map["userId"],
      reviewId:map["reviewId"]??"etetret",
      name:map["name"],
      publishAt:map["publishAt"].toDate(),
      reviewerPhotoUrl:map["reviewerPhotoUrl"],
      text:map["text"]
    );

      
  }

  

}
