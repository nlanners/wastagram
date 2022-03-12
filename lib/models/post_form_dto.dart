import 'package:intl/intl.dart';

class PostFormDTO {
  late int quantity;
  late String imageURL;
  late DateTime dateTime;
  late double latitude;
  late double longitude;

  @override
  String toString() {
    return """Date: $dateTime, Quantity: $quantity, 
    Location: {$latitude, $longitude}, Image: $imageURL""";
  }


  Map<String, dynamic> sendValues(){
    return {
      'date': dateTime.toString(),
      'imageURL': imageURL,
      'latitude': latitude,
      'longitude': longitude,
      'quantity': quantity
    };
  }

  String getDateString() {
    return DateFormat('EEEE, MMM. d').format(dateTime);
  }

}