import 'package:flutter/material.dart';
import 'package:flutter_file_manager_macos/flutter_file_manager_macos.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FileManagerPlatform.instance = FlutterFileManagerMacos();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveFile,
        tooltip: 'Download',
        child: const Icon(Icons.download),
      ),
    );
  }

  Future<void> _saveFile() async {
    final path = await FileManagerPlatform.instance.writeFileAsString(
      fileName: 'test.txt',
      data: "toto42sh",
    );
    debugPrint('path: $path');
  }
}
