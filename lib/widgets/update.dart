import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/helpers/transaction.dart';
import 'package:money_manager/model/transaction.dart';
import 'package:money_manager/widgets/home.dart';

List<String> dropdownMenuEntries = Category.values.map((e) => e.name).toList();

class UpdateScreen extends StatefulWidget {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String transactionType;
  const UpdateScreen(
      {super.key,
      required this.id,
      required this.title,
      required this.amount,
      required this.date,
      required this.category,
      required this.transactionType});

  @override
  State<UpdateScreen> createState() => _PemasukanScreenState();
}

class _PemasukanScreenState extends State<UpdateScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  int id = -1;
  String transactionType = "income";

  @override
  void initState() {
    super.initState();
    dateInput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    categoryController.text = dropdownMenuEntries.first;

    id = widget.id;
    transactionType = widget.transactionType;
    titleController.text = widget.title;
    amountController.text = widget.amount.toString();
    dateInput.text = DateFormat('yyyy-MM-dd').format(widget.date);
    categoryController.text = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaksi')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
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
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
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
              prefixIcon: Icon(Icons.category),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    int result = await DbTransactionHelper.instance
                        .deleteTransaction(id);

                    if (result > 0) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Berhasil dihapus')));
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ));
                    }
                  },
                  child: const Text('Hapus'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    int result = await DbTransactionHelper.instance
                        .updateTransaction(TranscationModel(
                            id: id,
                            title: titleController.text,
                            amount: double.parse(amountController.text),
                            date: DateTime.parse(dateInput.text),
                            category: categoryController.text,
                            transcationType: transactionType));

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
              ),
            ],
          )
        ],
      ),
    );
  }
}
