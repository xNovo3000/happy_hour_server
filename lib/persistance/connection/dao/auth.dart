import '../../model/auth.dart';
import '_base.dart';

abstract class AuthDao implements BaseDao<Auth> {

	Auth? getFromUsername(String? username);

	Auth? login(String? username, String? password);

}