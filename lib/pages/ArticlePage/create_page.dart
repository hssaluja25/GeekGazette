// import 'package:flutter/material.dart';

// class CreatePage extends StatelessWidget {
//   final List<Widget> widgets;
//   const CreatePage({required this.widgets, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         const SliverAppBar(
//           title: Text(
//             'Home',
//             style: TextStyle(
//               fontFamily: 'Corben',
//               fontWeight: FontWeight.w700,
//               fontSize: 24,
//               color: Colors.black,
//             ),
//           ),
//           backgroundColor: Colors.yellow,
//           floating: true,
//         ),
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             addAutomaticKeepAlives: true,
//             childCount: widgets.length,
//             (BuildContext context, int index) {
//               print('Widget Length = ${widgets.length}');
//               return widgets[index];
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
