import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, dynamic>> orders = [
    {
      'id': 1,
      'user': 'John Doe',
      'category': 'Electronics',
      'product': 'iPhone 12',
      'date': '2023-04-15',
      'method': 'pay now',
      'status': 'Pending',
    },
    {
      'id': 2,
      'user': 'Jane Doe',
      'category': 'Fashion',
      'product': 'T-shirt',
      'date': '2023-04-16',
      'method': 'pay on delivery',
      'status': 'Delivered',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Schedule',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 31,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('User')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Payement Method')),
                  DataColumn(label: Text('Order Status')),
                ],
                rows: orders
                    .map(
                      (order) => DataRow(
                        cells: [
                          DataCell(Text('${order['id']}')),
                          DataCell(Text(order['user'])),
                          DataCell(Text(order['category'])),
                          DataCell(Text(order['product'])),
                          DataCell(Text(order['date'])),
                          DataCell(Text(order['method'])),
                          DataCell(Text(order['status'])),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          // Add more slivers here...
        ],
      ),
    );
  }
}
