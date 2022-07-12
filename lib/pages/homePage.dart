import 'package:flutter/material.dart';
import 'package:flutterapp/pages/messagePage.dart';
import 'package:flutterapp/service/messageService.dart';
import 'package:hive/hive.dart';

import '../models/messageModel.dart';
import 'newTopic.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {

  Future<List<MessageModel>>? _messages;
  List<MessageModel>? _messageList;
  late Box _topicBox;


  @override
  // ignore: must_call_super
  void initState(){
    loadMessages("Main");
    _topicBox = Hive.box("topics");
  }

  Future loadMessages(String topic) async {
    _messages = MessageService().getMessages(topic);
    setState(() {
      _messages = this._messages;
    });
    return _messages;
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Center(child: Text("CommunityCenter",style: TextStyle(color: Colors.white70))),
        elevation: 1.0,
        ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.amber[600],
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: <Widget>[
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 2,
            padding: const EdgeInsets.only(top: 10),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4),
                child:ElevatedButton(
                    onPressed: (){
                      loadMessages("Main");
                    },
                    child: const Text("Main")
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                    onPressed: (){
                      loadMessages("Student");
                    },
                    child: const Text("Student")
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                    onPressed: (){
                      loadMessages("Work");
                    },
                    child: const Text("Work")
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                    onPressed: (){
                      loadMessages("Hobby");
                    },
                    child: const Text("Hobby")
                ),
              ),
            ],
          ),
          SizedBox(
                height: 45,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _topicBox.length,
                    itemBuilder: (context, index) {
                      final topicName = _topicBox.getAt(index);
                      return newTopicButton(topicName,index);
                    }),
              ),
          Expanded(child: RefreshIndicator(
            onRefresh: refresh,
            child: FutureBuilder(
              future: _messages,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.hasData){
                final data = snapshot.data;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final messageData = data[index];
                      return _messageUI(messageData, index);
                    });
            }
              else{
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: const [
                      Center(child: CircularProgressIndicator()),
                      Center(child:Text("Establishing Database Connection")),
                    ],
                  ),
                );
              }
          },
            ),
          ))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const NewTopic(),
          ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Padding newTopicButton(String topicName, int index){
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
          onPressed: (){
            loadMessages(topicName);
          },
          onLongPress: (){
            _topicBox.deleteAt(index);
            setState(() { });
          },
          child: Text(topicName),
      ),
    );
  }

  Future refresh() async { //For the pull down functionality
    Future.delayed(const Duration(seconds: 1));//1sec duration to prevent spam
    loadMessages("Main");
  }

  Card _messageUI(MessageModel messageData, int index){
    return Card(
      child: ListTile(
        title: Row(mainAxisSize: MainAxisSize.min,children: <Widget>[
          Text(messageData.username, style: const TextStyle(color: Colors.black,fontSize: 20),),
          Text("(${messageData.topic})",style: const TextStyle(fontSize: 13,color: Colors.lightBlue)),
        ]),
        subtitle: Text(messageData.mainMessage,style: const TextStyle(fontSize: 20),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(messageData.subMessages!.length.toString(),),
            const Icon(Icons.message_outlined)
          ],
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) =>MessagePage(messageData),
          ),
          );
        },
      ),
    );
  }

}
