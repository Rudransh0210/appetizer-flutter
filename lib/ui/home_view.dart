import 'package:appetizer/app_theme.dart';
import 'package:appetizer/globals.dart';
import 'package:appetizer/ui/base_view.dart';
import 'package:appetizer/ui/components/appetizer_date_picker.dart';
import 'package:appetizer/ui/leaves/my_leaves_view.dart';
import 'package:appetizer/ui/menu/other_menu_view.dart';
import 'package:appetizer/ui/menu/week_menu_view.dart';
import 'package:appetizer/ui/menu/your_menu_view.dart';
import 'package:appetizer/ui/notification_history/notification_history_view.dart';
import 'package:appetizer/ui/rebates/my_rebates_view.dart';
import 'package:appetizer/ui/settings/settings_view.dart';
import 'package:appetizer/ui/switches/my_switches_view.dart';
import 'package:appetizer/ui/user_feedback/user_feedback_view.dart';
import 'package:appetizer/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  static const String id = 'home_view';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel _model;
  String selectedHostelName;
  DateTime _selectedDateTime;

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: _model.onCheckoutTap,
      backgroundColor: AppTheme.primary,
      child: Image.asset(
        'assets/images/check_out.png',
        height: 24,
        width: 24,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      height: 90.r,
      color: AppTheme.secondary,
      width: MediaQuery.of(context).size.width,
      child: AppetizerDatePicker(
        onDateChanged: (date) => setState(() => _selectedDateTime = date),
      ),
    );
  }

  Widget _buildCheckedOutComponent() {
    if (isCheckedOut == true) {
      return Container(
        width: MediaQuery.of(context).size.width,
        color: AppTheme.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ),
              child: Center(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'You are currently Checked-Out',
                    style: AppTheme.subtitle2.copyWith(
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(MyLeavesView.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ),
                child: Text(
                  'CHECK-IN',
                  style: AppTheme.subtitle2.copyWith(
                    color: AppTheme.white,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return Container();
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.secondary,
      title: _model.isSwitchEnabled
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.black.withOpacity(0.25),
                ),
              ),
              child: Theme(
                data: ThemeData(canvasColor: AppTheme.secondary),
                child: Center(
                  child: DropdownButton<String>(
                    underline: Container(),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: AppTheme.white,
                    ),
                    value: selectedHostelName,
                    hint: Text(
                      '       Your Meals',
                      textAlign: TextAlign.center,
                      style: AppTheme.headline1.copyWith(
                        color: AppTheme.white,
                        fontFamily: 'Lobster_Two',
                      ),
                    ),
                    items:
                        _model.switchableHostelsList.map((String hostelName) {
                      return DropdownMenuItem<String>(
                        value: hostelName,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.47,
                            child: Text(
                              hostelName,
                              textAlign: TextAlign.center,
                              style: AppTheme.headline1.copyWith(
                                color: AppTheme.white,
                                fontFamily: 'Lobster_Two',
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String _selectedHostelName) {
                      setState(() => selectedHostelName = _selectedHostelName);
                      _model.selectedHostel = _selectedHostelName;
                    },
                  ),
                ),
              ),
            )
          : Text(
              'Menu',
              style: AppTheme.headline3.copyWith(
                color: AppTheme.white,
              ),
            ),
      actions: <Widget>[
        Visibility(
          visible: !_model.isSwitchEnabled,
          child: _buildMonthComponent(),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => Get.toNamed(WeekMenuView.id),
            child: Container(
              height: 24,
              width: 24,
              child: Image.asset(
                'assets/icons/week_menu.png',
                color: AppTheme.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        image: DecorationImage(
          alignment: Alignment.topRight,
          image: AssetImage('assets/images/iitr.png'),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 80,
            color: AppTheme.primary,
          ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _model.currentUser?.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.headline3.copyWith(
                    color: AppTheme.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _model.currentUser?.enrNo.toString() ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.headline3.copyWith(
                    color: AppTheme.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDrawerComponent(
      {String iconPath, IconData iconData, String title, VoidCallback onTap}) {
    return ListTile(
      onTap: () {
        Get.back();
        onTap();
      },
      leading: iconPath != null
          ? Image(image: AssetImage(iconPath), width: 24, height: 24)
          : Icon(iconData, size: 24, color: AppTheme.primary),
      title: Text(title),
    );
  }

  Widget _buildMadeByMdgComponent() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _model.appetizerVersion,
            style: AppTheme.overline,
            textAlign: TextAlign.left,
          ),
          Row(
            children: <Widget>[
              Text(
                'Made with ',
                style: AppTheme.subtitle2,
              ),
              Icon(
                Icons.favorite,
                color: AppTheme.red,
              ),
              Text(
                ' by MDG',
                style: AppTheme.subtitle2,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          _buildDrawerHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildDrawerComponent(
                    onTap: () => Get.toNamed(UserFeedbackView.id),
                    iconPath: 'assets/icons/feedback.png',
                    title: 'Feedback',
                  ),
                  if (_model.isLeaveEnabled)
                    _buildDrawerComponent(
                      onTap: () => Get.toNamed(MyLeavesView.id),
                      iconPath: 'assets/icons/leaves.png',
                      title: 'Leaves',
                    ),
                  if (_model.isSwitchEnabled)
                    _buildDrawerComponent(
                      onTap: () => Get.toNamed(MySwitchesView.id),
                      iconPath: 'assets/icons/leaves.png',
                      title: 'Switches',
                    ),
                  if (_model.isLeaveEnabled)
                    _buildDrawerComponent(
                      onTap: () => Get.toNamed(MyRebatesView.id),
                      iconData: Icons.attach_money,
                      title: 'Rebates',
                    ),
                  _buildDrawerComponent(
                    onTap: () => Get.toNamed(NotificationHistoryView.id),
                    iconPath: 'assets/icons/notification.png',
                    title: 'Notification History',
                  ),
                  _buildDrawerComponent(
                    onTap: () => Get.toNamed(SettingsView.id),
                    iconPath: 'assets/icons/setting.png',
                    title: 'Settings',
                  ),
                  // _buildDrawerComponent(
                  //   onTap: () => Get.toNamed(FaqView.id),
                  //   iconData: Icons.help_outline,
                  //   title: 'FAQ',
                  // ),
                  _buildDrawerComponent(
                    onTap: () => _model.onLogoutTap(),
                    iconData: Icons.logout,
                    title: 'Logout',
                  ),
                ],
              ),
            ),
          ),
          _buildMadeByMdgComponent(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      onModelReady: (model) {
        _model = model;
        _model.checkVersion();
        _model.fetchInitialCheckedStatus();
        _selectedDateTime ??= DateTime.now();
        if (_model.isSwitchEnabled) _model.setSwitchableHostels();
      },
      builder: (context, model, child) => Scaffold(
        floatingActionButton: !isCheckedOut ? _buildFAB() : null,
        appBar: _buildAppBar(),
        drawer: _buildDrawer(),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              _buildDatePicker(),
              _buildCheckedOutComponent(),
              _model.selectedHostel == 'Your Meals'
                  ? YourMenuView(
                      selectedDateTime: _selectedDateTime,
                    )
                  : OtherMenuView(
                      hostelName: model.selectedHostel,
                      selectedDateTime: _selectedDateTime,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthComponent() {
    return Container(
      padding: EdgeInsets.only(top: 16, right: 10),
      color: AppTheme.secondary,
      child: Text(
        DateFormat('MMM’yy').format(_selectedDateTime),
        style: AppTheme.headline5.copyWith(
          color: AppTheme.white,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}
