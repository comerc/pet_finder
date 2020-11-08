// import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';
import 'package:pet_finder/data.dart';
import 'package:pet_finder/category_list.dart';
import 'package:pet_finder/pet_widget.dart';

final List<Pet> pets = getPetList();

class ShowcaseScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/showcase',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 2.0; // Will slow down animations by a factor of two
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.sort,
          color: Colors.grey[800],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.notifications_none,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (BuildContext context) =>
            ShowcaseCubit(getRepository<DatabaseRepository>(context))..load(),
        child: ShowcaseBody(),
      ),
    );
  }
}

class ShowcaseBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double _kHorizontalPadding = 16;
    return BlocBuilder<ShowcaseCubit, ShowcaseState>(
      builder: (BuildContext context, ShowcaseState state) {
        if (state.status == ShowcaseStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Text(
              //     "Find Your",
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 24,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //   child: Text(
              //     "Lovely pet in anywhere",
              //     style: TextStyle(
              //       color: Colors.grey[800],
              //       fontSize: 24,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.all(16),
              //   child: TextField(
              //     decoration: InputDecoration(
              //       hintText: 'Search',
              //       hintStyle: TextStyle(fontSize: 16),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(15),
              //         borderSide: BorderSide(
              //           width: 0,
              //           style: BorderStyle.none,
              //         ),
              //       ),
              //       filled: true,
              //       fillColor: Colors.grey[100],
              //       contentPadding: EdgeInsets.only(
              //         right: 30,
              //       ),
              //       prefixIcon: Padding(
              //         padding: EdgeInsets.only(right: 16.0, left: 24.0),
              //         child: Icon(
              //           Icons.search,
              //           color: Colors.black,
              //           size: 24,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pet Category",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.grey[800],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: GridView.count(
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  childAspectRatio: 5 / 2,
                  mainAxisSpacing: _kHorizontalPadding,
                  crossAxisSpacing: _kHorizontalPadding,
                  children: List.generate(state.categories.length,
                      (int index) => buildPetCategory(state.categories[index])),
                ),

                // child: Column(
                //   children: [
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         buildPetCategory(
                //             Category.HAMSTER, "56", Colors.orange[200]),
                //         buildPetCategory(Category.CAT, "210", Colors.blue[200]),
                //       ],
                //     ),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         buildPetCategory(
                //             Category.BUNNY, "90", Colors.green[200]),
                //         buildPetCategory(Category.DOG, "340", Colors.red[200]),
                //       ],
                //     ),
                //   ],
                // ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Newest Pet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.grey[800],
                    ),
                  ],
                ),
              ),
              Container(
                height: 280,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: buildNewestPet(units: state.units),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "Vets Near You",
              //         style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.grey[800],
              //         ),
              //       ),
              //       Icon(
              //         Icons.more_horiz,
              //         color: Colors.grey[800],
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   height: 130,
              //   margin: EdgeInsets.only(bottom: 16),
              //   child: PageView(
              //     physics: BouncingScrollPhysics(),
              //     children: [
              //       buildVet("assets/images/vets/vet_0.png",
              //           "Animal Emergency Hospital", "(369) 133-8956"),
              //       buildVet("assets/images/vets/vet_1.png",
              //           "Artemis Veterinary Center", "(706) 722-9159"),
              //       buildVet("assets/images/vets/vet_2.png",
              //           "Big Lake Vet Hospital", "(598) 4986-9532"),
              //       buildVet("assets/images/vets/vet_3.png",
              //           "Veterinary Medical Center", "(33) 8974-559-555"),
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget buildPetCategory(CategoryModel category
      // Category category, String total, Color color
      ) {
    final color = Colors.blue[200]; // TODO: category.color
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // navigator.push(
          //   MaterialPageRoute(
          //       builder: (context) => CategoryList(category: category)),
          // );
        },
        child: Container(
          height: 80,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[200],
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.5),
                ),
                child: Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      'assets/images/${category.id}.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Total of ${category.totalOf}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildNewestPet({List<UnitModel> units}) {
    // List<Widget> list = [];
    // for (var i = 0; i < pets.length; i++) {
    //   if (pets[i].newest) {
    //     list.add(PetWidget(pet: pets[i], index: i));
    //   }
    // }
    // return list;
    return List.generate(units.length,
        (int index) => PetWidget(unit: units[index], index: index));
  }

  Widget buildVet(String imageUrl, String name, String phone) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        border: Border.all(
          width: 1,
          color: Colors.grey[300],
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 98,
            width: 98,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.grey[800],
                    size: 18,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    phone,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "OPEN - 24/7",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
