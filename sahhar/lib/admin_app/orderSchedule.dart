import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'orderInfo.dart';

class OrderSchedule extends StatefulWidget {
  const OrderSchedule({Key? key});

  @override
  State<OrderSchedule> createState() => _OrderScheduleState();
}

class _OrderScheduleState extends State<OrderSchedule> {
  String selectedFilter = 'All'; // Variable to store the selected filter

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Orders Schedule',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterChip(
                    label: Text('All'),
                    selected: selectedFilter == 'All',
                    onSelected: (value) {
                      setState(() {
                        selectedFilter = 'All';
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('Ordering'),
                    selected: selectedFilter == 'Ordering',
                    onSelected: (value) {
                      setState(() {
                        selectedFilter = 'Ordering';
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('Working on'),
                    selected: selectedFilter == 'Working on',
                    onSelected: (value) {
                      setState(() {
                        selectedFilter = 'Working on';
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('Completed'),
                    selected: selectedFilter == 'Completed',
                    onSelected: (value) {
                      setState(() {
                        selectedFilter = 'Completed';
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future:
                    FirebaseFirestore.instance.collection('orderStates').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Color(0xFF7E0000),
                    ));
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    // Filter the data based on the selected filter
                    var filteredData = snapshot.data!.docs;
                    if (selectedFilter != 'All') {
                      filteredData = filteredData
                          .where(
                              (doc) => doc['packageStutes'] == selectedFilter)
                          .toList();
                    }

                    if (filteredData.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Orders',
                          style: TextStyle(color: Colors.black, fontSize: 26),
                        ),
                      );
                    }

                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.90,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          var orderData = filteredData[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => Ordernfo(
                                  orderId: orderData.id,
                                ),
                              ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF7E0000),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.93,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Name : ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                    '${orderData['userName']}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 30,
                                              width: 20,
                                              child: InkWell(
                                                onTap: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('order')
                                                      .doc(orderData.id)
                                                      .collection('items')
                                                      .get()
                                                      .then((value) {
                                                    for (int i = 0;
                                                        i < value.docs.length;
                                                        i++)
                                                      value.docs[i].reference
                                                          .delete();
                                                  }).then((value) async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'orderStates')
                                                        .doc(orderData.id)
                                                        .delete();
                                                  }).then((value) =>
                                                          setState(() {}));
                                                },
                                                child: Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Phone : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            width: 181,
                                            child: Text(
                                              '${orderData['number']}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Email: ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            width: 170,
                                            child: Text(
                                              orderData['email'].toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Total price : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            '${orderData['totalprice']} ₪',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: const [
                                              Text(
                                                'Order Status :  ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                'Ordering',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Container(
                                                  height: 25,
                                                  width: 23,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Checkbox(
                                                    checkColor: Colors.black,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    activeColor: Colors.white,
                                                    value: orderData[
                                                                'packageStutes'] ==
                                                            'Ordering'
                                                        ? true
                                                        : false,
                                                    onChanged: (val) async {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'orderStates')
                                                          .doc(orderData.id)
                                                          .update({
                                                        'packageStutes':
                                                            'Ordering',
                                                      }).then((value) =>
                                                              setState(() {}));
                                                    },
                                                  )),
                                              const Text(
                                                'Working On',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Container(
                                                  height: 25,
                                                  width: 23,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Checkbox(
                                                    checkColor: Colors.black,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    activeColor: Colors.white,
                                                    value: orderData[
                                                                'packageStutes'] ==
                                                            'Working on'
                                                        ? true
                                                        : false,
                                                    onChanged: (val) async {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'orderStates')
                                                          .doc(orderData.id)
                                                          .update({
                                                        'packageStutes':
                                                            'Working on',
                                                      }).then((value) =>
                                                              setState(() {}));
                                                    },
                                                  )),
                                              const Text(
                                                'Completed',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Container(
                                                  height: 25,
                                                  width: 23,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Checkbox(
                                                    checkColor: Colors.black,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    activeColor: Colors.white,
                                                    value: orderData[
                                                                'packageStutes'] ==
                                                            'Completed'
                                                        ? true
                                                        : false,
                                                    onChanged: (val) {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'orderStates')
                                                          .doc(orderData.id)
                                                          .update({
                                                        'packageStutes':
                                                            'Completed',
                                                      }).then((value) =>
                                                              setState(() {}));
                                                    },
                                                  )),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No Orders',
                        style: TextStyle(color: Colors.black, fontSize: 26),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}
