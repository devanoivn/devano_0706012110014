part of 'models.dart';

class City extends Equatable {
  final String? cityId;
  final String? provinceId;
  final String? province;
  final String? type;
  final String? cityName;
  final String? postalCode;

  const City({
    this.cityId,
    this.provinceId,
    this.province,
    this.type,
    this.cityName,
    this.postalCode,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        cityId: json['cityid'] as String?,
        provinceId: json['provinceid'] as String?,
        province: json['province'] as String?,
        type: json['type'] as String?,
        cityName: json['cityname'] as String?,
        postalCode: json['postalcode'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'cityid': cityId,
        'provinceid': provinceId,
        'province': province,
        'type': type,
        'cityname': cityName,
        'postalcode': postalCode,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      cityId,
      provinceId,
      province,
      type,
      cityName,
      postalCode,
    ];
  }
}
