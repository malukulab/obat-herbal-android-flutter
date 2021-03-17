import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obat_herbal_android/simple_validator.dart';
import 'package:obat_herbal_android/widgets/textfield_bordered.dart';

typedef FormSubmitedHandle = void Function(Map<String, dynamic> formData);

class HerbFormActivity extends StatefulWidget {
  final SimpleValidator? validator;
  final FormSubmitedHandle? onSubmit;
  final String labelTextSubmit;
  final Map<String, dynamic>? formData;

  HerbFormActivity({
    this.validator,
    this.onSubmit,
    this.labelTextSubmit = 'Submit',
    this.formData,
  });

  @override
  _HerbFormActivityState createState() => _HerbFormActivityState();
}

class _HerbFormActivityState extends State<HerbFormActivity> {
  final _formKey = GlobalKey<FormState>();

  // state.
  final TextEditingController textFieldTitle = new TextEditingController();
  final TextEditingController textFieldDescription = new TextEditingController();
  Future<String>? _resolveImagePath;

  @override
  void initState() {
    super.initState();

    if (widget.formData != null) {
      Map<String, dynamic> _formData = widget.formData!;
      _resolveImagePath = Future.value(_formData['photo']);
      textFieldTitle.text = _formData['title'];
      textFieldDescription.text = _formData['description'];
    }
  }


  @override
  void dispose() {
    textFieldTitle.dispose();
    textFieldDescription.dispose();
    super.dispose();
  }

  void handleOnSubmit() async {
    bool isFormValidateNotFalsy = _formKey.currentState!.validate();

    if (isFormValidateNotFalsy) {
      // ignore: non_constant_identifier_names
      final FALLBACK_PHOTO = '';

      Map<String, dynamic> formData = {
        'photo': (await _resolveImagePath) ?? FALLBACK_PHOTO,
        'title': textFieldTitle.text,
        'description': textFieldDescription.text,
      };

    widget.onSubmit!(formData);
    _formKey.currentState!.reset();
    }
  }

  void handleOnImagePicker() async {
    PickedFile? _picker = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 300,
      imageQuality: 100
    );

    setState(() {
      _resolveImagePath = Future.value(_picker!.path);
    });
  }

  Widget _buildImagePicker() {
    return FutureBuilder(
      future: _resolveImagePath,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget _resolveImageOrFallbackBuild = Image.asset(
          'assets/images/upload-vector-2.png',
          width: 130,
          height: 130
        );

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          _resolveImageOrFallbackBuild = Image.file(File(snapshot.data!), fit: BoxFit.fill);
        } else if (snapshot.hasError) {
          // not implementation error build.
        }
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _resolveImageOrFallbackBuild,
                SizedBox(height: 12),
                Text(
                  """Tekan untuk sertakan/ganti gambar (opsional).
                  """,
                  style: TextStyle(color: Colors.grey[700])
                ),
              ]
            ),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: handleOnImagePicker,
              child: _buildImagePicker()
            ),
            SizedBox(height: 12),
            // Form fields.
            TextFieldBordered(
              labelText: 'Judul',
              hintText: 'Contoh: Obat mujarab untuk 😻.',
              controller: textFieldTitle,
              validator: (String? value) {
                return widget.validator!.run(value);
              }
            ),
            SizedBox(height: 22),
            TextFieldBordered(
              maxLines: 2,
              labelText: 'Deskripsi',
              hintText: 'Contoh: Recommended banget deh.',
              keyboardType: TextInputType.multiline,
              controller: textFieldDescription,
              validator: (String? value) {
                return widget.validator!.run(value);
              }
            ),
            SizedBox(
              height: 22,
            ),
            MaterialButton(
              child: Text(
                widget.labelTextSubmit,
                style: TextStyle(fontSize: 17, color: Colors.teal)
              ),
              onPressed: handleOnSubmit,
            )
          ]
        ),
      ),
    );
  }
}
