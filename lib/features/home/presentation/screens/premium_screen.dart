import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import 'home_tab_components.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: const ValueKey('premium-screen'),
      child: OotTabPage(
        eyebrow: 'Premium discovery',
        title: 'Standout',
        subtitle:
            'Meet a curated group of especially stylish, magnetic people.',
        trailing: Container(
          width: 46.w,
          height: 46.w,
          decoration: const BoxDecoration(
            color: AppColors.surfaceSelected,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.diamond_outlined,
            color: AppColors.accent,
            size: 22.sp,
          ),
        ),
        children: [
          _PremiumHero(onPressed: () => _showPlanMessage(context)),
          SizedBox(height: 24.h),
          const OotSectionTitle('Featured today'),
          SizedBox(height: 12.h),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: .72,
            children: const [
              _StandoutProfileCard(
                image: 'assets/images/profile_onboarding3.png',
                name: 'Serena, 29',
                detail: 'Seoul · Creative director',
                signal: 'Refined style',
              ),
              _StandoutProfileCard(
                image: 'assets/images/profile_onboarding2.png',
                name: 'Ren, 31',
                detail: 'Tokyo · Architect',
                signal: 'Magnetic energy',
              ),
              _StandoutProfileCard(
                image: 'assets/images/profile_onboarding.png',
                name: 'Mio, 28',
                detail: 'Kyoto · Art curator',
                signal: 'Elegant profile',
              ),
              _StandoutProfileCard(
                image: 'assets/images/profile_onboarding3.png',
                name: 'Jiwon, 30',
                detail: 'Busan · Founder',
                signal: 'Confident presence',
              ),
            ],
          ),
          SizedBox(height: 24.h),
          const OotSectionTitle('Why they stand out'),
          SizedBox(height: 12.h),
          const OotSurfaceCard(
            child: Column(
              children: [
                _PremiumBenefit(
                  icon: Icons.diamond_outlined,
                  title: 'Elevated profiles',
                  detail:
                      'Polished people with distinctive style and presence.',
                ),
                _BenefitDivider(),
                _PremiumBenefit(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Thoughtfully curated',
                  detail: 'A smaller selection chosen for quality, not volume.',
                ),
                _BenefitDivider(),
                _PremiumBenefit(
                  icon: Icons.refresh_rounded,
                  title: 'Fresh introductions',
                  detail: 'New standout profiles are added regularly.',
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          _PlanCard(onPressed: () => _showPlanMessage(context)),
        ],
      ),
    );
  }

  void _showPlanMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Standout checkout will open here.')),
    );
  }
}

class _PremiumHero extends StatelessWidget {
  const _PremiumHero({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: .16),
            blurRadius: 28.r,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Text(
              'HANDPICKED',
              style: GoogleFonts.inter(
                color: const Color(0xFFF3C6B8),
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: .8,
              ),
            ),
          ),
          SizedBox(height: 22.h),
          Text(
            'The people who\nturn heads.',
            style: GoogleFonts.cormorant(
              color: Colors.white,
              fontSize: 36.sp,
              height: 1.02,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Discover polished profiles with unmistakable style, confidence, and presence.',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: .7),
              fontSize: 11.sp,
              height: 1.45,
            ),
          ),
          SizedBox(height: 22.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: FilledButton.icon(
              key: const ValueKey('premium-start-button'),
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              icon: const Icon(Icons.diamond_outlined),
              label: Text(
                'Unlock Standout',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StandoutProfileCard extends StatelessWidget {
  const _StandoutProfileCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.signal,
  });

  final String image;
  final String name;
  final String detail;
  final String signal;

  @override
  Widget build(BuildContext context) {
    final profileKey = name.split(',').first.toLowerCase();
    return Container(
      key: ValueKey('standout-profile-$profileKey'),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(image, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xE0392722)],
                stops: [.42, 1],
              ),
            ),
          ),
          Positioned(
            left: 10.w,
            top: 10.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: .92),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'STANDOUT',
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .5,
                ),
              ),
            ),
          ),
          Positioned(
            left: 14.w,
            right: 14.w,
            bottom: 14.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.cormorant(
                    color: Colors.white,
                    fontSize: 24.sp,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: .82),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    signal,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
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

class _PremiumBenefit extends StatelessWidget {
  const _PremiumBenefit({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: const BoxDecoration(
            color: AppColors.surfaceSelected,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.accent, size: 20.sp),
        ),
        SizedBox(width: 13.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                detail,
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 10.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitDivider extends StatelessWidget {
  const _BenefitDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: const Divider(height: 1, color: AppColors.border),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OotSurfaceCard(
      color: AppColors.surfaceSelected,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ANNUAL · BEST VALUE',
                  style: GoogleFonts.inter(
                    color: AppColors.accent,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .5,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '₩12,900 / month',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Choose annual plan',
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_forward_rounded),
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}
