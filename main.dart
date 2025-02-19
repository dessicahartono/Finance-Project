import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp kelas utama root dari app yang akan mewarisi statelesswidget, dan tida bisa berubah-ubah
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 106, 77, 112),
        ),
      ),
      home: const MyHomePage(title: 'Laporan Keuangan Sederhana'),
    );
  }
}

class Expense {
  final double amount;
  final String category;
  final String? name;
  final DateTime date;

  Expense({
    required this.amount,
    required this.category,
    this.name,
    required this.date,
  });
}

// kelas ini yang nantinya mewarisi statefullwidget dan bisa berubah-ubah statusnya seiring waktu,
// sperti menambahkan atau mengurangi data.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// kelas yang mengolah semua data
class _MyHomePageState extends State<MyHomePage> {
  final List<Expense> _expenses = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // method yang akan menambhakan pengeluaran baru ke list pengeluaran
  void _addExpense() {
    final amount = double.tryParse(_amountController.text);
    final category = _categoryController.text;
    final name = _nameController.text.isNotEmpty ? _nameController.text : null;

    if (amount != null && amount > 0 && category.isNotEmpty) {
      setState(() {
        _expenses.add(
          Expense(
            amount: amount,
            category: category,
            name: name,
            date: DateTime.now(),
          ),
        );
      });
      // utk menghapus input di fields
      _amountController.clear();
      _categoryController.clear();
      _nameController.clear();
    }
  }

  //menjumlahkan semua yangh ada di data pengeluaran
  double get _totalExpenses {
    return _expenses.fold(0, (sum, item) => sum + item.amount);
  }

  //untuk kembalikan struktur UI halaman, susunan widget vertikal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          //form Input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pengeluaran',
                  ), //untuk ganti label
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addExpense,
                  child: const Text('Tambah Pengeluaran'),
                ),
              ],
            ),
          ),
          //menampilkan total pengeluaran
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Pengeluaran: Rp${_totalExpenses.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          //list pengeluaran
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return ListTile(
                  title: Text(expense.category),
                  subtitle: Text(
                    expense.name != null ? 'Nama: ${expense.name}' : '',
                  ), //tampilkan nama pengeluaran
                  trailing: Text('Rp${expense.amount.toStringAsFixed(2)}'),
                  leading: Text(
                    '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
