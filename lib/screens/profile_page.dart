import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0;

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
        // Removed leading and automatically implied leading properties
        // This will prevent the double back button issue
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Using empty container to maintain alignment
            const SizedBox(width: 48),
            Text(
              'Profile',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.05,
              ),
            ),
            Container(
              decoration: AppTheme.glassDecoration,
              child: IconButton(
                icon: Icon(
                  Icons.edit, 
                  color: AppTheme.textPrimary,
                  size: iconSize,
                ),
                onPressed: () {
                  // Edit profile action
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        padding: EdgeInsets.all(horizontalPadding),
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
            Expanded(
              child: _selectedTab == 0 
                ? _buildPersonalInfoContent() 
                : _buildPreferencesContent(),
            ),
            
            // Account actions section at bottom
            _buildAccountActionsSection(),
          ],
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
            child: Text(
              'A',
              style: TextStyle(
                fontSize: profilePicSize * 0.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ),
        
        SizedBox(width: screenSize.width * 0.04),
        
        // Profile name and info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing / 2),
              Text(
                'john.doe@example.com',
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: AppTheme.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.03,
                  vertical: screenSize.height * 0.006,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(screenSize.width * 0.05),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabSelector() {
    final Size screenSize = MediaQuery.of(context).size;
    final double tabHeight = screenSize.height * 0.05;
    final double fontSize = screenSize.width * 0.04;
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.5),
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
                  color: _selectedTab == 0 ? AppTheme.accentBlue.withOpacity(0.3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(screenSize.width * 0.03),
                ),
                child: Text(
                  'Personal Info',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: _selectedTab == 0 ? AppTheme.textPrimary : AppTheme.textSecondary,
                    fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
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
                  color: _selectedTab == 1 ? AppTheme.accentBlue.withOpacity(0.3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(screenSize.width * 0.03),
                ),
                child: Text(
                  'Preferences',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: _selectedTab == 1 ? AppTheme.textPrimary : AppTheme.textSecondary,
                    fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
      decoration: AppTheme.glassDecoration.copyWith(
        borderRadius: BorderRadius.circular(screenSize.width * 0.04),
      ),
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            
            SizedBox(height: spacing),
            
            // Personal info fields
            _buildInfoItem('Email', 'john.doe@example.com', Icons.email),
            SizedBox(height: spacing * 0.8),
            _buildInfoItem('Phone', '+1 123 456 7890', Icons.phone),
            SizedBox(height: spacing * 0.8),
            _buildInfoItem('Department', 'Computer Science', Icons.school),
            SizedBox(height: spacing * 0.8),
            _buildInfoItem('Year', '3rd Year', Icons.calendar_today),
            
            SizedBox(height: spacing * 1.5),
            
            // Change password button
            Container(
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
          ],
        ),
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
      children: [
        Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          ),
          child: Center(
            child: Icon(
              icon,
              color: AppTheme.accentBlue,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(width: screenSize.width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: labelSize,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: valueSize,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
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
      decoration: AppTheme.glassDecoration.copyWith(
        borderRadius: BorderRadius.circular(screenSize.width * 0.04),
      ),
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferences',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
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
                color: AppTheme.textPrimary,
              ),
            ),
            
            SizedBox(height: spacing * 0.8),
            
            // Interests chips
            Wrap(
              spacing: chipSpacing,
              runSpacing: chipSpacing,
              children: [
                _buildInterestChip('Technology'),
                _buildInterestChip('Economics'),
                _buildInterestChip('International Affairs'),
                _buildInterestChip('Management'),
                _buildInterestChip('Diplomacy'),
              ],
            ),
            
            SizedBox(height: spacing),
            
            // Add interest button
            Container(
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
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingItem(String title, String subtitle, IconData icon, bool value) {
    final Size screenSize = MediaQuery.of(context).size;
    final double iconContainerSize = screenSize.width * 0.1;
    final double iconSize = screenSize.width * 0.05;
    final double titleSize = screenSize.width * 0.04;
    final double subtitleSize = screenSize.width * 0.035;
    
    return Row(
      children: [
        Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          ),
          child: Center(
            child: Icon(
              icon,
              color: AppTheme.accentBlue,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(width: screenSize.width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: titleSize,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: AppTheme.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
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
            style: TextStyle(
              fontSize: fontSize,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(width: screenSize.width * 0.01),
          Icon(
            Icons.close,
            color: AppTheme.textSecondary,
            size: iconSize,
          ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Account actions header
          Container(
            padding: EdgeInsets.symmetric(vertical: smallSpacing),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.textSecondary.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
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
            decoration: AppTheme.glassDecoration.copyWith(
              borderRadius: BorderRadius.circular(screenSize.width * 0.03),
            ),
            child: Column(
              children: [
                Text(
                  'IR Cell App v1.0.0',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.035,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: smallSpacing),
                Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.035,
                    color: AppTheme.accentBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: smallSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(Icons.language, 'College Website', screenSize),
                    SizedBox(width: buttonSpacing),
                    _buildSocialIcon(Icons.abc, 'LinkedIn', screenSize),
                    SizedBox(width: buttonSpacing),
                    _buildSocialIcon(Icons.facebook, 'Facebook', screenSize),
                    SizedBox(width: buttonSpacing),
                    _buildSocialIcon(Icons.camera_alt, 'Instagram', screenSize),
                  ],
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
    
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(screenSize.width * 0.03),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
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
    );
  }
  
  Widget _buildSocialIcon(IconData icon, String tooltip, Size screenSize) {
    final double iconContainerSize = screenSize.width * 0.09;
    final double iconSize = screenSize.width * 0.045;
    
    return Tooltip(
      message: tooltip,
      child: Container(
        width: iconContainerSize,
        height: iconContainerSize,
        decoration: BoxDecoration(
          color: AppTheme.accentBlue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: AppTheme.accentBlue,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}