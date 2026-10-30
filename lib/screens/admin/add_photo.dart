import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/lace_model.dart';
import '../../services/firebase_service.dart';

class AddPhotoScreen extends StatefulWidget {
  final LaceModel? laceToEdit; // જો એડિટ કરવું હોય તો આમાં ડેટા આવશે

  const AddPhotoScreen({super.key, this.laceToEdit});

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final _n = TextEditingController();
  final _m = TextEditingController();
  final _p = TextEditingController();
  final _d = TextEditingController();
  final _pr = TextEditingController();
  
  String? _path;       
  Uint8List? _webImage; 
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // જો એડિટ મોડમાં હોય તો જૂની માહિતી ભરી દો
    if (widget.laceToEdit != null) {
      _n.text = widget.laceToEdit!.name;
      _m.text = widget.laceToEdit!.material;
      _p.text = widget.laceToEdit!.price.toString();
      _d.text = widget.laceToEdit!.designNumber;
      _pr.text = widget.laceToEdit!.pricePerRoll.toString();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final x = await ImagePicker().pickImage(source: source, imageQuality: 30);
    if (x != null) {
      if (kIsWeb) {
        final bytes = await x.readAsBytes();
        setState(() => _webImage = bytes);
      } else {
        setState(() => _path = x.path);
      }
    }
  }

  Future<void> _save() async {
    if (_path == null && _webImage == null && widget.laceToEdit == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('કૃપા કરીને પહેલા ફોટો પસંદ કરો')));
      return;
    }
    
    setState(() => _isLoading = true);

    try {
      String base64Image = widget.laceToEdit?.imagePath ?? ''; // જૂની ઈમેજ રાખો

      // જો નવી ઈમેજ પસંદ કરી હોય તો તેને Base64 માં કન્વર્ટ કરો
      if (_webImage != null) {
        base64Image = base64Encode(_webImage!);
      } else if (_path != null) {
        final bytes = await File(_path!).readAsBytes();
        base64Image = base64Encode(bytes);
      }

      LaceModel lace = LaceModel(
        id: widget.laceToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _n.text.isEmpty ? 'Lace' : _n.text,
        material: _m.text,
        price: double.tryParse(_p.text) ?? 0.0,
        designNumber: _d.text,
        pricePerRoll: double.tryParse(_pr.text) ?? 0.0,
        imagePath: base64Image,
      );
      
      if (widget.laceToEdit != null) {
        await FirebaseService.updateLace(lace); // અપડેટ કરો
      } else {
        await FirebaseService.addLace(lace);    // નવું ઉમેરો
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.laceToEdit == null ? 'Add New Photo' : 'Edit Photo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade600, width: 1.5),
                ),
                child: _buildImagePreview(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(onPressed: () => _pickImage(ImageSource.gallery), icon: const Icon(Icons.photo), label: const Text('Gallery'))),
                const SizedBox(width: 16),
                Expanded(child: OutlinedButton.icon(onPressed: () => _pickImage(ImageSource.camera), icon: const Icon(Icons.camera_alt), label: const Text('Camera'))),
              ],
            ),
            const SizedBox(height: 30),
            TextField(controller: _n, decoration: const InputDecoration(labelText: 'Lace Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _m, decoration: const InputDecoration(labelText: 'Lace Material', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _d, decoration: const InputDecoration(labelText: 'Design Number', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _p, decoration: const InputDecoration(labelText: 'Price (₹)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _pr, decoration: const InputDecoration(labelText: 'Price per Roll (₹)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save, 
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(widget.laceToEdit == null ? 'Save Photo' : 'Update Photo', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _webImage != null) {
      return ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.memory(_webImage!, fit: BoxFit.cover));
    } else if (!kIsWeb && _path != null) {
      return ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(File(_path!), fit: BoxFit.cover));
    } else if (widget.laceToEdit != null) {
      // જો એડિટ કરતા હોય તો જૂની ઈમેજ દેખાડો
      return ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.memory(base64Decode(widget.laceToEdit!.imagePath), fit: BoxFit.cover));
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 80, color: Colors.grey.shade500),
          const SizedBox(height: 10),
          Text('ફોટો પસંદ કરવા માટે અહીં ટચ કરો', style: TextStyle(color: Colors.grey.shade500)),
        ],
      );
    }
  }
}