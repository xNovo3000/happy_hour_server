import '../../model/user.dart';
import '_base.dart';

abstract class UserDao implements BaseDao<User> {

	User? getFromInitial(int? initial);

}