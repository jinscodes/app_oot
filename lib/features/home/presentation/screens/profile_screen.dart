import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import 'edit_profile_screen.dart';
import 'home_tab_components.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.onLogout});

  final Future<void> Function()? onLogout;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: const ValueKey('profile-screen'),
      child: OotTabPage(
        eyebrow: 'Your account',
        title: 'Profile',
        subtitle:
            'Keep your story current so introductions feel more like you.',
        trailing: IconButton.filledTonal(
          tooltip: 'Settings',
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surfaceSelected,
          ),
          icon: const Icon(Icons.settings_outlined, color: AppColors.accent),
        ),
        children: [
          _ProfileIdentity(onEdit: () => _openEditProfile(context)),
          SizedBox(height: 16.h),
          const _CompletenessCard(),
          SizedBox(height: 22.h),
          const OotSectionTitle('Your profile'),
          SizedBox(height: 10.h),
          OotSurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ProfileMenuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit profile',
                  subtitle: 'Photos, details, prompts, and quizzes',
                  onTap: () => _openEditProfile(context),
                ),
                const _ProfileMenuDivider(),
                const _ProfileMenuItem(
                  icon: Icons.tune_rounded,
                  title: 'Discovery preferences',
                  subtitle: 'Location, age range, and intentions',
                ),
                const _ProfileMenuDivider(),
                const _ProfileMenuItem(
                  icon: Icons.shield_outlined,
                  title: 'Safety & privacy',
                  subtitle: 'Visibility, blocked accounts, and policies',
                ),
                const _ProfileMenuDivider(),
                const _ProfileMenuItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Matches, messages, and updates',
                ),
              ],
            ),
          ),
          if (onLogout != null) ...[
            SizedBox(height: 16.h),
            OotSurfaceCard(
              padding: EdgeInsets.zero,
              child: _ProfileMenuItem(
                key: const ValueKey('profile-logout-button'),
                icon: Icons.logout_rounded,
                title: 'Log out',
                subtitle: 'Sign out securely on this device',
                onTap: onLogout,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openEditProfile(BuildContext context) async {
    final result = await Navigator.of(context).push<EditProfileData>(
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    if (result == null || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Profile changes saved.')));
  }
}

class _ProfileIdentity extends StatelessWidget {
  const _ProfileIdentity({required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return OotSurfaceCard(
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 82.w,
                height: 82.w,
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const ClipOval(
                  child: Image(
                    image: AssetImage('assets/images/profile_onboarding.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: -2.w,
                bottom: 1.h,
                child: Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 18.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jay Han, 29',
                  style: GoogleFonts.cormorant(
                    color: AppColors.textPrimary,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Chicago · Product designer',
                  style: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                TextButton.icon(
                  key: const ValueKey('profile-edit-button'),
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Icon(Icons.edit_outlined, size: 15.sp),
                  label: Text(
                    'Edit profile',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
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

class _CompletenessCard extends StatelessWidget {
  const _CompletenessCard();

  @override
  Widget build(BuildContext context) {
    return OotSurfaceCard(
      color: AppColors.textPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'PROFILE STRENGTH',
                style: GoogleFonts.inter(
                  color: const Color(0xFFF3C6B8),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .7,
                ),
              ),
              const Spacer(),
              Text(
                '82%',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: .82,
              minHeight: 7.h,
              backgroundColor: Colors.white.withValues(alpha: .12),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Add one more photo comment to help people start a better conversation.',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: .7),
              fontSize: 10.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap ?? () {},
      contentPadding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 7.h),
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: const BoxDecoration(
          color: AppColors.surfaceSelected,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.accent, size: 19.sp),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 9.sp),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textMuted,
        size: 21.sp,
      ),
    );
  }
}

class _ProfileMenuDivider extends StatelessWidget {
  const _ProfileMenuDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 72.w),
      child: const Divider(height: 1, color: AppColors.border),
    );
  }
}
