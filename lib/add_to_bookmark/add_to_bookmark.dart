import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ====================================================================
// 1. Color and Style Constants
// ====================================================================

class AppColors {
  // Primary Green Color (Create button, selected checkmark)
  static const Color primaryGreen = Color(0xFF38A77E);
  // Pink/Magenta color for the 'Select Folder' icon
  static const Color pinkFolder = Color(0xFFE91E63);
  // Green color for the 'Create New Folder' icon
  static const Color greenFolder = Color(0xFF4CAF50);
  // Text colors
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF3D4953);
  static const Color border = Color(0xFFE0E0E0);

  // Color options for the folder color picker
  static const List<Color> folderColors = [
    primaryGreen,
    Color(0xFFFFC107), // Yellow
    Color(0xFF9C27B0), // Purple
    Color(0xFF2196F3), // Blue
    Color(0xFF8BC34A), // Lime Green
    Color(0xFFF06292), // Hot Pink
  ];
}

class AppStyles {
  static const TextStyle dialogTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle selectFieldText = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
  );

  static const TextStyle buttonTextPrimary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle buttonTextSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );
}

// ====================================================================
// 2. Reusable Dialog Components
// ====================================================================

class ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorOption({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          // 1. Border shoriye deya hoyeche. Selection er jonno r kono border nai.
          border: null,
        ),
        child: isSelected
            // 2. Icon er bodole SvgPicture.asset use kora hoyeche
            ? Center(
                child: SvgPicture.asset(
                  'assets/image/svg/tik.svg', // Apnar SVG file er path
                  width: 24,
                  height: 24,
                  // Ei property ti SVG ke shada (white) color korbe
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class BookmarkDialogContent extends StatefulWidget {
  const BookmarkDialogContent({super.key});

  @override
  State<BookmarkDialogContent> createState() => _BookmarkDialogContentState();
}

class _BookmarkDialogContentState extends State<BookmarkDialogContent> {
  Color _selectedColor = AppColors.folderColors.first;
  String? _selectedFolder; // State for the dropdown value

  @override
  Widget build(BuildContext context) {
    // Dropdown options (dummy data)
    const List<String> folderOptions = [
      'Select Folder',
      'Folder 1',
      'Folder 2',
      'Work',
      'Personal',
    ];

    return AlertDialog(
      backgroundColor: const Color(0xFFFFFFFF),
      // Dialog shape and padding matching the video
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ), // ✅ Dialog width
      // contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      titlePadding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
      title: const Center(
        child: Text('Add to Bookmark', style: AppStyles.dialogTitle),
      ),
      content: SizedBox(
        width: double.maxFinite, // ✅ Take full available width

        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Choose Folder Section ---
                const Text('Choose Folder', style: AppStyles.sectionHeader),
                const SizedBox(height: 10),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF36B084).withOpacity(0.25),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      // Icon placeholder
                      SvgPicture.asset(
                        'assets/image/svg/bookmarkFolder.svg',
                        width: 24,
                        height: 24,
                        // colorFilter: const ColorFilter.mode(
                        //   AppColors.pinkFolder,
                        //   BlendMode.srcIn,
                        // ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedFolder ?? folderOptions.first,
                            style: AppStyles.selectFieldText,
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: SvgPicture.asset(
                                'assets/image/svg/arrow_down.svg',
                                width: 18, // Size adjust korte paren
                                height: 18,
                                colorFilter: const ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedFolder = newValue;
                              });
                            },
                            items: folderOptions.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // --- Separator ---
                Text('OR, Create a New Folder', style: AppStyles.sectionHeader),
                const SizedBox(height: 10),

                // --- Create a New Folder Section (Input Field) ---
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF36B084).withOpacity(0.25),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      // Icon placeholder
                      SvgPicture.asset(
                        'assets/image/svg/bookmarkFolder2.svg',
                        width: 24,
                        height: 24,
                        // colorFilter: const ColorFilter.mode(
                        //   AppColors.greenFolder,
                        //   BlendMode.srcIn,
                        // ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Example Name',
                            hintStyle: AppStyles.selectFieldText,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
                          ),
                          style: AppStyles.selectFieldText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // --- Change Folder Color Section ---
                const Text(
                  'Change Folder Color',
                  style: AppStyles.sectionHeader,
                ),
                const SizedBox(height: 15),
                // The Container with a Transform is used to shift the content
                // 8 pixels to the left to counteract the margin of the first ColorOption.
                Container(
                  // This transform moves the Wrap widget.
                  transform: Matrix4.translationValues(-8.0, 0, 0),
                  child: Wrap(
                    // Row er bodole Wrap widget use kora hoyeche
                    children: AppColors.folderColors.map((color) {
                      return ColorOption(
                        color: color,
                        isSelected: _selectedColor == color,
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      // --- Action Buttons ---
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ Center alignment
          children: [
            SizedBox(
              width: 120, // ✅ Fixed width instead of Expanded
              height: 55,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF4F4F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    // side: const BorderSide(color: AppColors.border, width: 1),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: AppStyles.buttonTextSecondary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 120, // ✅ Fixed width instead of Expanded
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Create', style: AppStyles.buttonTextPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ====================================================================
// 3. Main Application and Button Logic
// ====================================================================

class AddToBookmark extends StatelessWidget {
  const AddToBookmark({super.key});

  void _showBookmarkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const BookmarkDialogContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Bookmark'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showBookmarkDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Add to Bookmark",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// 4. Main Function
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
      home: AddToBookmark(),
    );
  }
}
