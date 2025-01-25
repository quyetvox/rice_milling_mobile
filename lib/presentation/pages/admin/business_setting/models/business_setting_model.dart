class MBusinessSetting {
  final num id;
  final String businessName;
  final num businessStartDate;
  final num currencyId;
  final num timezoneId;
  final String logoPath;
  final num financialYearStartMonth;
  final String contactPerson;
  final String contactNumber;
  final String contactEmail;

  MBusinessSetting({
    required this.id,
    required this.businessName,
    required this.businessStartDate,
    required this.currencyId,
    required this.timezoneId,
    required this.logoPath,
    required this.financialYearStartMonth,
    required this.contactPerson,
    required this.contactNumber,
    required this.contactEmail,
  });

  factory MBusinessSetting.fromJson(Map<String, dynamic> json) {
    return MBusinessSetting(
      id: json['id'] ?? 0,
      businessName: json['business_name'] ?? '',
      businessStartDate: json['business_start_date'] ?? 0,
      currencyId: json['currency_id'] ?? 0,
      timezoneId: json['timezone_id'] ?? 0,
      logoPath: json['logo_path'] ?? '',
      financialYearStartMonth: json['financial_year_start_month'] ?? 0,
      contactPerson: json['contact_person'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      contactEmail: json['contact_email'] ?? '',
    );
  }
}
