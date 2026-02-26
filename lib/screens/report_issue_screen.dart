import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../models/issue_model.dart';
import '../services/issue_service.dart';
import '../services/crowd_service.dart';
import '../services/image_service.dart';
import '../engines/priority_engine.dart';
import '../widgets/elevated_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/glass_card.dart';
import '../core/utilities/helpers.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImageService _imageService = ImageService();
  String? _selectedCategory;
  String? _selectedZone;
  bool _isSubmitting = false;
  double _calculatedPriority = 0.0;
  List<File> _selectedImages = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    final image = await _imageService.pickImageFromCamera();
    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final image = await _imageService.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _calculatePriority() {
    if (_selectedCategory == null) return;

    final priorityEngine = context.read<PriorityEngine>();
    final crowdService = context.read<CrowdService>();

    final severity = priorityEngine.getSeverityFromCategory(_selectedCategory!);
    final density = crowdService.getAverageDensity();

    setState(() {
      _calculatedPriority = priorityEngine.calculatePriority(
        severity: severity,
        density: density,
        environmentalFactor: 0.5,
        delayFactor: 0.1,
      );
    });
  }

  Future<void> _submitIssue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCategory == null || _selectedZone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select category and zone')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final issueService = context.read<IssueService>();
    final random = Random();

    final newIssue = IssueModel(
      id: 'ISS${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      description: _descriptionController.text,
      category: _selectedCategory!,
      zone: _selectedZone!,
      latitude: 28.6 + random.nextDouble() * 0.1,
      longitude: 77.2 + random.nextDouble() * 0.1,
      createdAt: DateTime.now(),
      status: IssueStatus.pending,
      priorityScore: _calculatedPriority,
      severity: _calculatedPriority,
      reportedBy: 'CurrentUser',
    );

    await issueService.addIssue(newIssue);

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Issue reported successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Helpers.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageCapture(),
                        const SizedBox(height: 24),
                        _buildFormFields(),
                        const SizedBox(height: 24),
                        _buildPriorityIndicator(),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: 'Submit Report',
                          onPressed: _submitIssue,
                          isLoading: _isSubmitting,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Helpers.getCardColor(context),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Report Issue',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCapture() {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedImages.isNotEmpty) ...[
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImages[index],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
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
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _pickImageFromCamera,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Helpers.getCardColor(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.softTeal.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 32,
                          color: AppColors.softTeal,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Camera',
                          style: TextStyle(
                            color: Helpers.getTextSecondary(context),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _pickImageFromGallery,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Helpers.getCardColor(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.softTeal.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_rounded,
                          size: 32,
                          color: AppColors.softTeal,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            color: Helpers.getTextSecondary(context),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _titleController,
            label: 'Issue Title',
            hint: 'Brief description of the issue',
            prefixIcon: Icons.title_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Title is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select category'),
                value: _selectedCategory,
                items: AppConstants.issueCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                  _calculatePriority();
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Zone',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select zone'),
                value: _selectedZone,
                items: AppConstants.zones.map((zone) {
                  return DropdownMenuItem(
                    value: zone,
                    child: Text(zone),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedZone = value);
                  _calculatePriority();
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Provide detailed information about the issue',
            prefixIcon: Icons.description_rounded,
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Description is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    final priorityEngine = context.read<PriorityEngine>();
    final priorityLevel = priorityEngine.getPriorityLevel(_calculatedPriority);

    Color priorityColor;
    switch (priorityLevel) {
      case 'Critical':
        priorityColor = AppColors.critical;
        break;
      case 'High':
        priorityColor = AppColors.high;
        break;
      case 'Medium':
        priorityColor = AppColors.medium;
        break;
      default:
        priorityColor = AppColors.low;
    }

    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Priority Score',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priorityLevel,
                  style: TextStyle(
                    color: priorityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _calculatedPriority,
              minHeight: 12,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(priorityColor),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Priority = (Severity × 0.4) + (Density × 0.3) + (Env × 0.2) + (Delay × 0.1)',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
