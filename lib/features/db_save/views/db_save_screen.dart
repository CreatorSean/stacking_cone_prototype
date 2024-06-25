import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';

import '../widgets/db_button.dart';

class DbSaveScreen extends ConsumerStatefulWidget {
  const DbSaveScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DbSaveScreenState();
}

class _DbSaveScreenState extends ConsumerState<DbSaveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: false,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Save Database",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Gaps.v150,
          Gaps.v32,
          const DbButton(
            buttonName: "DB 저장",
          ),
        ],
      ),
    );
  }
}
