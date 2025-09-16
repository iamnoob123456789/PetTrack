// lib/screens/add_pet_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';  // ✅ Add this
import 'package:pet_track/config.dart';
import 'package:pet_track/models/pet.dart';
import 'package:pet_track/services/pet_service.dart';
import 'package:flutter/material.dart';


class AddPetScreen extends StatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _breedController = TextEditingController();
  final _descController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _lastSeenDate;
List<XFile> _images = [];

  bool _isSubmitting = false;

 Future<void> _pickImages() async {
  final picker = ImagePicker();
  final picked = await picker.pickMultiImage();
  if (picked.isNotEmpty) {
    setState(() {
      _images = picked;
    });
  }
}

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one photo")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await PetService().addPet(
      name: _nameController.text.trim(),
      type: _typeController.text.trim(), // lost / found
      breed: _breedController.text.trim().isEmpty ? null : _breedController.text.trim(),
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      ownerPhone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      lastSeenDate: _lastSeenDate,
       images: _images,
 // <-- FIX
    );

    setState(() => _isSubmitting = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pet added successfully")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${result['message']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Pet")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Pet Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: "Type (lost / found)"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: "Breed (optional)"),
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description (optional)"),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Owner Phone (optional)"),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address (optional)"),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(_lastSeenDate == null
                        ? "No date selected"
                        : "Last seen: ${_lastSeenDate!.toLocal()}".split(' ')[0]),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _lastSeenDate = picked);
                      }
                    },
                    child: const Text("Select Date"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
          Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    ..._images.map((img) {
      if (kIsWeb) {
        return Image.network(
          img.path,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => 
              const Icon(Icons.broken_image, size: 100, color: Colors.red),
        );
      } else {
        return Image.file(
          File(img.path),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 100, color: Colors.red),
        );
      }
    }),
    IconButton(
      icon: const Icon(Icons.add_a_photo),
      onPressed: _pickImages,
    ),
  ],
),


              const SizedBox(height: 20),
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Submit"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
