import 'package:flutter/material.dart';

void main() => runApp(const TemperatureConverterApp());

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ConverterPage(),
    );
  }
}

enum ConversionType {
  celsiusToFahrenheit('Celsius to Fahrenheit (°C → °F)', 'Celsius', '°F'),
  fahrenheitToCelsius('Fahrenheit to Celsius (°F → °C)', 'Fahrenheit', '°C');

  const ConversionType(this.label, this.inputName, this.unit);
  final String label;
  final String inputName;
  final String unit;

  double convert(double value) {
    switch (this) {
      case ConversionType.celsiusToFahrenheit:
        return (value * 9 / 5) + 32;
      case ConversionType.fahrenheitToCelsius:
        return (value - 32) * 5 / 9;
    }
  }
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final _controller = TextEditingController();
  ConversionType _type = ConversionType.celsiusToFahrenheit;
  String? _error;
  String _result = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _calculate() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      setState(() {
        _error = 'Please enter a temperature value';
        _result = '';
      });
      return;
    }

    final value = double.tryParse(text);
    if (value == null || value.isNaN || value.isInfinite) {
      setState(() {
        _error = 'Please enter a valid number';
        _result = '';
      });
      return;
    }

    setState(() {
      _error = null;
      _result = '${_type.convert(value).toStringAsFixed(2)} ${_type.unit}';
    });
  }

  static const _blue = Color(0xFF1E6FE8);
  static const _labelStyle = TextStyle(fontSize: 13, color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Temperature converter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Degrees',
                        labelStyle: _labelStyle,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorText: _error,
                        errorMaxLines: 3,
                      ),
                      onSubmitted: (_) => _calculate(),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        labelStyle: _labelStyle,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ConversionType>(
                          value: _type,
                          isExpanded: true,
                          isDense: true,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black87),
                          items: ConversionType.values
                              .map((t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t.label),
                                  ))
                              .toList(),
                          selectedItemBuilder: (context) => ConversionType
                              .values
                              .map((t) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(t.inputName),
                                  ))
                              .toList(),
                          onChanged: (t) {
                            if (t == null) return;
                            setState(() {
                              _type = t;
                              _result = '';
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text('Result', style: _labelStyle),
              const SizedBox(height: 8),
              Text(
                _result,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _calculate,
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Convert',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
