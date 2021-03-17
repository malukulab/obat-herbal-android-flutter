import 'package:flutter/material.dart';
import 'package:obat_herbal_android/activity/herbs/show_activity.dart';
import 'package:obat_herbal_android/widgets/cardpressable_herb.dart';
import 'package:obat_herbal_android/herb_dao_impl.dart';
import './about_activity.dart';
import 'herbs/edit_activity.dart';
import 'herbs/creation_activity.dart';

class HomeActivity extends StatefulWidget {


  @override
  _HomeActivityState createState() => _HomeActivityState();
}



class _HomeActivityState extends State<HomeActivity> {

  final herbDao = HerbDaoImpl();
  Future<List<Map<String, dynamic>>>? herbs;

  @override
  void initState() {
    super.initState();

    herbs = herbDao.findAll();
  }

  void refreshListView() {
    setState(() {
      herbs = herbDao.findAll();
    });
  }


  String? _subStringDescription(String? text) {
    if (text!.length > 90) {
      return '${text.substring(0, 90)}...';
    }

    return text;
  }


  void handleOnEditable(BuildContext context, int id) async {
    var herbExist = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HerbEditActivity(id: id)
      )
    );

    if (herbExist != null) refreshListView();
  }

  void handleToShowActivity(BuildContext context, int id) async {
    try {
      Map<String, dynamic> _data = await herbDao.findByid(id);
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return HerbShowActivity(data: _data);
        }
      )
    );
    }catch (err) {
      // handle error implementation.
    }
  }

  void handleOnDelete(BuildContext context, int id) async {
    String? _message;

    try {
      bool isDeleted = await herbDao.delete(id);
       if (isDeleted) {
          refreshListView();
          _message = '👍 Data berhasil dihapus!';
        }
    } catch (err) {

      _message = 'Terjadi kesalahan';

    } finally {
      ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(
              _message!,
              style: TextStyle(
                color: Colors.red[400]
              )
            )
          )
      );
    }
  }


  Widget _buildListView(List<Map<String, dynamic>>? rows) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, _) {
        return Divider(color: Colors.black12, height: 1.5);
      },
      itemCount: rows!.length,
      itemBuilder: (BuildContext context, int it) {
        return CardPressabelHerb(
          title: rows[it]['title'],
          description: _subStringDescription(rows[it]['description']),
          photo: rows[it]['photo'],
          padding: EdgeInsets.all(10.0),
          onEditable: () {
            handleOnEditable(context, rows[it]['id']);
          },
          onDestroy: () async {
            handleOnDelete(context, rows[it]['id']);
          },
          onPressed: ()  {
            handleToShowActivity(context, rows[it]['id']);
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OBAT HERBAL',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600)
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle_outlined, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => AboutActivity())
                );
              }
            )
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: herbs,
          builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              if (snapshot.data!.length == 0) {
                return Center(
                  child: Text(
                    'DATA BELUM TERSEDIA 🙀',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[700]
                    )
                  )
                );
              }

              return _buildListView(snapshot.data);
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
            } else {
              return Center(
                child: CircularProgressIndicator()
              );
            }
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Tambahkan',
          child: Icon(Icons.add),
          onPressed: () async {
            var herbExist = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HerbCreationActivity()
              )
            );

            if (herbExist != null) refreshListView();
          }),
    );
  }
}
