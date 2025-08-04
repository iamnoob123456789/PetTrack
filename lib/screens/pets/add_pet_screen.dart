import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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
  double? _latitude;
  double? _longitude;
  String _address = '';

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
    final locationService = Provider.of<LocationService>(context, listen: false);
    await locationService.getCurrentLocation();
    
    if (locationService.currentPosition != null) {
      setState(() {
        _latitude = locationService.currentPosition!.latitude;
        _longitude = locationService.currentPosition!.longitude;
        _address = locationService.currentAddress;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      setState(() {
        _photoUrls.add(image.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _photoUrls.add(image.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastSeenDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _lastSeenDate) {
      setState(() {
        _lastSeenDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final petService = Provider.of<PetService>(context, listen: false);

    final pet = Pet(
      id: '',
      name: _nameController.text.trim(),
      type: _selectedType,
      breed: _breedController.text.trim(),
      color: _colorController.text.trim(),
      collarColor: _collarColorController.text.trim(),
      description: _descriptionController.text.trim(),
      photoUrls: _photoUrls,
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

    await petService.addPet(pet);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pet ${_selectedStatus} successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Clear form
      _formKey.currentState!.reset();
      setState(() {
        _photoUrls.clear();
      });
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
              // Status Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pet Status',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Lost Pet'),
                              value: 'lost',
                              groupValue: _selectedStatus,
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Found Pet'),
                              value: 'found',
                              groupValue: _selectedStatus,
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pet Type Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pet Type',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Dog'),
                              value: 'dog',
                              groupValue: _selectedType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Cat'),
                              value: 'cat',
                              groupValue: _selectedType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pet Details
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pet Details',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _nameController,
                        labelText: 'Pet Name',
                        hintText: 'Enter pet name',
                        prefixIcon: Icons.pets,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter pet name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _breedController,
                        labelText: 'Breed',
                        hintText: 'Enter breed',
                        prefixIcon: Icons.category,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter breed';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _colorController,
                              labelText: 'Color',
                              hintText: 'Enter color',
                              prefixIcon: Icons.palette,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter color';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: _collarColorController,
                              labelText: 'Collar Color',
                              hintText: 'Enter collar color',
                              prefixIcon: Icons.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _descriptionController,
                        labelText: 'Description',
                        hintText: 'Describe the pet and any identifying features',
                        prefixIcon: Icons.description,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Photos
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Photos',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _pickImageFromGallery,
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
                            itemBuilder: (context, index) {
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
                                          image: NetworkImage(_photoUrls[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _photoUrls.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Owner Details
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Owner Details',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _ownerNameController,
                        labelText: 'Owner Name',
                        hintText: 'Enter owner name',
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter owner name';
                          }
                          return null;
                        },
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: _ownerEmailController,
                              labelText: 'Email',
                              hintText: 'Enter email',
                              prefixIcon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location and Date
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location & Date',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(_address.isNotEmpty ? _address : 'Getting location...'),
                        subtitle: const Text('Current location'),
                        trailing: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _getCurrentLocation,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text('${_lastSeenDate.day}/${_lastSeenDate.month}/${_lastSeenDate.year}'),
                        subtitle: const Text('Last seen date'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _selectDate,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              Consumer<PetService>(
                builder: (context, petService, child) {
                  return CustomButton(
                    text: 'Add Pet',
                    onPressed: petService.isLoading ? null : _submitForm,
                    isLoading: petService.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 