import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
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
  final fileSaverPlugin = FlutterFileSaver();
  final formKey = GlobalKey<FormState>();

  String? fileName;
  String? fileContent;
  bool twoPhaseSaveEnabled = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  initialValue: 'test.txt',
                  enabled: !isLoading,
                  decoration: const InputDecoration(labelText: 'File name'),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'File name is required',
                  onSaved: (val) => fileName = val,
                ),
                TextFormField(
                  initialValue: 'test',
                  enabled: !isLoading,
                  decoration: const InputDecoration(labelText: 'File content'),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'File content is required',
                  onSaved: (val) => fileContent = val,
                ),
                SwitchListTile(
                  value: twoPhaseSaveEnabled,
                  title: const Text('Two phase save'),
                  onChanged: !isLoading
                      ? (v) => setState(() => twoPhaseSaveEnabled = v)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isLoading ? null : _downloadFile,
        label: Text(
          isLoading && twoPhaseSaveEnabled ? 'Preparing file' : 'Download',
        ),
        icon: isLoading
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.download),
      ),
    );
  }

  Future<void> _downloadFile() async {
    final formState = formKey.currentState!;
    if (formState.validate()) {
      formState.save();

      setState(() => isLoading = true);

      try {
        String? path;
        if (twoPhaseSaveEnabled) {
          await Future.delayed(const Duration(seconds: 10));
          if (!mounted) return;

          final error = await showDialog<Object?>(
            context: context,
            builder: (_) => DownloadDialog(
              fileName: fileName!,
              bytes: Uint8List.fromList(fileContent!.codeUnits),
            ),
          );
          if (error != null) throw error;
        } else {
          path = await fileSaverPlugin.writeFileAsString(
            fileName: fileName!,
            data: fileContent!,
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
        if (mounted) setState(() => isLoading = false);
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
            Object? error;
            try {
              await FlutterFileSaver().writeFileAsBytes(
                fileName: fileName,
                bytes: bytes,
              );
            } catch (e) {
              error = e;
            } finally {
              if (context.mounted) Navigator.pop(context, error);
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
