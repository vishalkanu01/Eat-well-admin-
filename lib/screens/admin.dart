import 'package:CWCFlutter/api/food_api.dart';
import 'package:CWCFlutter/notifier/order_notifier.dart';
import 'package:CWCFlutter/screens/feed.dart';
import 'package:CWCFlutter/screens/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;

  @override
  void initState() {
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    getOrders(orderNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    Future<void> _refreshList() async {
      getOrders(orderNotifier);
    }

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: new RefreshIndicator(
          child: _loadScreen(),
          onRefresh: _refreshList,
        ));
  }

  Widget _loadScreen() {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Text("Users")),
                          subtitle: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Card(
                      child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Orders()));
                          },
                          title: FlatButton.icon(
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders")),
                          subtitle: Text(
                            orderNotifier.orderList.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Feed()));
              },
            ),
          ],
        );
        break;
      default:
        return Container();
    }
  }
}
