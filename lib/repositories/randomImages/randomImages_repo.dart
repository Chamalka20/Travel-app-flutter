import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class randomImagesRepo{


  Future<String> getRandomImage(tripCount) async {
    
    late String photoUrl;
    const apiUrl = 'https://api.pexels.com/v1/search';
    final apiKey = dotenv.env['pexelsApiKey'].toString();
    const url ='$apiUrl?query=Landscape&per_page=20&orientation=landscape&size=medium';

    final response = await http.get(
      Uri.parse(url),
      headers: {
       
        'Authorization': apiKey,
      },
      
    );

    if (response.statusCode == 200) {

      print('photo url get susses');
      
      final data = jsonDecode(response.body);
      photoUrl = data['photos'][tripCount]['src']['medium']??'https://www.pexels.com/photo/mountain-covered-snow-under-star-572897/';

      
    }else{
      print('photo url get faild${response.statusCode}');
    }

    return photoUrl;
    
  }


}

final randomImagesRep = randomImagesRepo();