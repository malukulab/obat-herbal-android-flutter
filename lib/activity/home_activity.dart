import 'package:flutter/material.dart';
import 'package:obat_herbal_android/activity/herbs/show_activity.dart';
import 'package:obat_herbal_android/widgets/cardpressable_herb.dart';
import '../herb_repository_impl.dart';
import './about_activity.dart';
import 'herbs/edit_activity.dart';
import 'herbs/creation_activity.dart';

class HomeActivity extends StatefulWidget {


  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {

  final herbRepository = HerbRepositoryImpl();
  Future<List<Map<String, dynamic>>>? herbs;

  @override
  void initState() {
    super.initState();

    herbs = herbRepository.findAll();
  }

  void refreshListView() {
    setState(() {
      herbs = herbRepository.findAll();
    });
  }


  String? _subStringDescription(String? text) {
    if (text!.length > 90) {
      return '${text.substring(0, 90)}...';
    }

    return text;
  }


  void handleOnEditable(int? id) async {
    var herbExist = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HerbEditActivity(id: id)
      )
    );

    if (herbExist != null) refreshListView();
  }

  void handleToShowShowActivity(BuildContext context, int? id) async {
     try {
       Map<String, dynamic> _data = await herbRepository.findByid(id);
       Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return HerbShowActivity(data: _data);
            }
          )
        );
     }catch (err) {

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

            handleOnEditable(rows[it]['id']);
          },
          onDestroy: () async {
            int id = rows[it]['id'];
            bool isDeleted = await herbRepository.delete(id);

            if (isDeleted) {
              refreshListView();

              ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text(
                      '👍 Data berhasil dihapus!',
                      style: TextStyle(
                        color: Colors.red[400]
                      )
                    )
                  )
              );
            }
          },
          onPressed: ()  {
            handleToShowShowActivity(context, rows[it]['id']);
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
