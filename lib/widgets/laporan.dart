import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/helpers/transaction.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController dateInputEnd = TextEditingController();

  double sumPemasukan = 0;
  double sumPengeluaran = 0;

  @override
  void initState() {
    super.initState();

    dateInput.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 30)));
    dateInputEnd.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    getLaporanPeriod();
  }

  Map<String, List<Map<String, dynamic>>> mappedLaporanPengeluaran = {
    'income': [],
    'expense': [],
  };

  Future getLaporanPeriod() async {
    sumPemasukan = 0;
    sumPengeluaran = 0;
    mappedLaporanPengeluaran['income'] = [];
    mappedLaporanPengeluaran['expense'] = [];

    var result = await DbTransactionHelper.instance
        .getSumTransactionPeriod(dateInput.text, dateInputEnd.text);

    for (var item in result) {
      if (item['transcation_type'] == 'income') {
        sumPemasukan += double.tryParse(item['total'].toString()) ?? 0;
        mappedLaporanPengeluaran['income']?.add({
          'category': item['category'],
          'total': double.tryParse(item['total'].toString()) ?? 0,
        });
      } else {
        sumPengeluaran += double.tryParse(item['total'].toString()) ?? 0;
        mappedLaporanPengeluaran['expense']?.add({
          'category': item['category'],
          'total': double.tryParse(item['total'].toString()) ?? 0,
        });
      }
    }

    setState(() {
      sumPemasukan = sumPemasukan;
      sumPengeluaran = sumPengeluaran;
      mappedLaporanPengeluaran = mappedLaporanPengeluaran;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: getLaporanPeriod,
        child: ListView(padding: const EdgeInsets.all(10), children: [
          const Text(
            'Laporan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextField(
                  controller: dateInput,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tanggal Mulai',
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
              ),
              const SizedBox(width: 10),
              Flexible(
                child: TextField(
                  controller: dateInputEnd,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tanggal Selesai',
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
                        dateInputEnd.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Total",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(fontSize: 16, color: Colors.green),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pemasukan',
                prefixIcon: Icon(Icons.attach_money),
              ),
              readOnly: true,
              controller: TextEditingController(
                  text: NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(sumPemasukan)),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(fontSize: 16, color: Colors.red),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pengeluaran',
                prefixIcon: Icon(Icons.attach_money),
              ),
              readOnly: true,
              controller: TextEditingController(
                  text: NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(sumPengeluaran)),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Selisih',
                prefixIcon: Icon(Icons.attach_money),
              ),
              readOnly: true,
              controller: TextEditingController(
                  text: NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(sumPemasukan - sumPengeluaran)),
            ),
          ]),
          const SizedBox(height: 20),
          ExpansionTile(
              title: const Text(
                "Total Pemasukan ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: [
                ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(mappedLaporanPengeluaran['income']?[index]
                              ['category'] ??
                          ''),
                      trailing: Text(
                          NumberFormat.currency(
                                  locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                              .format(mappedLaporanPengeluaran['income']?[index]
                                      ['total'] ??
                                  0),
                          style: const TextStyle(
                              color: Colors.green, fontSize: 14)),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                  itemCount: mappedLaporanPengeluaran['income']?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                )
              ]),
          ExpansionTile(
              title: const Text(
                "Total Pengeluaran",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: [
                ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(mappedLaporanPengeluaran['expense']?[index]
                              ['category'] ??
                          ''),
                      trailing: Text(
                          NumberFormat.currency(
                                  locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                              .format(mappedLaporanPengeluaran['expense']
                                      ?[index]['total'] ??
                                  0),
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14)),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                  itemCount: mappedLaporanPengeluaran['expense']?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                )
              ])
        ]));
  }
}
