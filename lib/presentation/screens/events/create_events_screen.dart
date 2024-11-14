// import 'package:flutter/material.dart';

// class CreateEventScreen extends StatelessWidget {
//   const CreateEventScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Create New Event'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Cover Photos Section
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 children: [
//                   Icon(Icons.add, size: 36, color: Colors.grey.shade500),
//                   const Text("Add Cover Photos",
//                       style: TextStyle(color: Colors.grey)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: List.generate(4, (index) {
//                 return Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(Icons.add, color: Colors.grey.shade500),
//                 );
//               }),
//             ),
//             const SizedBox(height: 24),

//             // Event Details Section
//             const Text('Event Details',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),

//             _buildTextField(label: "Event Name", hintText: "Event Name"),
//             _buildTextField(
//                 label: "Event Type", hintText: "Event Type", isDropdown: true),
//             _buildTextField(
//                 label: "Select Date",
//                 hintText: "Select Date",
//                 isDate: true,
//                 inputType: TextInputType.datetime),
//             _buildTextField(
//                 label: "Select Hours", hintText: "Select Hours", isTime: true),
//             _buildTextField(
//                 label: "Add Location",
//                 hintText: "Add Location",
//                 isLocation: true),
//             _buildTextField(
//                 label: "Add Location Details",
//                 hintText: "Add Location Details"),
//             _buildTextField(
//                 label: "About Event",
//                 hintText: "About Event",
//                 isMultiLine: true,
//                 inputType: TextInputType.multiline),

//             // Map Section
//             const SizedBox(height: 12),
//             const Text("Add Location on Maps", style: TextStyle(fontSize: 16)),
//             const SizedBox(height: 8),
//             Container(
//               height: 150,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Center(
//                 child: Icon(Icons.map, color: Colors.grey, size: 50),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Tickets and Payment Section
//             const Text('Tickets and Payment',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

//             const SizedBox(height: 12),

//             _buildTextField(
//                 label: "Ticket Price for VIP",
//                 hintText: "Ticket Price for VIP",
//                 inputType: TextInputType.number),
//             _buildTextField(
//                 label: "Ticket Price for Economy",
//                 hintText: "Ticket Price for Economy",
//                 inputType: TextInputType.number),
//             _buildTextField(
//                 label: "Choose a Ticket Purchase Deadline",
//                 hintText: "Choose a Ticket Purchase Deadline",
//                 isDate: true,
//                 inputType: TextInputType.datetime),
//             _buildTextField(
//                 label: "Choose Payout Method",
//                 hintText: "Choose Payout Method",
//                 isDropdown: true),

//             const SizedBox(height: 24),
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                   backgroundColor: Colors.blue.shade300,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onPressed: () {
//                   // Submit event creation logic
//                 },
//                 child: const Text("Create New Event & Publish",
//                     style: TextStyle(fontSize: 16)),
//               ),
//             ),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required String hintText,
//     TextInputType inputType = TextInputType.text,
//     bool isDropdown = false,
//     bool isDate = false,
//     bool isTime = false,
//     bool isLocation = false,
//     bool isMultiLine = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("$label *", style: const TextStyle(fontWeight: FontWeight.w500)),
//           const SizedBox(height: 6),
//           TextFormField(
//             maxLines: isMultiLine ? 4 : 1,
//             decoration: InputDecoration(
//               hintText: hintText,
//               suffixIcon: isDropdown
//                   ? const Icon(Icons.arrow_drop_down)
//                   : isDate
//                       ? const Icon(Icons.calendar_today)
//                       : isTime
//                           ? const Icon(Icons.access_time)
//                           : isLocation
//                               ? const Icon(Icons.location_on)
//                               : null,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//             ),
//             keyboardType: inputType,
//           ),
//         ],
//       ),
//     );
//   }
// }
