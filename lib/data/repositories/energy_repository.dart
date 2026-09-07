import '../../models/energy.dart';
import '../mock/mock_data.dart';

class EnergyRepository {
  EnergySnapshot current() => MockData.energySnapshot();
}
