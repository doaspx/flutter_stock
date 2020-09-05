import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_list_model.dart';

/// 基于privoider 和下拉框进行特殊处理
abstract class BaseRefreshListModel<T> extends BaseListModel<T> {
  /// 分页第一页页码
  static const int firstPage = 1;

  /// 分页条目数量
  static const int limit = 50;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  /// 当前页码
  int _currentPage = firstPage;

  /// 下拉刷新
  ///
  /// [init] 是否是第一次加载
  /// true:  Error时,需要跳转页面
  /// false: Error时,不需要跳转页面,直接给出提示
  Future<List<T>> refresh({bool init = false}) async {
    try {
      _currentPage = firstPage;
      var data = await loadData(params: requestPms());

      list.clear();
      if (data == null || data.isEmpty) {
        refreshController.refreshCompleted(resetFooterState: true);
        setEmpty();
      } else {
        onCompleted(data);
        list.addAll(data);
        refreshController.refreshCompleted();
        // 小于分页的数量,禁止上拉加载更多
        if (data.length < limit) {
          refreshController.loadNoData();
        } else {
          //防止上次上拉加载更多失败,需要重置状态
          refreshController.loadComplete();
        }
        setIdle();
      }
      return data;
    } catch (e) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) list.clear();
      refreshController.refreshFailed();
      setError(e);
      return null;
    }
  }

  Map requestPms() {
    var pms = {};
    pms['page'] = _currentPage;
    pms['start'] = (_currentPage - 1) * limit;
    pms['limit'] = limit;
    if (params != null && params.isNotEmpty) {
      // if(params['filter'] != null) pms['filter'] = params['filter'];
      // if(params['where'] != null) pms['where'] = params['where'];

      params.forEach((key, value) {
        if (key == 'filter')
          pms['filter'] = params['filter'];
        else if (key == 'where')
          pms['where'] = params['where'];
        else
          pms[key] = value;
      });
    }
    return pms;
  }

  /// 上拉加载更多
  Future<List<T>> loadMore() async {
    try {
      ++_currentPage;
      var data = await loadData(
        params: requestPms(),
      );
      // var data = await loadData(params: null);
      if (data.isEmpty) {
        _currentPage--;
        refreshController.loadNoData();
      } else {
        onCompleted(data);
        list.addAll(data);
        if (data.length < limit) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
        notifyListeners();
      }
      return data;
    } catch (e, s) {
      _currentPage--;
      refreshController.loadFailed();
      print('error--->\n' + e.toString());
      print('statck--->\n' + s.toString());
      return null;
    }
  }

  // 继承自己来实现
  Future<List<T>> loadData({params});

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
