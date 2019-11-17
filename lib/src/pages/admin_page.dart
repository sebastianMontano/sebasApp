import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:tp_food/src/model/usuario_model.dart';

class AdminPage extends StatefulWidget {

  AdminPage({Key key, this.title, this.uid}) : super(key: key); 
  //update the constructor to include the uid
  final String title;
  final String uid; //include this


  @override
  _AdminPageState  createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            child: Text("Salir"),
            textColor: Colors.white,
            onPressed: () {
              FirebaseAuth.instance
                  .signOut().then((result) =>
                      Navigator.pushReplacementNamed(context, "login"))
                  .catchError((err) => print(err));
            },
          ),         
        ],
      ),
      body: Container(
            child: UserList(),
          ),     
    );
  }

}

class UserList extends StatefulWidget {

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseReference.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return ListView.builder(
                itemCount: snapshot.data.documents.length-1,
                itemBuilder: (_,int index){
                  snapshot.data.documents.removeWhere((item) => item['rol'] == 'admin');
                  return _buildList(context, snapshot.data.documents[index]);
                }
            );
        }  
      }
      /*builder: (BuildContext context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
        if(!snapshot.hasData){
              return Text("No hay");
        }
        int lengthOfDocs=0;
        int querySnapShotCounter = 0;
        snapshot.data.forEach((snap){lengthOfDocs = lengthOfDocs + snap.documents.length;});
        int counter = 0;
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            /*return new ListView(
              children: querySnapshotData[0].documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['nombres']),
                  subtitle: new Text(document['dni'].toString()),
                );
              }).toList(),
            );*/
            return ListView.builder(
              itemCount: lengthOfDocs,
              itemBuilder: (_,int index){
                try{DocumentSnapshot doc = snapshot.data[querySnapShotCounter].documents[counter];
                counter = counter + 1 ;
                  return  Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: (){ 
                            print(doc['nombres']);
                          },
                          title: new Text(doc['nombres']),
                          subtitle: new Text(doc['dni'].toString()), 
                          trailing: SwitchUser(user: UsuarioModel.fromJson(doc.data))    
                        ),
                      ],
                    ),
                  );
                  
                }
                catch(RangeError){
                  querySnapShotCounter = querySnapShotCounter+1;
                  counter = 0;
                  DocumentSnapshot doc = snapshot.data[querySnapShotCounter].documents[counter];
                  counter = counter + 1 ;
                    //return new Container(child: Text(doc.data["name"]));
                    /*return new ListTile(
                      onTap: (){ 
                        print(doc['nombres']);
                      },
                      title: new Text(doc['nombres']),
                      subtitle: new Text(doc['dni'].toString()),                      
                    );*/
                    return  Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: (){ 
                            print(doc['nombres']);
                          },
                          title: new Text(doc['nombres']),
                          subtitle: new Text(doc['dni'].toString()), 
                          trailing: SwitchUser(user: UsuarioModel.fromJson(doc.data))    
                        ),
                      ],
                    ),
                  );
                }
              },
            );
        }
      },*/
    );
  }

   Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return  Card(
      child: Column(
        children: <Widget> [
            ListTile(
              onTap: (){ 
                print(document['nombres']);
              },
              title: new Text(document['nombres']),
              subtitle: new Text(document['dni'].toString()), 
              trailing: SwitchUser(user: UsuarioModel.fromJson(document.data))    
            )
        ]
      ),
    );
  }

  Stream<List<QuerySnapshot>> getData(){
    Stream<QuerySnapshot> streamOne =  getCustomer();
    Stream<QuerySnapshot> streamTwo =  getProvider();
    return StreamZip([streamOne, streamTwo]);
  }

  Stream<QuerySnapshot> getCustomer() {
    return  databaseReference.collection('users')
      .where("rol", isEqualTo: "customer").snapshots();
  }

  Stream<QuerySnapshot> getProvider() {
    return  databaseReference.collection('users')
      .where("rol", isEqualTo: "provider").snapshots();
  }
}

class SwitchUser extends StatefulWidget {
    SwitchUser({Key key, @required this.user}) : super(key: key);

    UsuarioModel user;
    @override
    _SwitchUserState createState() => _SwitchUserState();
    
}


class _SwitchUserState extends State<SwitchUser> {

  final databaseReference = Firestore.instance;
  bool _state = false;

  @override
  void initState() { 
    super.initState();
    if(widget.user.estado != null){
      (widget.user.estado) ? _state = true : _state =false;
    }
  }

  Widget build(BuildContext context) {
    return Switch(     
      value:  _state ,
      onChanged: (value){       
        if(value){
          widget.user.rol = "provider";
          widget.user.estado = true;
        }else{
          widget.user.rol = "customer";
          widget.user.estado = false;
        }
        setState(() {
          _state = value;
          databaseReference.collection('users').document(widget.user.uid).updateData(widget.user.toJson());
        });
      },     
    ); 
  }
}