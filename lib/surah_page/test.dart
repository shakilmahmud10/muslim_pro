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
  static const Color ayahCardColor = Colors.white; // Ayah card background color
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
    fontWeight: FontWeight.w500,
  );
  static const TextStyle settingsValue = TextStyle(
    color: AppColors.primaryText,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // NOTUN: Page Number Text Style
  static const TextStyle pageNumberText = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // Ayah number style
  static const TextStyle ayahNumber = TextStyle(
    color: AppColors.primaryGreen,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // Arabic Text Style (Placeholder, font family dependency thakle adjust korte hobe)
  static const TextStyle arabicText = TextStyle(
    color: Color(0xFF1E272E),
    fontSize: 32,
    fontWeight: FontWeight.w400,
    // fontFamily: 'AlMeezan', // Example Arabic font
  );

  // Translation Header Style
  static const TextStyle translationHeader = TextStyle(
    color: AppColors.primaryGreen,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Translation Text Style
  static const TextStyle translationText = TextStyle(
    color: AppColors.primaryText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
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
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppTextStyles.settingsLabel),
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
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(label, style: AppTextStyles.settingsLabel),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: AppColors.dropdownBackgroundColor,
              borderRadius: BorderRadius.circular(8.0),
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
                  child: Text(value),
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
// 5. EXISTING WIDGET: SurahCards
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
    return Container(
      // SurahCards er main container. MainContentPage e 10px padding dewar jonno ekhane padding remove kora holo.
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ), // Placeholder padding
      child: Stack(
        // ... (Existing Stack content is simplified for brevity but logic is kept)
        children: [
          // Background/Kaaba Image (Hardcoded for Al Fatiha)
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              'assets/image/kaaba.png', // Placeholder, assuming Kaaba image
              height: 80,
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Surah Number (Assuming a numbered icon)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGreen, width: 1),
                ),
                child: Center(
                  child: Text(
                    suraNumber,
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suraName,
                    style: AppTextStyles.appBarTitle.copyWith(fontSize: 18),
                  ),
                  if (nameTranslation != null)
                    Text(
                      nameTranslation!,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  if (noOfAyah != null || location != null)
                    Text(
                      _buildAyahLocationText(),
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                ],
              ),
            ],
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
      // margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 70, // UI image er moto ekta fixed height dhora holo
      width: double.infinity,
      decoration: BoxDecoration(
        // NOTUN ASSET PATH byabohar kora holo: 'assets/image/png/Page_no.png'
        image: const DecorationImage(
          image: AssetImage('assets/image/png/Page_no.png'),
          fit: BoxFit.fill, // Container er size fill korbe
        ),
        // Ektu round kora holo jodi image-e na thake
        // borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Container(
          // Text ke card er majhe "Page: 01" design er moto kora holo
          // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          // decoration: BoxDecoration(
          //   // Image er opor majhkhane thaka white border-er box
          //   color: Colors
          //       .transparent, // Background transparent, shudhu border thakbe
          //   borderRadius: BorderRadius.circular(20),
          //   border: Border.all(
          //     color: Colors.white,
          //     width: 2,
          //   ), // White border around the text box
          // ),
          child: Text("Page: $pageNumber", style: _pageNumberText),
        ),
      ),
    );
  }
}

// =================================================================
// 7. NOTUN WIDGET: AyahCard
// (Main Content Page er baki content-ke manage korar jonno)
// =================================================================

class AyahCard extends StatelessWidget {
  final String ayahNumber;
  final String arabicText;
  final String translationHeader;
  final String translationText;
  final bool isBismillah;

  const AyahCard({
    super.key,
    required this.ayahNumber,
    required this.arabicText,
    required this.translationHeader,
    required this.translationText,
    this.isBismillah = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
        left: 16,
        right: 16,
      ), // Padding theke alada rakhar jonno
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.ayahCardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000), // Very slight shadow for depth
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ayah Header (Ayah Number + Options Icon)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ayahNumber, style: AppTextStyles.ayahNumber),
              const Icon(
                Icons.more_horiz_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Arabic Text
          Align(
            alignment: isBismillah ? Alignment.center : Alignment.centerRight,
            child: Text(
              arabicText,
              style: AppTextStyles.arabicText,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl, // Arabic writing direction
            ),
          ),
          const SizedBox(height: 16),

          // Translation Header
          Text(translationHeader, style: AppTextStyles.translationHeader),
          const SizedBox(height: 4),

          // Translation Text
          Text(translationText, style: AppTextStyles.translationText),
        ],
      ),
    );
  }
}

// =================================================================
// 3. PAGE WIDGETS (Main Content and Settings)
// (MainContentPage updated)
// =================================================================

class MainContentPage extends StatelessWidget {
  const MainContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding remove kora hoyechilo, ekhon padding dorkar nei karon content-er modhye margin/padding use kora hobe
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      // Scrollable content
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            // 10px Gap (PageNumberCard-er margin/padding adjust korte hobe)
            const SizedBox(height: 10),

            // Ayah Card 1 (Bismillah)
            // const AyahCard(
            //   ayahNumber: '1',
            //   arabicText: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
            //   translationHeader: 'English - Sahih International',
            //   translationText:
            //       'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
            //   isBismillah: true,
            // ),

            // // Ayah Card 2
            // const AyahCard(
            //   ayahNumber: '2',
            //   arabicText: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ',
            //   translationHeader: 'English - Sahih International',
            //   translationText: 'All praise is for Allah—Lord of all worlds,1',
            // ),

            // // Ayah Card 3
            // const AyahCard(
            //   ayahNumber: '3',
            //   arabicText: 'ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
            //   translationHeader: 'English - Sahih International',
            //   translationText:
            //       'The Entirely Merciful, the Especially Merciful,',
            // ),

            // Footer/Bottom Navigation placeholder (Image e niche footer bar deka jaache)
            const SizedBox(height: 80),
          ],
        ),
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
            // Settings UI components...
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
              showLabel: false,
            ),
            SettingsDropdown(
              label: 'Arabic Font',
              items: const ['KFGQ Hafs', 'Naskh', 'Scheherazade'],
              selectedItem: 'KFGQ Hafs',
              onChanged: (value) {},
              showLabel: false,
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
// (No change in slide logic)
// =================================================================

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  bool _isSettingsOpen = false;

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
    final double pageMargin = 10.0;
    final double settingsPanelWidth = screenWidth * 0.8; // 80% width maintained

    // Pushing Slide Logic
    final double mainContentLeft = _isSettingsOpen ? -settingsPanelWidth : 0.0;
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
              _toggleSettings();
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
              _toggleSettings();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Bottom Navigation Bar placeholder (Image e niche dekha jaache)
      // Bottom navigation bar widget jukto kora holo
      bottomNavigationBar: Container(
        height: 60,
        margin: const EdgeInsets.all(
          10,
        ), // Page margin er shathe adjust korar jonno
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.translate, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.pause, color: Colors.grey),
              onPressed: () {},
            ),
            // Play Button (Primary Green background)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: const Icon(Icons.sort, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
      ),

      // Stack diye du'ti page-ke ekshathe slide korano holo
      body: Stack(
        children: [
          // 1. Main Content Page (Slide kore bam dike shore jaabe)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: mainContentLeft + pageMargin,
            right: -mainContentLeft + pageMargin,
            top: pageMargin,
            bottom: pageMargin,
            child: const MainContentPage(),
          ),

          // 2. Settings Panel (Daan dik theke slide kore dhukbe)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            right: settingsRight + pageMargin,
            top: pageMargin,
            bottom: pageMargin,
            child: SizedBox(
              width: settingsPanelWidth - pageMargin,
              child: const SettingsPage(),
            ),
          ),
        ],
      ),
    );
  }
}
