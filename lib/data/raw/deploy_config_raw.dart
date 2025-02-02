class DeployConfigRaw {
  final bool isDeploy;
  final String testName;
  final String testPhoneNumber;

  DeployConfigRaw({
    required this.isDeploy,
    required this.testName,
    required this.testPhoneNumber,
  });

  factory DeployConfigRaw.fromJson(Map<String, dynamic> json) {
    return DeployConfigRaw(
      isDeploy: json['isDeploy'] as bool,
      testName: json['testName'] as String,
      testPhoneNumber: json['testPhoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDeploy': isDeploy,
      'testName': testName,
      'testPhoneNumber': testPhoneNumber,
    };
  }
}