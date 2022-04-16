// // import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:pet_finder/import.dart';

// class EditProfileScreen extends StatefulWidget {
//   Route<T> getRoute<T>() {
//     return buildRoute<T>(
//       '/edit_profile',
//       builder: (_) => this,
//       fullscreenDialog: false,
//     );
//   }

//   const EditProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('Profile'),
//       ),
//       body: ProfileForm(),
//       // Column(
//       //   crossAxisAlignment: CrossAxisAlignment.stretch,
//       //   children: [
//       //     SizedBox(height: 16),
//       //     _buildAvatar(),
//       //     ProfileForm(),
//       //   ],
//       // ),
//     );
//   }
// }

// class _Avatar extends StatelessWidget {
//   const _Avatar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final url = DatabaseRepository().member.validImageUrl;
//     const kRadius = 80.0;
//     // const kButtonRadius = 24.0;
//     return Avatar(
//       url: url,
//       radius: kRadius,
//       borderRadius: 24,
//       onTap: () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             behavior: SnackBarBehavior.floating,
//             content: Text('Upload avatar is not available.'),
//           ),
//         );
//       },
//     );
//     // return Center(
//     //   child: Container(
//     //     width: kRadius * 2,
//     //     height: kRadius * 2,
//     //     decoration: BoxDecoration(
//     //       shape: BoxShape.circle,
//     //       image: DecorationImage(
//     //         image: getImageProvider(url),
//     //         fit: BoxFit.cover,
//     //       ),
//     //     ),
//     //     // TODO: пока аватарка приходит из аккаунта аутентификации?
//     //     // child: Container(
//     //     //   alignment: Alignment.bottomRight,
//     //     //   padding: EdgeInsets.only(bottom: 4, right: 4),
//     //     //   child: SizedBox(
//     //     //     height: kButtonRadius * 2,
//     //     //     width: kButtonRadius * 2,
//     //     //     child: Material(
//     //     //       elevation: 2.0,
//     //     //       type: MaterialType.circle,
//     //     //       clipBehavior: Clip.antiAlias,
//     //     //       color: Theme.of(context).primaryColor,
//     //     //       child: InkWell(
//     //     //         highlightColor: Colors.transparent,
//     //     //         splashColor: Colors.white.withOpacity(0.24),
//     //     //         child: Icon(
//     //     //           defaultTargetPlatform == TargetPlatform.iOS ? CupertinoIcons.camera : Icons.camera,
//     //     //           color: Theme.of(context).primaryIconTheme.color,
//     //     //         ),
//     //     //         onTap: () {
//     //     //           print('pressed');
//     //     //         },
//     //     //       ),
//     //     //     ),
//     //     //   ),
//     //     // ),
//     //   ),
//     // );
//   }
// }

// class ProfileForm extends StatelessWidget {
//   ProfileForm({Key? key}) : super(key: key);

//   final _formKey = GlobalKey<FormState>();
//   final _displayNameFieldKey = GlobalKey<FormFieldState<String>>();
//   final _phoneFieldKey = GlobalKey<FormFieldState<String>>();
//   final _whatsAppFieldKey = GlobalKey<SwitchFieldState>();
//   final _viberFieldKey = GlobalKey<SwitchFieldState>();
//   // final _emailFieldKey = GlobalKey<FormFieldState<String>>();
//   // final _showEmailFieldKey = GlobalKey<FormSwitchState>();

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       child: Form(
//         key: _formKey,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//           child: Column(
//             children: [
//               _Avatar(),
//               SizedBox(height: 16),
//               TextFormField(
//                 key: _displayNameFieldKey,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: RequiredValidator(),
//                 keyboardType: TextInputType.text,
//                 decoration: InputDecoration(
//                   hintText: 'Your Name',
//                   // helperText: '',
//                 ),
//               ),
//               SizedBox(height: 8),
//               // TODO: email можно вытаскивать из аутентификации
//               // TextFormField(
//               //   key: _emailFieldKey,
//               //   autovalidateMode: AutovalidateMode.onUserInteraction,
//               //   validator: RequiredValidator(),
//               //   // maxLength: 20,
//               //   keyboardType: TextInputType.emailAddress,
//               //   decoration: InputDecoration(
//               //     hintText: 'Email',
//               //     // helperText: '',
//               //   ),
//               // ),
//               // FormSwitch(
//               //   key: _showEmailFieldKey,
//               //   label: 'Show Email',
//               // ),
//               // SizedBox(height: 8),
//               TextFormField(
//                 key: _phoneFieldKey,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: RequiredValidator(),
//                 // maxLength: 20,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   hintText: 'Phone',
//                   // helperText: '',
//                 ),
//               ),
//               SwitchField(
//                 key: _whatsAppFieldKey,
//                 label: 'WhatsApp',
//                 initialValue: false,
//               ),
//               SwitchField(
//                 key: _viberFieldKey,
//                 label: 'Viber',
//                 initialValue: false,
//               ),
//               SizedBox(height: 8),
//               ElevatedButton(
//                 onPressed: () {
//                   FocusScope.of(context).unfocus();
//                   // if (!_formKey.currentState!.validate()) {
//                   //   return;
//                   // }
//                   out(_whatsAppFieldKey.currentState!.value);
//                   out(_viberFieldKey.currentState!.value);
//                   // final data = UnitData(
//                   //   condition: _conditionFieldKey.currentState!.value,
//                   //   breedId: _breedFieldKey.currentState!.value?.id,
//                   //   color: _getTextValue(_colorFieldKey),
//                   //   weight:
//                   //       int.parse(_getTextValue(_weightFieldKey), radix: 10),
//                   //   story: _getTextValue(_storyFieldKey),
//                   //   imageUrl: _getImageUrl(_imagesFieldKey),
//                   //   birthday: DateFormat(kDateFormat)
//                   //       .parse(_getTextValue(_birthdayFieldKey), true),
//                   //   address: _getTextValue(_addressFieldKey),
//                   // );
//                   // save(() async {
//                   //   await getBloc<AddUnitCubit>(context).add(data);
//                   //   navigator.pop(true);
//                   // });
//                 },
//                 child: Text('Submit'.toUpperCase()),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getTextValue(GlobalKey<FormFieldState<String>> key) {
//     return key.currentState!.value!.trim();
//   }
// }

// class MyButtonDefaultOverlay extends MaterialStateProperty<Color?> {
//   MyButtonDefaultOverlay(this.onPrimary);

//   final Color onPrimary;

//   @override
//   Color? resolve(Set<MaterialState> states) {
//     if (states.contains(MaterialState.hovered))
//       return onPrimary.withOpacity(0.08);
//     if (states.contains(MaterialState.focused) ||
//         states.contains(MaterialState.pressed))
//       return onPrimary.withOpacity(0.24);
//     return null;
//   }
// }
