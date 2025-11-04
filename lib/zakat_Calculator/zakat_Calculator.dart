import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ====================================================================
// 1. Color and Style Constants
// ====================================================================

class AppColors {
  // Estimated Primary Green Color from the video
  static const Color primary = Color(0xFF38A77E);
  // Light background for section headers in the report
  static const Color lightGreen = Color(0xFFEAF8F1);
  // Light grey for unfocused borders
  static const Color border = Color(0xFFE0E0E0);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF494949);
  static const Color textHint = Color(0xFFA8A8A8);
  static const Color background = Color(0xFFF5F5F5); // Very light grey
  // Alternating color for report items (lightest grey/off-white)
  static const Color reportAlternatingBg = Color(0xFFF8F8F8);
}

class AppStyles {
  static const TextStyle headerTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    height: 1.7,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 13,
    color: AppColors.textHint,
  );

  static const TextStyle reportHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // Adjusted font size for report list item label
  static const TextStyle reportLabel = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
  );

  // Adjusted font size for report list item value
  static const TextStyle reportValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
}

// ====================================================================
// 2. Reusable Widgets
// ====================================================================

class ZakatInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool initialValuePresent;

  const ZakatInputField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText = 'add value',
    this.initialValuePresent = false,
  });

  @override
  State<ZakatInputField> createState() => _ZakatInputFieldState();
}

class _ZakatInputFieldState extends State<ZakatInputField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text color changes based on the _isFocused state
          Text(
            widget.label,
            style: AppStyles.reportLabel.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 14, // Consistent label size
              color: _isFocused ? AppColors.primary : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color(0xFFF9F9F9),
              border: Border.all(
                color: _isFocused ? AppColors.primary : Colors.transparent,
                width: 1.2,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: _focusNode, // Assign the focus node
                    controller: widget.controller,
                    keyboardType: TextInputType.number,
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: AppStyles.hintText,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppStyles.reportValue.copyWith(fontSize: 14),
                  ),
                ),
                // Currency symbol ৳ in primary color
                Text(
                  '৳',
                  style: AppStyles.reportValue.copyWith(
                    fontWeight: FontWeight.w400,
                    color: _isFocused || widget.initialValuePresent
                        ? AppColors.primary
                        : AppColors.textLight,
                    fontSize: 18,
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

class ZakatNextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String? iconPath; // ✅ Optional SVG path
  final bool showIcon; // ✅ Show/hide icon

  const ZakatNextButton({
    super.key,
    required this.onPressed,
    this.text = 'Next',
    this.iconPath = 'assets/image/svg/arrow1.svg', // ✅ Default icon
    this.showIcon = true, // ✅ Default true
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: AppStyles.buttonText),

              // ✅ Conditional SVG Icon
              if (showIcon && iconPath != null) ...[
                const SizedBox(width: 12),
                SvgPicture.asset(
                  iconPath!,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ZakatCardContainer extends StatelessWidget {
  final Widget child;

  const ZakatCardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Replicating the white card with rounded corners and subtle shadow
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.02),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ====================================================================
// 3. Screen Templates (Forms)
// ====================================================================

class ZakatFormTemplate extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> fields;
  final VoidCallback onNext;

  const ZakatFormTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.sectionTitle),
                  const SizedBox(height: 8.0),
                  Text(subtitle, style: AppStyles.subtitle),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ZakatCardContainer(
              child: Column(
                children: [
                  ...fields,
                  ZakatNextButton(onPressed: onNext),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// 4. Specific Form Screens (Unchanged for this fix)
// ====================================================================

// Step 1: Personal Assets
class PersonalAssetsForm extends StatelessWidget {
  final VoidCallback onNext;
  final TextEditingController p1 = TextEditingController();
  final TextEditingController p2 = TextEditingController();
  final TextEditingController p3 = TextEditingController();
  final TextEditingController p4 = TextEditingController();

  PersonalAssetsForm({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return ZakatFormTemplate(
      title: 'Personal Assets',
      subtitle: 'Please fill your personal assets informations',
      fields: [
        ZakatInputField(
          label: 'Precious Ornaments: Gold, Silver, etc. (Value)',
          controller: p1,
        ),
        ZakatInputField(
          label: 'Bank Deposits: Fixed, Savings, Current, etc',
          controller: p2,
        ),
        ZakatInputField(
          label: 'Shares, Savings, Insurance, Provident Fund etc.',
          controller: p3,
        ),
        ZakatInputField(
          label: 'Foreign Currency, FC Account, TC, (Exc. Rate Tk.)',
          controller: p4,
        ),
      ],
      onNext: onNext,
    );
  }
}

// Step 2: Business Assets (Solo Proprietorship)
class BusinessAssetsSoleProprietorshipForm extends StatelessWidget {
  final VoidCallback onNext;
  final TextEditingController s1 = TextEditingController();
  final TextEditingController s2 = TextEditingController();
  final TextEditingController s3 = TextEditingController();
  final TextEditingController s4 = TextEditingController();

  BusinessAssetsSoleProprietorshipForm({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return ZakatFormTemplate(
      title: 'Business Assets(Solo Proprietorship)',
      subtitle: 'Please fill your business assets informations',
      fields: [
        ZakatInputField(
          label: 'Precious Ornaments: Gold, Silver, etc. (Value)',
          controller: s1,
        ),
        ZakatInputField(
          label: 'Bank Deposits: Fixed, Savings, Current, etc',
          controller: s2,
        ),
        ZakatInputField(
          label: 'Shares, Savings, Insurance, Provident Fund etc.',
          controller: s3,
        ),
        ZakatInputField(
          label: 'Foreign Currency, FC Account, TC, (Exc. Rate Tk.)',
          controller: s4,
        ),
      ],
      onNext: onNext,
    );
  }
}

// Step 3: Joint Proprietorship/Partnership Business Account (Your Share)
class JointProprietorshipForm extends StatelessWidget {
  final VoidCallback onNext;
  final TextEditingController j1 = TextEditingController();
  final TextEditingController j2 = TextEditingController();
  final TextEditingController j3 = TextEditingController();
  final TextEditingController j4 = TextEditingController();

  JointProprietorshipForm({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return ZakatFormTemplate(
      title: 'Joint Proprietorship/Partnership Business Account (Your Share)',
      subtitle: 'Please fill your business assets informations',
      fields: [
        ZakatInputField(
          label: 'Precious Ornaments: Gold, Silver, etc. (Value)',
          controller: j1,
        ),
        ZakatInputField(
          label: 'Bank Deposits: Fixed, Savings, Current, etc',
          controller: j2,
        ),
        ZakatInputField(
          label: 'Shares, Savings, Insurance, Provident Fund etc.',
          controller: j3,
        ),
        ZakatInputField(
          label: 'Foreign Currency, FC Account, TC, (Exc. Rate Tk.)',
          controller: j4,
        ),
      ],
      onNext: onNext,
    );
  }
}

// Step 4: Zakatable assets invested in industry/business
class ZakatableAssetsInvestedForm extends StatelessWidget {
  final VoidCallback onNext;
  final TextEditingController i1 = TextEditingController();

  ZakatableAssetsInvestedForm({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return ZakatFormTemplate(
      title: 'Zakatable assets invested in industry/business',
      subtitle: 'Please fill your business assets informations',
      fields: [
        ZakatInputField(
          label: 'Zakatable assets invested in industry/business',
          controller: i1,
        ),
      ],
      onNext: onNext,
    );
  }
}

// Step 5: Zakat Calculation Result Screen (Unchanged for this fix)
class ZakatResultScreen extends StatelessWidget {
  final VoidCallback onGenerateReport;

  const ZakatResultScreen({super.key, required this.onGenerateReport});

  @override
  Widget build(BuildContext context) {
    // Hardcoded values for UI replication
    const String zakatableWealth = '61,89,554';
    const String totalZakat = '1,54,785.35';
    const String infoText =
        'This year (2023), the minimum amount of Zakatable assets is Tk 40,000, the amount of Zakat is 2.50%.';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: ZakatCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow(
              context,
              label: 'The amount of your Zakatable wealth',
              value: zakatableWealth,
            ),
            const SizedBox(height: 20.0),
            _buildResultRow(
              context,
              label: 'Your total Zakat this year:',
              value: totalZakat,
            ),
            const SizedBox(height: 20.0),
            Text(infoText, style: AppStyles.subtitle.copyWith(fontSize: 12)),
            const SizedBox(height: 20.0),
            ZakatNextButton(
              onPressed: onGenerateReport,
              text: 'Generate Report',
              showIcon: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.reportLabel.copyWith(fontSize: 14)),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: AppStyles.headerTitle.copyWith(
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                '৳',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Step 6: Entire Report Screen (FIXED)
class EntireReportScreen extends StatelessWidget {
  final VoidCallback onDownloadReport;

  const EntireReportScreen({super.key, required this.onDownloadReport});

  @override
  Widget build(BuildContext context) {
    // Hardcoded dummy data for replication
    const Map<String, List<Map<String, String>>> reportData = {
      'Personal Assets': [
        {
          'label': 'Precious Ornaments: Gold, Silver, etc. (Value)',
          'value': '500000',
        },
        {
          'label': 'Bank Deposits: Fixed, Savings, Current, etc',
          'value': '500000',
        },
        {
          'label': 'Shares, Savings, Insurance, Provident Fund',
          'value': '500000',
        },
        {
          'label': 'Foreign Currency, FC Account, TC, (Exc. Rate Tk.)',
          'value': '500000',
        },
        {
          'label': 'Shares, Savings, Insurance, Provident Fund',
          'value': '500000',
        },
        {
          'label': 'Precious Ornaments: Gold, Silver, etc. (Value)',
          'value': '500000',
        },
        {
          'label': 'Bank Deposits: Fixed, Savings, Current, etc',
          'value': '500000',
        },
      ],
      'Business Assets(Sole Proprietorship)': [
        {
          'label': 'Precious Ornaments: Gold, Silver, etc. (Value)',
          'value': '500000',
        },
        {
          'label': 'Bank Deposits: Fixed, Savings, Current, etc',
          'value': '500000',
        },
        {
          'label': 'Shares, Savings, Insurance, Provident Fund',
          'value': '500000',
        },
        {
          'label': 'Foreign Currency, FC Account, TC, (Exc. Rate Tk.)',
          'value': '500000',
        },
        {
          'label': 'Shares, Savings, Insurance, Provident Fund',
          'value': '500000',
        },
        {
          'label': 'Precious Ornaments: Gold, Silver, etc. (Value)',
          'value': '500000',
        },
        {
          'label': 'Bank Deposits: Fixed, Savings, Current, etc',
          'value': '500000',
        },
      ],
      'Total Zakat': [
        {'label': 'Total eligible wealth for Zakat', 'value': '500000'},
        {'label': 'Your total zakat in this year', 'value': '500000'},
        {
          'label':
              'This year (2023) the minimum amount of eligible wealth for zakat',
          'value': '500000',
        },
      ],
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ZakatCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Your Entire Report',
                style: AppStyles.sectionTitle.copyWith(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12.0),

            // Divider is removed to match the left screen more closely
            ...reportData.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportHeader(entry.key),
                  // Use ListView.builder-like logic to alternate colors
                  ...entry.value.asMap().entries.map((mapEntry) {
                    int idx = mapEntry.key;
                    var item = mapEntry.value;
                    return _buildReportItem(
                      item['label']!,
                      item['value']!,
                      idx,
                      entry.value.length, // ✅ Total items count
                    );
                  }),
                  const SizedBox(height: 20.0),
                ],
              );
            }).toList(),

            // Replicating the Download Report button at the very end
            ZakatNextButton(
              onPressed: onDownloadReport,
              text: 'Download Report',
              showIcon: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportHeader(String title) {
    return Container(
      width: double.infinity,
      // Removed horizontal padding here as it's already in the card container's inner padding
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      // margin: const EdgeInsets.only(top: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(title, style: AppStyles.reportHeader),
      ),
    );
  }

  // FIX: Implemented logic to alternate background color and adjusted padding/font styles
  Widget _buildReportItem(
    String label,
    String value,
    int index,
    int totalItems,
  ) {
    final Color backgroundColor = index.isEven
        ? AppColors.reportAlternatingBg
        : Colors.transparent;

    // ✅ Conditional BorderRadius
    BorderRadius? borderRadius;
    if (index == 0) {
      // First item: top corners rounded
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      );
    } else if (index == totalItems - 1) {
      // Last item: bottom corners rounded
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius, // ✅ Dynamic border radius
      ),
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(label, style: AppStyles.reportLabel)),
          const SizedBox(width: 10.0),
          Container(
            height: 35,
            width: 1,
            color: AppColors.border,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
          ),
          const SizedBox(width: 14.0),
          Row(
            children: [
              Text(value, style: AppStyles.reportValue),
              const SizedBox(width: 4.0),
              const Text('৳', style: TextStyle(fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// 5. Main Screen (State Management)
// ====================================================================

class ZakatCalculatorScreen extends StatefulWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  State<ZakatCalculatorScreen> createState() => _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends State<ZakatCalculatorScreen> {
  int _currentStep = 6; // Start at step 6 to show the report screen for fixing

  void _nextStep() {
    setState(() {
      if (_currentStep < 6) {
        _currentStep++;
      }
    });
  }

  void _backStep() {
    setState(() {
      if (_currentStep > 1) {
        _currentStep--;
      }
    });
  }

  Widget _buildCurrentScreen() {
    switch (_currentStep) {
      case 1:
        return PersonalAssetsForm(onNext: _nextStep);
      case 2:
        return BusinessAssetsSoleProprietorshipForm(onNext: _nextStep);
      case 3:
        return JointProprietorshipForm(onNext: _nextStep);
      case 4:
        return ZakatableAssetsInvestedForm(onNext: _nextStep);
      case 5:
        return ZakatResultScreen(onGenerateReport: _nextStep);
      case 6:
        return EntireReportScreen(
          onDownloadReport: () {
            // Placeholder for download action
          },
        );
      default:
        return PersonalAssetsForm(onNext: _nextStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the title based on the current step for AppBar
    String currentTitle = 'Zakat Calculator';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(currentTitle, style: AppStyles.headerTitle),
        leading: _currentStep > 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                onPressed: _backStep,
              )
            : null,
      ),
      body: Column(
        children: [
          const SizedBox(height: 2),
          Expanded(child: _buildCurrentScreen()),
        ],
      ),
    );
  }
}

// ====================================================================
// 6. Main Function
// ====================================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ZakatCalculatorScreen(),
    );
  }
}
