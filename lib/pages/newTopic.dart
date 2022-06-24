import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class newTopic extends StatefulWidget {
  @override
  State<newTopic> createState() => _newTopicState();
}

class _newTopicState extends State<newTopic> {

  late Box _topicBox;
  final myController = TextEditingController();

  @override
  initState(){
    _topicBox = Hive.box("topics");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("CommunityCenter",style: TextStyle(color: Colors.white70)),
        elevation: 1.0,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Text("New Channel Topic",style: TextStyle(fontSize: 20)),
          Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 10),
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: "Enter a new Topic",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: (){
                        var topicLength= _topicBox.length;
                        _topicBox.put(topicLength,myController.text);
                      },
                    )
                ),
                maxLength: 12,
              ),
          )
        ],
      ),
      backgroundColor:Colors.amber[600],
    );
  }
}
