import 'package:flutter/material.dart';
import 'package:flutterapp/models/messageModel.dart';
import 'package:hive/hive.dart';

import '../service/messageService.dart';

class MessagePage extends StatefulWidget {
   final MessageModel messageData;
   // ignore: use_key_in_widget_constructors
   const MessagePage(this.messageData);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  String? _newComment;
  final _formKey = GlobalKey<FormState>();
  final MessageService _messageService = MessageService();

  late Box _userBox;

  @override
  // ignore: must_call_super
  initState(){
    _userBox = Hive.box("username");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("CommunityCenter",style: TextStyle(color: Colors.white70)),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Container(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Row(
                        children: <Widget>[
                          Text(widget.messageData.username),
                          Text(" ("+widget.messageData.topic+")",style: const TextStyle(fontSize: 11,color: Colors.blue),)
                        ],
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Text( widget.messageData.mainMessage,
                        style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
        ),
        Expanded(child: ListView.builder(
            itemCount: widget.messageData.subMessages?.length,
            itemBuilder: (context, index){
              final subMessage = widget.messageData.subMessages?[index];
              return _commentWidget(subMessage);
            })
        ),
        Form(
          key: _formKey,
          child: TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Comment:',
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save(); //Saves state of textfields
                        SubMessage newSubMessage = SubMessage(subMessage: _newComment!, parent: widget.messageData.id, username: _userBox.get('username'));
                        _messageService.sendSubMessage(newSubMessage);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("New Comment created",style: TextStyle(color: Colors.amber[600]),), behavior: SnackBarBehavior.floating,)
                        );
                      }
                      setState((){
                        widget.messageData.subMessages!.add(SubMessage(username: _userBox.get('username'),parent: widget.messageData.id, subMessage: _newComment!));
                      });
                    },
                  )
                ),
                validator: (String? value) {
                  (value != null) ? 'No Comment typed' : null;
                  _userBox.get('username')!=null ? 'Create a Username first.' : null;
                  return null;
                },
                onSaved: (String? value) {
                  _newComment= value!;
                },
                maxLength: 120,
              ),
        ),
      ],),
      backgroundColor: Colors.amber[600],
    );
  }


  Card _commentWidget(SubMessage? subMessage){
    return Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(subMessage!.username),
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text(subMessage.subMessage,
              style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

