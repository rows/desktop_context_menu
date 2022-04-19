import 'package:context_menu_api/context_menu_api.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Context Menu Plugin Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: ContextMenuApi.instance.platformVersion,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                '${snapshot.data}',
                style: Theme.of(context).textTheme.headline4,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
