import 'package:citizenone_app/modules/agency_banking/presentation/screens/BaseScreen/base_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
class ChequeBookRequest extends StatefulWidget {


  @override
  _ChequeBookRequestState createState() => _ChequeBookRequestState();
  const ChequeBookRequest();

}

class _ChequeBookRequestState extends BaseScreenState<ChequeBookRequest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> accountList = ['1234567890', '0987654321', '1122334455'];
    String? selectedAccount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Cheque Book Request',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          buildMobileDataStatusImage(),
          const SizedBox(width: 25),
          InkWell(
            onTap: () {
              showLogoutDialog(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Image.asset(
                'assets/images/ic_exit_to_app_white.png',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.fbTooLite,
      ),
      body: Padding(
        padding: EdgeInsets.all(2),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Accounts Linked',
                  ),
                  items: accountList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedAccount = newValue;
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'No of Leaves',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                  ),
                  keyboardType: TextInputType.text,
                ),
               
                SizedBox(height: 24),
                // Text("Cheque book will be dispatched to the above address",style: TextStyle(fontSize: 16),),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Add your request submission logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Request Submitted")),
                    );
                  },
                  child: Text(
                    'Request',
                    style: TextStyle(color: Colors.white), // Ensures white text
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.fbTooLite,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



