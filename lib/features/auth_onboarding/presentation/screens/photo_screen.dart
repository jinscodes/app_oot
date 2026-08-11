import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

typedef GalleryPhotoPicker = Future<XFile?> Function();
typedef MultiGalleryPhotoPicker = Future<List<XFile>> Function(int limit);
typedef AppSettingsOpener = Future<void> Function();

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({
    super.key,
    this.onNext,
    this.photoPicker,
    this.multiPhotoPicker,
    this.openAppSettings,
  });

  final VoidCallback? onNext;
  final GalleryPhotoPicker? photoPicker;
  final MultiGalleryPhotoPicker? multiPhotoPicker;
  final AppSettingsOpener? openAppSettings;

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final Map<int, Uint8List> _photos = {};
  int? _pickingSlot;

  Future<XFile?> _pickOneFromGallery() {
    final injectedPicker = widget.photoPicker;
    if (injectedPicker != null) return injectedPicker();
    return _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      imageQuality: 90,
      requestFullMetadata: false,
    );
  }

  Future<List<XFile>> _pickMultipleFromGallery(int limit) {
    final injectedPicker = widget.multiPhotoPicker;
    if (injectedPicker != null) return injectedPicker(limit);
    return _imagePicker.pickMultiImage(
      maxWidth: 2048,
      imageQuality: 90,
      limit: limit,
      requestFullMetadata: false,
    );
  }

  Future<void> _selectPhotos(int index) async {
    if (_pickingSlot != null) return;
    setState(() => _pickingSlot = index);
    final replacingPhoto = _photos.containsKey(index);
    List<XFile> selectedPhotos;
    try {
      if (replacingPhoto) {
        final selectedPhoto = await _pickOneFromGallery();
        selectedPhotos = [?selectedPhoto];
      } else {
        selectedPhotos = await _pickMultipleFromGallery(6 - _photos.length);
      }
    } on MissingPluginException catch (error) {
      debugPrint('Photo picker is not registered: $error');
      _clearPickingSlot();
      if (mounted) {
        _showMessage(
          'Photo picker needs an app restart. Close OOT completely and open it again.',
        );
      }
      return;
    } on PlatformException catch (error) {
      debugPrint('Photo picker platform error (${error.code}): $error');
      _clearPickingSlot();
      if (!mounted) return;
      if (_isPermissionError(error)) {
        await _showPermissionDialog();
      } else {
        _showMessage('Unable to open the photo gallery. Please try again.');
      }
      return;
    } catch (error, stackTrace) {
      debugPrint('Photo picker error: $error\n$stackTrace');
      _clearPickingSlot();
      if (mounted) {
        _showMessage('Unable to open the photo gallery. Please try again.');
      }
      return;
    }

    if (selectedPhotos.isEmpty) {
      _clearPickingSlot();
      return;
    }

    final targetSlots = replacingPhoto
        ? [index]
        : [
            index,
            for (var slot = 0; slot < 6; slot++)
              if (slot != index && !_photos.containsKey(slot)) slot,
          ];
    final loadedPhotos = <int, Uint8List>{};
    var unreadablePhotoFound = false;
    try {
      for (
        var photoIndex = 0;
        photoIndex < selectedPhotos.length && photoIndex < targetSlots.length;
        photoIndex++
      ) {
        try {
          loadedPhotos[targetSlots[photoIndex]] =
              await selectedPhotos[photoIndex].readAsBytes();
        } catch (error, stackTrace) {
          unreadablePhotoFound = true;
          debugPrint('Unable to read selected photo: $error\n$stackTrace');
        }
      }
      if (!mounted) return;
      setState(() => _photos.addAll(loadedPhotos));
      if (unreadablePhotoFound) {
        _showMessage(
          'Some photos could not be read. Try JPEG or PNG files instead.',
        );
      }
    } finally {
      _clearPickingSlot();
    }
  }

  void _clearPickingSlot() {
    if (mounted && _pickingSlot != null) {
      setState(() => _pickingSlot = null);
    }
  }

  bool _isPermissionError(PlatformException error) {
    const permissionCodes = {
      'photo_access_denied',
      'photo_access_restricted',
      'permission_denied',
      'access_denied',
    };
    final message = error.message?.toLowerCase() ?? '';
    return permissionCodes.contains(error.code) ||
        message.contains('permission') ||
        message.contains('denied') ||
        message.contains('restricted');
  }

  Future<void> _showPermissionDialog() {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Allow photo access'),
        content: const Text(
          'To add profile photos, allow OOT to access your photo library in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final settingsOpener = widget.openAppSettings;
              if (settingsOpener != null) {
                await settingsOpener();
              } else {
                await Geolocator.openAppSettings();
              }
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Profile details',
      currentStep: 5,
      totalSteps: 5,
      buttonLabel: 'Finish setup',
      onContinue: widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Your profile',
            title: 'Add your best moments',
            description:
                'Start with 3–6 clear photos. You can update them anytime.',
          ),
          SizedBox(height: 34.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const OotSectionLabel('Your photos'),
              Text(
                '${_photos.length} / 6',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 12.sp,
                  height: 18 / 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          for (var row = 0; row < 3; row++) ...[
            Row(
              children: [
                Expanded(child: _slot(row * 2)),
                SizedBox(width: 10.w),
                Expanded(child: _slot(row * 2 + 1)),
              ],
            ),
            if (row != 2) SizedBox(height: 10.h),
          ],
        ],
      ),
    );
  }

  Widget _slot(int index) {
    final main = index == 0;
    final photo = _photos[index];
    final picking = _pickingSlot == index;
    return Semantics(
      button: true,
      label: photo == null
          ? main
                ? 'Add main photo from gallery'
                : 'Add photo from gallery'
          : 'Replace photo from gallery',
      child: GestureDetector(
        onTap: () => _selectPhotos(index),
        child: Container(
          key: ValueKey('photo-slot-$index'),
          height: 112.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: main ? AppColors.surfaceSelected : Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: main ? AppColors.accent : const Color(0xFFDCCEC7),
            ),
          ),
          child: picking
              ? Center(
                  child: SizedBox.square(
                    dimension: 24.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : photo == null
              ? _EmptyPhotoSlot(main: main)
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(
                      photo,
                      key: ValueKey('photo-image-$index'),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .58),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (main)
                      Positioned(
                        left: 8.w,
                        bottom: 8.h,
                        child: Container(
                          height: 24.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .58),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Main photo',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
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
}

class _EmptyPhotoSlot extends StatelessWidget {
  const _EmptyPhotoSlot({required this.main});

  final bool main;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          main ? Icons.photo_library_outlined : Icons.add_rounded,
          size: main ? 28.sp : 24.sp,
          color: AppColors.accent,
        ),
        SizedBox(height: main ? 4.h : 8.h),
        Text(
          main ? 'Add main photo' : 'Add photo',
          style: GoogleFonts.inter(
            color: main ? AppColors.label : AppColors.textMuted,
            fontSize: 12.sp,
            height: 18 / 12,
            fontWeight: main ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        if (main) ...[
          SizedBox(height: 4.h),
          Text(
            'Required',
            style: GoogleFonts.inter(
              color: AppColors.accent,
              fontSize: 10.sp,
              height: 14 / 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
