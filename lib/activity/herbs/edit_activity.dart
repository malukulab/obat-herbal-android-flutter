import 'package:flutter/material.dart';
import 'package:obat_herbal_android/simple_validator.dart';
import 'package:obat_herbal_android/herb_repository_impl.dart';
import './_form_activity.dart';

class HerbEditActivity extends StatefulWidget {

  final int? id;

  HerbEditActivity({this.id});

  @override
  _HerbEditActivityState createState() => _HerbEditActivityState();
}


class _HerbEditActivityState extends State<HerbEditActivity> {

  final herbRepository = HerbRepositoryImpl();
  Future<Map<String, dynamic>>? herb;


  @override
  void initState() {
    super.initState();

    herb = herbRepository.findByid(widget.id);
  }


  void handleEdit(BuildContext context, Map<String, dynamic> formData) async {
    String? _message;
    try {
      await herbRepository.update(formData, widget.id);
      _message = 'Berhasil menyimpan perubahan';
    }catch(err) {
      _message = 'Terjadil kesalahan, coba lagi nanti!';
    }finally {
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(_message!)
        )
      );
    }

    Navigator.pop(context, formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit obat')
      ),
      body: Container(
        child: FutureBuilder(
          future: herb,
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot)  {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              return HerbFormActivity(
                labelTextSubmit: 'Simpan perubahan',
                formData: snapshot.data,
                onSubmit: (formData) {
                  handleEdit(context, formData);
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
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'TERJADI KESALAHAN 👺',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.red[700]
                  )
                )
              );
            }else {
              return Center(
                child: CircularProgressIndicator()
              );
            }
          }
        ),
        padding: EdgeInsets.all(10.0)
      )
    );
  }
}
