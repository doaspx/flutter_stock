import 'package:app_stock/utils/sql_util.dart';
import 'package:flutter/material.dart';
class StockSearch extends StatefulWidget {
  StockSearch({Key key}) : super(key: key);

  @override
  _StockSearchState createState() => _StockSearchState();
}

class _StockSearchState extends State<StockSearch> {
  List list = [];

  search(String str,{init = false}) async {
    SqlUtil sql = SqlUtil.setTable('stock_list');
    if(init == false) list = await sql.search(conditions: {'name':str, 'code':str, 'jc':str});
    else list = await sql.searchlimit(600);
    setState(() {
      
    });
  }



  

  @override
  void initState() {
    search('', init: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
        leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.keyboard_arrow_left,
                    size: 28, color: Colors.white)),
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left:10),
          margin: EdgeInsets.only(bottom:3),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: TextField(
            onChanged: (str){
                print(str);
                search(str);
            },
            keyboardType:TextInputType.text,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              suffixIcon:Icon(Icons.picture_in_picture),
            hintText:'股票代码/名称/简称',
              border:InputBorder.none,
              icon: Icon(Icons.search)),
          )
        ),
      ),
    ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemBuilder: (childContext, index){
          return InkWell(
            onTap:(){
                Navigator.of(context).pop(list[index]);
            },
            child: Column(
              children: [
                ListTile(title: Text(list[index]['name']), 
                dense:true,
                subtitle: Text(list[index]['code']), leading: Icon(Icons.tab),),
                Divider()
              ]
            )
          );
      }, itemCount:  list.length,)
    );
  }
}