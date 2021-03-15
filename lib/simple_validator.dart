
String? validateRequired(String? value) {
  if (value!.isEmpty) {
    return 'required';
  }

}


class SimpleValidator {
  List<dynamic> validators;
  final Map<String, String>? errorMessages;
  final String fallbackMessage = 'Bidang ini tidak benar';

  SimpleValidator(List<dynamic> validators, {this.errorMessages})
    : this.validators = validators;


  String? run(String? value) {
    for (dynamic validator in validators) {
      String? key = validator(value);
      // ignore: unnecessary_null_comparison
      bool isFalsy = !(key == null);

      if (isFalsy) {
        return errorMessages?[key] ?? fallbackMessage;
      }

      return null;
    }
  }
}
