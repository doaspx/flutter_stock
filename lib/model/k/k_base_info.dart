/*
 * @Author: zhang
 * @Date: 2020-05-25 21:49:15
 * @LastEditTime: 2020-05-25 21:54:30
 * @FilePath: /app_stock/lib/model/k/k_base_info.dart
 */ 
 mixin KBaseInfoEntity{
   String m;
   String c;
   String name;
   get fullCode=> m+c;

} 