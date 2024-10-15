import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_font.dart';
import 'package:mobile/entity/model/paginate.dart';
import 'package:mobile/entity/model/transaction.dart';
import 'package:mobile/extension/extension_method.dart';
import 'package:mobile/page/listtransaction/cashier/cashiersalesdetial.dart';

import 'package:mobile/services/service_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CashierListTransaction extends StatefulWidget {
  const CashierListTransaction({super.key});

  @override
  State<CashierListTransaction> createState() => _CashierListTransactionState();
}

class _CashierListTransactionState extends State<CashierListTransaction> {
  List<Transaction> items = [];
  Paginate<Transaction> paginateData = Paginate<Transaction>();
  RefreshController refreshController = RefreshController();
  TextEditingController receiptNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initFutureList();
  }

  Future initFutureList() async {
    paginateData = await ServiceController.getCashierSales(paginateData);
    setState(() {});
  }

  Future searchInvoice() async {
    paginateData.currentPage = 1;
    paginateData.data!.clear();
    paginateData = await ServiceController.getCashierSales(paginateData,
        param: "receipt_number=${receiptNumberController.text}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total sum of all transactions
    double sumTotal = paginateData.data?.fold(0.0, (sum, item) {
          return sum! + (item.totalPrice ?? 0.0);
        }) ??
        0.0;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'ការលក់សរុប',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  sumTotal.toKhmerCurrency(), // Display the total sum
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: 50,
              //   decoration: BoxDecoration(
              //     color: Colors.grey[200],
              //   ),
              //   child: const Text("25/September/2024"),
              // ),
              Expanded(
                child: SmartRefresher(
                  physics: const ClampingScrollPhysics(),
                  controller: refreshController,
                  enablePullDown: true,
                  enablePullUp: paginateData.lastPage != null &&
                          paginateData.currentPage != null
                      ? paginateData.lastPage! > paginateData.currentPage!
                      : false,
                  footer: const ClassicFooter(),
                  header: const ClassicHeader(),
                  onRefresh: () {
                    paginateData.currentPage = 1;
                    initFutureList();
                    refreshController.refreshCompleted();
                    setState(() {});
                  },
                  onLoading: () async {
                    if (paginateData.currentPage != null) {
                      paginateData.currentPage = paginateData.currentPage! + 1;
                    }
                    await initFutureList();
                    refreshController.loadComplete();
                    setState(() {});
                  },
                  child: paginateData.data != null &&
                          paginateData.data!.isNotEmpty
                      ? ListView(
                          children: paginateData.data!.map((e) {
                            double totalPrice = e.totalPrice ?? 0.0;
                            final pro = e.details!.length;

                            return Dismissible(
                              key: Key(e.id
                                  .toString()), // Use unique ID or receiptNumber
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) {
                                // Handle deletion logic
                                setState(() {
                                  paginateData.data!.remove(e);
                                });
                                // Optionally, call a service to delete the item from the server
                                final service = ServiceController();
                                service.daleteSales(e.id!);
                              },
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                    () => CashierSalesDetail(
                                      totalPrice:
                                          e.totalPrice!.toKhmerCurrency(),
                                      date: e.orderedAt,
                                      img: e.cashier!.avatar,
                                      cashier: e.cashier!.name,
                                      recieptNum: e.receiptNumber,
                                      code: pro,
                                      qty: e.details!.indexed,
                                      id: e.id,
                                    ),
                                    transition: Transition.downToUp,
                                    duration: const Duration(milliseconds: 350),
                                  );
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.receipt,
                                                            color: Colors.grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "#${e.receiptNumber!}"
                                                                    .toString(),
                                                                style: GoogleFonts
                                                                    .kantumruyPro(),
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    (e.orderedAt ??
                                                                            "N/A")
                                                                        .toDateYYYYMMDD(),
                                                                    style: GoogleFonts.kantumruyPro(
                                                                        fontSize:
                                                                            11),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            totalPrice
                                                                .toKhmerCurrency(),
                                                            style: GoogleFonts
                                                                .kantumruyPro(
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          CircleAvatar(
                                                            radius: 12,
                                                            backgroundColor:
                                                                Colors.white,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    '${e.cashier!.avatar}'),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                          thickness: 1,
                                          color: Colors.grey[200]),
                                      const SizedBox(height: 5)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : Center(
                          child: EText(
                            text: "No Data",
                          ),
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
