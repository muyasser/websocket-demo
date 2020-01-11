import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: WebSocketDemo(),
      ),
    );
  }
}

class WebSocketDemo extends StatefulWidget {
  @override
  _WebSocketDemoState createState() => _WebSocketDemoState();
}

class _WebSocketDemoState extends State<WebSocketDemo> {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect('wss://echo.websocket.org');

  _WebSocketDemoState() {
    channel.stream.listen((data) {
      setState(() {
        messages.add(data);
      });
    });
  }

  final inputController = TextEditingController();

  List<String> messages = [];

  @override
  void dispose() {
    // TODO: implement dispose
    inputController.dispose();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Send Message',
                    ),
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: RaisedButton(
                    child: Text(
                      'SEND',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (inputController.text.isNotEmpty) {
                        print(inputController.text);

                        channel.sink.add(inputController.text);

                        inputController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: getMessageList(),
          )
        ],
      ),
    );
  }

  ListView getMessageList() {
    List<Widget> listWidget = [];

    for (String message in messages) {
      listWidget.add(
        ListTile(
          title: Container(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                message,
                style: TextStyle(fontSize: 22),
              ),
            ),
            color: Colors.teal[50],
            height: 60,
          ),
        ),
      );
    }
    return ListView(
      children: listWidget,
    );
  }
}
