
String? validateRequired(String? value) {
  if (value!.isEmpty) {
    return 'required';
  }

}

class SimpleValidator {
  bool? _isFalsy;
  String? _message;
  List<dynamic> validators;
  final Map<String, String>? errorMessages;
  final String fallbackMessage = 'Bidang ini tidak benar';

  SimpleValidator(List<dynamic> validators, {this.errorMessages})
    : this.validators = validators;

  get message {
    return _message;
  }



  run(String? value) {
    for (dynamic validator in validators) {
      String? key = validator(value);
      // ignore: unnecessary_null_comparison
      bool isFalsy = !(key == null);

      if (isFalsy) {
        _message = errorMessages?[key] ?? fallbackMessage;
        continue;
      }

      _message = null;
    }
  }
}
