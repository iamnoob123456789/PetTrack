import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/pet_service.dart';
import '../../services/location_service.dart';
import '../../services/auth_service.dart';
import '../../models/pet.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  final _collarColorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();

  String _selectedType = 'dog';
  String _selectedStatus = 'lost';
  DateTime _lastSeenDate = DateTime.now();
  List<String> _photoUrls = [];
  List<File> _imageFiles = [];
  double? _latitude;
  double? _longitude;
  String _address = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _collarColorController.dispose();
    _descriptionController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationService = Provider.of<LocationService>(context, listen: false);
      await locationService.getCurrentLocation();
      
      if (locationService.currentPosition != null) {
        setState(() {
          _latitude = locationService.currentPosition!.latitude;
          _longitude = locationService.currentPosition!.longitude;
          _address = locationService.currentAddress;
        });
      }
    } catch (e) {
      debugPrint('Location error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location error: ${e.toString()}')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      
      if (image != null) {
        setState(() {
          _imageFiles.add(File(image.path));
          _photoUrls.add(image.path);
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> downloadUrls = [];
    try {
      final storage = FirebaseStorage.instance;
      
      for (File imageFile in _imageFiles) {
        String fileName = 'pet_images/${DateTime.now().millisecondsSinceEpoch}_${_nameController.text}';
        Reference ref = storage.ref().child(fileName);
        await ref.putFile(imageFile);
        String url = await ref.getDownloadURL();
        downloadUrls.add(url);
        debugPrint('Uploaded image: $url');
      }
    } catch (e) {
      debugPrint('Image upload error: $e');
      rethrow;
    }
    return downloadUrls;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastSeenDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _lastSeenDate) {
      setState(() {
        _lastSeenDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('Form validation failed');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final List<String> imageUrls = await _uploadImages();
      debugPrint('Successfully uploaded ${imageUrls.length} images');

      final pet = Pet(
        id: '',
        name: _nameController.text.trim(),
        type: _selectedType,
        breed: _breedController.text.trim(),
        color: _colorController.text.trim(),
        collarColor: _collarColorController.text.trim(),
        description: _descriptionController.text.trim(),
        photoUrls: imageUrls,
        ownerName: _ownerNameController.text.trim(),
        ownerPhone: _ownerPhoneController.text.trim(),
        ownerEmail: _ownerEmailController.text.trim(),
        lastSeenDate: _lastSeenDate,
        latitude: _latitude ?? 0.0,
        longitude: _longitude ?? 0.0,
        address: _address,
        status: _selectedStatus,
        createdAt: DateTime.now(),
      );

      await Provider.of<PetService>(context, listen: false).addPet(pet);
      debugPrint('Pet saved successfully!');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pet ${_selectedStatus} successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        _formKey.currentState!.reset();
        setState(() {
          _photoUrls.clear();
          _imageFiles.clear();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Submission error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionCard(
                title: 'Pet Status',
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Lost Pet'),
                        value: 'lost',
                        groupValue: _selectedStatus,
                        onChanged: (value) => setState(() => _selectedStatus = value!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Found Pet'),
                        value: 'found',
                        groupValue: _selectedStatus,
                        onChanged: (value) => setState(() => _selectedStatus = value!),
                      ),
                    ),
                  ],
                ),
              ),

              _buildSectionCard(
                title: 'Pet Type',
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Dog'),
                        value: 'dog',
                        groupValue: _selectedType,
                        onChanged: (value) => setState(() => _selectedType = value!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Cat'),
                        value: 'cat',
                        groupValue: _selectedType,
                        onChanged: (value) => setState(() => _selectedType = value!),
                      ),
                    ),
                  ],
                ),
              ),

              _buildSectionCard(
                title: 'Pet Details',
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Pet Name',
                      hintText: 'Enter pet name',
                      prefixIcon: Icons.pets,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _breedController,
                      labelText: 'Breed',
                      hintText: 'Enter breed',
                      prefixIcon: Icons.category,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _colorController,
                            labelText: 'Color',
                            hintText: 'Enter color',
                            prefixIcon: Icons.color_lens,
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _collarColorController,
                            labelText: 'Collar Color',
                            hintText: 'Enter collar color',
                            prefixIcon: Icons.color_lens_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _descriptionController,
                      labelText: 'Description',
                      hintText: 'Enter description',
                      prefixIcon: Icons.description,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),

              _buildSectionCard(
                title: 'Photos',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Gallery'),
                          ),
                        ),
                      ],
                    ),
                    if (_photoUrls.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _photoUrls.length,
                          itemBuilder: (context, index) => _buildImagePreview(index),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Owner Details
              _buildSectionCard(
                title: 'Owner Details',
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _ownerNameController,
                      labelText: 'Owner Name',
                      hintText: 'Enter owner name',
                      prefixIcon: Icons.person,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _ownerPhoneController,
                            labelText: 'Phone',
                            hintText: 'Enter phone number',
                            prefixIcon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _ownerEmailController,
                            labelText: 'Email',
                            hintText: 'Enter email address',
                            prefixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) return 'Required';
                              if (!value.contains('@')) return 'Invalid email';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              _buildSectionCard(
                title: 'Location & Date',
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(_address.isNotEmpty ? _address : 'Getting location...'),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _getCurrentLocation,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(DateFormat('MMM dd, yyyy').format(_lastSeenDate)),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _selectDate,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              CustomButton(
                text: 'Add Pet',
                onPressed: _isLoading ? null : _submitForm,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                child,
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImagePreview(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(File(_photoUrls[index])),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => setState(() {
                _photoUrls.removeAt(index);
                _imageFiles.removeAt(index);
              }),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}