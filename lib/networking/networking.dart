import 'dart:convert' as json;
import 'package:http/http.dart' as http;

class Networking {
  Future getApiData() async {
    http.Response response =
        await http.get('https://jsonplaceholder.typicode.com/users');
    if (response.statusCode == 200) {
      var data = json.jsonDecode(response.body);
      return data;
    } else {
      print('error in fetching the data');
      return;
    }
  }
}
