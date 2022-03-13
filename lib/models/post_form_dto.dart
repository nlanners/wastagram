import 'package:intl/intl.dart';

class PostFormDTO {
  late int _quantity;
  late String _imageURL;
  late DateTime _dateTime;
  late double _latitude;
  late double _longitude;

  int get quantity => _quantity;
  String get imageURL => _imageURL;
  DateTime get dateTime => _dateTime;
  double get latitude => _latitude;
  double get longitude => _longitude;

  PostFormDTO.fromMap(Map<String, dynamic> map) {
    _quantity = map['quantity'];
    _imageURL = map['imageURL'];
    _dateTime = map['date'];
    _latitude = map['latitude'];
    _longitude = map['longitude'];
  }
  

  @override
  String toString() {
    return "Date: $dateTime, Quantity: $quantity, Location: {$latitude, $longitude}, Image: $imageURL";
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