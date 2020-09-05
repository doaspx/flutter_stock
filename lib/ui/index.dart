/*
 * @Author: zhang
 * @Date: 2020-06-20 08:22:01
 * @LastEditTime: 2020-09-05 13:51:58
 * @FilePath: /stock_app/lib/ui/index.dart
 */ 
import 'package:app_stock/ui/choice.dart';
import 'package:app_stock/ui/home.dart';
import 'package:app_stock/ui/market.dart';
import 'package:app_stock/ui/my.dart';
import 'package:app_stock/ui/widgets/index.dart';
import 'package:flutter/material.dart';


class IndexPage extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<IndexPage> {
  int  selectTabIndex = 0;
  @override
  Widget build(BuildContext context) {
      return Scaffold(
                backgroundColor: Color.fromRGBO(244, 245, 245, 1),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: selectTabIndex,
                  items: [ 
                      BottomNavigationBarItem(icon:Icon(Icons.home), title: Text('首页', style: TextStyle(fontSize:12),)),
                      BottomNavigationBarItem(icon:Icon(Icons.group_work), title: Text('市场', style: TextStyle(fontSize:12),)),
                      BottomNavigationBarItem(icon: Icon(Icons.group_work), title: Text('自选', style: TextStyle(fontSize:12),)),
                      BottomNavigationBarItem(icon: Icon(Icons.group_work), title: Text('股票', style: TextStyle(fontSize:12),)),
                      BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我的', style: TextStyle(fontSize:12),)),
                  ] ,
                  onTap: (index){
                    setState(() {
                      selectTabIndex = index;
                    });
                  },
                ),
                body: IndexedStack(
                  index: selectTabIndex,
                  children:[   HomePage(),MarketPage(),  ChoicePage(), StockIndex(),  MyPage() ] ,//StockIndex(),
                )
              );
      
  }
}

class HomeOther {
}
