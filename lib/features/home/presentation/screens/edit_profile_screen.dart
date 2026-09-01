import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';

typedef EditProfilePhotoPicker = Future<Uint8List?> Function();

@immutable
class EditProfileData {
  const EditProfileData({
    this.gender = 'Man',
    this.heightCm = 178,
    this.location = 'Chicago, Illinois',
    this.connection = 'Long-term relationship',
    this.study = 'Illinois Institute of Technology',
    this.educationLevel = 'Graduate degree',
    this.work = 'Product designer · OOT',
    this.lifestyle = 'Drinks sometimes · Does not smoke',
    this.beliefs = 'Agnostic',
    this.familyPlans = 'Wants children',
    this.photoBytes = const [],
  });

  final String gender;
  final int heightCm;
  final String location;
  final String connection;
  final String study;
  final String educationLevel;
  final String work;
  final String lifestyle;
  final String beliefs;
  final String familyPlans;
  final List<Uint8List?> photoBytes;
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.initialData = const EditProfileData(),
    this.photoPicker,
    this.onSaved,
  });

  final EditProfileData initialData;
  final EditProfilePhotoPicker? photoPicker;
  final ValueChanged<EditProfileData>? onSaved;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const _background = Color(0xFFFBF6F0);
  static const _action = Color(0xFFAA432F);
  static const _assetPhotos = [
    'assets/images/profile_onboarding.png',
    'assets/images/profile_onboarding2.png',
    'assets/images/profile_onboarding3.png',
  ];

  final ImagePicker _imagePicker = ImagePicker();
  late final List<Uint8List?> _photoBytes;
  int? _pickingPhoto;

  late String _gender;
  late int _heightCm;
  late String _location;
  late String _connection;
  late String _study;
  late String _educationLevel;
  late String _work;
  late String _lifestyle;
  late String _beliefs;
  late String _familyPlans;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialData;
    _gender = initial.gender;
    _heightCm = initial.heightCm;
    _location = initial.location;
    _connection = initial.connection;
    _study = initial.study;
    _educationLevel = initial.educationLevel;
    _work = initial.work;
    _lifestyle = initial.lifestyle;
    _beliefs = initial.beliefs;
    _familyPlans = initial.familyPlans;
    _photoBytes = List<Uint8List?>.filled(6, null);
    for (
      var index = 0;
      index < initial.photoBytes.length && index < _photoBytes.length;
      index++
    ) {
      _photoBytes[index] = initial.photoBytes[index];
    }
  }

  Future<Uint8List?> _pickPhotoBytes() async {
    final injectedPicker = widget.photoPicker;
    if (injectedPicker != null) return injectedPicker();
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      imageQuality: 90,
      requestFullMetadata: false,
    );
    return file?.readAsBytes();
  }

  Future<void> _editPhoto(int index) async {
    if (_pickingPhoto != null) return;
    setState(() => _pickingPhoto = index);
    try {
      final bytes = await _pickPhotoBytes();
      if (!mounted || bytes == null) return;
      setState(() => _photoBytes[index] = bytes);
    } on MissingPluginException catch (error) {
      debugPrint('Photo picker is not registered: $error');
      if (mounted) {
        _showMessage(
          'Photo picker needs an app restart. Close OOT and open it again.',
        );
      }
    } on PlatformException catch (error) {
      debugPrint('Unable to open the photo gallery: $error');
      if (mounted) {
        _showMessage('Unable to open the photo gallery. Please try again.');
      }
    } catch (error, stackTrace) {
      debugPrint('Unable to edit profile photo: $error\n$stackTrace');
      if (mounted) {
        _showMessage('Unable to update that photo. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _pickingPhoto = null);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String?> _chooseValue({
    required String title,
    required String currentValue,
    required List<String> options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x4D2D1E1A),
      builder: (_) => _ChoiceEditorSheet(
        title: title,
        currentValue: currentValue,
        options: options,
      ),
    );
  }

  Future<String?> _editText({
    required String title,
    required String currentValue,
    required String hint,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x4D2D1E1A),
      builder: (_) => _TextEditorSheet(
        title: title,
        currentValue: currentValue,
        hint: hint,
      ),
    );
  }

  Future<void> _editGender() async {
    final value = await _chooseValue(
      title: 'Edit gender',
      currentValue: _gender,
      options: const ['Man', 'Woman', 'Non-binary', 'Prefer not to say'],
    );
    if (mounted && value != null) setState(() => _gender = value);
  }

  Future<void> _editHeight() async {
    final value = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x4D2D1E1A),
      builder: (_) => _HeightEditorSheet(initialValue: _heightCm),
    );
    if (mounted && value != null) setState(() => _heightCm = value);
  }

  Future<void> _editLocation() async {
    final value = await _editText(
      title: 'Edit location',
      currentValue: _location,
      hint: 'City, state or country',
    );
    if (mounted && value != null) setState(() => _location = value);
  }

  Future<void> _editConnection() async {
    final value = await _chooseValue(
      title: 'Edit connection',
      currentValue: _connection,
      options: const [
        'Life partner',
        'Long-term relationship',
        'Long-term, open to short',
        'Short-term, open to long',
        'Short-term',
        'Figuring out my dating goals',
      ],
    );
    if (mounted && value != null) setState(() => _connection = value);
  }

  Future<void> _editStudy() async {
    final value = await _editText(
      title: 'Edit study',
      currentValue: _study,
      hint: 'School or university',
    );
    if (mounted && value != null) setState(() => _study = value);
  }

  Future<void> _editEducationLevel() async {
    final value = await _chooseValue(
      title: 'Edit education level',
      currentValue: _educationLevel,
      options: const [
        'High school',
        'College degree',
        'Graduate degree',
        'Prefer not to say',
      ],
    );
    if (mounted && value != null) setState(() => _educationLevel = value);
  }

  Future<void> _editWork() async {
    final value = await _editText(
      title: 'Edit work',
      currentValue: _work,
      hint: 'Role · Company',
    );
    if (mounted && value != null) setState(() => _work = value);
  }

  Future<void> _editLifestyle() async {
    final value = await _chooseValue(
      title: 'Edit lifestyle',
      currentValue: _lifestyle,
      options: const [
        'Drinks sometimes · Does not smoke',
        'Drinks socially · Does not smoke',
        'Does not drink · Does not smoke',
        'Does not drink · Smokes sometimes',
        'Prefer not to say',
      ],
    );
    if (mounted && value != null) setState(() => _lifestyle = value);
  }

  Future<void> _editBeliefs() async {
    final value = await _chooseValue(
      title: 'Edit beliefs',
      currentValue: _beliefs,
      options: const [
        'Agnostic',
        'Atheist',
        'Buddhist',
        'Catholic',
        'Christian',
        'Hindu',
        'Jewish',
        'Muslim',
        'Sikh',
        'Prefer not to say',
      ],
    );
    if (mounted && value != null) setState(() => _beliefs = value);
  }

  Future<void> _editFamilyPlans() async {
    final value = await _chooseValue(
      title: 'Edit family plans',
      currentValue: _familyPlans,
      options: const [
        'Wants children',
        'Does not want children',
        'Open to children',
        'Not sure yet',
        'Prefer not to say',
      ],
    );
    if (mounted && value != null) setState(() => _familyPlans = value);
  }

  void _save() {
    final result = EditProfileData(
      gender: _gender,
      heightCm: _heightCm,
      location: _location,
      connection: _connection,
      study: _study,
      educationLevel: _educationLevel,
      work: _work,
      lifestyle: _lifestyle,
      beliefs: _beliefs,
      familyPlans: _familyPlans,
      photoBytes: List<Uint8List?>.unmodifiable(_photoBytes),
    );
    widget.onSaved?.call(result);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
    } else {
      _showMessage('Profile changes saved.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('edit-profile-screen'),
      backgroundColor: _background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _EditProfileHeader(onSave: _save),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 28.h),
                children: [
                  _PhotoEditorCard(
                    photoBytes: _photoBytes,
                    pickingPhoto: _pickingPhoto,
                    onEditPhoto: _editPhoto,
                  ),
                  SizedBox(height: 18.h),
                  _EditSection(
                    title: 'Personal details',
                    children: [
                      _EditFieldRow(
                        key: const ValueKey('edit-profile-gender'),
                        label: 'Gender',
                        value: _gender,
                        onTap: _editGender,
                      ),
                      _EditFieldRow(
                        key: const ValueKey('edit-profile-height'),
                        label: 'Height',
                        value: '$_heightCm cm',
                        onTap: _editHeight,
                      ),
                      _EditFieldRow(
                        key: const ValueKey('edit-profile-location'),
                        label: 'Location',
                        value: _location,
                        onTap: _editLocation,
                      ),
                      _EditFieldRow(
                        key: const ValueKey('edit-profile-connection'),
                        label: 'Connection',
                        value: _connection,
                        onTap: _editConnection,
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  _EditSection(
                    title: 'About you',
                    children: [
                      _EditFieldRow(
                        key: const ValueKey('edit-profile-study'),
                        label: 'Study',
                        value: _study,
                        onTap: _editStudy,
                        compact: true,
                      ),
                      _EditFieldRow(
                        key: const ValueKey('edit-profile-education-level'),
                        label: 'Education level',
                        value: _educationLevel,
                        onTap: _editEducationLevel,
                        compact: true,
                      ),
                      _EditFieldRow(
                        key: const ValueKey('edit-profile-work'),
                        label: 'Work',
                        value: _work,
                        onTap: _editWork,
                        compact: true,
                      ),
                      _EditFieldRow(
                        key: const ValueKey('edit-profile-lifestyle'),
                        label: 'Lifestyle',
                        value: _lifestyle,
                        onTap: _editLifestyle,
                        compact: true,
                      ),
                      _EditFieldRow(
                        key: const ValueKey('edit-profile-beliefs'),
                        label: 'Beliefs',
                        value: _beliefs,
                        onTap: _editBeliefs,
                        compact: true,
                      ),
                      _EditFieldRow(
                        key: const ValueKey('edit-profile-family-plans'),
                        label: 'Family plans',
                        value: _familyPlans,
                        onTap: _editFamilyPlans,
                        compact: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  FilledButton(
                    key: const ValueKey('edit-profile-save-button'),
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(56.h),
                      backgroundColor: _action,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('Save changes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditProfileHeader extends StatelessWidget {
  const _EditProfileHeader({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            IconButton(
              key: const ValueKey('edit-profile-back-button'),
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.chevron_left_rounded,
                color: const Color(0xFF2B211E),
                size: 30.sp,
              ),
            ),
            Expanded(
              child: Text(
                'Edit profile',
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorant(
                  color: const Color(0xFF2B211E),
                  fontSize: 26.sp,
                  height: 28 / 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              key: const ValueKey('edit-profile-header-save'),
              onPressed: onSave,
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: _EditProfileScreenState._action,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoEditorCard extends StatelessWidget {
  const _PhotoEditorCard({
    required this.photoBytes,
    required this.pickingPhoto,
    required this.onEditPhoto,
  });

  final List<Uint8List?> photoBytes;
  final int? pickingPhoto;
  final ValueChanged<int> onEditPhoto;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Your photos'),
          SizedBox(height: 7.h),
          Text(
            'Your first photo is shown first. Drag to reorder.',
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 11.sp,
              height: 16 / 11,
            ),
          ),
          SizedBox(height: 13.h),
          SizedBox(
            height: 164.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, index) => _PhotoTile(
                key: ValueKey('edit-profile-photo-$index'),
                index: index,
                bytes: photoBytes[index],
                picking: pickingPhoto == index,
                onTap: () => onEditPhoto(index),
              ),
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            'Add up to 6 photos',
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 10.sp,
              height: 14 / 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    super.key,
    required this.index,
    required this.bytes,
    required this.picking,
    required this.onTap,
  });

  final int index;
  final Uint8List? bytes;
  final bool picking;
  final VoidCallback onTap;

  bool get _hasBundledPhoto =>
      index < _EditProfileScreenState._assetPhotos.length;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: _hasBundledPhoto || bytes != null
          ? 'Replace profile photo ${index + 1}'
          : 'Add profile photo ${index + 1}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: 100.w,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: picking
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    if (bytes != null)
                      Image.memory(bytes!, fit: BoxFit.cover)
                    else if (_hasBundledPhoto)
                      Image.asset(
                        _EditProfileScreenState._assetPhotos[index],
                        fit: BoxFit.cover,
                      )
                    else
                      Center(
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          color: AppColors.accent,
                          size: 28.sp,
                        ),
                      ),
                    Positioned(
                      right: 4.w,
                      bottom: 4.h,
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: _EditProfileScreenState._action,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 20.sp,
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

class _EditSection extends StatelessWidget {
  const _EditSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(title),
          SizedBox(height: 8.h),
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index != children.length - 1) SizedBox(height: 8.h),
          ],
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.inter(
        color: _EditProfileScreenState._action,
        fontSize: 12.sp,
        height: 18 / 12,
        fontWeight: FontWeight.w700,
        letterSpacing: .7,
      ),
    );
  }
}

class _EditFieldRow extends StatelessWidget {
  const _EditFieldRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _EditProfileScreenState._background,
      borderRadius: BorderRadius.circular(compact ? 14.r : 15.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 14.r : 15.r),
        child: SizedBox(
          height: (compact ? 52 : 64).h,
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 7.h, 10.w, 7.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: (compact ? 9 : 10).sp,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF2B211E),
                          fontSize: (compact ? 12 : 13).sp,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFF9A8880),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetShell extends StatelessWidget {
  const _SheetShell({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom > 0
        ? mediaQuery.viewInsets.bottom
        : mediaQuery.viewPadding.bottom;
    return Container(
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height * .78),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h + bottomInset),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            title,
            style: GoogleFonts.cormorant(
              color: AppColors.textPrimary,
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 14.h),
          Flexible(child: child),
        ],
      ),
    );
  }
}

class _ChoiceEditorSheet extends StatelessWidget {
  const _ChoiceEditorSheet({
    required this.title,
    required this.currentValue,
    required this.options,
  });

  final String title;
  final String currentValue;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: title,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: options.length,
        separatorBuilder: (_, _) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final option = options[index];
          final selected = option == currentValue;
          return Material(
            color: selected
                ? AppColors.surfaceSelected
                : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(14.r),
            child: ListTile(
              key: ValueKey('edit-profile-choice-$index'),
              onTap: () => Navigator.of(context).pop(option),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              title: Text(
                option,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 13.sp,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              trailing: Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected ? AppColors.accent : AppColors.textMuted,
                size: 20.sp,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TextEditorSheet extends StatefulWidget {
  const _TextEditorSheet({
    required this.title,
    required this.currentValue,
    required this.hint,
  });

  final String title;
  final String currentValue;
  final String hint;

  @override
  State<_TextEditorSheet> createState() => _TextEditorSheetState();
}

class _TextEditorSheetState extends State<_TextEditorSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.currentValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const ValueKey('edit-profile-text-input'),
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              filled: true,
              fillColor: AppColors.surfaceMuted,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          FilledButton(
            key: const ValueKey('edit-profile-text-apply'),
            onPressed: _submit,
            style: FilledButton.styleFrom(
              minimumSize: Size.fromHeight(52.h),
              backgroundColor: _EditProfileScreenState._action,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) Navigator.of(context).pop(value);
  }
}

class _HeightEditorSheet extends StatefulWidget {
  const _HeightEditorSheet({required this.initialValue});

  final int initialValue;

  @override
  State<_HeightEditorSheet> createState() => _HeightEditorSheetState();
}

class _HeightEditorSheetState extends State<_HeightEditorSheet> {
  late int _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: 'Edit height',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$_value cm',
            style: GoogleFonts.cormorant(
              color: AppColors.textPrimary,
              fontSize: 42.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Slider(
            key: const ValueKey('edit-profile-height-slider'),
            value: _value.toDouble(),
            min: 140,
            max: 220,
            divisions: 80,
            activeColor: _EditProfileScreenState._action,
            inactiveColor: AppColors.progressTrack,
            onChanged: (value) => setState(() => _value = value.round()),
          ),
          SizedBox(height: 10.h),
          FilledButton(
            key: const ValueKey('edit-profile-height-apply'),
            onPressed: () => Navigator.of(context).pop(_value),
            style: FilledButton.styleFrom(
              minimumSize: Size.fromHeight(52.h),
              backgroundColor: _EditProfileScreenState._action,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
