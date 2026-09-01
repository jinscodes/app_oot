import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import 'home_tab_components.dart';

class HeartScreen extends StatefulWidget {
  const HeartScreen({super.key});

  @override
  State<HeartScreen> createState() => _HeartScreenState();
}

class _HeartScreenState extends State<HeartScreen> {
  bool _showLikedYou = true;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: const ValueKey('heart-screen'),
      child: OotTabPage(
        eyebrow: 'Connections',
        title: 'Heart',
        subtitle: 'A quiet place for people you want to remember.',
        trailing: Container(
          width: 46.w,
          height: 46.w,
          decoration: const BoxDecoration(
            color: AppColors.surfaceSelected,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite_border_rounded,
            color: AppColors.accent,
            size: 22.sp,
          ),
        ),
        children: [
          _HeartToggle(
            showLikedYou: _showLikedYou,
            onChanged: (value) => setState(() => _showLikedYou = value),
          ),
          SizedBox(height: 20.h),
          OotSectionTitle(
            _showLikedYou ? 'They noticed you' : 'Your saved people',
          ),
          SizedBox(height: 12.h),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: .73,
            children: _showLikedYou
                ? const [
                    _HeartProfileCard(
                      image: 'assets/images/profile_onboarding2.png',
                      name: 'Mina, 28',
                      detail: 'Tokyo · 84% match',
                    ),
                    _HeartProfileCard(
                      image: 'assets/images/profile_onboarding3.png',
                      name: 'Hana, 29',
                      detail: 'Seoul · 90% match',
                    ),
                  ]
                : const [
                    _HeartProfileCard(
                      image: 'assets/images/profile_onboarding.png',
                      name: 'Yuna, 30',
                      detail: 'Busan · 78% match',
                    ),
                    _HeartProfileCard(
                      image: 'assets/images/profile_onboarding2.png',
                      name: 'Aoi, 27',
                      detail: 'Kyoto · 82% match',
                    ),
                  ],
          ),
          SizedBox(height: 20.h),
          OotSurfaceCard(
            color: AppColors.surfaceMuted,
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.accent,
                  size: 21.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Complete a profile quiz to make your next like feel more personal.',
                    style: GoogleFonts.inter(
                      color: AppColors.label,
                      fontSize: 11.sp,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
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

class _HeartToggle extends StatelessWidget {
  const _HeartToggle({required this.showLikedYou, required this.onChanged});

  final bool showLikedYou;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleItem(
              key: const ValueKey('heart-liked-you'),
              label: 'Liked you',
              count: '2',
              selected: showLikedYou,
              onPressed: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _ToggleItem(
              key: const ValueKey('heart-you-liked'),
              label: 'You liked',
              count: '2',
              selected: !showLikedYou,
              onPressed: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    super.key,
    required this.label,
    required this.count,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final String count;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: selected ? AppColors.textPrimary : AppColors.textMuted,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.surfaceSelected
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  count,
                  style: GoogleFonts.inter(
                    color: AppColors.accent,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
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

class _HeartProfileCard extends StatelessWidget {
  const _HeartProfileCard({
    required this.image,
    required this.name,
    required this.detail,
  });

  final String image;
  final String name;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.surfaceMuted),
          Image.asset(image, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xD63B2924)],
                stops: [.42, 1],
              ),
            ),
          ),
          Positioned(
            right: 10.w,
            top: 10.h,
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: .9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: AppColors.primary,
                size: 18.sp,
              ),
            ),
          ),
          Positioned(
            left: 14.w,
            right: 12.w,
            bottom: 14.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.cormorant(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  detail,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: .78),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
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
