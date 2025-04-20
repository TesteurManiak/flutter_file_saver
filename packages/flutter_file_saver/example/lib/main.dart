import 'dart:async';
import 'dart:typed_data';

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
  bool _twoPhaseSaveEnabled = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
            value: _twoPhaseSaveEnabled,
            onChanged: (v) => setState(() => _twoPhaseSaveEnabled = v),
          ),
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  initialValue: 'test.txt',
                  enabled: !_isLoading,
                  decoration: const InputDecoration(labelText: 'File name'),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'File name is required',
                  onSaved: (val) => _fileName = val,
                ),
                TextFormField(
                  initialValue: 'test',
                  enabled: !_isLoading,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _downloadFile,
        label: const Text('Download'),
        icon: _isLoading
            ? const CircularProgressIndicator()
            : const Icon(Icons.download),
      ),
    );
  }

  Future<void> _downloadFile() async {
    final formState = _formKey.currentState!;
    if (formState.validate()) {
      formState.save();

      setState(() => _isLoading = true);

      try {
        String? path;
        if (_twoPhaseSaveEnabled) {
          await Future.delayed(const Duration(seconds: 10));
          if (!mounted) return;

          await showDialog(
            context: context,
            builder: (_) => DownloadDialog(
              fileName: _fileName!,
              bytes: Uint8List.fromList(_fileContent!.codeUnits),
            ),
          );
        } else {
          path = await _fileSaverPlugin.writeFileAsString(
            fileName: _fileName!,
            data: _fileContent!,
          );
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'File saved${path != null && path.isNotEmpty ? ' to $path' : ''}',
            ),
          ),
        );
      } on FileSaverCancelledException {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Save cancelled')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}

class DownloadDialog extends StatelessWidget {
  const DownloadDialog({
    required this.fileName,
    required this.bytes,
    super.key,
  });

  final String fileName;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('File ready'),
      content: const Text('Your file is ready to be downloaded.'),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              await FlutterFileSaver().writeFileAsBytes(
                fileName: 'test.txt',
                bytes: bytes,
              );
            } catch (e) {
              rethrow;
            } finally {
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text('Download'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
