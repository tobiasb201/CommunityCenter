import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Box _usernameBox;
  String? _username;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameBox = Hive.box("username");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("CommunityCenter",style: TextStyle(color: Colors.white70))),
        elevation: 1.0,
      ),
      body: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 20,bottom: 20),child: Text("Create Accountname:",style: TextStyle(fontSize: 25))),
          Form(
            key:_formKey,
            child: Padding(
              padding: const EdgeInsets.only(left:20,right: 20),
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          _usernameBox.put('username',_username);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Username created",style: TextStyle(color: Colors.amber[600]),), behavior: SnackBarBehavior.floating,)
                          );
                        }
                      },
                    )
                ),
                validator: (String? value) {
                  if(value!.trim().isEmpty){
                    return "Username is Empty";
                  }
                  if(value.length>15){
                    return "Username is too long";
                  }
                  if(value.contains('@')){
                    return "@ is not allowed";
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _username = value!;
                },
                maxLength: 15,
              ),
            ),
          ),
        ]
      ),
      backgroundColor: Colors.amber[600],
    );
  }
}
