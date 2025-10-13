// lib/screens/add_pet_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
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
  final _breedController = TextEditingController();
  final _descController = TextEditingController();
  final _phoneController = TextEditingController(); // owner or reporter depending on type
  final _addressController = TextEditingController();
  DateTime? _lastSeenDate;
  List<XFile> _images = [];

  bool _isSubmitting = false;
  String _petType = 'lost'; // 'lost' or 'found'

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images = picked;
      });
    }
  }

  void _setType(String type) {
    setState(() {
      _petType = type;
      _phoneController.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // require at least one image
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one photo")),
      );
      return;
    }

    // additional required checks for lost
    if (_petType == 'lost' && _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add an owner contact phone for lost pets")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final payload = {
      'name': _nameController.text.trim(),
      'type': _petType, // lost or found
      'breed': _breedController.text.trim().isEmpty ? null : _breedController.text.trim(),
      'description': _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      // phone used as ownerPhone for lost, reporterPhone for found
      _petType == 'lost' ? 'ownerPhone' : 'reporterPhone': _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      'address': _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      'lastSeenDate': _lastSeenDate?.toIso8601String(),
      // images will be handled inside PetService.addPet (XFile list)
    };

    // call PetService which previously used addPet; keep same method
    final result = await PetService().addPet(
      // validator guarantees name is non-null/filled, cast to String to satisfy signature
      name: payload['name'] as String,
      type: _petType,
      breed: payload['breed'] as String?,
      description: payload['description'] as String?,
      ownerPhone: _petType == 'lost' ? payload['ownerPhone'] as String? : null,
      reporterPhone: _petType == 'found' ? payload['reporterPhone'] as String? : null,
      address: payload['address'] as String?,
      lastSeenDate: _lastSeenDate,
      images: _images,
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
    final isLost = _petType == 'lost';
    return Scaffold(
      appBar: AppBar(title: const Text("Add Pet")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Pet type toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Lost'),
                    selected: isLost,
                    onSelected: (_) => _setType('lost'),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Found'),
                    selected: !isLost,
                    onSelected: (_) => _setType('found'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Pet Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),

              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: "Breed (optional)"),
              ),

              TextFormField(
                controller: _descController,
                // cannot use `const` with a runtime expression
                decoration: InputDecoration(labelText: isLost ? "Description (optional)" : "Description / notes"),
              ),

              // phone field meaning depends on pet type
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: isLost ? "Owner Phone (required for lost)" : "Your Phone (optional)",
                ),
                validator: (v) {
                  if (isLost && (v == null || v.trim().isEmpty)) return "Owner phone required for lost pets";
                  return null;
                },
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
                        ? (isLost ? "No last seen date selected" : "No found date selected")
                        : "Date: ${_lastSeenDate!.toLocal()}".split(' ')[0]),
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
                      child: Text(isLost ? "Submit Lost Pet" : "Submit Found Pet"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
