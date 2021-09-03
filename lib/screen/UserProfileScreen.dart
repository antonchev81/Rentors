import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rentors/bloc/OTPVerifiedBloc.dart';
import 'package:rentors/bloc/UserDetailBloc.dart';
import 'package:rentors/config/app_config.dart' as config;
import 'package:rentors/core/InheritedStateContainer.dart';
import 'package:rentors/core/RentorState.dart';
import 'package:rentors/event/SendOTPEvent.dart';
import 'package:rentors/event/UpdateUserDetailEvent.dart';
import 'package:rentors/event/UserDetailEvent.dart';
import 'package:rentors/event/VerifyOTPEvent.dart';
import 'package:rentors/generated/l10n.dart';
import 'package:rentors/state/DoneState.dart';
import 'package:rentors/state/ErrorState.dart';
import 'package:rentors/state/OtpState.dart';
import 'package:rentors/state/UserDetailState.dart';
import 'package:rentors/util/TypeEnum.dart';
import 'package:rentors/widget/AuctionFormField.dart';
import 'package:rentors/widget/PinEntryTextField.dart';
import 'package:rentors/widget/ProgressDialog.dart';
import 'package:rentors/widget/ProgressIndicatorWidget.dart';
import 'package:rentors/widget/RentorRaisedButton.dart';
import 'package:rentors/widget/UploadPhotoWidget.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserProfileScreenState();
  }
}

class UserProfileScreenState extends RentorState<UserProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  UserDetailBloc mBloc;
  String countryCode = "+91";
  String imagerUrl;
  bool isLoading = false;
  OTPVerifiedBloc otpVerifiedBloc = OTPVerifiedBloc();

  ProgressDialog dialog;
  String oldCountryCode;

  String phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagerUrl = "";
    mBloc = UserDetailBloc();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mBloc.listen((state) {
        if (state is ProgressDialogState) {
          dialog = ProgressDialog(context, isDismissible: true);
          dialog.show();
        } else {
          if (dialog != null && dialog.isShowing()) {
            dialog.hide();
          }
          if (state is DoneState) {
            Fluttertoast.showToast(msg: state.home.message);
          } else if (state is UserDetailState) {
            nameController.text = state.home.data.name;
            phoneController.text = state.home.data.mobile;
            addressController.text = state.home.data.address;
            emailController.text = state.home.data.email;
            oldCountryCode =
                "+" + state.home.data.countryCode.replaceAll("+", "");
            phone = state.home.data.mobile;
            countryCode = oldCountryCode;
            imagerUrl = state.home.data.profilePic;
            setState(() {
              isLoading = false;
            });
          }
        }
      });
      setState(() {
        isLoading = true;
      });
      mBloc.add(UserDetailEvent());
    });
    otpVerifiedBloc.listen((state) {
      if (state is ProgressDialogState) {
        dialog = ProgressDialog(context, isDismissible: true);
        dialog.show();
      } else {
        if (dialog != null && dialog.isShowing()) {
          dialog.hide();
        }
        if (state is VerifiedOTPState) {
          _updateProfile();
        } else if (state is OtpState) {
          showInputDialog(state.mobileNumber, state.verificationId);
        } else if (state is ErrorState) {
          Fluttertoast.showToast(msg: state.home);
        }
      }
    });
  }

  void save() {
    var name = nameController.text.toString().trim();
    var phne = phoneController.text.trim();
    var address = addressController.text.trim();
    var emailAddress = emailController.text.trim();
    if (name.isEmpty) {
      Fluttertoast.showToast(msg: S.of(context).pleaseEnterName);
    } else if (phne.isEmpty) {
      Fluttertoast.showToast(msg: S.of(context).pleaseEnterPhoneNumber);
    } else if (address.isEmpty) {
      Fluttertoast.showToast(msg: S.of(context).pleaseEnterAddress);
    } else if (emailAddress.isEmpty || !EmailValidator.validate(emailAddress)) {
      Fluttertoast.showToast(msg: S.of(context).pleaseEnterValidEmailAddress);
    } else {
      if (phone != phne || countryCode != oldCountryCode) {
        otpVerifiedBloc.add(SendOTPEvent(countryCode, phne));
      } else {
        _updateProfile();
      }
    }
  }

  void _updateProfile() {
    var name = nameController.text.toString().trim();
    var phne = phoneController.text.trim();
    var address = addressController.text.trim();
    var emailAddress = emailController.text.trim();
    var body = Map();
    body["name"] = name;
    body["address"] = address;
    body["mobile"] = phne;
    body["email"] = emailAddress;
    body["country_code"] = countryCode;
    body["profile_pic"] = imagerUrl;
    mBloc.add(UpdateUserDetailEvent(body));
  }

  void showInputDialog(String mobileNumber, String verificationId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  child: Text(
                    S.of(context).weSentYouACodeToVerifyYourPhoneNumber,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      mobileNumber,
                      style: TextStyle(
                          color: config.Colors().accentColor, fontSize: 15),
                    )),
                Container(
                    margin: EdgeInsets.all(10),
                    child: PinEntryTextField(
                        fieldWidth: 25.0,
                        fields: 6,
                        onSubmit: (value) {
                          if (value.length == 6) {
                            otpVerifiedBloc
                                .add(VerifyOTPEvent(verificationId, value));
                            Navigator.of(context).pop();
                          }
                        })),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
      child: InheritedStateContainer(
        state: this,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: isLoading ? ProgressIndicatorWidget() : box(),
          appBar: AppBar(
            brightness: Brightness.dark,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.black,
            title: Text(
              S.of(context).userProfile,
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void imageSelectionCallback(String url, TypeEnum typeEnum) {}

  Widget box() {
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UploadPhotoWidget(
                          "", TypeEnum.IMAGE1, imageSelectionCallback,
                          child: Card(
                            elevation: 10,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(imagerUrl),
                                      fit: BoxFit.fill)),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: AuctionFormField(S.of(context).name,
                      mController: nameController),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    autofocus: false,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: S.of(context).mobileNumber,
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: S.of(context).mobileNumber,
                        hintStyle:
                            TextStyle(color: Theme.of(context).buttonColor),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).buttonColor)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).buttonColor)),
                        prefixIcon: CountryCodePicker(
                          onChanged: (code) {
                            countryCode = code.dialCode;
                          },
                          flagWidth: 20,
                          initialSelection: countryCode,
                          showFlag: true,
                          showFlagDialog: true,
                          comparator: (a, b) => b.name.compareTo(a.name),
                          //Get the country information relevant to the initial selection
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: AuctionFormField(S.of(context).address,
                      mController: addressController),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: AuctionFormField(S.of(context).email,
                      mController: emailController),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: RentorRaisedButton(
                    child: Text(
                      S.of(context).save,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      save();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: RentorRaisedButton(
                    child: Text(
                      S.of(context).contactSupport,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      save();
                    },
                  ),
                ),
              ],
            )));
  }

  @override
  void update() {}

  @override
  void updateView(item) {
    super.updateView(item);
    setState(() {
      isLoading = true;
      imagerUrl = item;
      isLoading = false;
    });
  }
}
