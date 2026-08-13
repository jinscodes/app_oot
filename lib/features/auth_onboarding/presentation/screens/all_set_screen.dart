import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class AllSetScreen extends StatefulWidget {
  const AllSetScreen({super.key, this.onStartExploring});

  final VoidCallback? onStartExploring;

  @override
  State<AllSetScreen> createState() => _AllSetScreenState();
}

class _AllSetScreenState extends State<AllSetScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _topGlowOffset;
  late final Animation<double> _bottomGlowOffset;
  late final Animation<double> _haloOpacity;
  late final Animation<double> _haloScale;
  late final Animation<double> _ringOpacity;
  late final Animation<double> _ringScale;
  late final Animation<double> _mascotOpacity;
  late final Animation<double> _mascotOffset;
  late final Animation<double> _badgeScale;
  late final Animation<double> _badgeRotation;
  late final Animation<double> _copyOpacity;
  late final Animation<double> _copyOffset;
  late final Animation<double> _cardOpacity;
  late final Animation<double> _cardOffset;
  late final Animation<double> _buttonOpacity;
  late final Animation<double> _buttonOffset;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _topGlowOffset = _tween(-12, 0, 0, 1, Curves.easeOutBack);
    _bottomGlowOffset = _tween(14, 0, 0, 1, Curves.easeOutBack);
    _haloOpacity = _tween(.15, 1, .02, .29, Curves.easeOut);
    _haloScale = _tween(.84, 1, .02, .36, Curves.elasticOut);
    _ringOpacity = _tween(0, 1, .08, .42, Curves.easeOut);
    _ringScale = _tween(.72, 1, .08, .51, Curves.easeOutBack);
    _mascotOpacity = _tween(0, 1, .06, .31, Curves.easeOut);
    _mascotOffset = _tween(16, 0, .06, .36, Curves.easeOut);
    _badgeScale = _tween(.5, 1, .21, .52, Curves.elasticOut);
    _badgeRotation = _tween(-math.pi / 10, 0, .21, .52, Curves.elasticOut);
    _copyOpacity = _tween(0, 1, .19, .48, Curves.easeOut);
    _copyOffset = _tween(16, 0, .19, .48, Curves.easeOut);
    _cardOpacity = _tween(0, 1, .29, .58, Curves.easeOut);
    _cardOffset = _tween(14, 0, .29, .58, Curves.easeOut);
    _buttonOpacity = _tween(0, 1, .38, .67, Curves.easeOut);
    _buttonOffset = _tween(10, 0, .38, .67, Curves.easeOut);
  }

  Animation<double> _tween(
    double begin,
    double end,
    double intervalBegin,
    double intervalEnd,
    Curve curve,
  ) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(intervalBegin, intervalEnd, curve: curve),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: 292.w,
            top: -110.h,
            child: _AnimatedOffset(
              animation: _topGlowOffset,
              child: _AmbientGlow(
                diameter: 276.w,
                color: const Color(0x80F3DED7),
              ),
            ),
          ),
          Positioned(
            left: -122.w,
            top: 770.h,
            child: _AnimatedOffset(
              animation: _bottomGlowOffset,
              child: _AmbientGlow(
                diameter: 224.w,
                color: const Color(0xCCF8ECE7),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 104.h, 24.w, 44.h),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CelebrationMark(
                          haloOpacity: _haloOpacity,
                          haloScale: _haloScale,
                          ringOpacity: _ringOpacity,
                          ringScale: _ringScale,
                          mascotOpacity: _mascotOpacity,
                          mascotOffset: _mascotOffset,
                          badgeScale: _badgeScale,
                          badgeRotation: _badgeRotation,
                        ),
                        SizedBox(height: 22.h),
                        _FadeSlide(
                          opacity: _copyOpacity,
                          offset: _copyOffset,
                          child: const _CompletionCopy(),
                        ),
                        SizedBox(height: 22.h),
                        _FadeSlide(
                          opacity: _cardOpacity,
                          offset: _cardOffset,
                          child: const _ReadyStatusCard(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _FadeSlide(
                opacity: _buttonOpacity,
                offset: _buttonOffset,
                child: OotFooterButton(
                  label: 'Start exploring',
                  onPressed: widget.onStartExploring,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CelebrationMark extends StatelessWidget {
  const _CelebrationMark({
    required this.haloOpacity,
    required this.haloScale,
    required this.ringOpacity,
    required this.ringScale,
    required this.mascotOpacity,
    required this.mascotOffset,
    required this.badgeScale,
    required this.badgeRotation,
  });

  final Animation<double> haloOpacity;
  final Animation<double> haloScale;
  final Animation<double> ringOpacity;
  final Animation<double> ringScale;
  final Animation<double> mascotOpacity;
  final Animation<double> mascotOffset;
  final Animation<double> badgeScale;
  final Animation<double> badgeRotation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240.w,
      height: 240.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 16.w,
            top: 12.w,
            child: FadeTransition(
              opacity: haloOpacity,
              child: ScaleTransition(
                scale: haloScale,
                child: Container(
                  width: 208.w,
                  height: 208.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8E9E4),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEECFC4)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F8A5B4B),
                        blurRadius: 34,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 33.w,
            top: 29.w,
            child: FadeTransition(
              opacity: ringOpacity,
              child: ScaleTransition(
                scale: ringScale,
                child: CustomPaint(
                  size: Size.square(174.w),
                  painter: const _DashedCirclePainter(),
                ),
              ),
            ),
          ),
          Positioned(
            left: 60.w,
            top: 66.w,
            child: _FadeSlide(
              opacity: mascotOpacity,
              offset: mascotOffset,
              child: Image.asset(
                'assets/images/talking_logo.png',
                width: 120.w,
                height: 97.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 158.w,
            top: 158.w,
            child: AnimatedBuilder(
              animation: badgeRotation,
              builder: (context, child) => Transform.rotate(
                angle: badgeRotation.value,
                child: ScaleTransition(scale: badgeScale, child: child),
              ),
              child: Container(
                width: 50.w,
                height: 50.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentStrong,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 4.w),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x2E6B4B43),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  '✓',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 21.sp,
                    height: 24 / 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionCopy extends StatelessWidget {
  const _CompletionCopy();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'Profile complete. You’re all set.',
      child: SizedBox(
        width: 392.w,
        height: 156.h,
        child: Column(
          children: [
            SizedBox(
              height: 14.h,
              child: Text(
                'PROFILE COMPLETE',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontSize: 11.sp,
                  height: 14 / 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: .99.w,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 48.h,
              child: Text(
                'You’re all set',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorant(
                  color: AppColors.textPrimary,
                  fontSize: 42.sp,
                  height: 48 / 42,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -.42.w,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: 344.w,
              height: 44.h,
              child: Text(
                'Your profile is ready. Thoughtful introductions are waiting for you.',
                maxLines: 2,
                overflow: TextOverflow.clip,
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
      ),
    );
  }
}

class _ReadyStatusCard extends StatelessWidget {
  const _ReadyStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('ready-status-card'),
      width: 392.w,
      height: 104.h,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x146B4B43),
            blurRadius: 24,
            spreadRadius: -4,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF8E9E4),
              shape: BoxShape.circle,
            ),
            child: Text(
              '✓',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontSize: 18.sp,
                height: 22 / 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your profile is ready',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                    height: 18 / 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'You can edit any detail whenever you like.',
                  style: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 12.sp,
                    height: 18 / 12,
                    fontWeight: FontWeight.w400,
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

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _FadeSlide extends StatelessWidget {
  const _FadeSlide({
    required this.opacity,
    required this.offset,
    required this.child,
  });

  final Animation<double> opacity;
  final Animation<double> offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: _AnimatedOffset(animation: offset, child: child),
    );
  }
}

class _AnimatedOffset extends StatelessWidget {
  const _AnimatedOffset({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, animation.value.h),
        child: child,
      ),
      child: child,
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.shortestSide - 1) / 2;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );
    final paint = Paint()
      ..color = const Color(0x99DDAF9F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final dashAngle = 4 / radius;
    final gapAngle = 7 / radius;

    for (
      var start = -math.pi / 2;
      start < math.pi * 1.5;
      start += dashAngle + gapAngle
    ) {
      canvas.drawArc(rect, start, dashAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
