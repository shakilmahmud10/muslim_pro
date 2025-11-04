import 'package:flutter/material.dart';

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
  static const Color textLight = Color(0xFF757575);
  static const Color background = Color(0xFFF5F5F5); // Very light grey
}

class AppStyles {
  static const TextStyle headerTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
  );

  static const TextStyle reportHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle reportLabel = TextStyle(
    fontSize: 12,
    color: AppColors.textDark,
  );

  static const TextStyle reportValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );
}

// ====================================================================
// 2. Reusable Widgets
// ====================================================================

class ZakatInputField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Determine the initial border color. If initialValuePresent is true,
    // it means a value is already there (like in the video's example where 5000 is present).
    // The video shows a light border when unfocused, and a primary color border when focused.
    final Color initialColor = initialValuePresent
        ? AppColors.border
        : AppColors.border;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.reportLabel.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: initialColor, width: 1.0),
            ),
            child: Focus(
              onFocusChange: (hasFocus) {
                // Replicating the focus border color change
                (context as Element).markNeedsBuild();
              },
              child: Builder(
                builder: (context) {
                  final isFocused = Focus.of(context).hasFocus;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: isFocused
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            cursorColor: AppColors.primary,
                            decoration: InputDecoration(
                              hintText: hintText,
                              hintStyle: AppStyles.subtitle,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            // Replicating the text style when value is present (5000)
                            style: AppStyles.reportValue,
                          ),
                        ),
                        // Currency symbol ৳ in primary color
                        Text(
                          '৳',
                          style: AppStyles.reportValue.copyWith(
                            color: isFocused || initialValuePresent
                                ? AppColors.primary
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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

  const ZakatNextButton({
    super.key,
    required this.onPressed,
    this.text = 'Next →',
  });

  @override
  Widget build(BuildContext context) {
    // Replicating the full-width, rounded button with primary color
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 50,
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
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.sectionTitle),
          const SizedBox(height: 4.0),
          Text(subtitle, style: AppStyles.subtitle),
          ZakatCardContainer(
            child: Column(
              children: [
                ...fields,
                ZakatNextButton(onPressed: onNext),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// 4. Specific Form Screens
// ====================================================================

// Step 1: Personal Assets
class PersonalAssetsForm extends StatelessWidget {
  final VoidCallback onNext;
  // final TextEditingController p1 = TextEditingController(
  //   text: '5000',
  // ); // Sample data for replication
  // final TextEditingController p2 = TextEditingController(
  //   text: '5000',
  // ); // Sample data for replication
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
          // initialValuePresent: true,
        ),
        ZakatInputField(
          label: 'Bank Deposits: Fixed, Savings, Current, etc',
          controller: p2,
          // initialValuePresent: true,
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

// Step 5: Zakat Calculation Result Screen
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
              Text(value, style: AppStyles.headerTitle.copyWith(fontSize: 18)),
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

// Step 6: Entire Report Screen
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
      // Adding a Total Zakat section as shown at the end of the report
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
      padding: const EdgeInsets.all(16.0),
      child: ZakatCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Entire Report',
              style: AppStyles.sectionTitle.copyWith(color: AppColors.textDark),
            ),
            const SizedBox(height: 20.0),
            ...reportData.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportHeader(entry.key),
                  const SizedBox(height: 8.0),
                  ...entry.value.map(
                    (item) => _buildReportItem(item['label']!, item['value']!),
                  ),
                  const SizedBox(height: 20.0),
                ],
              );
            }).toList(),

            // Replicating the Download Report button at the very end
            ZakatNextButton(
              onPressed: onDownloadReport,
              text: 'Download Report',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportHeader(String title) {
    // Replicating the header style with light green background
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(title, style: AppStyles.reportHeader),
    );
  }

  Widget _buildReportItem(String label, String value) {
    // Replicating the individual report item row
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: AppStyles.reportLabel)),
          const SizedBox(width: 10.0),
          Row(
            children: [
              Text(value, style: AppStyles.reportValue),
              const SizedBox(width: 4.0),
              const Text(
                '৳',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark, // Dark color for value text
                ),
              ),
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
  int _currentStep = 1;

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
      body: _buildCurrentScreen(),
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
