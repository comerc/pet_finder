// import 'package:built_collection/built_collection.dart';
// import 'package:english_words/english_words.dart';
// import 'package:pet_finder/import.dart';

// class DatabaseRepository {
//   DatabaseRepository._() {
//     colors = [];
//     colors.add(ColorModel(id: 'gray', name: 'Gray'));
//     colors.add(ColorModel(id: 'white', name: 'White'));
//     colors.add(ColorModel(id: 'black', name: 'Black'));
//     colors.add(ColorModel(id: 'tiger', name: 'Tiger'));
//     colors.add(ColorModel(id: 'stripe', name: 'Stripe'));
//     sizes = [];
//     sizes.add(SizeModel(id: 'tiny', name: 'Tiny'));
//     sizes.add(SizeModel(id: 'little', name: 'Little'));
//     sizes.add(SizeModel(id: 'middle', name: 'Middle'));
//     sizes.add(SizeModel(id: 'big', name: 'Big'));
//     sizes.add(SizeModel(id: 'huge', name: 'Huge'));
//     member = MemberModel(
//       id: '0',
//       // displayName: 'Maria',
//       // imageUrl: 'assets/user_avatar.jpg',
//       phone: '+7 (777) 654-3210',
//       isWhatsApp: false,
//       isViber: false,
//     );
//     final cats = generateUnits('cats', 9);
//     final dogs = generateUnits('dogs', 12);
//     data = [...cats, ...dogs];
//   }

//   late List<ColorModel> colors;
//   late List<SizeModel> sizes;
//   late MemberModel member;
//   late List<UnitModel> data;
//   var offset = 0;

//   static final DatabaseRepository _instance = DatabaseRepository._();

//   factory DatabaseRepository() {
//     return _instance;
//   }

//   List<UnitModel> generateUnits(String prefix, int size) {
//     final wordPairs = generateWordPairs().take(size).toList();
//     return List.generate(size, (int index) {
//       final images = (index == 0)
//           ? List.generate(4, (index) {
//               return ImageModel(
//                 url: 'assets/$prefix/$index.jpg',
//                 height: 0,
//                 width: 0,
//               );
//             })
//           : [
//               ImageModel(
//                 url: 'assets/$prefix/$index.jpg',
//                 height: 0,
//                 width: 0,
//               )
//             ];
//       // : [
//       //     'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'
//       //   ];
//       return UnitModel(
//         id: '${prefix}_$index',
//         title: '${wordPairs[index].asPascalCase} (${prefix}_$index)',
//         color: colors[next(0, colors.length - 1)],
//         wool: WoolValue.values[next(0, WoolValue.values.length - 1)],
//         weight: next(5, 15) * 100,
//         size: sizes[next(0, sizes.length - 1)],
//         story: 'story',
//         member: member,
//         images: images.toBuiltList(),
//         birthday: DateTime.now().add(Duration(days: -next(0, 9125))),
//         address: 'address',
//         sex: index % 2 == 0 ? SexValue.male : SexValue.female,
//         age: AgeValue.values[next(0, AgeValue.values.length - 1)],
//         wishesCount: 321,
//       );
//     });
//   }

//   Future<List<UnitModel>> load(
//       {int size = 10, int delay = 2, bool isMore = false}) async {
//     await Future.delayed(Duration(seconds: delay));
//     final start = isMore ? offset : 0;
//     var end = offset + size;
//     if (end > data.length) {
//       end = data.length;
//     }
//     offset = end;
//     if (!isMore) {
//       // data.shuffle();
//     }
//     return data.getRange(start, end).toList();
//   }
// }
