import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../bloc/address_bloc.dart';
import '../../bloc/address_event.dart';
import '../../bloc/address_state.dart';
import '../../data/models/address_payload.dart';
import '../../domain/entities/user_address.dart';

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key, this.initialAddress});

  final UserAddress? initialAddress;

  bool get isEditing => initialAddress != null;

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  late final TextEditingController _streetController;
  late final TextEditingController _buildingController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  late final TextEditingController _typeController;
  bool _isDefault = false;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialAddress;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _descriptionController = TextEditingController(
      text: initial?.description ?? '',
    );
    _cityController = TextEditingController(text: initial?.city ?? '');
    _districtController = TextEditingController(text: initial?.district ?? '');
    _streetController = TextEditingController(text: initial?.streetName ?? '');
    _buildingController = TextEditingController(
      text: initial?.buildingNumber ?? '',
    );
    _latController = TextEditingController(
      text: initial?.latitude?.toString() ?? '',
    );
    _lngController = TextEditingController(
      text: initial?.longitude?.toString() ?? '',
    );
    _typeController = TextEditingController(
      text: initial?.addressType ?? 'home',
    );
    _isDefault = initial?.isDefault ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final hasCoordinates =
          _latController.text.isNotEmpty && _lngController.text.isNotEmpty;
      if (!hasCoordinates) {
        _captureCurrentLocation(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'تعديل العنوان' : 'عنوان جديد')),
      body: BlocListener<AddressBloc, AddressState>(
        listenWhen: (previous, current) =>
            previous.mutationStatus != current.mutationStatus ||
            previous.mutationError != current.mutationError,
        listener: (context, state) {
          final type = state.mutationType;
          final isFormMutation =
              type == AddressMutationType.create ||
              type == AddressMutationType.update;

          if (!isFormMutation) return;

          if (state.mutationStatus == AddressMutationStatus.success) {
            if (!mounted) return;
            final bloc = context.read<AddressBloc>();
            bloc
              ..add(const AddressRequested())
              ..add(const AddressMutationStatusCleared());
            final messenger = ScaffoldMessenger.of(context);
            Navigator.of(context).maybePop();
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  type == AddressMutationType.create
                      ? 'تم إضافة العنوان بنجاح'
                      : 'تم تحديث العنوان بنجاح',
                ),
              ),
            );
          } else if (state.mutationStatus == AddressMutationStatus.failure) {
            if (!mounted) return;
            final message = state.mutationError ?? 'حدث خطأ أثناء حفظ العنوان';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: 'اسم العنوان',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال اسم العنوان';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _descriptionController,
                labelText: 'الوصف',
                maxLines: 3,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _cityController,
                      labelText: 'المدينة',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomTextField(
                      controller: _districtController,
                      labelText: 'الحي',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _streetController,
                      labelText: 'الشارع',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomTextField(
                      controller: _buildingController,
                      labelText: 'رقم المبنى',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _latController,
                      labelText: 'خط العرض',
                      readOnly: true,
                      helperText: 'يتم تحديد الإحداثيات تلقائياً',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomTextField(
                      controller: _lngController,
                      labelText: 'خط الطول',
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton.icon(
                  onPressed: _isLocating
                      ? null
                      : () => _captureCurrentLocation(),
                  icon: _isLocating
                      ? SizedBox(
                          width: 18.sp,
                          height: 18.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.my_location, size: 18.sp),
                  label: Text(
                    _isLocating ? 'جاري تحديد الموقع' : 'تحديد الموقع الحالي',
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _typeController,
                labelText: 'نوع العنوان (home/work)',
              ),
              SizedBox(height: 16.h),
              SwitchListTile.adaptive(
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
                title: const Text('تعيين كعنوان افتراضي'),
              ),
              SizedBox(height: 24.h),
              BlocBuilder<AddressBloc, AddressState>(
                buildWhen: (previous, current) =>
                    previous.mutationStatus != current.mutationStatus,
                builder: (context, state) {
                  final isBusy = state.isMutationInProgress;
                  return ElevatedButton(
                    onPressed: isBusy ? null : () => _submit(),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: isBusy
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEditing ? 'تحديث' : 'حفظ'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> _obtainPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('الرجاء تفعيل خدمة تحديد الموقع');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض إذن الموقع');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'تم رفض إذن الموقع نهائياً، الرجاء تفعيل الإذن من الإعدادات.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<bool> _captureCurrentLocation({bool silent = false}) async {
    if (_isLocating) return false;
    if (!mounted) return false;

    setState(() {
      _isLocating = true;
    });

    try {
      final position = await _obtainPosition();
      if (!mounted) return true;

      setState(() {
        _latController.text = position.latitude.toStringAsFixed(6);
        _lngController.text = position.longitude.toStringAsFixed(6);
      });

      if (!silent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث الإحداثيات من موقعك الحالي')),
        );
      }
      return true;
    } catch (error) {
      if (!silent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isLocating = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final hasCoordinates =
        _latController.text.trim().isNotEmpty &&
        _lngController.text.trim().isNotEmpty;
    if (!hasCoordinates) {
      final fetched = await _captureCurrentLocation(silent: true);
      if (!fetched || !mounted) return;
    }
    if (!mounted) return;

    final payload = AddressPayload(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      city: _cityController.text.trim().isEmpty
          ? null
          : _cityController.text.trim(),
      district: _districtController.text.trim().isEmpty
          ? null
          : _districtController.text.trim(),
      streetName: _streetController.text.trim().isEmpty
          ? null
          : _streetController.text.trim(),
      buildingNumber: _buildingController.text.trim().isEmpty
          ? null
          : _buildingController.text.trim(),
      latitude: _parseDouble(_latController.text.trim()),
      longitude: _parseDouble(_lngController.text.trim()),
      addressType: _typeController.text.trim().isEmpty
          ? null
          : _typeController.text.trim(),
      isDefault: _isDefault,
    );

    final bloc = context.read<AddressBloc>();
    if (widget.isEditing) {
      bloc.add(AddressUpdated(id: widget.initialAddress!.id, payload: payload));
    } else {
      bloc.add(AddressCreated(payload));
    }
  }

  double? _parseDouble(String value) {
    if (value.isEmpty) return null;
    return double.tryParse(value);
  }
}
