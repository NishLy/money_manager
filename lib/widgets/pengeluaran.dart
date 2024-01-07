import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/helpers/transaction.dart';
import 'package:money_manager/model/transaction.dart';
import 'package:money_manager/widgets/home.dart';

List<String> dropdownMenuEntries = Category.values.map((e) => e.name).toList();

class PengeluaraanScreen extends StatefulWidget {
  const PengeluaraanScreen({super.key});

  @override
  State<PengeluaraanScreen> createState() => _PemasukanScreenState();
}

class _PemasukanScreenState extends State<PengeluaraanScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateInput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    categoryController.text = dropdownMenuEntries.first;
  }

  Future<int> _insertTransaction(TranscationModel input) async {
    return await DbTransactionHelper.instance.insertTransaction(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengerluaran')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Text("Tambah Pengeluaraan", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Judul',
            ),
            controller: titleController,
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Jumlah',
            ),
            controller: amountController,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: dateInput,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tanggal',
              prefixIcon: Icon(Icons.calendar_today),
              hintText: 'Pilih Tanggal',
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime.now());

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() {
                  dateInput.text =
                      formattedDate; //set output date to TextField value.
                });
              } else {}
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kategori',
            ),
            isExpanded: true,
            value: categoryController.text,
            items: dropdownMenuEntries
                .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                categoryController.text = value!;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              int result = await _insertTransaction(TranscationModel(
                  title: titleController.text,
                  amount: double.tryParse(amountController.text) ?? 0,
                  date: DateTime.parse(dateInput.text),
                  transcationType: 'expense',
                  category: categoryController.text));

              if (result > 0) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Berhasil disimpan')));
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ));
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
