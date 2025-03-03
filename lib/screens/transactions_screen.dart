import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Gelir';
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> transactions = []; // Transaction listesi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Para ekleme formu
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Miktar'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: <String>['Gelir', 'Gider']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                // Yeni transaction ekleme
                setState(() {
                  transactions.add({
                    'amount': double.tryParse(_amountController.text) ?? 0.0,
                    'category': _selectedCategory,
                    'date': _selectedDate,
                  });
                  _amountController.clear();
                });
              },
              child: const Text("Ekle"),
            ),
            const SizedBox(height: 20),
            // Gelir ve giderlerin listelenmesi
            const Text("Gelir ve Giderler", style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${transactions[index]['category']} - ${transactions[index]['amount']}"),
                    subtitle: Text("${transactions[index]['date']}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
