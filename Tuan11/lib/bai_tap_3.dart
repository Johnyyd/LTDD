import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class BaiTap3 extends StatefulWidget {
  const BaiTap3({super.key});

  @override
  State<BaiTap3> createState() => _BaiTap3State();
}

class _BaiTap3State extends State<BaiTap3> {
  final CollectionReference productsRef = FirebaseFirestore.instance.collection('products');

  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    File? imageFile;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Thêm Sản Phẩm'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
                TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Giá (\$)',), keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                imageFile == null
                    ? TextButton(
                        onPressed: () async {
                          final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) setStateDialog(() => imageFile = File(pickedFile.path));
                        },
                        child: const Text('Chọn hình ảnh'),
                      )
                    : Image.file(imageFile!, height: 100),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty || imageFile == null) return;
                  
                  // 1. Upload ảnh lên Storage
                  final storageRef = FirebaseStorage.instance.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
                  await storageRef.putFile(imageFile!);
                  final imageUrl = await storageRef.getDownloadURL();

                  // 2. Lưu vào Firestore
                  await productsRef.add({
                    'name': nameCtrl.text,
                    'price': double.parse(priceCtrl.text),
                    'imageUrl': imageUrl,
                  });
                  Navigator.pop(context);
                },
                child: const Text('Lưu'),
              )
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(data['imageUrl'] ?? '', width: 50, height: 50, fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(Icons.image),
                ),
                title: Text(data['name'] ?? ''),
                subtitle: Text('\$${data['price']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => productsRef.doc(docs[index].id).delete(), // Xóa sản phẩm
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}