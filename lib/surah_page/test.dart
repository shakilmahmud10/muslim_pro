import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// =================================================================
// 1. CONSTANTS FOR COLORS AND TEXT STYLES
// =================================================================

class AppColors {
  static const Color primaryText = Color(0xFF455A64);
  static const Color primaryGreen = Color(0xFF36B084);
  static const Color dropdownBackgroundColor = Color(0xFFF9F9F9);
  static const Color sectionDividerColor = Color(0xFFEFEFEF);
  static const Color bodyBackground = Color(0xFFF4F4F4);
}

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle sectionHeaderTitle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle settingsLabel = TextStyle(
    color: AppColors.primaryText,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle settingsValue = TextStyle(
    color: AppColors.primaryText,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}

// =================================================================
// 2. REUSABLE SETTINGS WIDGETS
// (No change)
// =================================================================

class SettingsSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const SettingsSectionHeader({
    super.key,
    required this.icon,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryText, size: 24),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.sectionHeaderTitle),
        ],
      ),
    );
  }
}

class SettingsToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  const SettingsToggleRow({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.settingsLabel),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryGreen,
            inactiveTrackColor: AppColors.dropdownBackgroundColor,
          ),
        ],
      ),
    );
  }
}

class SettingsSliderRow extends StatefulWidget {
  final String label;
  final double initialValue;
  final double min;
  final double max;
  const SettingsSliderRow({
    super.key,
    required this.label,
    required this.initialValue,
    this.min = 10.0,
    this.max = 40.0,
  });
  @override
  State<SettingsSliderRow> createState() => _SettingsSliderRowState();
}

class _SettingsSliderRowState extends State<SettingsSliderRow> {
  late double _currentValue;
  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppTextStyles.settingsLabel),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.0,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbColor: AppColors.primaryGreen,
                    activeTrackColor: AppColors.primaryGreen,
                    inactiveTrackColor: AppColors.dropdownBackgroundColor,
                  ),
                  child: Slider(
                    value: _currentValue,
                    min: widget.min,
                    max: widget.max,
                    onChanged: (double newValue) {
                      setState(() {
                        _currentValue = newValue;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _currentValue.round().toString(),
                style: AppTextStyles.settingsValue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String?>? onChanged;
  final bool showLabel;
  const SettingsDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItem,
    this.onChanged,
    this.showLabel = true,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(label, style: AppTextStyles.settingsLabel),
            ),

          Container(
            // height: 3,
            padding: const EdgeInsets.only(
              right: 12,
              left: 16.0,
              top: 4,
              bottom: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.dropdownBackgroundColor,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: AppColors.primaryText.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              isExpanded: true,
              value: selectedItem,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryText,
              ),
              style: AppTextStyles.settingsValue,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// 3. PAGE WIDGETS (Main Content and Settings)
// (No change)
// =================================================================

class MainContentPage extends StatelessWidget {
  const MainContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          // Surah Header Card (Top)
          const SurahCards(
            suraNumber: '1',
            suraName: 'Al Fatiha',
            nameTranslation: 'The Opening',
            noOfAyah: 7,
            location: 'Meccan',
          ),

          // 10px Gap
          const SizedBox(height: 10),

          // Page Number Card
          const PageNumberCard(pageNumber: '01'),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsSectionHeader(
              icon: Icons.description_rounded,
              title: 'Content Settings',
            ),
            SettingsDropdown(
              label: 'Language',
              items: const ['English', 'Bengali', 'Urdu'],
              selectedItem: 'English',
              onChanged: (value) {},
            ),
            const SettingsToggleRow(
              label: 'Show Arabic',
              value: true,
              onChanged: null,
            ),
            const SettingsToggleRow(
              label: 'Show Translation',
              value: true,
              onChanged: null,
            ),
            const SettingsToggleRow(
              label: 'Show Transliteration',
              value: false,
              onChanged: null,
            ),
            const SettingsToggleRow(
              label: 'Show Reference',
              value: false,
              onChanged: null,
            ),

            Container(height: 10.0, color: AppColors.sectionDividerColor),

            const SettingsSectionHeader(
              icon: Icons.text_fields_rounded,
              title: 'Font Settings',
            ),
            const SettingsSliderRow(
              label: 'Arabic Font Size',
              initialValue: 28.0,
              min: 16.0,
              max: 40.0,
            ),
            const SettingsSliderRow(
              label: 'Text Font Size',
              initialValue: 28.0,
              min: 10.0,
              max: 30.0,
            ),
            SettingsDropdown(
              label: 'Script',
              items: const ['Uthma', 'Madani', 'Indo-Pak'],
              selectedItem: 'Uthma',
              onChanged: (value) {},
              showLabel: true,
            ),
            SettingsDropdown(
              label: 'Arabic Font',
              items: const ['KFGQ Hafs', 'Naskh', 'Scheherazade'],
              selectedItem: 'KFGQ Hafs',
              onChanged: (value) {},
              showLabel: true,
            ),

            Container(height: 10.0, color: AppColors.sectionDividerColor),
            const SettingsSectionHeader(
              icon: Icons.color_lens_outlined,
              title: 'Appearence',
            ),
            const SettingsToggleRow(
              label: 'Always On Display Mode',
              value: true,
              onChanged: null,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// 4. MAIN SURAH PAGE (Stateful for Appbar and Pushing Slide Logic)
// (SettingsPanel-ke daan dik theke slide koranor jonno logic bodol)
// =================================================================

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  // SettingsPanel open ki na
  bool _isSettingsOpen = false;

  // SettingsPanel toggle korar function
  void _toggleSettings() {
    setState(() {
      _isSettingsOpen = !_isSettingsOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color appBarIconColor = AppColors.primaryText;
    const double appBarIconSize = 24.0;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double pageMargin = 10.0; // Sob dike 10px margin
    // SettingsPanelWidth screen er 75%
    final double settingsPanelWidth = screenWidth * 0.75;

    // MainContentPage er left position (Pushing effect)
    // Settings bondho: 0.0
    // Settings khola: -settingsPanelWidth poriman bam dike shore jaabe
    final double mainContentLeft = _isSettingsOpen ? -settingsPanelWidth : 0.0;

    // SettingsPage er right position (Daan dik theke slide korar jonno)
    // Settings bondho: -settingsPanelWidth (Daan dike screen er baire)
    // Settings khola: 0.0 (Screen er right edge theke shuru)
    final double settingsRight = _isSettingsOpen ? 0.0 : -settingsPanelWidth;

    return Scaffold(
      backgroundColor: AppColors.bodyBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        // Back/Close Icon
        leading: IconButton(
          icon: Icon(
            _isSettingsOpen ? Icons.close_rounded : Icons.arrow_back_rounded,
            color: appBarIconColor,
            size: appBarIconSize,
          ),
          onPressed: () {
            if (_isSettingsOpen) {
              _toggleSettings(); // Close SettingsPanel
            } else {
              // App er baki back functionality
            }
          },
        ),

        // Dropdown Title
        title: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Al Fatihah', style: AppTextStyles.appBarTitle),
              SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: appBarIconColor,
                size: appBarIconSize,
              ),
            ],
          ),
        ),

        centerTitle: true,
        // Settings/Tools Icon
        actions: [
          IconButton(
            icon: const Icon(
              Icons.build_rounded,
              color: appBarIconColor,
              size: appBarIconSize,
            ),
            onPressed: () {
              _toggleSettings(); // Open SettingsPanel
            },
          ),
          // IconButton(
          //   onPressed: _toggleSettings,
          //   // SVG Icon ke ekta Fixed Size Container er moddhe rakha holo
          //   icon: SizedBox(
          //     width: appBarIconSize, // 24.0
          //     height: appBarIconSize, // 24.0
          //     child: SvgPicture.asset(
          //       'assets/image/svg/settings1.svg',
          //       fit: BoxFit.contain, // SVG ke container e adjust korbe
          //       colorFilter: const ColorFilter.mode( // Icon color set korar jonno
          //         AppColors.primaryText,
          //         BlendMode.srcIn,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(width: 8),
        ],
      ),

      // Stack diye du'ti page-ke ekshathe slide korano holo
      body: Stack(
        children: [
          // 1. Main Content Page (Slide kore bam dike shore jaabe)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            // MainContent er left position + 10px margin. Settings khola hole left: -75% + 10
            left: mainContentLeft + pageMargin,
            right: -mainContentLeft + pageMargin, // Width maintain korar jonno
            top: pageMargin,
            bottom: pageMargin,
            child: const MainContentPage(),
          ),

          // 2. Settings Panel (Daan dik theke slide kore dhukbe)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            // Right position + 10px margin
            right: settingsRight + pageMargin,
            top: pageMargin,
            bottom: pageMargin,
            child: SizedBox(
              width:
                  settingsPanelWidth -
                  pageMargin, // Container er 10px margin adjust kora holo
              child: const SettingsPage(),
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// 5. EXISTING WIDGET (Kept as per instruction)
// =================================================================

class SurahCards extends StatelessWidget {
  final String suraNumber;
  final String suraName;
  final String? nameTranslation;
  final int? noOfAyah;
  final String? location; // "Meccan" or "Madani"

  const SurahCards({
    super.key,
    required this.suraNumber,
    required this.suraName,
    this.nameTranslation,
    this.noOfAyah,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              "assets/image/svg/downWave.svg",
              fit: BoxFit.cover,
            ),
          ),
          // Location Image (Meccan/Madani)
          if (location != null)
            Positioned(
              right: 0,
              child: Image.asset(
                location == "Meccan"
                    ? "assets/image/png/Macci.png"
                    : "assets/image/png/Madani.png",
                fit: BoxFit.cover,
                scale: 1,
              ),
            ),
          Positioned(
            left: 10,
            top: 10,
            bottom: 10,
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/image/svg/numberBG.svg',
                      width: 46,
                      height: 46,
                    ),
                    Text(
                      suraNumber,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Surah Name
                    Text(
                      suraName,
                      style: const TextStyle(
                        color: Color(0xFF3d4953),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    // Surah Translation (if provided)
                    if (nameTranslation != null)
                      Text(
                        nameTranslation!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    // Ayah count and location (if provided)
                    if (noOfAyah != null || location != null)
                      Text(
                        _buildAyahLocationText(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildAyahLocationText() {
    String text = '';
    if (noOfAyah != null) {
      text += '$noOfAyah Ayahs';
    }
    if (location != null) {
      if (text.isNotEmpty) text += ' | ';
      text += location!;
    }
    return text;
  }
}

// =================================================================
// 6. NOTUN WIDGET: PageNumberCard
// =================================================================

class PageNumberCard extends StatelessWidget {
  final String pageNumber;

  const PageNumberCard({
    super.key,
    this.pageNumber = '01', // Default page number
  });

  // Apnar dewa AppTextStyles theke Page Number er style
  static const TextStyle _pageNumberText = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      // Surah Page er main content theke ektu alada korar jonno margin
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 70, // UI image er moto ekta fixed height dhora holo
      width: double.infinity,
      decoration: BoxDecoration(
        // NOTUN ASSET PATH byabohar kora holo: 'assets/image/png/Page_no.png'
        image: const DecorationImage(
          image: AssetImage('assets/image/png/Page_no.png'),
          fit: BoxFit.fill, // Container er size fill korbe
        ),
        // Ektu round kora holo jodi image-e na thake
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Container(
          // Text ke card er majhe "Page: 01" design er moto kora holo
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            // Image er opor majhkhane thaka white border-er box
            color: Colors
                .transparent, // Background transparent, shudhu border thakbe
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ), // White border around the text box
          ),
          child: Text("Page: $pageNumber", style: _pageNumberText),
        ),
      ),
    );
  }
}
