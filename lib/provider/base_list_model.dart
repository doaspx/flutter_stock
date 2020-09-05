import 'base_model.dart';


abstract class BaseListModel<T> extends BaseModel{
  List<T> list = [];
  Map params = {}; //针对erp 筛选(包含filter参数(erp筛选的),自定义的例如:where)


  initData({ Map initParams, }) async {
    setBusy();    
    params = initParams;
    await refresh(init: true);
  }

  // 下拉刷新
  refresh({bool init = false}) async {
    try {
      List<T> data = await loadData(params:params);
      list.clear();
      if (data.isEmpty) {
        setEmpty();
      } else {
        onCompleted(data);
        list.addAll(data);
        setIdle();
      }
    } catch (e) {
      if (init) list.clear();
      setError(e);
    }
  }

  Future<List<T>> loadData({params});

   onCompleted(List<T> data) {}
}