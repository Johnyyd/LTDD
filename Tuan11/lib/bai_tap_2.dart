import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class BaiTap2 extends StatefulWidget {
  const BaiTap2({super.key});

  @override
  State<BaiTap2> createState() => _BaiTap2State();
}

class _BaiTap2State extends State<BaiTap2> {
  UploadTask? uploadTask;
  String? fileName;

  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      fileName = result.files.single.name;
      
      final ref = FirebaseStorage.instance.ref().child('uploads/$fileName');
      
      setState(() {
        uploadTask = ref.putFile(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Manager')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (uploadTask != null)
              StreamBuilder<TaskSnapshot>(
                stream: uploadTask!.snapshotEvents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    double progress = data.bytesTransferred / data.totalBytes;
                    
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text('Đang tải: $fileName'),
                          LinearProgressIndicator(value: progress),
                          Text('${(progress * 100).toStringAsFixed(1)} %'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(uploadTask!.snapshot.state == TaskState.paused ? Icons.play_arrow : Icons.pause),
                                onPressed: () {
                                  if (uploadTask!.snapshot.state == TaskState.paused) {
                                    uploadTask!.resume();
                                  } else {
                                    uploadTask!.pause();
                                  }
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.stop),
                                onPressed: () {
                                  uploadTask!.cancel();
                                  setState(() => uploadTask = null);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _pickAndUploadFile,
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text('Choose File'),
            ),
          ],
        ),
      ),
    );
  }
}