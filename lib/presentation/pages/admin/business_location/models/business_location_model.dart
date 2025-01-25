class MBusinessLocation {
  final num id;
  final String businessName;
  final num countryId;
  final num provinceId;
  final num cityId;
  final num locationId;
  final String locationCode;
  final String contactPerson;
  final String contactNumber;
  final String contactEmail;

  MBusinessLocation({
    required this.id,
    required this.businessName,
    required this.countryId,
    required this.provinceId,
    required this.cityId,
    required this.locationId,
    required this.locationCode,
    required this.contactPerson,
    required this.contactNumber,
    required this.contactEmail,
  });

  factory MBusinessLocation.fromJson(Map<String, dynamic> json) {
    return MBusinessLocation(
      id: json['id'] ?? 0,
      businessName: json['business_name'] ?? '',
      countryId: json['country_id'] ?? 0,
      provinceId: json['province_id'] ?? 0,
      cityId: json['city_id'] ?? 0,
      locationId: json['location_id'] ?? 0,
      locationCode: json['location_code'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      contactEmail: json['contact_email'] ?? '',
    );
  }
}
