import 'dart:convert';

class EmailECPFCheckoutModel {
  String email;
  String cpf;
  String checkoutID;
  EmailECPFCheckoutModel({
    required this.email,
    required this.cpf,
    required this.checkoutID,
  });

  EmailECPFCheckoutModel copyWith({
    String? email,
    String? cpf,
    String? checkoutID,
  }) {
    return EmailECPFCheckoutModel(
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      checkoutID: checkoutID ?? this.checkoutID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'cpf': cpf,
      'checkoutID': checkoutID,
    };
  }

  factory EmailECPFCheckoutModel.fromMap(Map<String, dynamic> map) {
    return EmailECPFCheckoutModel(
      email: map['email'] ?? '',
      cpf: map['cpf'] ?? '',
      checkoutID: map['checkoutID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EmailECPFCheckoutModel.fromJson(String source) =>
      EmailECPFCheckoutModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'EmailECPFCheckoutModel(email: $email, cpf: $cpf, checkoutID: $checkoutID)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmailECPFCheckoutModel &&
        other.email == email &&
        other.cpf == cpf &&
        other.checkoutID == checkoutID;
  }

  @override
  int get hashCode => email.hashCode ^ cpf.hashCode ^ checkoutID.hashCode;
}
