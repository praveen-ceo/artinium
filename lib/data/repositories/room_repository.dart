import '../../models/room.dart';
import '../mock/mock_data.dart';

class RoomRepository {
  List<Room> all() => MockData.rooms;

  Room? byId(String id) {
    for (final r in MockData.rooms) {
      if (r.id == id) return r;
    }
    return null;
  }

  int totalDeviceCount() =>
      MockData.rooms.fold(0, (sum, r) => sum + r.deviceCount);
}
