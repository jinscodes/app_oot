import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';

class VerificationCodeInput extends StatefulWidget {
  const VerificationCodeInput({
    super.key,
    this.controller,
    this.maxLength = 6,
    this.onValidityChanged,
    this.hasError = false,
  });

  final TextEditingController? controller;
  final int maxLength;
  final ValueChanged<bool>? onValidityChanged;
  final bool hasError;

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  bool _ownsController = false;
  final FocusNode _focusNode = FocusNode();

  late AnimationController _shakeController;
  late Animation<double> _shakeOffset;
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    _controller.addListener(_emitValidity);
    WidgetsBinding.instance.addPostFrameCallback((_) => _emitValidity());

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _shakeOffset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);

    _cursorController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _cursorController.repeat();
    } else {
      _cursorController.stop();
      _cursorController.value = 0;
    }
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant VerificationCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_emitValidity);
    if (_ownsController) _controller.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  void _emitValidity() {
    widget.onValidityChanged?.call(_controller.text.isNotEmpty);
  }

  void _focusField() => _focusNode.requestFocus();

  Widget _buildSlotContent(int index, String text) {
    final isCursorSlot = _focusNode.hasFocus && index == text.length;
    if (isCursorSlot) {
      return AnimatedBuilder(
        animation: _cursorController,
        builder: (context, _) {
          final visible = _cursorController.value < 0.5;
          return Opacity(
            opacity: visible ? 1.0 : 0.0,
            child: Container(
              width: 1.5.w,
              height: 20.h,
              color: AppColors.accent,
            ),
          );
        },
      );
    }
    final digit = index < text.length ? text[index] : null;
    return Text(
      digit ?? '_',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: digit != null ? AppColors.textPrimary : const Color(0xFFBDBDBD),
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0.h,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.hasError
        ? const Color(0xFFD64545)
        : AppColors.accent;
    final borderSide = BorderSide(color: borderColor, width: 1.5.w);
    final radius = BorderRadius.circular(16.r);

    return AnimatedBuilder(
      animation: _shakeOffset,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeOffset.value, 0),
          child: child,
        );
      },
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: Border.fromBorderSide(borderSide),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                autofocus: true,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.maxLength),
                ],
                showCursor: false,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final text = _controller.text;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.maxLength, (i) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _focusField,
                        child: SizedBox(
                          width: 20.w,
                          child: Center(child: _buildSlotContent(i, text)),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
