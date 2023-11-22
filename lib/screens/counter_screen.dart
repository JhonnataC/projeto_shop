import 'package:flutter/material.dart';
import 'package:projeto_shop/providers/counter.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(CounterProvider.of(context)!.state.value.toString()),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  CounterProvider.of(context)?.state.inc();
                });
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                setState(() {
                  CounterProvider.of(context)?.state.dec();
                });
              },
              icon: const Icon(Icons.remove)),
        ],
      ),
    );
  }
}
