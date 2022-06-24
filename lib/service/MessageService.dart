import 'package:flutterapp/models/messagemodel.dart';
import 'package:http/http.dart' as http;

class MessageService{


  Future<List<MessageModel>> getMessages(String topic) async{
    List<MessageModel> messageModel;
    var response = await http.get(Uri.parse("http://192.168.178.56:8080/messageData?topic=$topic"));
    if(response.statusCode==200){
      messageModel = MessageModelFromJson(response.body);
      return messageModel;
    }else{
      throw Exception("Failed to Load Messages");
    }
  }

  Future<http.Response> sendMessage(MessageModel newMessage) async{
      return http.post(Uri.parse("http://192.168.178.56:8080/messageData/newMessage"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: MessageModelToJson(newMessage)
      );
  }

  Future<http.Response> sendSubMessage(SubMessage newSubMessage) async{
    return http.post(Uri.parse("http://192.168.178.56:8080/messageData/subMessage"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: SubMessageToJson(newSubMessage)
    );
  }

  Future<MessageModel> loadSingleMessage(int? id) async{
    var response = await http.get(Uri.parse("http://192.168.178.56:8080/messageData/$id"));
    MessageModel messageModel = SingleMessageModelFromJson(response.body);
    return messageModel;
  }

}