import 'package:flutter/material.dart';
import 'package:obat_herbal_android/simple_validator.dart';
import 'package:obat_herbal_android/herb_repository_impl.dart';
import './_form_activity.dart';

class HerbCreationActivity extends StatelessWidget {

  final herbRepository = HerbRepositoryImpl();


  void handleCreation(context, formData) async {
    String? message;

    try {
      await herbRepository.create(formData);
      message = 'Berhasil menambahkan data';
    }catch (err){
      message = 'Terjadi kesalahan, coba nanti!';
    } finally {
      ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(message!)
          )
        );

      Navigator.pop(context, formData);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambahkan obat')
      ),
      body: Container(
        child: HerbFormActivity(
          labelTextSubmit: 'Tambahkan',
          onSubmit: (formData) {
            handleCreation(context, formData);
          },
          validator: SimpleValidator(
            [
              validateRequired,
              // add another validate here.
            ],
            errorMessages: {
              'required': 'Field ini wajib dimasukan!'
            }
          )
        ),
        padding: EdgeInsets.all(10.0)
      )
    );
  }
}
