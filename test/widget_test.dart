import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:temperature_converter/main.dart';

void main() {
  testWidgets('converts C to F and F to C, validates input', (tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    // Empty input
    await tester.tap(find.text('Convert'));
    await tester.pump();
    expect(find.text('Please enter a temperature value'), findsOneWidget);

    // Invalid input
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.tap(find.text('Convert'));
    await tester.pump();
    expect(find.text('Please enter a valid number'), findsOneWidget);

    // C -> F
    await tester.enterText(find.byType(TextField), '100');
    await tester.tap(find.text('Convert'));
    await tester.pump();
    expect(find.text('212.00 °F'), findsOneWidget);

    // F -> C
    await tester.tap(find.byType(DropdownButton<ConversionType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fahrenheit to Celsius (°F → °C)').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '72');
    await tester.tap(find.text('Convert'));
    await tester.pump();
    expect(find.text('22.22 °C'), findsOneWidget);
  });
}
