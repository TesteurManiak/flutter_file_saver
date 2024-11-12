import 'package:flutter/material.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _fileSaverPlugin = FlutterFileSaver();
  final _formKey = GlobalKey<FormState>();

  String? _fileName;
  String? _fileContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  initialValue: 'test',
                  decoration: const InputDecoration(labelText: 'File name'),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'File name is required',
                  onSaved: (val) => _fileName = val,
                ),
                TextFormField(
                  initialValue: 'test',
                  decoration: const InputDecoration(labelText: 'File content'),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'File content is required',
                  onSaved: (val) => _fileContent = val,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downloadFile,
        tooltip: 'Download',
        child: const Icon(Icons.download),
      ),
    );
  }

  Future<void> _downloadFile() async {
    final formState = _formKey.currentState!;
    if (formState.validate()) {
      formState.save();

      try {
        final path = await _fileSaverPlugin.writeFileAsString(
          fileName: '$_fileName.txt',
          data: _fileContent!,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File saved to $path')),
        );
      } on FileSaverCancelledException {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Save cancelled')),
        );
      }
    }
  }
}
