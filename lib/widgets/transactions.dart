import 'package:flutter/material.dart';
import 'package:money_manager/helpers/transaction.dart';
import 'package:money_manager/model/transaction.dart';

List<String> month = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

class ShowTransactions extends StatefulWidget {
  const ShowTransactions({
    super.key,
  });

  @override
  State<ShowTransactions> createState() => _ShowTransactionsState();
}

class _ShowTransactionsState extends State<ShowTransactions> {
  Future<List<TranscationModel>> listTranscation = Future.value([]);
  String transactionType = "all";

  @override
  void initState() {
    super.initState();
    listTranscation = DbTransactionHelper.instance.getTransactionsList();
  }

  Future<void> _refresh() async {
    setState(() {
      listTranscation = DbTransactionHelper.instance.getTransactionsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder(
          future: listTranscation,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data transaksi'));
              }

              Map<String, List<Widget>> mappedWidget = {};

              for (TranscationModel tran in snapshot.data!) {
                if (mappedWidget.containsKey(tran.date.toIso8601String())) {
                  if (transactionType != "all" &&
                      transactionType != tran.transcationType) {
                    continue;
                  }

                  mappedWidget[tran.date.toIso8601String()]!.add(
                    CardTransaction(
                      transaction: tran,
                    ),
                  );
                } else {
                  mappedWidget[tran.date.toIso8601String()] = [];

                  if (transactionType != "all" &&
                      transactionType != tran.transcationType) {
                    continue;
                  }

                  mappedWidget[tran.date.toIso8601String()]!
                      .add(CardTransaction(
                    transaction: tran,
                  ));
                }
              }

              List<Widget> finalWidget = [
                Wrap(
                  spacing: 10,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            transactionType = "all";
                            _refresh();
                          });
                        },
                        style: transactionType == "all"
                            ? ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        child: Text(
                          "Semua",
                          style: transactionType == "all"
                              ? const TextStyle(color: Colors.white)
                              : null,
                        )),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            transactionType = "income";
                            _refresh();
                          });
                        },
                        style: transactionType == "income"
                            ? ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        child: Text("Pemasukan",
                            style: transactionType == "income"
                                ? const TextStyle(color: Colors.white)
                                : null)),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            transactionType = "expense";
                            _refresh();
                          });
                        },
                        style: transactionType == "expense"
                            ? ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        child: Text("Pengeluaran",
                            style: transactionType == "expense"
                                ? const TextStyle(color: Colors.white)
                                : null)),
                  ],
                )
              ];

              mappedWidget = Map.fromEntries(mappedWidget.entries.toList()
                ..sort((e1, e2) => e2.key.compareTo(e1.key)));

              for (String key in mappedWidget.keys) {
                if (mappedWidget[key]!.isNotEmpty) {
                  DateTime date = DateTime.parse(key);
                  mappedWidget[key]!.insert(
                      0,
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "${month[date.month - 1]} ${date.day}, ${date.year}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )));
                }

                finalWidget.addAll(mappedWidget[key]!);
              }

              if (finalWidget.length == 1) {
                finalWidget.add(const ListTile(
                  title: Text("Tidak ada data transaksi"),
                ));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                itemCount: finalWidget.length,
                itemBuilder: (context, index) {
                  return finalWidget[index];
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class CardTransaction extends StatelessWidget {
  final TranscationModel transaction;
  const CardTransaction({
    super.key,
    required this.transaction,
  });

  Widget buildIcon(String category) {
    switch (category) {
      case 'food':
        return const Icon(Icons.fastfood);
      case 'travel':
        return const Icon(Icons.flight);
      case 'shopping':
        return const Icon(Icons.shopping_cart);
      case 'medical':
        return const Icon(Icons.medical_services);
      case 'education':
        return const Icon(Icons.school);
      case 'salary':
        return const Icon(Icons.money);
      case 'entertainment':
        return const Icon(Icons.movie);
      case 'others':
        return const Icon(Icons.more_horiz);
      default:
        return const Icon(Icons.more_horiz);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: ListTile(
          leading: Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildIcon(transaction.category),
            ),
          ),
          title: Text(transaction.title),
          subtitle: Text(transaction.amount.toString()),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  "${transaction.transcationType == "income" ? "+" : "-"}Rp ${transaction.amount}",
                  style: TextStyle(
                      color: transaction.transcationType == "income"
                          ? Colors.green
                          : Colors.red,
                      fontSize: 16)),
              Text(
                  "${month[transaction.date.month - 1]} ${transaction.date.day} "),
            ],
          )),
    );
  }
}
