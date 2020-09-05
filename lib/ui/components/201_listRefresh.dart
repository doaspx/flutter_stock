import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListRefresh<T> extends StatelessWidget {
  final RefreshController refreshController;
  final Function onRefresh;
  final Function onLoading;
  final List list;
  final shrinkWrap ;
  final controller;
  final Function<T>(BuildContext context, int index, T item, ) buildItem;

  ListRefresh(
      {this.refreshController, this.onRefresh, this.onLoading, this.list, this.buildItem,
      this.controller ,
       this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: refreshController,
        header: ClassicHeader(
            idleText: '下拉刷新',
            releaseText: '释放刷新', 
            refreshingText: '刷新中',
            completeText: '刷新完成'),
        footer: ClassicFooter(
            idleText: '上拉加载',
            canLoadingText: '释放加载',
            noDataText: '没有数据',
            loadingText: '加载中'),
        onRefresh: onRefresh,
        onLoading: onLoading,
        enablePullUp: true,
        child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: shrinkWrap,
            controller: controller??ScrollController(),
            itemBuilder: (context, index) {
              if(buildItem != null && list[index] != null){
                return buildItem(context, index, list[index]);
              }else {
                return list[index];
              }
            })
            
        );
  }
}