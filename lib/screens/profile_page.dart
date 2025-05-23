import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/backend/fetch_user_data.dart';
import 'package:ircell/backend/shared_pref.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/login/splash_screen.dart';
import 'package:ircell/screens/edit_profile_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0;

  Map<String, dynamic>? userDetails; // Make it a class-level variable

  @override
  void initState() {
    super.initState();
    loadUserDetails(); // Call the async function
  }

  void loadUserDetails() async {
    final details = await fetchUserDetails();

    if (details == null) {
      print('User not found');
    } else {
      setState(() {
        userDetails = details;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double horizontalPadding = screenSize.width * 0.04;
    final double verticalPadding = screenSize.height * 0.02;
    final double iconSize = screenSize.width * 0.06;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 48),
            Text(
              'Profile',
              style: TextStyle(
                color:
                    Theme.of(
                      context,
                    ).colorScheme.onSurface, // For primary text color,
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.05,
              ),
            ),
            Container(
              decoration: AppTheme.glassDecoration(context),
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: iconSize,
                ),
                onPressed: () async {
                  final userDetails =
                      await fetchUserDetailsForEditing(); // The function you already have

                  if (userDetails != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                EditProfilePage(userDetails: userDetails),
                      ),
                    );
                    loadUserDetails();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User details not found')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppTheme.backgroundColor(context),
      // Wrap the main body in a SafeArea to avoid system intrusions
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
          // Make the entire content scrollable
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header section
                _buildProfileHeader(),

                SizedBox(height: verticalPadding * 1.5),

                // Personal Info & Preferences tabs
                _buildTabSelector(),

                SizedBox(height: verticalPadding),

                // Main content area based on selected tab
                _selectedTab == 0
                    ? _buildPersonalInfoContent()
                    : _buildPreferencesContent(),

                SizedBox(height: verticalPadding),

                // Account actions section at bottom
                _buildAccountActionsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final Size screenSize = MediaQuery.of(context).size;
    final double profilePicSize = screenSize.width * 0.22;
    final double fontSize = screenSize.width * 0.045;
    final double smallFontSize = screenSize.width * 0.035;
    final double spacing = screenSize.height * 0.01;
    final double iconSize = screenSize.width * 0.04;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Align items properly
      children: [
        // Profile Picture with glass decoration
        Container(
          width: profilePicSize,
          height: profilePicSize,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child:
                userDetails == null
                    ? buildShimmer(width: 80, height: profilePicSize * 0.5)
                    : Text(
                      createEmailShortForm(userDetails?['email']),
                      style: TextStyle(
                        fontSize: profilePicSize * 0.5,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
          ),
        ),

        SizedBox(width: screenSize.width * 0.04),

        // Profile name and info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Only take necessary space
            children: [
              userDetails == null
                  ? buildShimmer(width: 160, height: fontSize + 8)
                  : Text(
                    '${userDetails?['first_name'] ?? ''} ${userDetails?['last_name'] ?? ''}',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              SizedBox(height: spacing / 2),
              userDetails == null
                  ? buildShimmer(width: 160, height: fontSize + 8)
                  : Text(
                    userDetails?['email'] ?? '',
                    style: TextStyle(
                      fontSize: smallFontSize,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle text overflow
                  ),
              SizedBox(height: spacing),
              InkWell(
                onTap: () {
                  // QR Code action
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.03,
                    vertical: screenSize.height * 0.006,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      screenSize.width * 0.05,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Only take necessary space
                    children: [
                      Icon(
                        Icons.qr_code,
                        color: AppTheme.accentBlue,
                        size: iconSize,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        'View QR Code',
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: AppTheme.accentBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildShimmer({double width = 150, double height = 16}) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.grey,
      child: Container(width: width, height: height, color: Colors.white),
    );
  }

  Widget _buildTabSelector() {
    final Size screenSize = MediaQuery.of(context).size;
    final double tabHeight = screenSize.height * 0.05;
    final double fontSize = screenSize.width * 0.04;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context).withOpacity(0.5),
        borderRadius: BorderRadius.circular(screenSize.width * 0.03),
      ),
      child: Row(
        children: [
          // Personal Info Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: tabHeight * 0.5),
                decoration: BoxDecoration(
                  color:
                      _selectedTab == 0
                          ? AppTheme.accentBlue.withOpacity(0.3)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(screenSize.width * 0.03),
                ),
                child: Text(
                  'Personal Info',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color:
                        _selectedTab == 0
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight:
                        _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),

          // Preferences Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 1;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: tabHeight * 0.5),
                decoration: BoxDecoration(
                  color:
                      _selectedTab == 1
                          ? AppTheme.accentBlue.withOpacity(0.3)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(screenSize.width * 0.03),
                ),
                child: Text(
                  'Preferences',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color:
                        _selectedTab == 1
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight:
                        _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteUserData() async {
    await FirebaseFirestore.instance
        .collection(userDetails?['source_collection'] ?? '')
        .doc(userDetails?['uid'] ?? "")
        .delete();
  }

  Future<void> deleteUserAuth() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.delete(); // This deletes from Firebase Authentication
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      if (uid != null) {
        // First, delete from Firestore
        await deleteUserData();

        // Then, delete from Firebase Auth
        await deleteUserAuth();

        // Optional: Clear SharedPreferences
        await LocalStorage.clearUID();

        // Navigate to login or landing screen
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Show message to re-login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please re-login to delete your account.")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      }
    }
  }

  String createEmailShortForm(String? email) {
    if (email == null || email.length < 7) return '-';
    return '${email[0].toUpperCase()}${email[6].toUpperCase()}';
  }

  Widget _buildPersonalInfoContent() {
    final Size screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.04;
    final double spacing = screenSize.height * 0.015;
    final double titleSize = screenSize.width * 0.05;
    final double buttonHeight = screenSize.height * 0.06;
    final double iconSize = screenSize.width * 0.05;

    return Container(
      width: double.infinity,
      decoration: AppTheme.glassDecoration(
        context,
      ).copyWith(borderRadius: BorderRadius.circular(screenSize.width * 0.04)),
      padding: EdgeInsets.all(padding),
      // Fixed height constraint removed to prevent overflow
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take only needed space
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          SizedBox(height: spacing),

          // Personal info fields
          _buildInfoItem('Email', userDetails?['email'] ?? '', Icons.email),
          SizedBox(height: spacing * 0.8),
          _buildInfoItem(
            'Phone',
            '+91 ${userDetails?['contact'] ?? ''}',
            Icons.phone,
          ),
          SizedBox(height: spacing * 0.8),
          _buildInfoItem(
            'Department',
            userDetails?['department'] ?? '',
            Icons.school,
          ),
          SizedBox(height: spacing * 0.8),
          _buildInfoItem(
            'Year',
            userDetails?['year'] ?? '',
            Icons.calendar_today,
          ),

          SizedBox(height: spacing * 1.5),

          // Change password button
          InkWell(
            onTap: () {
              // Change password action
            },
            child: Container(
              width: double.infinity,
              height: buttonHeight,
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(screenSize.width * 0.03),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: AppTheme.accentBlue,
                    size: iconSize,
                  ),
                  SizedBox(width: screenSize.width * 0.02),
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.04,
                      color: AppTheme.accentBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    final Size screenSize = MediaQuery.of(context).size;
    final double iconContainerSize = screenSize.width * 0.1;
    final double iconSize = screenSize.width * 0.05;
    final double labelSize = screenSize.width * 0.035;
    final double valueSize = screenSize.width * 0.04;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Align vertically
      children: [
        Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.accentBlue, size: iconSize),
          ),
        ),
        SizedBox(width: screenSize.width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Take only necessary space
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: labelSize,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              userDetails == null
                  ? buildShimmer(width: 160, height: valueSize + 8)
                  : Text(
                    value,
                    style: TextStyle(
                      fontSize: valueSize,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle text overflow
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesContent() {
    final Size screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.04;
    final double spacing = screenSize.height * 0.015;
    final double titleSize = screenSize.width * 0.05;
    final double chipSpacing = screenSize.width * 0.02;

    return Container(
      width: double.infinity,
      decoration: AppTheme.glassDecoration(context).copyWith(
        borderRadius: BorderRadius.circular(screenSize.width * 0.04),
      ),
      padding: EdgeInsets.all(padding),
      // Fixed height constraint removed to prevent overflow
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take only needed space
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          SizedBox(height: spacing),

          // Notification preferences
          _buildSettingItem(
            'Notifications',
            'Receive app notifications',
            Icons.notifications_none,
            true,
          ),

          SizedBox(height: spacing * 0.8),

          // Email preferences
          _buildSettingItem(
            'Email updates',
            'Receive updates via email',
            Icons.mark_email_unread_outlined,
            true,
          ),

          SizedBox(height: spacing),

          Text(
            'Interests',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary(context),
            ),
          ),

          SizedBox(height: spacing * 0.8),

          // Interests chips - wrap in a ConstrainedBox to ensure it wraps properly
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width - (2 * padding),
            ),
            child: Wrap(
              spacing: chipSpacing,
              runSpacing: chipSpacing,
              children:
                  userDetails == null
                      ? buildShimmer(width: 160, height: chipSpacing + 8)
                      : (userDetails!['interests'])
                          .map<Widget>(
                            (interest) => _buildInterestChip(interest),
                          )
                          .toList(),
            ),
          ),

          SizedBox(height: spacing),

          // Add interest button
          InkWell(
            onTap: () {
              // Add interest action
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.008,
                horizontal: screenSize.width * 0.03,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.accentBlue.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(screenSize.width * 0.05),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: AppTheme.accentBlue,
                    size: screenSize.width * 0.04,
                  ),
                  SizedBox(width: screenSize.width * 0.01),
                  Text(
                    'Add Interest',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.035,
                      color: AppTheme.accentBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
  ) {
    final Size screenSize = MediaQuery.of(context).size;
    final double iconContainerSize = screenSize.width * 0.1;
    final double iconSize = screenSize.width * 0.05;
    final double titleSize = screenSize.width * 0.04;
    final double subtitleSize = screenSize.width * 0.035;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Align items properly
      children: [
        Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.accentBlue, size: iconSize),
          ),
        ),
        SizedBox(width: screenSize.width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Take only needed space
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: titleSize,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: AppTheme.textSecondary(context),
                ),
                overflow: TextOverflow.ellipsis, // Handle text overflow
              ),
            ],
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            activeColor: AppTheme.accentBlue,
            onChanged: (newValue) {
              // Handle toggle
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInterestChip(String interest) {
    final Size screenSize = MediaQuery.of(context).size;
    final double fontSize = screenSize.width * 0.035;
    final double iconSize = screenSize.width * 0.04;

    return Container(
      margin: EdgeInsets.only(bottom: 4), // Add margin to prevent overflow
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.03,
        vertical: screenSize.height * 0.006,
      ),
      decoration: BoxDecoration(
        color: AppTheme.accentBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(screenSize.width * 0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            interest,
            style: TextStyle(fontSize: fontSize, color: AppTheme.textPrimary(context)),
          ),
          SizedBox(width: screenSize.width * 0.01),
          Icon(Icons.close, color: AppTheme.textSecondary(context), size: iconSize),
        ],
      ),
    );
  }

  Widget _buildAccountActionsSection() {
    final Size screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.04;
    final double spacing = screenSize.height * 0.015;
    final double titleSize = screenSize.width * 0.05;
    final double smallSpacing = screenSize.height * 0.01;
    final double buttonSpacing = screenSize.width * 0.04;
    final double actionButtonHeight = screenSize.height * 0.05;
    final double iconSize = screenSize.width * 0.045;
    final double buttonTextSize = screenSize.width * 0.04;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Take only required space
        children: [
          // Account actions header
          Container(
            padding: EdgeInsets.symmetric(vertical: smallSpacing),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.textSecondary(context).withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary(context),
              ),
            ),
          ),

          SizedBox(height: spacing),

          // Account actions
          Row(
            children: [
              Expanded(
                child: _buildAccountActionItem(
                  'Sign Out',
                  Icons.logout,
                  AppTheme.accentBlue.withOpacity(0.1),
                  AppTheme.accentBlue,
                  actionButtonHeight,
                  iconSize,
                  buttonTextSize,
                ),
              ),
              SizedBox(width: buttonSpacing),
              Expanded(
                child: _buildAccountActionItem(
                  'Delete Account',
                  Icons.delete_outline,
                  Colors.red.withOpacity(0.1),
                  Colors.red,
                  actionButtonHeight,
                  iconSize,
                  buttonTextSize,
                ),
              ),
            ],
          ),

          SizedBox(height: spacing),

          // App info & socials
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(padding),
            decoration: AppTheme.glassDecoration(context).copyWith(
              borderRadius: BorderRadius.circular(screenSize.width * 0.03),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Take only required space
              children: [
                Text(
                  'IR Cell App v1.0.0',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.035,
                    color: AppTheme.textSecondary(context),
                  ),
                ),
                SizedBox(height: smallSpacing),
                InkWell(
                  onTap: () {
                    final Uri url = Uri.parse(
                      'https://www.pccoepune.com/ir/ir-coordinators.php',
                    );
                    launchUrl(url);
                  },
                  child: Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.035,
                      color: AppTheme.accentBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: smallSpacing),
                // Make the social icons row scrollable on small screens
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(
                        Icons.language,
                        'College Website',
                        screenSize,
                        'https://www.pccoepune.com/ir/ir-coordinators.php',
                      ),
                      SizedBox(width: buttonSpacing),
                      _buildSocialIcon(
                        FontAwesomeIcons.linkedin,
                        'LinkedIn',
                        screenSize,
                        'https://www.linkedin.com/company/pccoe-ir-cell/',
                      ),
                      SizedBox(width: buttonSpacing),
                      _buildSocialIcon(
                        Icons.facebook,
                        'Facebook',
                        screenSize,
                        'https://www.facebook.com/share/1BPXjQ81E7/',
                      ),
                      SizedBox(width: buttonSpacing),
                      _buildSocialIcon(
                        FontAwesomeIcons.instagram,
                        'Instagram',
                        screenSize,
                        'https://www.instagram.com/pccoe_ircell?igsh=MWVybGVyZTE2aXVtbQ==',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActionItem(
    String text,
    IconData icon,
    Color bgColor,
    Color iconColor,
    double height,
    double iconSize,
    double textSize,
  ) {
    final Size screenSize = MediaQuery.of(context).size;

    return TextButton(
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(text),
                content: Text('Are you sure you want to $text?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
        );

        if (confirmed == true) {
          if (text == 'Sign Out') {
            try {
              await Auth().signOut();
              // Use context.mounted to check if the widget is still in the tree
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (route) => false,
                );
              }
            } on FirebaseAuthException catch (e) {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('Error'),
                        content: Text(e.message ?? 'An error occurred'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Got it!'),
                          ),
                        ],
                      ),
                );
              }
            }
          } else {
            deleteAccount(context);
          }
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Remove padding from TextButton
        minimumSize: Size.zero, // Remove minimum size constraint
      ),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(screenSize.width * 0.03),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: iconSize),
            SizedBox(width: screenSize.width * 0.02),
            Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
    IconData icon,
    String tooltip,
    Size screenSize,
    String redirectLink,
  ) {
    final double iconContainerSize = screenSize.width * 0.09;
    final double iconSize = screenSize.width * 0.045;

    return InkWell(
      onTap: () {
        final Uri url = Uri.parse(redirectLink);
        launchUrl(url);
      },
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.accentBlue, size: iconSize),
          ),
        ),
      ),
    );
  }
}
