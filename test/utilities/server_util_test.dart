import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:moviereviewapp/models/user_model.dart';

import 'server_util_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Get User object from server', () {
    
    /// Test parsing from json to User object with good data
    test('Parse with good data', () async {
      final client = MockClient();

      when(client.get(Uri.parse('https://jakemoviereviewserver.herokuapp.com/api/user/0')))
        .thenAnswer((_) async => http.Response('{"id": "f0d64d51-e46b-41ac-95a8-621dbe806409", "username": "jake57" }', 200));

      expect(await server_util.getUser('0', client: client), isA<User>());
    });

    /// When trying to parse json to User with bad data we should get null
    test('Parse with bad data', () async {
      final client = MockClient();

      when(client.get(Uri.parse('https://jakemoviereviewserver.herokuapp.com/api/user/0')))
        .thenAnswer((_) async => http.Response('{"id": 1, "username": "jake57" }', 200));

      expect(await server_util.getUser('0', client: client), null);
    });

    /// Test getting a bad response from server
    test('Throws exception if we get a bad response from server', () async {
      final client = MockClient();

      when(client.get(Uri.parse('https://jakemoviereviewserver.herokuapp.com/api/user/0')))
        .thenAnswer((_) async => http.Response('Server error', 500));

      expect(server_util.getUser('0', client: client), throwsException);
    });

  });
}