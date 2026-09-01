import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import 'chat_screen.dart';
import 'heart_screen.dart';
import 'premium_screen.dart';
import 'profile_screen.dart';

typedef _PhotoLikeCallback =
    Future<void> Function({
      required String photoId,
      required String photoLabel,
      required String imageAsset,
    });

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onLogout});

  final Future<void> Function()? onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _baseMatchScore = 72;

  final Set<String> _selectedFilters = {};
  final Set<String> _likedPhotos = {};
  RangeValues? _ageRange;
  RangeValues? _heightRange;
  String? _datingIntention;
  int _matchScore = _baseMatchScore;
  int _selectedNavigationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('home-screen'),
      backgroundColor: AppColors.background,
      bottomNavigationBar: _OotBottomNavigation(
        currentIndex: _selectedNavigationIndex,
        onSelected: (index) => setState(() => _selectedNavigationIndex = index),
      ),
      body: IndexedStack(
        index: _selectedNavigationIndex,
        children: [
          SafeArea(
            bottom: false,
            child: ListView(
              key: const ValueKey('home-profile-feed'),
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 32.h),
              children: [
                _FilterRow(
                  selected: _selectedFilters,
                  ageRange: _ageRange,
                  heightRange: _heightRange,
                  datingIntention: _datingIntention,
                  onAgePressed: _showAgeFilter,
                  onHeightPressed: _showHeightFilter,
                  onDatingIntentionPressed: _showDatingIntentionFilter,
                  onMorePressed: _showFilterSheet,
                  onToggle: (value) => setState(() {
                    if (!_selectedFilters.add(value)) {
                      _selectedFilters.remove(value);
                    }
                  }),
                ),
                SizedBox(height: 14.h),
                _MainPhoto(
                  matchScore: _matchScore,
                  onLike: () => _showPhotoLike(
                    photoId: 'main',
                    photoLabel: "Hana's main photo",
                    imageAsset: 'assets/images/profile_onboarding3.png',
                  ),
                ),
                SizedBox(height: 16.h),
                const _ProfileBox(),
                SizedBox(height: 16.h),
                _QuizCard(matchScore: _matchScore, onPressed: _showQuizSheet),
                SizedBox(height: 24.h),
                _MomentSection(
                  likedPhotos: _likedPhotos,
                  onLike:
                      ({
                        required photoId,
                        required photoLabel,
                        required imageAsset,
                      }) => _showPhotoLike(
                        photoId: photoId,
                        photoLabel: photoLabel,
                        imageAsset: imageAsset,
                      ),
                ),
                SizedBox(height: 24.h),
                const _PromptAnswerCard(),
              ],
            ),
          ),
          const PremiumScreen(),
          const HeartScreen(),
          const ChatScreen(),
          ProfileScreen(onLogout: widget.onLogout),
        ],
      ),
    );
  }

  Future<void> _showFilterSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterSheet(
        selected: _selectedFilters,
        ageRange: _ageRange,
        heightRange: _heightRange,
        datingIntention: _datingIntention,
      ),
    );
  }

  Future<void> _showAgeFilter() async {
    final range = await showModalBottomSheet<RangeValues>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RangeFilterSheet(
        title: 'Define age range',
        description: 'Choose the age range you would like to meet.',
        initialValues: _ageRange ?? const RangeValues(25, 35),
        min: 18,
        max: 65,
        divisions: 47,
        sliderKey: const ValueKey('age-range-slider'),
        applyKey: const ValueKey('apply-age-range'),
        formatValue: (value) => value.round().toString(),
      ),
    );
    if (range == null || !mounted) return;
    setState(() => _ageRange = range);
  }

  Future<void> _showHeightFilter() async {
    final range = await showModalBottomSheet<RangeValues>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RangeFilterSheet(
        title: 'Define height range',
        description: 'Choose a preferred height range in centimeters.',
        initialValues: _heightRange ?? const RangeValues(155, 185),
        min: 140,
        max: 210,
        divisions: 70,
        sliderKey: const ValueKey('height-range-slider'),
        applyKey: const ValueKey('apply-height-range'),
        formatValue: (value) => '${value.round()} cm',
      ),
    );
    if (range == null || !mounted) return;
    setState(() => _heightRange = range);
  }

  Future<void> _showDatingIntentionFilter() async {
    final intention = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _DatingIntentionSheet(initialValue: _datingIntention),
    );
    if (intention == null || !mounted) return;
    setState(() => _datingIntention = intention);
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

  Future<void> _showPhotoLike({
    required String photoId,
    required String photoLabel,
    required String imageAsset,
  }) async {
    final comment = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _PhotoLikeSheet(photoLabel: photoLabel, imageAsset: imageAsset),
    );
    if (comment == null || !mounted) return;

    setState(() => _likedPhotos.add(photoId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          comment.isEmpty
              ? 'Like sent to Hana.'
              : 'Like and comment sent to Hana.',
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.selected,
    required this.ageRange,
    required this.heightRange,
    required this.datingIntention,
    required this.onAgePressed,
    required this.onHeightPressed,
    required this.onDatingIntentionPressed,
    required this.onMorePressed,
    required this.onToggle,
  });

  final Set<String> selected;
  final RangeValues? ageRange;
  final RangeValues? heightRange;
  final String? datingIntention;
  final VoidCallback onAgePressed;
  final VoidCallback onHeightPressed;
  final VoidCallback onDatingIntentionPressed;
  final VoidCallback onMorePressed;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ListView(
        key: const ValueKey('home-filter-row'),
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            key: const ValueKey('home-filter-signals'),
            label: 'Signals',
            selected: selected.contains('Signals'),
            onPressed: () => onToggle('Signals'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            key: const ValueKey('home-filter-age'),
            label: ageRange == null
                ? 'Age'
                : '${ageRange!.start.round()}–${ageRange!.end.round()}',
            selected: ageRange != null,
            trailingIcon: Icons.keyboard_arrow_down_rounded,
            onPressed: onAgePressed,
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            key: const ValueKey('home-filter-height'),
            label: heightRange == null
                ? 'Height'
                : '${heightRange!.start.round()}–${heightRange!.end.round()} cm',
            selected: heightRange != null,
            trailingIcon: Icons.keyboard_arrow_down_rounded,
            onPressed: onHeightPressed,
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            key: const ValueKey('home-filter-dating-intentions'),
            label: _datingIntentionChipLabel(datingIntention),
            selected: datingIntention != null,
            trailingIcon: Icons.keyboard_arrow_down_rounded,
            onPressed: onDatingIntentionPressed,
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            key: const ValueKey('home-filter-active-today'),
            label: 'Active Today',
            selected: selected.contains('Active Today'),
            onPressed: () => onToggle('Active Today'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            key: const ValueKey('home-filter-new-here'),
            label: 'New Here',
            selected: selected.contains('New Here'),
            onPressed: () => onToggle('New Here'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            key: const ValueKey('home-filter-more'),
            label: 'More',
            selected: false,
            trailingIcon: Icons.tune_rounded,
            onPressed: onMorePressed,
          ),
        ],
      ),
    );
  }
}

String _datingIntentionChipLabel(String? value) => switch (value) {
  'Long-term relationship' => 'Long-term',
  'Long-term, open to short' => 'Long-term + short',
  'Short-term relationship' => 'Short-term',
  'Figuring it out' => 'Figuring it out',
  _ => 'Dating Intentions',
};

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
    this.trailingIcon,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final IconData? trailingIcon;

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
            child: Row(
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: selected ? AppColors.accent : AppColors.label,
                    fontSize: 12.sp,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (trailingIcon != null) ...[
                  SizedBox(width: 6.w),
                  Icon(trailingIcon, size: 15.sp, color: AppColors.accent),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MainPhoto extends StatelessWidget {
  const _MainPhoto({required this.matchScore, required this.onLike});

  final int matchScore;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .8,
      child: Container(
        key: const ValueKey('home-main-photo'),
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
            const ColoredBox(color: AppColors.surfaceMuted),
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
              child: _MatchHeartButton(
                key: const ValueKey('photo-like-main'),
                percentage: matchScore,
                onPressed: onLike,
              ),
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
      ),
    );
  }
}

class _PhotoBadge extends StatelessWidget {
  const _PhotoBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.label,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: .4,
          ),
        ),
      ),
    );
  }
}

class _MatchHeartButton extends StatelessWidget {
  const _MatchHeartButton({
    super.key,
    required this.percentage,
    required this.onPressed,
  });

  final int percentage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$percentage% compatibility. Like this photo',
      child: Material(
        color: AppColors.surface.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20.r),
          child: SizedBox(
            width: 58.w,
            height: 62.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PercentageHeart(percentage: percentage, size: 31.sp),
                SizedBox(height: 2.h),
                Text(
                  '$percentage%',
                  style: GoogleFonts.inter(
                    color: AppColors.accent,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PercentageHeart extends StatelessWidget {
  const _PercentageHeart({required this.percentage, required this.size});

  final int percentage;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fraction = (percentage / 100).clamp(0.0, 1.0);
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: size,
            color: AppColors.borderStrong,
          ),
          ClipRect(
            clipper: _BottomFractionClipper(fraction),
            child: Icon(
              Icons.favorite_rounded,
              size: size,
              color: AppColors.primary,
            ),
          ),
          Icon(
            Icons.favorite_border_rounded,
            size: size,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

class _BottomFractionClipper extends CustomClipper<Rect> {
  const _BottomFractionClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(
    0,
    size.height * (1 - fraction),
    size.width,
    size.height * fraction,
  );

  @override
  bool shouldReclip(covariant _BottomFractionClipper oldClipper) =>
      oldClipper.fraction != fraction;
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
  const _MomentSection({required this.likedPhotos, required this.onLike});

  final Set<String> likedPhotos;
  final _PhotoLikeCallback onLike;

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
        _MomentCard(
          photoId: 'kyoto',
          imageAsset: 'assets/images/profile_onboarding2.png',
          comment: 'Late summer in Kyoto — my favorite kind of evening.',
          liked: likedPhotos.contains('kyoto'),
          onLike: () => onLike(
            photoId: 'kyoto',
            photoLabel: "Hana's Kyoto photo",
            imageAsset: 'assets/images/profile_onboarding2.png',
          ),
        ),
        SizedBox(height: 14.h),
        _MomentCard(
          photoId: 'cafe',
          imageAsset: 'assets/images/profile_onboarding.png',
          comment: 'Sunday mornings are for long walks and tiny cafés.',
          liked: likedPhotos.contains('cafe'),
          onLike: () => onLike(
            photoId: 'cafe',
            photoLabel: "Hana's Sunday photo",
            imageAsset: 'assets/images/profile_onboarding.png',
          ),
        ),
      ],
    );
  }
}

class _MomentCard extends StatelessWidget {
  const _MomentCard({
    required this.photoId,
    required this.imageAsset,
    required this.comment,
    required this.liked,
    required this.onLike,
  });

  final String photoId;
  final String imageAsset;
  final String comment;
  final bool liked;
  final VoidCallback onLike;

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
          AspectRatio(
            key: ValueKey('home-photo-frame-$photoId'),
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surfaceMuted),
                Image.asset(imageAsset, fit: BoxFit.cover),
                Positioned(
                  right: 12.w,
                  top: 12.h,
                  child: _PhotoHeartButton(
                    key: ValueKey('photo-like-$photoId'),
                    liked: liked,
                    onPressed: onLike,
                  ),
                ),
              ],
            ),
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

class _PhotoHeartButton extends StatelessWidget {
  const _PhotoHeartButton({
    super.key,
    required this.liked,
    required this.onPressed,
  });

  final bool liked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: .94),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: liked ? 'Photo liked' : 'Like this photo',
        onPressed: onPressed,
        icon: Icon(
          liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: liked ? AppColors.primary : AppColors.accent,
          size: 21.sp,
        ),
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

class _PhotoLikeSheet extends StatefulWidget {
  const _PhotoLikeSheet({required this.photoLabel, required this.imageAsset});

  final String photoLabel;
  final String imageAsset;

  @override
  State<_PhotoLikeSheet> createState() => _PhotoLikeSheetState();
}

class _PhotoLikeSheetState extends State<_PhotoLikeSheet> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
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
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: ColoredBox(
                        color: AppColors.surfaceMuted,
                        child: Image.asset(
                          widget.imageAsset,
                          width: 74.w,
                          height: 74.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SEND A LIKE',
                            style: GoogleFonts.inter(
                              color: AppColors.accent,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: .8,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            widget.photoLabel,
                            style: GoogleFonts.cormorant(
                              color: AppColors.textPrimary,
                              fontSize: 25.sp,
                              height: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 42.w,
                      height: 42.w,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceSelected,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
                        color: AppColors.primary,
                        size: 21.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'Add a comment',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'Optional · Mention something specific from the photo.',
                  style: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  key: const ValueKey('photo-like-comment'),
                  controller: _commentController,
                  maxLength: 200,
                  minLines: 3,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Write a thoughtful comment…',
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.textMuted,
                      fontSize: 12.sp,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.r),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.r),
                      borderSide: const BorderSide(color: AppColors.accent),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: FilledButton.icon(
                    key: const ValueKey('send-photo-like'),
                    onPressed: () =>
                        Navigator.pop(context, _commentController.text.trim()),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                    icon: const Icon(Icons.favorite_rounded),
                    label: Text(
                      'Send like',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OotBottomNavigation extends StatelessWidget {
  const _OotBottomNavigation({
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  static const _destinations = [
    (label: 'Home', icon: Icons.home_rounded),
    (label: 'Premium', icon: Icons.diamond_outlined),
    (label: 'Heart', icon: Icons.favorite_border_rounded),
    (label: 'Chat', icon: Icons.chat_bubble_outline_rounded),
    (label: 'Profile', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('bottom-navigation'),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Row(
              children: [
                for (var index = 0; index < _destinations.length; index++)
                  Expanded(
                    child: _NavigationDestination(
                      key: ValueKey(
                        'bottom-nav-${_destinations[index].label.toLowerCase()}',
                      ),
                      label: _destinations[index].label,
                      icon: _destinations[index].icon,
                      selected: currentIndex == index,
                      onPressed: () => onSelected(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationDestination extends StatelessWidget {
  const _NavigationDestination({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: '$label tab',
      child: ExcludeSemantics(
        child: Material(
          color: selected ? AppColors.surfaceSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(18.r),
            child: SizedBox(
              height: 54.h,
              child: Center(
                child: Icon(
                  icon,
                  size: 23.sp,
                  color: selected ? AppColors.accent : AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet({
    required this.selected,
    required this.ageRange,
    required this.heightRange,
    required this.datingIntention,
  });

  final Set<String> selected;
  final RangeValues? ageRange;
  final RangeValues? heightRange;
  final String? datingIntention;

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
              'Choose which signals should shape the people you see first.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                height: 1.45,
              ),
            ),
            SizedBox(height: 20.h),
            _FilterSummaryRow(
              icon: Icons.auto_awesome_outlined,
              label: 'Signals',
              value: selected.contains('Signals')
                  ? 'Values & compatibility'
                  : 'Any',
            ),
            _FilterSummaryRow(
              icon: Icons.cake_outlined,
              label: 'Age',
              value: ageRange == null
                  ? 'Any age'
                  : '${ageRange!.start.round()}–${ageRange!.end.round()}',
            ),
            _FilterSummaryRow(
              icon: Icons.height_rounded,
              label: 'Height',
              value: heightRange == null
                  ? 'Any height'
                  : '${heightRange!.start.round()}–${heightRange!.end.round()} cm',
            ),
            _FilterSummaryRow(
              icon: Icons.favorite_border_rounded,
              label: 'Dating intentions',
              value: datingIntention ?? 'Any intention',
            ),
            _FilterSummaryRow(
              icon: Icons.bolt_outlined,
              label: 'Active today',
              value: selected.contains('Active Today') ? 'Included' : 'Any',
            ),
            _FilterSummaryRow(
              icon: Icons.new_releases_outlined,
              label: 'New here',
              value: selected.contains('New Here') ? 'Included' : 'Any',
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

class _RangeFilterSheet extends StatefulWidget {
  const _RangeFilterSheet({
    required this.title,
    required this.description,
    required this.initialValues,
    required this.min,
    required this.max,
    required this.divisions,
    required this.sliderKey,
    required this.applyKey,
    required this.formatValue,
  });

  final String title;
  final String description;
  final RangeValues initialValues;
  final double min;
  final double max;
  final int divisions;
  final Key sliderKey;
  final Key applyKey;
  final String Function(double value) formatValue;

  @override
  State<_RangeFilterSheet> createState() => _RangeFilterSheetState();
}

class _RangeFilterSheetState extends State<_RangeFilterSheet> {
  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    _values = widget.initialValues;
  }

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
            const _BottomSheetHandle(),
            SizedBox(height: 20.h),
            Text(
              widget.title,
              style: GoogleFonts.cormorant(
                color: AppColors.textPrimary,
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 7.h),
            Text(
              widget.description,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                height: 1.45,
              ),
            ),
            SizedBox(height: 28.h),
            Center(
              child: Text(
                '${widget.formatValue(_values.start)}  –  ${widget.formatValue(_values.end)}',
                key: const ValueKey('selected-range-value'),
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 18.h),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.accent,
                inactiveTrackColor: AppColors.progressTrack,
                thumbColor: AppColors.surface,
                overlayColor: AppColors.accent.withValues(alpha: .12),
                rangeThumbShape: RoundRangeSliderThumbShape(
                  enabledThumbRadius: 11.r,
                  elevation: 1,
                ),
                trackHeight: 4.h,
              ),
              child: RangeSlider(
                key: widget.sliderKey,
                values: _values,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                labels: RangeLabels(
                  widget.formatValue(_values.start),
                  widget.formatValue(_values.end),
                ),
                onChanged: (values) => setState(() => _values = values),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.formatValue(widget.min),
                    style: GoogleFonts.inter(
                      color: AppColors.textMuted,
                      fontSize: 11.sp,
                    ),
                  ),
                  Text(
                    widget.formatValue(widget.max),
                    style: GoogleFonts.inter(
                      color: AppColors.textMuted,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: FilledButton(
                key: widget.applyKey,
                onPressed: () => Navigator.pop(context, _values),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: const Text('Apply range'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatingIntentionSheet extends StatefulWidget {
  const _DatingIntentionSheet({required this.initialValue});

  final String? initialValue;

  @override
  State<_DatingIntentionSheet> createState() => _DatingIntentionSheetState();
}

class _DatingIntentionSheetState extends State<_DatingIntentionSheet> {
  static const _options = [
    'Long-term relationship',
    'Long-term, open to short',
    'Short-term relationship',
    'Figuring it out',
  ];

  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

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
            const _BottomSheetHandle(),
            SizedBox(height: 20.h),
            Text(
              'Define dating intention',
              style: GoogleFonts.cormorant(
                color: AppColors.textPrimary,
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 7.h),
            Text(
              'Choose one intention. Nothing is selected by default.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                height: 1.45,
              ),
            ),
            SizedBox(height: 20.h),
            for (final option in _options)
              Padding(
                padding: EdgeInsets.only(bottom: 9.h),
                child: _DatingIntentionOption(
                  key: ValueKey(
                    'dating-intention-${option.toLowerCase().replaceAll(RegExp(r'[^a-z]+'), '-')}',
                  ),
                  label: option,
                  selected: _selected == option,
                  onPressed: () => setState(() => _selected = option),
                ),
              ),
            SizedBox(height: 11.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: FilledButton(
                key: const ValueKey('apply-dating-intention'),
                onPressed: _selected == null
                    ? null
                    : () => Navigator.pop(context, _selected),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  disabledBackgroundColor: AppColors.accent.withValues(
                    alpha: .35,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: const Text('Apply intention'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatingIntentionOption extends StatelessWidget {
  const _DatingIntentionOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.surfaceSelected : AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: selected ? AppColors.accent : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.accent
                          : AppColors.borderStrong,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? const DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.borderStrong,
          borderRadius: BorderRadius.circular(2.r),
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
