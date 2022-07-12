import 'package:flutter/material.dart';
import 'package:flutterapp/service/messageService.dart';
import 'package:hive/hive.dart';

import '../models/messageModel.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  late String _newMessage;
  final _topicOptions = ["Main","Hobby","Work","Student"];
  String _selectedTopicOption = "Main";
  late Box _userBox;
  late Box _newTopics;

  final MessageService _messageService = MessageService();
  final _formKey = GlobalKey<FormState>();

  @override
  // ignore: must_call_super
  initState(){
    _userBox = Hive.box("username");
    _newTopics = Hive.box("topics");

    for(int x = 0;x<_newTopics.length;x++){
      _topicOptions.add(_newTopics.getAt(x));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("CommunityCenter",style: TextStyle(color: Colors.white70))),
        elevation: 1.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child:Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container( //Container for Headline
                      width: MediaQuery.of(context).size.width/1.6, //Fixed width depending on device
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.zero,
                      ),
                      child: const Center(
                          child: FittedBox(child: Text("New Message",style: TextStyle(fontSize: 30,color: Colors.blue)))
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 10,bottom: 20),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.blue,
                        value: _selectedTopicOption,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTopicOption = newValue!;
                          });
                        },
                        items: _topicOptions.map((item) {
                          return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(color: Colors.black),
                              ));
                        }).toList(),
                      ),
                    ),
                  _messageField(),
                    TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) { //Validates if textfields are filled
                            _formKey.currentState!.save(); //Saves state of textfields
                              final MessageModel newMessage = MessageModel(mainMessage: _newMessage,username: _userBox.get('username'),topic: _selectedTopicOption);
                              _messageService.sendMessage(newMessage);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("New Message created",style: TextStyle(color: Colors.blue),), behavior: SnackBarBehavior.floating,)
                            );
                          }
                        },
                        child: const Text(
                          "Create Message",
                          style: TextStyle(color: Colors.black),
                        )),
                ],)
              ),
            )
          ),
      ),
        backgroundColor: Colors.amber[600]
    );
  }

  Widget _messageField(){
    return Flexible(
        child: TextFormField(
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Message:',
            hintStyle: const TextStyle(color: Colors.black),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: (String? value) {
            if(value!.trim().isEmpty){
              return "No Message";
            }
            if(value.length>120){
              return "Message is too long";
            }
            if(_userBox.get('username') == null){
              return "Create a Username first";
            }
            return null;
          },
          onSaved: (String? value) {
            _newMessage = value!;
          },
          maxLength: 150, //Max Price length
        ));
  }

}
