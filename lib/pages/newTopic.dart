import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NewTopic extends StatefulWidget {
  const NewTopic({Key? key}) : super(key: key);
  @override
  State<NewTopic> createState() => _NewTopicState();
}

class _NewTopicState extends State<NewTopic> {

  late Box _topicBox;
  final myController = TextEditingController();

  @override
  // ignore: must_call_super
  initState(){
    _topicBox = Hive.box("topics");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("CommunityCenter",style: TextStyle(color: Colors.white70)),
        elevation: 1.0,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10,),
          const Text("New Channel Topic",style: TextStyle(fontSize: 20)),
          Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: "Enter a new Topic",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
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
