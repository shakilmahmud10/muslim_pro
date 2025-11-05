import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF38A77E);
  static const Color pinkFolder = Color(0xFFE91E63);
  static const Color greenFolder = Color(0xFF4CAF50);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF3D4953);
  static const Color border = Color(0xFFE0E0E0);
  static const List<Color> folderColors = [
    primaryGreen,
    Color(0xFFFFC107),
    Color(0xFF9C27B0),
    Color(0xFF2196F3),
    Color(0xFF8BC34A),
    Color(0xFFF06292),
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
          border: null,
        ),
        child: isSelected
            ? Center(
                child: SvgPicture.asset(
                  'assets/image/svg/tik.svg',
                  width: 24,
                  height: 24,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      titlePadding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
      title: const Center(
        child: Text('Edit Bookmark', style: AppStyles.dialogTitle),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Change Folder namge', style: AppStyles.sectionHeader),
                const SizedBox(height: 10),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF36B084).withOpacity(0.25),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/image/svg/bookmarkFolder.svg',
                        width: 24,
                        height: 24,
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
                const Text(
                  'Change Folder Color',
                  style: AppStyles.sectionHeader,
                ),
                const SizedBox(height: 15),
                Container(
                  transform: Matrix4.translationValues(-8.0, 0, 0),
                  child: Wrap(
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
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 55,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF4F4F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
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
              width: 120,
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
                child: const Text('Apply', style: AppStyles.buttonTextPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class EditBookmark extends StatelessWidget {
  const EditBookmark({super.key});

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
        title: const Text('Edit Bookmark'),
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
            "Edit Bookmark",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditBookmark(),
    );
  }
}
