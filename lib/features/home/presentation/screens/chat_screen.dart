import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import 'home_tab_components.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _query = '';

  static const _conversations = [
    (
      name: 'Hana',
      preview: 'Kyoto in late summer sounds perfect.',
      time: '2m',
      image: 'assets/images/profile_onboarding3.png',
      unread: 2,
    ),
    (
      name: 'Mina',
      preview: 'I know a small café near Daikanyama ☕',
      time: '1h',
      image: 'assets/images/profile_onboarding2.png',
      unread: 0,
    ),
    (
      name: 'Yuna',
      preview: 'Your quiz answer made me laugh.',
      time: 'Tue',
      image: 'assets/images/profile_onboarding.png',
      unread: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = _conversations
        .where((item) => item.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return KeyedSubtree(
      key: const ValueKey('chat-screen'),
      child: OotTabPage(
        eyebrow: 'Messages',
        title: 'Chat',
        subtitle: 'Conversations that started with something in common.',
        trailing: IconButton.filledTonal(
          tooltip: 'New message',
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surfaceSelected,
          ),
          icon: const Icon(Icons.edit_outlined, color: AppColors.accent),
        ),
        children: [
          TextField(
            key: const ValueKey('chat-search'),
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search conversations',
              hintStyle: GoogleFonts.inter(
                color: AppColors.textMuted,
                fontSize: 12.sp,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.textMuted,
                size: 20.sp,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: EdgeInsets.symmetric(vertical: 14.h),
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
          SizedBox(height: 22.h),
          const OotSectionTitle('New matches'),
          SizedBox(height: 12.h),
          const _NewMatches(),
          SizedBox(height: 24.h),
          OotSectionTitle(
            'Messages',
            action: Text(
              '${visible.length} conversations',
              style: GoogleFonts.inter(
                color: AppColors.textMuted,
                fontSize: 9.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          OotSurfaceCard(
            padding: EdgeInsets.zero,
            child: visible.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(28.r),
                    child: Center(
                      child: Text(
                        'No conversations found',
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      for (var index = 0; index < visible.length; index++) ...[
                        _ConversationTile(item: visible[index]),
                        if (index < visible.length - 1)
                          Padding(
                            padding: EdgeInsets.only(left: 82.w),
                            child: const Divider(
                              height: 1,
                              color: AppColors.border,
                            ),
                          ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _NewMatches extends StatelessWidget {
  const _NewMatches();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _MatchAvatar(
            image: 'assets/images/profile_onboarding.png',
            name: 'Aoi',
          ),
          _MatchAvatar(
            image: 'assets/images/profile_onboarding2.png',
            name: 'Mina',
          ),
          _MatchAvatar(
            image: 'assets/images/profile_onboarding3.png',
            name: 'Hana',
          ),
        ],
      ),
    );
  }
}

class _MatchAvatar extends StatelessWidget {
  const _MatchAvatar({required this.image, required this.name});

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 18.w),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            padding: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: ClipOval(child: Image.asset(image, fit: BoxFit.cover)),
          ),
          SizedBox(height: 6.h),
          Text(
            name,
            style: GoogleFonts.inter(
              color: AppColors.label,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.item});

  final ({String name, String preview, String time, String image, int unread})
  item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      leading: CircleAvatar(
        radius: 27.r,
        backgroundImage: AssetImage(item.image),
      ),
      title: Text(
        item.name,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        item.preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 10.sp),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            item.time,
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 9.sp,
            ),
          ),
          if (item.unread > 0) ...[
            SizedBox(height: 5.h),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${item.unread}',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
