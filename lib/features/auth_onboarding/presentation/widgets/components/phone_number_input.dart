import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';

const Map<String, List<int>> _phonePatterns = {
  'US': [3, 3, 4],
  'KR': [3, 4, 4],
  'JP': [3, 4, 4],
};

String _formatPhone(String input, List<int>? pattern) {
  final digits = input.replaceAll(RegExp(r'\D'), '');
  if (pattern == null || pattern.isEmpty) return digits;
  final max = pattern.fold<int>(0, (a, b) => a + b);
  final trimmed = digits.length > max ? digits.substring(0, max) : digits;
  if (trimmed.isEmpty) return '';
  final buf = StringBuffer();
  int idx = 0;
  for (final size in pattern) {
    if (idx >= trimmed.length) break;
    if (idx > 0) buf.write(' ');
    final end = idx + size > trimmed.length ? trimmed.length : idx + size;
    buf.write(trimmed.substring(idx, end));
    idx = end;
  }
  return buf.toString();
}

class _PhonePatternFormatter extends TextInputFormatter {
  const _PhonePatternFormatter(this.pattern);

  final List<int>? pattern;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = _formatPhone(newValue.text, pattern);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({
    super.key,
    this.initialCountryCode = 'KR',
    this.controller,
    this.onCountryChanged,
    this.onValidityChanged,
  });

  final String initialCountryCode;
  final TextEditingController? controller;
  final ValueChanged<Country>? onCountryChanged;
  final ValueChanged<bool>? onValidityChanged;

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  late Country _country;
  late TextEditingController _controller;
  bool _ownsController = false;

  List<int>? get _pattern => _phonePatterns[_country.countryCode];

  @override
  void initState() {
    super.initState();
    _country =
        Country.tryParse(widget.initialCountryCode) ?? Country.parse('KR');
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    _controller.addListener(_emitValidity);
    WidgetsBinding.instance.addPostFrameCallback((_) => _emitValidity());
  }

  @override
  void dispose() {
    _controller.removeListener(_emitValidity);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  bool _computeValidity() {
    final digits = _controller.text.replaceAll(RegExp(r'\D'), '');
    return digits.isNotEmpty;
  }

  void _emitValidity() {
    widget.onValidityChanged?.call(_computeValidity());
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: const ['US', 'JP', 'KR'],
      countryListTheme: CountryListThemeData(
        backgroundColor: AppColors.background,
        bottomSheetHeight: 600.h,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        inputDecoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.accent, width: 1.w),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() => _country = country);
        final reformatted = _formatPhone(_controller.text, _pattern);
        _controller.value = TextEditingValue(
          text: reformatted,
          selection: TextSelection.collapsed(offset: reformatted.length),
        );
        widget.onCountryChanged?.call(country);
        _emitValidity();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(color: AppColors.accent, width: 1.5.w);
    final radius = BorderRadius.circular(16.r);
    final height = 48.h;

    final valueStyle = TextStyle(
      color: AppColors.textPrimary,
      fontSize: 14.sp,
      letterSpacing: 0.0.h,
    );

    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _openCountryPicker,
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: radius,
              border: Border.fromBorderSide(borderSide),
            ),
            child: Row(
              children: [
                Text(_country.flagEmoji, style: TextStyle(fontSize: 16.sp)),
                SizedBox(width: 10.w),
                Text('+${_country.phoneCode}', style: valueStyle),
              ],
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: radius,
              border: Border.fromBorderSide(borderSide),
            ),
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              autofocus: true,
              autofillHints: const [AutofillHints.telephoneNumber],
              inputFormatters: [_PhonePatternFormatter(_pattern)],
              style: valueStyle,
              decoration: InputDecoration(
                hintText: 'Phone number',
                hintStyle: TextStyle(
                  color: const Color(0xFFBDBDBD),
                  fontSize: 14.sp,
                  letterSpacing: 0.0.h,
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
