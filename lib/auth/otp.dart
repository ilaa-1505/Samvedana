import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'login.dart';

class Myotp extends StatefulWidget {
  const Myotp({super.key});

  @override
  State<Myotp> createState() => _MyotpState();
}

class _MyotpState extends State<Myotp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";
  bool isOtpIncorrect = false;
  @override
  Widget build(BuildContext context) {
    const defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Colors.black
          )
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: const Border(
          bottom: BorderSide(
              width: 2,
              color: Colors.black
          ),),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
                width: 2,
                color: Colors.black
            )
        ),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
              Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded,
          color: Colors.black,),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/mental_health_app-removebg-preview.png', width: 150, height: 150,),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Phone Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'You need to register before getting started',
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onChanged: (value) {
                  code = value;
                  setState(() {
                    isOtpIncorrect = false; // Reset the incorrect OTP flag
                  });
                },
                onCompleted: (pin) => print(pin),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                isOtpIncorrect ? 'Incorrect OTP. Please try again.' : '',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    PhoneAuthCredential credential =
                    PhoneAuthProvider.credential(verificationId: Myphone.verify, smsCode: code);

                    try {
                      // Sign the user in (or link) with the credential
                      await auth.signInWithCredential(credential);
                      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                    } catch (e) {
                      // Handle authentication failure
                      print('Authentication failed: $e');
                      setState(() {
                        isOtpIncorrect = true;
                      });
                      // You can show an error message here if needed
                    }
                  },
                style: ElevatedButton.styleFrom(
                    primary: Colors.pink.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Verify Phone Number'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                  children: [TextButton(onPressed: () {

                      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);

                  },
                      child: const Text('Edit Phone Number?' , style: TextStyle(
                          color: Colors.black
                      ),))]
              )

            ],
          ),
        ),
      ),
    );
  }
}