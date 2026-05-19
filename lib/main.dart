import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const NebulaApp());
}

class NebulaApp extends StatelessWidget {
  const NebulaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const NebulaIdeScreen(),
    );
  }
}

class NebulaIdeScreen extends StatefulWidget {
  const NebulaIdeScreen({super.key});
  @override
  State<NebulaIdeScreen> createState() => _NebulaIdeScreenState();
}

class _NebulaIdeScreenState extends State<NebulaIdeScreen> {
  // API Key ကို GitHub Secrets ကနေ ခေါ်ယူရန် (သို့) ဒီနေရာမှာ ထည့်ပါ
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: 'YOUR_API_KEY_HERE');
  TextEditingController codeController = TextEditingController();
  InAppWebViewController? webViewController;

  Future<void> generateCode(String prompt) async {
    final response = await model.generateContent([Content.text(prompt)]);
    setState(() {
      codeController.text = response.text ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nebula Native IDE")),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: InAppWebView(
              onWebViewCreated: (controller) => webViewController = controller,
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: codeController,
              maxLines: null,
              decoration: const InputDecoration(hintText: "Code here..."),
            ),
          ),
          ElevatedButton(
            onPressed: () => generateCode("Create a simple button website"),
            child: const Text("Run AI Compiler"),
          )
        ],
      ),
    );
  }
}
