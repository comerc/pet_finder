import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

// TODO: как выполнить рефреш категорий?

class HomeScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/home',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 2.0; // Will slow down animations by a factor of two
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.sort,
          color: Colors.grey.shade800,
        ),
        actions: [
          _WishesButton(),
          _LogoutButton(),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.notifications_none,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (BuildContext context) =>
            HomeCubit(getRepository<DatabaseRepository>(context)),
        child: HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
    load(() => getBloc<HomeCubit>(context).load());
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    result = BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (HomeState previous, HomeState current) {
        return previous.status != current.status;
      },
      builder: (BuildContext context, HomeState state) {
        final cases = {
          HomeStatus.initial: () => Container(),
          HomeStatus.loading: () => Center(child: CircularProgressIndicator()),
          HomeStatus.error: () {
            return Center(
              child: FloatingActionButton(
                onPressed: () {
                  BotToast.cleanAll();
                  load(() => getBloc<HomeCubit>(context).load());
                },
                child: Icon(Icons.replay),
              ),
            );
          },
          HomeStatus.ready: () => HomeView(),
        };
        assert(cases.length == HomeStatus.values.length);
        return cases[state.status]!();
      },
    );
    result = RefreshIndicator(
      onRefresh: () async {
        load(() => getBloc<HomeCubit>(context).load());
        return;
      },
      child: result,
    );
    return result;
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPadding = 8.0;
    final height = 80.0;
    final margin = 8.0;
    final crossAxisCount = 2;
    final childAspectRatio =
        ((screenWidth - screenPadding * 2) / crossAxisCount) /
            (height + margin * 2);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Find Your',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Lovely pet in anywhere',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              onSubmitted: (String value) {
                final query = value.trim();
                if (query.isEmpty) {
                  return;
                }
                navigator.push(ShowcaseScreen(query: query).getRoute());
              },
              decoration: InputDecoration(
                hintText: 'Search', // TODO: вертикальная центрация
                hintStyle: TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.only(
                  right: 30,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(right: 16.0, left: 24.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pet Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  color: Colors.grey.shade800,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (HomeState previous, HomeState current) {
                return previous.categories != current.categories;
              },
              builder: (BuildContext context, HomeState state) {
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  childAspectRatio: childAspectRatio,
                  children: List.generate(
                    state.categories.length,
                    (int index) => _PetCategory(
                      category: state.categories[index],
                      margin: margin,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Newest Pet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  color: Colors.grey.shade800,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 280,
            child: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (HomeState previous, HomeState current) {
                return previous.newestUnits != current.newestUnits;
              },
              builder: (BuildContext context, HomeState state) {
                return ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    state.newestUnits.length,
                    (int index) => Unit(
                      unit: state.newestUnits[index],
                      index: index,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vets Near You',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  color: Colors.grey.shade800,
                ),
              ],
            ),
          ),
          Container(
            height: 130,
            margin: EdgeInsets.only(bottom: 16),
            child: PageView(
              physics: BouncingScrollPhysics(),
              children: [
                _Vet(
                  imageUrl: 'assets/images/vets/vet_0.png',
                  name: 'Animal Emergency Hospital',
                  phone: '(369) 133-8956',
                ),
                _Vet(
                  imageUrl: 'assets/images/vets/vet_1.png',
                  name: 'Artemis Veterinary Center',
                  phone: '(706) 722-9159',
                ),
                _Vet(
                  imageUrl: 'assets/images/vets/vet_2.png',
                  name: 'Big Lake Vet Hospital',
                  phone: '(598) 4986-9532',
                ),
                _Vet(
                  imageUrl: 'assets/images/vets/vet_3.png',
                  name: 'Veterinary Medical Center',
                  phone: '(33) 8974-559-555',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Vet extends StatelessWidget {
  const _Vet({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.phone,
  }) : super(key: key);

  final String imageUrl;
  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        border: Border.all(
          color: Colors.grey.shade300,
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
                  color: Colors.grey.shade800,
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
                    color: Colors.grey.shade800,
                    size: 18,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    phone,
                    style: TextStyle(
                      color: Colors.grey.shade800,
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
                  color: Colors.green.shade100,
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

class _PetCategory extends StatelessWidget {
  const _PetCategory({
    Key? key,
    required this.category,
    required this.margin,
  }) : super(key: key);

  final CategoryModel category;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigator.push(ShowcaseScreen(category: category).getRoute());
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade200,
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
                color: HexColor(category.color).withOpacity(0.5),
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
                    color: Colors.grey.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total of ${category.totalOf}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WishesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: Key('$runtimeType'),
      icon: Icon(Icons.favorite_border),
      onPressed: () {
        navigator.push(WishesScreen().getRoute());
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: Key('$runtimeType'),
      icon: Icon(Icons.exit_to_app),
      onPressed: () => getBloc<AuthenticationCubit>(context).requestLogout(),
    );
  }
}
