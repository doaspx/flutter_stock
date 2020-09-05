
import 'package:app_stock/provider/base_model.dart';

class ChartButtonProvider extends BaseModel{
  bool isShowBigButton;
  bool isShowFullButton;
  ChartButtonProvider() {
    isShowBigButton = false;
    isShowFullButton = false;
  }

  changeBSState(){
    isShowBigButton = !isShowBigButton;
    notifyListeners();
  }

  changeFullState(){
    isShowFullButton = !isShowFullButton;
    notifyListeners();
  }
}