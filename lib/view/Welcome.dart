//import 'package:flutter/foundation.dart';
import 'package:database/modal/User.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:database/modal/UserData.dart';
import 'package:database/control/DataHelper.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //Future<List<UserData>> userd;

  final List <UserData> _userlistd =<UserData>[];

  @override
  void initState() {
    super.initState();
    _showdata();
  }

  Databasehelper dbhelper = Databasehelper();

  TextEditingController titleController = TextEditingController();

  void _save(String text) async{
    titleController.clear();
    UserData user = UserData(text);
    int svdata = await dbhelper.saveUser(user);

    UserData svdatas = await dbhelper.getUser(svdata);

    //print("item saved id: $svdata");

    setState(() {

      _userlistd.insert(0,svdatas);

    });

  }


  _delete (int ids, int index) async{

    int id = await dbhelper.deleteUser(ids);

   print("user deleted: $id");

    setState(() {
      _userlistd.removeAt(index);
    });

  }

  _showdata() async{

    List items = await dbhelper.getAllUsers();
    items.forEach((item){

      //UserData userd = UserData.map(item);

      setState(() {

        _userlistd.add(UserData.map(item));


      });

     //print("this title :${userd.title}");
      //debugPrint("$user");

    });


}
  @override
  Widget build(BuildContext context) {
    //titleController.text =user.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Database project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Name',
                helperText: '..',
                border: OutlineInputBorder(),
              ),
            ),
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                setState(() {
                  //debugPrint("Save button clicked");
                  _save(titleController.text);
                  titleController.clear();
                });
              },
            ),

            Container(
              child: Flexible(
                child: ListView.builder(
                  padding:  const EdgeInsets.all(8.0),
                    reverse: false,
                    itemCount: _userlistd.length,
                    itemBuilder: (_,int index){

                    return Card(
                      child: ListTile(
                        title:Text("Name: ${_userlistd[index].title}"),
                       onTap: ()=>_update(_userlistd[index].id,index,"${_userlistd[index].title}"),

                        trailing: GestureDetector(
                         child: Icon(Icons.delete,color: Colors.red,),
                         onTap: () => _delete(_userlistd[index].id,index),
                      ),
                      ),

                    );

                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _update(int id, int index, String text) async {

    TextEditingController _updatetext = TextEditingController();
    _updatetext.text=text;

     //int upid =await updateUser(id);
    var alert = AlertDialog(
      title: Text("Update User"),
      content: TextField(
        controller: _updatetext,
        decoration: InputDecoration(
          labelText: "update",
          border:OutlineInputBorder(),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("update"),
          onPressed:() {
          _updatedata(_updatetext.text,id);
          _updatedelete(id , index);
          Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed:() {
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(context: context ,builder:(context) => alert);
    //showDialog(context: context ,child: alert);



  }

  void _updatedata(String updatetext, int id) async{
    Databasehelper dbhelper = Databasehelper();
    UserData updateds = UserData.fromMap(
      {
        "title" : updatetext,
        "id"    : id,
      }
    );
    int upid =await dbhelper.updateUser(updateds);

    print("user updted: $upid");
    setState(() {
     // _userlistd.add(UserData.map(upid));

      _showdata();



    });

  }

  void _updatedelete(int id, int index) {

    setState(() {

      _userlistd.removeWhere((test){

        _userlistd[index].id ==id;

      });

    });

  }

}
