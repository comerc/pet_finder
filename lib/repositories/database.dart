import 'package:english_words/english_words.dart';
import 'package:pet_finder/imports.dart';

class DatabaseRepository {
  DatabaseRepository._() {
    member = MemberModel(
      id: "1234",
      displayName: "Maria",
      imageUrl: "/assets/user_avatar.jpg",
    );
    var cats = generateUnits("cats", 9);
    var dogs = generateUnits("dogs", 12);
    data = [...cats, ...dogs];
  }

  late MemberModel member;
  late List<UnitModel> data;
  var offset = 0;

  static final DatabaseRepository _instance = DatabaseRepository._();

  factory DatabaseRepository() {
    return _instance;
  }

  List<UnitModel> generateUnits(String prefix, int size) {
    var wordPairs = generateWordPairs().take(size).toList();
    return List.generate(size, (index) {
      return UnitModel(
        id: "${prefix}_$index",
        title: "${wordPairs[index].asPascalCase} (${prefix}_$index)",
        color: "color",
        weight: 1200,
        story: "story",
        member: member,
        imageUrl: "/assets/${prefix}_$index.jpg",
        birthday: DateTime.now().add(Duration(days: -500)),
        address: "address",
      );
    });
  }

  Future<List<UnitModel>> load(
      {int size = 8, int delay = 2, bool isMore = false}) async {
    await Future.delayed(Duration(seconds: delay));
    var start = isMore ? offset : 0;
    var end = offset + size;
    if (end > data.length) {
      end = data.length;
    }
    offset = end;
    // if (!isMore) {
    //   data.shuffle();
    // }
    return data.getRange(start, end).toList();
  }
}
