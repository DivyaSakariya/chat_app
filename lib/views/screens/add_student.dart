// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
//
// import '../../helpers/firestore_helper.dart';
// import '../../modals/student_modal.dart';
//
// class AddStudent extends StatelessWidget {
//   const AddStudent({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController idController = TextEditingController();
//     TextEditingController nameController = TextEditingController();
//     TextEditingController ageController = TextEditingController();
//     TextEditingController courseController = TextEditingController();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add Student"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Form(
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: idController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Id",
//                 ),
//               ),
//               const Gap(10),
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Name",
//                 ),
//               ),
//               const Gap(10),
//               TextFormField(
//                 controller: ageController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Age",
//                 ),
//               ),
//               const Gap(10),
//               TextFormField(
//                 controller: courseController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Course",
//                 ),
//               ),
//               const Gap(18),
//               ElevatedButton(
//                 onPressed: () {
//                   StudentModal studentModal = StudentModal(
//                     int.parse(idController.text),
//                     nameController.text,
//                     int.parse(ageController.text),
//                     courseController.text,
//                   );
//
//                   FireStoreHelper.fireStoreHelper
//                       .addStudent(studentModal: studentModal);
//                 },
//                 child: const Text("SAVE"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
