import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mid_term/models/product.dart';
import 'package:mid_term/utils/encode.dart';

class EditScreen extends StatefulWidget {
  final Product? updatingProduct;

  const EditScreen({super.key, this.updatingProduct});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      setState(() {
        // logError(_image!.path);
        _image = selectedImage;
      });
    }
  }

  void _submitProduct() {
    final String name = _nameController.text;
    final String type = _typeController.text;
    final String price = _priceController.text;
    if (name.isEmpty || type.isEmpty || price.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder:
            (context) => CupertinoAlertDialog(
              title: Text('Error'),
              content: Text('Please fill all fields and select an image.'),
              actions: [
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
      return;
    }
    saveImageToLocalStorage(_image).then((uri) {
      Product product = Product(
        documentId: "",
        idsp: generateUniqueId(name),
        ten: name,
        loaisp: type,
        gia: int.parse(price),
        hinhanh: uri,
      );

      Map<String, dynamic> mappedProduct = product.toFirestore();

      if (widget.updatingProduct == null) {
        addProduct(mappedProduct);
      } else {
        updateProduct(widget.updatingProduct!.documentId, mappedProduct);
      }
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.updatingProduct != null) {
      _nameController.text = widget.updatingProduct!.ten;
      _typeController.text = widget.updatingProduct!.loaisp;
      _priceController.text = widget.updatingProduct!.gia.toString();

      File imageFile = File(widget.updatingProduct!.hinhanh);
      imageFile.exists().then((exists) {
        if (exists) {
          _image = XFile(widget.updatingProduct!.hinhanh);
        }
      });
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.updatingProduct == null ? 'Add' : 'Update'),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoButton.filled(
                              onPressed: _pickImage,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.photo),
                                  SizedBox(width: 8),
                                  Text('Pick Image'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      _image != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(_image!.path),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                          : Text('No image selected'),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product Name'),
                          CupertinoTextField(controller: _nameController),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product Type'),
                          CupertinoTextField(controller: _typeController),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Price',
                            style: TextStyle(fontSize: 18), // Make text bigger
                          ),
                          CupertinoTextField(
                            style: TextStyle(fontSize: 24),
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      SizedBox(height: 64),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoButton.filled(
                        onPressed: _submitProduct,
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addProduct(mappedProduct) {
    FirebaseFirestore.instance.collection('sanpham').add(mappedProduct);
  }

  void updateProduct(String documentId, Map<String, dynamic> updatedProduct) {
    FirebaseFirestore.instance
        .collection('sanpham')
        .doc(documentId)
        .update(updatedProduct);
  }

  Future<String> saveImageToLocalStorage(XFile? image) async {
    if (image == null) {
      return "";
    }
    try {
      final directory = await Directory.systemTemp.createTemp();
      final String newPath = '${directory.path}/${image.name}';
      final File newImage = await File(image.path).copy(newPath);
      return newImage.path;
    } catch (e) {
      return "";
    }
  }
}
