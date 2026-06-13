import 'package:flutter_test/flutter_test.dart';
import 'package:proyectofinal/main.dart';

void main() {
  testWidgets('muestra el acceso principal de TrailerStock', (tester) async {
    await tester.pumpWidget(const TrailerStockApp());

    expect(find.text('TrailerStock'), findsOneWidget);
    expect(find.text('Entrar al panel operativo'), findsOneWidget);
    expect(find.text('Rol operativo'), findsOneWidget);
  });
}
