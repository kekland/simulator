import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/apple/iphone_15.dart';
import 'package:simulator/src/modules/device_module/devices/apple/iphone_15_plus.dart';
import 'package:simulator/src/modules/device_module/devices/apple/iphone_15_pro.dart';
import 'package:simulator/src/modules/device_module/devices/apple/iphone_15_pro_max.dart';
import 'package:simulator/src/modules/device_module/devices/apple/iphone_se_gen_3.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_2.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_2_xl.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_3.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_3_xl.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_3a.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_3a_xl.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_4.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_4_xl.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_4a.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_5.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_6.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_6_pro.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_6a.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_7.dart';
import 'package:simulator/src/modules/device_module/devices/google/pixel_7_pro.dart';

const defaultDevices = <DeviceProperties>[
  iPhoneSEGen3,
  // iPhone14, TODO: Rework iPhone 14
  iPhone15,
  iPhone15Plus,
  iPhone15Pro,
  iPhone15ProMax,
  pixel2,
  pixel2Xl,
  pixel3,
  pixel3Xl,
  pixel3a,
  pixel3aXl,
  pixel4,
  pixel4Xl,
  pixel4a,
  pixel5,
  pixel6,
  pixel6Pro,
  pixel6a,
  pixel7,
  pixel7Pro,
];
