

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';


abstract class OnStartCloud {

 


}

class OnStartCloudDataSourceImpl implements OnStartCloud {
  final Firestore cloudDb;

  OnStartCloudDataSourceImpl({@required this.cloudDb});

 


 
}