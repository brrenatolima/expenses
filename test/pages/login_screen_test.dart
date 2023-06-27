import 'package:expenses/app_global_keys.dart';
import 'package:expenses/firebase_options.dart';
import 'package:expenses/pages/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mock.dart';

void main() {
   setupFirebaseAuthMocks();

setUpAll(() async {
  await Firebase.initializeApp();
});

  testWidgets('login screen ...', (tester) async {
    
  
     await tester.pumpWidget(const LogInScreen());

     expect(find.byKey(AppGlobalKeys.inputEmailKey), findsOneWidget);
     await tester.enterText(find.byKey(AppGlobalKeys.inputEmailKey), 'renatomdd@gmail.com');
     await tester.pump();

  });
}