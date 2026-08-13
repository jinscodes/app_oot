import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _baseMatchScore = 72;

  String _selectedFilter = 'For you';
  int _matchScore = _baseMatchScore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('home-screen'),
      backgroundColor: AppColors.background,
      bottomNavigationBar: const _DiscoveryActionBar(),
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const ValueKey('home-profile-feed'),
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 32.h),
          children: [
            const _DiscoveryHeader(),
            SizedBox(height: 14.h),
            _FilterRow(
              selected: _selectedFilter,
              onFilterPressed: _showFilterSheet,
              onSelected: (value) => setState(() => _selectedFilter = value),
            ),
            SizedBox(height: 14.h),
            _MainPhoto(matchScore: _matchScore),
            SizedBox(height: 16.h),
            const _ProfileBox(),
            SizedBox(height: 16.h),
            _QuizCard(matchScore: _matchScore, onPressed: _showQuizSheet),
            SizedBox(height: 24.h),
            const _MomentSection(),
            SizedBox(height: 24.h),
            const _PromptAnswerCard(),
          ],
        ),
      ),
    );
  }

  Future<void> _showFilterSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _FilterSheet(),
    );
  }

  Future<void> _showQuizSheet() async {
    final correctAnswers = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _QuizSheet(),
    );
    if (correctAnswers == null || !mounted) return;

    setState(() => _matchScore = _baseMatchScore + correctAnswers * 6);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$correctAnswers of 3 correct · Match updated to $_matchScore%',
        ),
      ),
    );
  }
}

class _DiscoveryHeader extends StatelessWidget {
  const _DiscoveryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TODAY'S INTRODUCTION",
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Discover someone',
                style: GoogleFonts.cormorant(
                  color: AppColors.textPrimary,
                  fontSize: 34.sp,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: AppColors.surfaceSoft,
          shape: const CircleBorder(),
          child: IconButton(
            key: const ValueKey('home-profile-button'),
            tooltip: 'Your profile',
            onPressed: () {},
            icon: Icon(
              Icons.person_outline_rounded,
              color: AppColors.label,
              size: 21.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.selected,
    required this.onFilterPressed,
    required this.onSelected,
  });

  final String selected;
  final VoidCallback onFilterPressed;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterButton(onPressed: onFilterPressed),
          SizedBox(width: 8.w),
          for (final item in const ['For you', 'Seoul', '27–32']) ...[
            _FilterChip(
              label: item,
              selected: selected == item,
              onPressed: () => onSelected(item),
            ),
            SizedBox(width: 8.w),
          ],
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textPrimary,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        key: const ValueKey('home-filter-button'),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Icon(Icons.filter_list_rounded, size: 17.sp, color: Colors.white),
              SizedBox(width: 7.w),
              Text(
                'Filter',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.surfaceSelected : AppColors.surface,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? AppColors.accent : AppColors.border),
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: selected ? AppColors.accent : AppColors.label,
                fontSize: 12.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainPhoto extends StatelessWidget {
  const _MainPhoto({required this.matchScore});

  final int matchScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('home-main-photo'),
      height: 510.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: .15),
            blurRadius: 26.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/profile_onboarding3.png',
            fit: BoxFit.cover,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xD1321C18),
                ],
                stops: [.0, .54, 1],
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            top: 16.h,
            child: const _PhotoBadge(label: 'CURATED FOR YOU'),
          ),
          Positioned(
            right: 16.w,
            top: 16.h,
            child: _PhotoBadge(label: '$matchScore% match', filled: true),
          ),
          Positioned(
            left: 22.w,
            right: 22.w,
            bottom: 22.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hana, 29',
                  style: GoogleFonts.cormorant(
                    color: Colors.white,
                    fontSize: 44.sp,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Product designer  ·  Seongsu, Seoul',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: .86),
                    fontSize: 12.sp,
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

class _PhotoBadge extends StatelessWidget {
  const _PhotoBadge({required this.label, this.filled = false});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: filled
            ? AppColors.accent
            : AppColors.surface.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: filled ? Colors.white : AppColors.label,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: filled ? 0 : .4,
          ),
        ),
      ),
    );
  }
}

class _ProfileBox extends StatelessWidget {
  const _ProfileBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('home-profile-box'),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'At a glance',
                  style: GoogleFonts.cormorant(
                    color: AppColors.textPrimary,
                    fontSize: 25.sp,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSelected,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  'FROM PROFILE SETUP',
                  style: GoogleFonts.inter(
                    color: AppColors.accent,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'The essentials Hana shared when she joined.',
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 11.sp,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Divider(height: 1, color: AppColors.border),
          ),
          const Row(
            children: [
              Expanded(
                child: _ProfileFact(label: 'AGE', value: '29'),
              ),
              Expanded(
                child: _ProfileFact(label: 'HEIGHT', value: '168 cm'),
              ),
              Expanded(
                child: _ProfileFact(label: 'LOCATION', value: 'Seoul'),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Icon(Icons.school_outlined, size: 18.sp, color: AppColors.accent),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'SNU · Bachelor’s  ·  Product designer',
                  style: GoogleFonts.inter(
                    color: AppColors.label,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileFact extends StatelessWidget {
  const _ProfileFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.accent,
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: .7,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({required this.matchScore, required this.onPressed});

  final int matchScore;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('home-quiz-card'),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Text(
                  'HANA WROTE THIS',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF3C6B8),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .3,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                matchScore == _HomeScreenState._baseMatchScore
                    ? '$matchScore% → up to 90%'
                    : '$matchScore% match',
                style: GoogleFonts.inter(
                  color: const Color(0xFFF3C6B8),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'How well do you know Hana?',
            style: GoogleFonts.cormorant(
              color: Colors.white,
              fontSize: 27.sp,
              height: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            '3 questions · Each right answer raises your match',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: .67),
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: FilledButton(
              key: const ValueKey('home-quiz-button'),
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    matchScore == _HomeScreenState._baseMatchScore
                        ? 'Start her quiz'
                        : 'Try the quiz again',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_rounded, size: 18.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MomentSection extends StatelessWidget {
  const _MomentSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('home-photo-comments'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'More moments',
                style: GoogleFonts.cormorant(
                  color: AppColors.textPrimary,
                  fontSize: 27.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '2 OF 5',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: .6,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        const _MomentCard(
          imageAsset: 'assets/images/profile_onboarding2.png',
          comment: 'Late summer in Kyoto — my favorite kind of evening.',
        ),
        SizedBox(height: 14.h),
        const _MomentCard(
          imageAsset: 'assets/images/profile_onboarding.png',
          comment: 'Sunday mornings are for long walks and tiny cafés.',
        ),
      ],
    );
  }
}

class _MomentCard extends StatelessWidget {
  const _MomentCard({required this.imageAsset, required this.comment});

  final String imageAsset;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 205.h,
            child: Image.asset(imageAsset, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceSelected,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.format_quote_rounded,
                    size: 16.sp,
                    color: AppColors.accent,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    comment,
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

class _PromptAnswerCard extends StatelessWidget {
  const _PromptAnswerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('home-prompt-answer'),
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceSelected,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFFE4C9BF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROMPT',
            style: GoogleFonts.inter(
              color: AppColors.accent,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'My ideal Sunday looks like…',
            style: GoogleFonts.inter(
              color: AppColors.label,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '“A slow breakfast, a neighborhood walk, and cooking something new with music on.”',
            style: GoogleFonts.cormorant(
              color: AppColors.textPrimary,
              fontSize: 27.sp,
              height: 1.12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'A good place to start a conversation',
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoveryActionBar extends StatelessWidget {
  const _DiscoveryActionBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 82.h,
        margin: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: .09),
              blurRadius: 20.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BottomAction(label: 'Pass', icon: Icons.close_rounded),
            _BottomAction(label: 'Save', icon: Icons.bookmark_border_rounded),
            _BottomAction(
              label: 'Say hi',
              icon: Icons.favorite_rounded,
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({
    required this.label,
    required this.icon,
    this.primary = false,
  });

  final String label;
  final IconData icon;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary ? AppColors.accent : AppColors.surfaceSoft,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20.r),
        child: SizedBox(
          width: primary ? 104.w : 72.w,
          height: 58.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: primary ? Colors.white : AppColors.accent,
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: primary ? Colors.white : AppColors.label,
                  fontSize: 10.sp,
                  fontWeight: primary ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
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
            SizedBox(height: 20.h),
            Text(
              'Refine introductions',
              style: GoogleFonts.cormorant(
                color: AppColors.textPrimary,
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Prioritize location, age, and height without hiding great matches.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                height: 1.45,
              ),
            ),
            SizedBox(height: 20.h),
            const _FilterSummaryRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: 'Seoul · within 15 km',
            ),
            const _FilterSummaryRow(
              icon: Icons.cake_outlined,
              label: 'Age',
              value: '27–32',
            ),
            const _FilterSummaryRow(
              icon: Icons.height_rounded,
              label: 'Height',
              value: 'No preference',
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: const Text('Show introductions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSummaryRow extends StatelessWidget {
  const _FilterSummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizSheet extends StatefulWidget {
  const _QuizSheet();

  @override
  State<_QuizSheet> createState() => _QuizSheetState();
}

class _QuizSheetState extends State<_QuizSheet> {
  static const _questions = [
    (
      prompt: 'Her perfect slow morning?',
      options: ['A long breakfast and a walk', 'An early gym class'],
      answer: 0,
    ),
    (
      prompt: 'A city she always returns to?',
      options: ['Tokyo', 'Kyoto'],
      answer: 1,
    ),
    (
      prompt: 'What would she cook together?',
      options: ['Something new', 'The same pasta every time'],
      answer: 0,
    ),
  ];

  final Map<int, int> _answers = {};

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .8,
      minChildSize: .62,
      maxChildSize: .94,
      expand: false,
      builder: (context, controller) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            controller: controller,
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
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
              SizedBox(height: 20.h),
              Text(
                "Hana's compatibility quiz",
                style: GoogleFonts.cormorant(
                  color: AppColors.textPrimary,
                  fontSize: 31.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Every correct answer adds 6% to your match score.',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 20.h),
              for (var index = 0; index < _questions.length; index++) ...[
                _QuizQuestion(
                  number: index + 1,
                  prompt: _questions[index].prompt,
                  options: _questions[index].options,
                  selected: _answers[index],
                  onSelected: (answer) =>
                      setState(() => _answers[index] = answer),
                ),
                SizedBox(height: 16.h),
              ],
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: FilledButton(
                  key: const ValueKey('submit-quiz-answers'),
                  onPressed: _answers.length == _questions.length
                      ? () {
                          var correct = 0;
                          for (var i = 0; i < _questions.length; i++) {
                            if (_answers[i] == _questions[i].answer) correct++;
                          }
                          Navigator.pop(context, correct);
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    disabledBackgroundColor: AppColors.accent.withValues(
                      alpha: .35,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  child: const Text('Submit answers'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizQuestion extends StatelessWidget {
  const _QuizQuestion({
    required this.number,
    required this.prompt,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final int number;
  final String prompt;
  final List<String> options;
  final int? selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number. $prompt',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        for (var index = 0; index < options.length; index++)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Material(
              color: selected == index
                  ? AppColors.surfaceSelected
                  : AppColors.background,
              borderRadius: BorderRadius.circular(15.r),
              child: InkWell(
                onTap: () => onSelected(index),
                borderRadius: BorderRadius.circular(15.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 13.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: selected == index
                          ? AppColors.accent
                          : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          color: selected == index
                              ? AppColors.accent
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected == index
                                ? AppColors.accent
                                : AppColors.borderStrong,
                          ),
                        ),
                        child: selected == index
                            ? Icon(
                                Icons.check_rounded,
                                size: 12.sp,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          options[index],
                          style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
