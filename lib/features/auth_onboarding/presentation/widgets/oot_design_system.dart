import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class OotOnboardingScaffold extends StatelessWidget {
  const OotOnboardingScaffold({
    super.key,
    required this.progressLabel,
    required this.currentStep,
    required this.totalSteps,
    required this.body,
    required this.buttonLabel,
    required this.onContinue,
    this.onBack,
  });

  final String progressLabel;
  final int currentStep;
  final int totalSteps;
  final Widget body;
  final String buttonLabel;
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          OotProgressHeader(
            label: progressLabel,
            currentStep: currentStep,
            totalSteps: totalSteps,
            onBack: onBack ?? () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
              child: body,
            ),
          ),
          OotFooterButton(label: buttonLabel, onPressed: onContinue),
        ],
      ),
    );
  }
}

class OotProgressHeader extends StatelessWidget {
  const OotProgressHeader({
    super.key,
    required this.label,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  final String label;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final progress = totalSteps == 0
        ? 0.0
        : (currentStep / totalSteps).clamp(0.0, 1.0);

    return SizedBox(
      height: 104.h,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 16.h),
        child: Row(
          children: [
            OotBackButton(onPressed: onBack),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: AppColors.label,
                          fontSize: 11.sp,
                          height: 14 / 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .77.w,
                        ),
                      ),
                      Text(
                        '$currentStep / $totalSteps',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFA18F88),
                          fontSize: 11.sp,
                          height: 14 / 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4.h,
                      color: AppColors.accent,
                      backgroundColor: AppColors.progressTrack,
                    ),
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

class OotBackButton extends StatelessWidget {
  const OotBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .82),
      borderRadius: BorderRadius.circular(20.r),
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFE6DBD5)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14573B32),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.chevron_left_rounded,
            size: 22.sp,
            color: const Color(0xFF6B4B40),
          ),
        ),
      ),
    );
  }
}

class OotFooterButton extends StatelessWidget {
  const OotFooterButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      height: 128.h,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 38.h, 24.w, 32.h),
        child: Material(
          color: enabled
              ? AppColors.accent
              : AppColors.accent.withValues(alpha: .42),
          borderRadius: BorderRadius.circular(18.r),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              height: 58.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: enabled
                    ? const [
                        BoxShadow(
                          color: Color(0x2E6B4B43),
                          blurRadius: 24,
                          spreadRadius: -4,
                          offset: Offset(0, 10),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox.square(dimension: 20.w),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .15.w,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OotHero extends StatelessWidget {
  const OotHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 258.h,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/talking_logo.png',
            width: 76.w,
            height: 61.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 22.h),
          Text(
            eyebrow.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.accent,
              fontSize: 11.sp,
              height: 14 / 11,
              fontWeight: FontWeight.w500,
              letterSpacing: .88.w,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorant(
              color: AppColors.textPrimary,
              fontSize: 36.sp,
              height: 42 / 36,
              fontWeight: FontWeight.w500,
              letterSpacing: -.36.w,
            ),
          ),
          SizedBox(height: 8.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 330.w),
            child: Text(
              description,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                height: 21 / 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OotSectionLabel extends StatelessWidget {
  const OotSectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          color: AppColors.label,
          fontSize: 12.sp,
          height: 18 / 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class OotFieldLabel extends StatelessWidget {
  const OotFieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 13.sp,
        height: 18 / 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class OotTextField extends StatelessWidget {
  const OotTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.autofocus = false,
    this.maxLength,
    this.maxLines = 1,
    this.focused = false,
    this.prefix,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool autofocus;
  final int? maxLength;
  final int maxLines;
  final bool focused;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final multiline = maxLines > 1;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      autofocus: autofocus,
      maxLength: maxLength,
      maxLines: maxLines,
      onChanged: onChanged,
      style: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: multiline ? 14.sp : 16.sp,
        height: multiline ? 22 / 14 : 22 / 16,
        fontWeight: multiline ? FontWeight.w400 : FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: prefix,
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF9A8880),
          fontSize: 14.sp,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: multiline
            ? EdgeInsets.fromLTRB(16.w, 44.h, 16.w, 12.h)
            : EdgeInsets.symmetric(horizontal: 16.w, vertical: 17.h),
        constraints: BoxConstraints(
          minHeight: multiline ? 156.h : 58.h,
          maxHeight: multiline ? 156.h : 58.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(multiline ? 18.r : 16.r),
          borderSide: BorderSide(
            color: focused ? AppColors.primary : AppColors.borderStrong,
            width: focused ? 1.5.w : 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(multiline ? 18.r : 16.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
        ),
      ),
    );
  }
}

class OotOptionData {
  const OotOptionData(this.label, {this.caption});

  final String label;
  final String? caption;
}

class OotSelectOption extends StatelessWidget {
  const OotSelectOption({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
    this.height = 58,
    this.compact = false,
    this.showSelectedBadge = false,
    this.showControl = true,
  });

  final OotOptionData option;
  final bool selected;
  final VoidCallback onTap;
  final double height;
  final bool compact;
  final bool showSelectedBadge;
  final bool showControl;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.surfaceSelected : Colors.white,
      borderRadius: BorderRadius.circular(compact ? 14.r : 16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 14.r : 16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: height.h,
          padding: EdgeInsets.only(left: 16.w, right: 14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 14.r : 16.r),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: GoogleFonts.inter(
                        color: selected
                            ? AppColors.textPrimary
                            : const Color(0xFF6B5A53),
                        fontSize: compact ? 13.sp : 14.sp,
                        height: 20 / 14,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    if (option.caption != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        option.caption!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9A8880),
                          fontSize: 12.sp,
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (selected && showSelectedBadge)
                Container(
                  height: 28.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    'Selected',
                    style: GoogleFonts.inter(
                      color: AppColors.accent,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else if (showControl)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: compact ? 20.w : 22.w,
                  height: compact ? 20.w : 22.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.accent : Colors.white,
                    border: Border.all(
                      color: selected
                          ? AppColors.accent
                          : const Color(0xFFDCCEC7),
                    ),
                  ),
                  child: selected
                      ? Icon(Icons.check, size: 15.sp, color: Colors.white)
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OotVisibilityRow extends StatelessWidget {
  const OotVisibilityRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 34.h : 38.h,
      padding: EdgeInsets.only(left: 12.w, right: 8.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Show on profile',
              style: GoogleFonts.inter(
                color: const Color(0xFF6B5A53),
                fontSize: 12.sp,
                height: 18 / 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          OotToggle(value: value, onChanged: onChanged, compact: compact),
        ],
      ),
    );
  }
}

class OotToggle extends StatelessWidget {
  const OotToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final width = compact ? 38.w : 44.w;
    final height = compact ? 22.h : 26.h;
    final knob = compact ? 16.w : 20.w;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: width,
        height: height,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: value ? AppColors.accent : const Color(0xFFD9CBC5),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 160),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: knob,
            height: knob,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class OotSingleChoiceScreen extends StatefulWidget {
  const OotSingleChoiceScreen({
    super.key,
    required this.progressLabel,
    required this.currentStep,
    required this.totalSteps,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.sectionLabel,
    required this.options,
    required this.onContinue,
    this.initialSelection,
    this.optionHeight = 58,
    this.compactOptions = false,
    this.showSelectedBadge = false,
    this.showVisibility = false,
    this.helperText,
    this.onSelectionChanged,
  });

  final String progressLabel;
  final int currentStep;
  final int totalSteps;
  final String eyebrow;
  final String title;
  final String description;
  final String sectionLabel;
  final List<OotOptionData> options;
  final VoidCallback? onContinue;
  final int? initialSelection;
  final double optionHeight;
  final bool compactOptions;
  final bool showSelectedBadge;
  final bool showVisibility;
  final String? helperText;
  final ValueChanged<int>? onSelectionChanged;

  @override
  State<OotSingleChoiceScreen> createState() => _OotSingleChoiceScreenState();
}

class _OotSingleChoiceScreenState extends State<OotSingleChoiceScreen> {
  int? _selection;
  bool _showOnProfile = true;

  @override
  void initState() {
    super.initState();
    _selection = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: widget.progressLabel,
      currentStep: widget.currentStep,
      totalSteps: widget.totalSteps,
      buttonLabel: 'Continue',
      onContinue: _selection == null ? null : widget.onContinue,
      body: Column(
        children: [
          OotHero(
            eyebrow: widget.eyebrow,
            title: widget.title,
            description: widget.description,
          ),
          SizedBox(height: 34.h),
          OotSectionLabel(widget.sectionLabel),
          SizedBox(height: widget.compactOptions ? 8.h : 10.h),
          for (var index = 0; index < widget.options.length; index++) ...[
            OotSelectOption(
              option: widget.options[index],
              selected: _selection == index,
              onTap: () {
                setState(() => _selection = index);
                widget.onSelectionChanged?.call(index);
              },
              height: widget.options[index].caption == null
                  ? widget.optionHeight
                  : math.max(widget.optionHeight, 72),
              compact: widget.compactOptions,
              showSelectedBadge: widget.showSelectedBadge,
            ),
            if (index != widget.options.length - 1) SizedBox(height: 8.h),
          ],
          if (widget.helperText != null) ...[
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.helperText!,
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 12.sp,
                  height: 16 / 12,
                ),
              ),
            ),
          ],
          if (widget.showVisibility) ...[
            SizedBox(height: 10.h),
            OotVisibilityRow(
              compact: true,
              value: _showOnProfile,
              onChanged: (value) => setState(() => _showOnProfile = value),
            ),
          ],
        ],
      ),
    );
  }
}

class OotStoryIntroScreen extends StatelessWidget {
  const OotStoryIntroScreen({
    super.key,
    required this.progressLabel,
    required this.currentStep,
    required this.totalSteps,
    required this.imageAsset,
    required this.imageAlignment,
    required this.pill,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.benefits,
    required this.buttonLabel,
    required this.onContinue,
  });

  final String progressLabel;
  final int currentStep;
  final int totalSteps;
  final String imageAsset;
  final Alignment imageAlignment;
  final String pill;
  final String eyebrow;
  final String title;
  final String description;
  final List<(String, String)> benefits;
  final String buttonLabel;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: progressLabel,
      currentStep: currentStep,
      totalSteps: totalSteps,
      buttonLabel: buttonLabel,
      onContinue: onContinue,
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: AppColors.surfaceMuted),
                  Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    alignment: imageAlignment,
                  ),
                  Positioned(
                    top: 16.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        height: 30.h,
                        width: 180,
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .94),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Text(
                          pill.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: AppColors.accent,
                            fontSize: 10.sp,
                            height: 14 / 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            height: 120.h,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 392.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      eyebrow.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: AppColors.accent,
                        fontSize: 11.sp,
                        height: 14 / 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .88.w,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorant(
                        color: AppColors.textPrimary,
                        fontSize: 36.sp,
                        height: 42 / 36,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 360.w),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                          height: 21 / 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            height: 86.h,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: const Color(0xFFE6DBD5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final benefit in benefits)
                  SizedBox(
                    width: 112.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: 112.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              benefit.$1.toUpperCase(),
                              style: GoogleFonts.inter(
                                color: AppColors.accent,
                                fontSize: 10.sp,
                                height: 14 / 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .8.w,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              benefit.$2,
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 11.sp,
                                height: 16 / 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle ootHelperStyle() => GoogleFonts.inter(
  color: AppColors.textMuted,
  fontSize: 12.sp,
  height: 16 / 12,
);
