class OnboardingProfileDraft {
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  DateTime? birthDate;
  int? heightCm;
  String? countryCode;
  String? city;
  String? locationName;
  double? latitude;
  double? longitude;
  String? connectionType;
  String? university;
  String? educationCountry;
  String? educationLevel;
  String? company;
  String? jobTitle;
  String? children;
  String? wantsChildren;
  String? religion;
  String? alcohol;
  String? smoking;
  List<Map<String, dynamic>> photos = [];

  Map<String, dynamic> toJson() => {
    if (email != null) 'email': email,
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (gender != null) 'gender': gender,
    if (birthDate != null) 'birthDate': birthDate!.toUtc().toIso8601String(),
    if (heightCm != null) 'heightCm': heightCm,
    if (countryCode != null ||
        city != null ||
        locationName != null ||
        latitude != null ||
        longitude != null)
      'location': {
        if (countryCode != null) 'countryCode': countryCode,
        if (city != null) 'city': city,
        if (locationName != null) 'displayName': locationName,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      },
    if (connectionType != null) 'connectionType': connectionType,
    if (university != null) 'university': university,
    if (educationCountry != null) 'educationCountry': educationCountry,
    if (educationLevel != null) 'educationLevel': educationLevel,
    if (company != null) 'company': company,
    if (jobTitle != null) 'jobTitle': jobTitle,
    if (children != null) 'children': children,
    if (wantsChildren != null) 'wantsChildren': wantsChildren,
    if (religion != null) 'religion': religion,
    if (alcohol != null) 'alcohol': alcohol,
    if (smoking != null) 'smoking': smoking,
    'photos': photos,
  };
}
