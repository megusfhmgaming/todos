import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomBarIndexProvider = StateProvider((_) => 0);

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('ฺBottomBar/build');
    return Consumer(
      builder: (context, watch, child) {
        debugPrint('ฺBottomBar/Consumer/builder');
        final currIndex = watch(bottomBarIndexProvider);
        return BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.checkmark_seal),
              label: 'todos',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.qrcode),
              label: 'QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
            ),
          ],
          currentIndex: currIndex.state,
          selectedItemColor: Colors.amber[800],
          onTap: (idx) {
            context.read(bottomBarIndexProvider).state = idx;
            switch (idx) {
              case 0:
                Navigator.pushNamed(context, '/');
                break;
              default:
                Navigator.pushNamed(context, '/');
            }
          },
        );
      },
    );
  }
}
