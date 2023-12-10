part of 'services.dart';

class MasterDataService {
  static Future<List<Province>> getProvince() async {
    var respon = await http.get(Uri.https(Const.baseUrl, "/starter/province"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey,
        });

    var ongkir = json.decode(respon.body);
    List<Province> result = [];

    if (respon.statusCode == 200) {
      result = (ongkir['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    }
    return result;
  }

  static Future<List<City>> getCity(var provId) async {
    var respon = await http.get(Uri.https(Const.baseUrl, "/starter/city"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey,
        });

    var ongkir = json.decode(respon.body);
    List<City> result = [];
    if (respon.statusCode == 200) {
      result = (ongkir['rajaongkir']['results'] as List)
          .map((e) => City.fromJson(e))
          .toList();
    }

    List<City> selectedCities = [];
    for (var c in result) {
      if (c.provinceId == provId) {
        selectedCities.add(c);
      }
    }

    return selectedCities;
  }

  static Future<List<Costs>> getCost(
      var kota, var tujuan, var berat, var kurir) async {
    Map<String, dynamic> requestBody = {
      "origin": kota,
      "destination": tujuan,
      "weight": berat,
      "courier": kurir,
    };

    String requestBodyJson = jsonEncode(requestBody);
    var respon = await http.post(
      Uri.https(Const.baseUrl, "/starter/cost"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
      body: requestBodyJson,
    );

    if (respon.statusCode == 200) {
      var data = jsonDecode(respon.body);
      // The structure of your response may vary, adjust accordingly
      var costsList = data['rajaongkir']['results'][0]['costs'] as List?;

      if (costsList != []) {
        List<Costs> costData = costsList!
            .map((e) => Costs.fromJson(e as Map<String, dynamic>))
            .toList();

        return costData;
      }
    }

    return [];
  }
}
