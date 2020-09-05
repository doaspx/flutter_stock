/*
 * @Author: zhang
 * @Date: 2020-06-20 08:29:41
 * @LastEditTime: 2020-06-26 23:42:09
 * @FilePath: /stock_app/lib/ui/choice.dart
 */

import 'package:flutter/material.dart';

import 'components/100_index.dart';
import 'widgets/table_sticky_headers.dart';

class ChoicePage extends StatelessWidget {
  const ChoicePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TLAppBar.top(context, '自选', leading: false),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _TopOneWidget(),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: ListWidget()
            )
          ],
        ));
  }
}

class _TopOneWidget extends StatelessWidget {
  const _TopOneWidget({Key key}) : super(key: key);

  Widget getItem(String name) {
    return Container(
        width: 80,
        height: 45,
        child: Row(children: [
          Icon(Icons.star, color: Colors.redAccent),
          SizedBox(width: 5),
          Text(name, style: TLFont.black54_16)
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      getItem('新闻'),
      getItem('公告'),
      getItem('研报'),
      getItem('大事'),
    ]);
  }
}

class ListWidget extends StatelessWidget {
  const ListWidget({Key key}) : super(key: key);

  final columns = 10;
  final rows = 20;

  List<List<String>> _makeData() {
    final List<List<String>> output = [];
    for (int i = 0; i < columns; i++) {
      final List<String> row = [];
      for (int j = 0; j < rows; j++) {
        row.add('127.1');
      }
      output.add(row);
    }
    return output;
  }



  /// Simple generator for column title
  List<String> _makeTitleColumn() => ['最新','涨幅', '涨跌','现手','开盘','昨收','最高','最低','总市值'];

  /// Simple generator for row title
  List<String> _makeTitleRow() => ['上证指数','深证指数','贵州茅台','贵州茅台','贵州茅台','贵州茅台','贵州茅台','贵州茅台','贵州茅台','贵州茅台',
  '贵州茅台','贵州茅台','贵州茅台','贵州茅台','贵州茅台','贵州茅台','贵州茅台','贵州茅台','贵州茅台','贵州茅台',];

  @override
  Widget build(BuildContext context) {
    return TableView(
      titleColumn: _makeTitleColumn(),
      titleRow: _makeTitleRow(),
      data: _makeData(),
    );
  }
}


class TableView extends StatelessWidget {
  TableView(
      {@required this.data,
        @required this.titleColumn,
        @required this.titleRow});

  final List<List<String>> data;
  final List<String> titleColumn;
  final List<String> titleRow;

  @override
  Widget build(BuildContext context) {
    return StickyHeadersTable(
          columnsLength: titleColumn.length,
          rowsLength: titleRow.length,
          columnsTitleBuilder: (index){
            return Text(titleColumn[index],style: TLFont.black54_16,);
          },
          rowsTitleBuilder: (i) {
           return  Column(
             children: [
               Text(titleRow[i]),
                Text('600519.SH',style: TLFont.black54_11,),
             ]
           );
          },
          contentCellBuilder: (i, j) {
            return Text(data[i][j], style: TLFont.red_16,);
          },
          cellDimensions:CellDimensions(
            contentCellWidth: 70.0,
            contentCellHeight: 50.0,
            stickyLegendWidth: 110.0,
            stickyLegendHeight: 35.0,
          ),
          legendCell: Row(
            children: [
              Text('编辑',style: TLFont.black54_16,),
              SizedBox(width: 5,),
              Icon(Icons.edit, size: 15, color: Colors.grey)
            ]
          ),
        );
  }
}