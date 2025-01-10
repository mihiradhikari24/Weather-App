import 'package:flutter/material.dart';


class settingsPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleTheme;

  const settingsPage({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode; // Initialize the local state with the current theme
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.grey[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                      widget.toggleTheme(value);
                    });
                  }
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Unit of Temperature'),
              trailing: DropdownButton<String>(
                value: 'Celsius',
                items: ['Celsius', 'Fahrenheit'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle unit change here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}