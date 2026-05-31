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
  });

  final TextEditingController? controller;
  final int maxLength;
  final ValueChanged<bool>? onValidityChanged;

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  late TextEditingController _controller;
  bool _ownsController = false;
  final FocusNode _focusNode = FocusNode();

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
  }

  @override
  void dispose() {
    _controller.removeListener(_emitValidity);
    if (_ownsController) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _emitValidity() {
    widget.onValidityChanged?.call(_controller.text.isNotEmpty);
  }

  void _focusField() => _focusNode.requestFocus();

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(color: AppColors.accent, width: 1.5.w);
    final radius = BorderRadius.circular(16.r);

    return Container(
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
              maxLength: widget.maxLength,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  final digit = i < text.length ? text[i] : null;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _focusField,
                      child: SizedBox(
                        width: 20.w,
                        child: Text(
                          digit ?? '_',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: digit != null
                                ? AppColors.textPrimary
                                : const Color(0xFFBDBDBD),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.0.h,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
