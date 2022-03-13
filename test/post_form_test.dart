import 'package:flutter_test/flutter_test.dart';
import 'package:wastagram/models/post_form_dto.dart';

void main() {
  group('DTO', () {

    test('DTO formats string correctly', () {
      Map<String, dynamic> map = {
        'quantity': 5,
        'imageURL': 'TEST',
        'date': DateTime.parse('2022-01-01'),
        'latitude': 62.0,
        'longitude': 59.345
      };

      PostFormDTO testDTO = PostFormDTO.fromMap(map);

      expect(testDTO.quantity, map['quantity']);
      expect(testDTO.imageURL, map['imageURL']);
      expect(testDTO.dateTime, map['date']);
      expect(testDTO.latitude, map['latitude']);
      expect(testDTO.longitude, map['longitude']);
    });

    test('DTO formats string correctly', () {
      Map<String, dynamic> map = {
        'quantity': 5,
        'imageURL': 'TEST',
        'date': DateTime.parse('2022-01-01'),
        'latitude': 62.0,
        'longitude': 59.345
      };

      String testString = "Date: 2022-01-01 00:00:00.000, Quantity: 5, Location: {62.0, 59.345}, Image: TEST";

      PostFormDTO testDTO = PostFormDTO.fromMap(map);

      expect(testDTO.toString(), testString);

    });
  });
     
}